const vscode = require('vscode');
const path = require('path');

const sourcemap = require('./sourcemap');
const parse = require('./parse');

const filePathCache = new Map();

let placeId
let outputChannel;

function getLinkForOutput(messageIndex, linkData, document) {
    const { filePath, lineNumber = 0, message } = linkData;

    const start = document.positionAt(messageIndex);
    const end = document.positionAt(messageIndex + message.length);

    const uri = vscode.Uri.parse(`command:nexus-sync.openFile?${encodeURIComponent(JSON.stringify([filePath, lineNumber]))}`);

    const link = new vscode.DocumentLink(new vscode.Range(start, end), uri);
    link.tooltip = "Open Script in Editor";

    return link;
}

async function documentLinks(document) {
    const text = document.getText();
    const links = [];

    let locations = parse.extractScriptLocationsAndLineNumbers(text)

    for (const location of locations) {
        let filePath = filePathCache.get(location.scriptPath);
        if (!filePath) {
            filePath = sourcemap.getScriptFilePathSingular(placeId, location.scriptPath);
            if (filePath) {
                filePathCache.set(location.scriptPath, filePath);
            } else {
                continue;
            }
        }

        const workspaceFolder = vscode.workspace.workspaceFolders ? vscode.workspace.workspaceFolders[0].uri.fsPath : '';
        const absoluteFilePath = path.join(workspaceFolder, filePath);

        const linkData = {
            filePath: absoluteFilePath,
            lineNumber: location.lineNumber,
            message: location.message,
        }

        links.push(getLinkForOutput(location.startIndex, linkData, document))
    };

    return links;
}

function clearSourcemapCache() {
    filePathCache.clear();
}

function sanitizeInstanceTable(message) {
    // Find all contents starting with "{<string> =" and ending with "... }" not followed by a comma
    const regex = /\{\w+\s*=.*?\.\.\.\ \}(?!,)\s*/gs;

    return message.replace(regex, match => {
        if (match.includes(", Archivable = ")) {
            return "";
        }
        return match;
    }).trim();
}

function logToOutput(placeIdArg, message, type) {
    if (message.includes(", Archivable = ")) {
        message = sanitizeInstanceTable(message);
    }

    placeId = placeIdArg

    switch (type) {
        case "MessageWarning":
            outputChannel.warn(message);
            break;
        case "MessageDebug":
            outputChannel.debug(message);
            break;
        case "MessageTrace":
            if (message.includes("Stack End")) {
                message += "\n";
            }
            outputChannel.trace(message);
            break;
        case "MessageError":
            outputChannel.error(message);
            break;
        default:
            outputChannel.info(message);
            break;
    }
}

function start() {
    if (!outputChannel) {
        outputChannel = vscode.window.createOutputChannel('Roblox Studio', { log: true });
        outputChannel.show();
    }
}

function stop() {
    if (outputChannel) {
        outputChannel.info("Plugin server stopped successfully");
    }
}

module.exports = {
    logToOutput,
    documentLinks,
    clearSourcemapCache,
    start,
    stop
}
