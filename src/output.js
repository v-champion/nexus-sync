const vscode = require('vscode');
const path = require('path');

const sourcemap = require('./sourcemap');
const parse = require('./parse');

let scriptLocationMap = new Map();
let outputChannel;

async function documentLinks(document) {
    const text = document.getText();
    const links = [];

    // Sort the entries by scriptLocation length in descending order
    const sortedEntries = Array.from(scriptLocationMap.entries()).sort((a, b) => 
        parse.extractScriptLocation(b[0], b[1].messageType).length - parse.extractScriptLocation(a[0], a[1].messageType).length
    );
    
    for (const [message, linkData] of sortedEntries) {
        const {filePath, lineNumber, messageType} = linkData;
        const scriptLocation = parse.extractScriptLocation(message, messageType);

        let startIndex = 0;

        if (!scriptLocation) {
            continue;
        }

        while (startIndex !== -1) {
            startIndex = text.indexOf(message, startIndex);

            if (startIndex !== -1) {
                const scriptLocationIndex = text.indexOf(scriptLocation, startIndex);

                if (scriptLocationIndex !== -1 && scriptLocationIndex < startIndex + message.length) {
                    const start = document.positionAt(scriptLocationIndex);
                    const end = document.positionAt(scriptLocationIndex + scriptLocation.length);

                    const uri = vscode.Uri.parse(`command:nexus-sync.openFile?${encodeURIComponent(JSON.stringify([filePath, lineNumber]))}`);

                    const link = new vscode.DocumentLink(new vscode.Range(start, end), uri);
                    link.tooltip = "Open Script in Editor";

                    links.push(link);
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

async function logToOutput(placeId, message, type) {
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