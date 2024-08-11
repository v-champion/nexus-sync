const vscode = require('vscode');

const settings = require(`./settings`);
const server = require('./server');
const output = require('./output');

/**
 * @param {vscode.ExtensionContext} context
 */
function activate(context) {
	console.log('Nexus Sync: extension is running');
	
	let openFile = vscode.commands.registerCommand('nexus-toolset.openFile', (filePath, line) => {
        const uri = vscode.Uri.file(filePath);

        vscode.workspace.openTextDocument(uri).then(doc => {
            vscode.window.showTextDocument(doc).then(editor => {
                const position = new vscode.Position(line - 1, 0);
                const range = new vscode.Range(position, position);

                editor.selection = new vscode.Selection(position, position);
                editor.revealRange(range, vscode.TextEditorRevealType.InCenter);
            });
        });
    });

    const linkProvider = vscode.languages.registerDocumentLinkProvider({ scheme: 'output' }, {
        provideDocumentLinks(document) {
            return output.documentLinks(document);   
        }
    });

    const settingChanged = vscode.workspace.onDidChangeConfiguration(event => {
        const affectedConfiguration = settings.changedConfiguration(event);

        if (affectedConfiguration == "plugin") {
            if (settings.fetch('plugin', 'enabled')) {
                server.startServer(settings.fetch('plugin', 'port'));
            } else {
                server.stopServer();
            }
        }
    });

    context.subscriptions.push(
        openFile, linkProvider, settingChanged
    );

    if (settings.fetch('plugin', 'enabled')) {
        server.startServer(settings.fetch('plugin', 'port'));
    }
}

function deactivate() {
    server.stopServer();
}

module.exports = {
	activate,
	deactivate
}
