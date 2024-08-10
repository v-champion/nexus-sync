const vscode = require('vscode');

function send(message) {
    vscode.window.withProgress({
        location: vscode.ProgressLocation.Notification,
        title: message,
        cancellable: true
    }, (progress) => {
        return new Promise((resolve) => {
            setTimeout(() => {
                resolve();
            }, 4000);
        });
    });
}

module.exports = {
	send
}
