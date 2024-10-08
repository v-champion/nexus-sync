const vscode = require('vscode');
const path = require('path');

const sourcemap = require('./sourcemap');
const parse = require('./parse');

let scriptLocationMap = new Map();
let outputChannel;

function getLinkForOutput(scriptLocationIndex, scriptLocation, linkData, document) {
    const {filePath, lineNumber} = linkData;

    const start = document.positionAt(scriptLocationIndex);
    const end = document.positionAt(scriptLocationIndex + scriptLocation.length);

    const uri = vscode.Uri.parse(`command:nexus-sync.openFile?${encodeURIComponent(JSON.stringify([filePath, lineNumber]))}`);

    const link = new vscode.DocumentLink(new vscode.Range(start, end), uri);
    link.tooltip = "Open Script in Editor";

    return link;
}

async function documentLinks(document) {
    const text = document.getText();
    const links = [];

    const sortedEntries = Array.from(scriptLocationMap.entries()).sort((a, b) => 
        parse.extractScriptLocation(b[0], b[1].messageType).length - parse.extractScriptLocation(a[0], a[1].messageType).length
    );
    
    for (const [message, linkData] of sortedEntries) {
        const scriptLocation = parse.extractScriptLocation(message, linkData.messageType);

        if (!scriptLocation) {
            continue;
        }

        let startIndex = 0;
        
        while (startIndex !== -1) {
            startIndex = text.indexOf(message, startIndex);

            if (startIndex !== -1) {
                const scriptLocationIndex = text.indexOf(scriptLocation, startIndex);

                if (scriptLocationIndex !== -1 && scriptLocationIndex < startIndex + message.length) {
                    links.push(getLinkForOutput(scriptLocationIndex, scriptLocation, linkData, document));
                }
                startIndex += message.length;
            }
        }
    }
    return links;
}

async function logMessageToFilepath(message, type, filePath) {
    const lineNumber = parse.extractScriptLineNumber(message, type);
    
    const workspaceFolder = vscode.workspace.workspaceFolders ? vscode.workspace.workspaceFolders[0].uri.fsPath : '';
    const absoluteFilePath = path.join(workspaceFolder, filePath);

    scriptLocationMap.set(message, {
        messageType: type,
        filePath: absoluteFilePath, 
        lineNumber: lineNumber
    });
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

function logToOutput(placeId, message, type) {
    if (message.includes(", Archivable = ")) {
        message = sanitizeInstanceTable(message);
    }

    if (type === "MessageError" || type === "MessageTrace") {
        const filePath = sourcemap.getScriptFilePath(placeId, message, type);

        if (filePath) {
            logMessageToFilepath(message, type, filePath);
        }
        handleErrorOrTrace(message, type);
    } else {
        handleOtherTypes(message, type);
    }
}

function handleErrorOrTrace(message, type) {
    if (type === "MessageError") {
        outputChannel.error(message);
    } else {
        if (message.includes("Stack End")) {
            message += "\n";
        }
        outputChannel.trace(message);
    }
}

function handleOtherTypes(message, type) {
    switch (type) {
        case "MessageWarning":
            outputChannel.warn(message);
            break;
        case "MessageDebug":
            outputChannel.debug(message);
            break;
        default:
            outputChannel.info(message);
            break;
    }
}

function start() {
    if (!outputChannel) {
        outputChannel = vscode.window.createOutputChannel('Roblox Studio', {log: true});
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
	start,
    stop
}