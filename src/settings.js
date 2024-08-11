const vscode = require('vscode');

function fetch(tag, name) {
    return vscode.workspace.getConfiguration(`nexus-sync.${tag}`).get(name);
}

function changedConfiguration(event) {
    if (event.affectsConfiguration('nexus-sync.plugin')) {
        return "plugin";
    }
    else if (event.affectsConfiguration('nexus-sync.server')) {
        return "server";
    }
}

module.exports = {
    changedConfiguration,
	fetch
}