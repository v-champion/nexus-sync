const vscode = require('vscode');

const settings = require(`./settings`);
const server = require('./server');
const output = require('./output');

/**
 * @param {vscode.ExtensionContext} context
 */
function activate(context) {
	console.log('Nexus Sync: Extension activated');
	
	let openFileEvent = vscode.commands.registerCommand('nexus-sync.openFile', (filePath, line) => {
        openFile(filePath, line);
    });

    let startServer = vscode.commands.registerCommand('nexus-sync.startServer', () => {
        server.start(settings.fetch("plugin", "port"));
    });

    let stopServer = vscode.commands.registerCommand('nexus-sync.stopServer', () => {
        server.stop();
    });

    const linkProvider = vscode.languages.registerDocumentLinkProvider({ scheme: 'output' }, {
        provideDocumentLinks(document) {
            return output.documentLinks(document);   
        }
    });
    
    context.subscriptions.push(openFileEvent, linkProvider, startServer, stopServer);

    if (settings.fetch('server', 'autoStart')) {
        server.start(settings.fetch('plugin', 'port'));
    }
}

function openFile(filePath, line) {
    const uri = vscode.Uri.file(filePath);

    vscode.workspace.openTextDocument(uri).then(doc => {
        vscode.window.showTextDocument(doc).then(editor => {
            const position = new vscode.Position(line - 1, 0);
            const range = new vscode.Range(position, position);

            editor.selection = new vscode.Selection(position, position);
            editor.revealRange(range, vscode.TextEditorRevealType.InCenter);
        });
    });
}

function deactivate() {
    server.stop();
}

module.exports = {
	activate,
	deactivate
}