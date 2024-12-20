const vscode = require('vscode');

function send(message) {
    vscode.window.withProgress({
        location: vscode.ProgressLocation.Notification,
        title: message,
        cancellable: false
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
