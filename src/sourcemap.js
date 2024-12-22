const vscode = require('vscode');
const path = require('path');
const fs = require('fs');

const settings = require('./settings');

const projectFileName = settings.fetch("workspace", "projectFile");

function getRojoProjects() {
    const workspaceFolders = vscode.workspace.workspaceFolders || [];
    const rojoProjects = [];

    for (const folder of workspaceFolders) {
        try {
            const projectPath = path.join(folder.uri.fsPath, projectFileName);
            const sourcemapPath = path.join(folder.uri.fsPath, 'sourcemap.json');

            if (fs.existsSync(sourcemapPath) && fs.existsSync(projectPath)) {
                rojoProjects.push({
                    sourcemap: JSON.parse(fs.readFileSync(sourcemapPath, 'utf8')),
                    project: JSON.parse(fs.readFileSync(projectPath, 'utf8')),
                    folder: folder
                });
            }
        }
        catch (e) {
            console.error(e);
        }
    }

    return rojoProjects;
}

function searchSourcemapForScript(sourcemap, scriptDetails, folderName) {
    const [name, location] = scriptDetails;
    let node = sourcemap;

    for (let i = 0; i < location.length; i++) {
        for (const child of (node.children || [])) {
            if (location[i] === (child.name || child.className)) {
                node = child;
                continue;
            }
        }
    }

    for (const child of (node.children || [])) {
        if (child.className.includes("Script") && child.filePaths) {
            const scriptPath = child.filePaths.find(filePath => filePath.includes('.lua'));

            if (scriptPath && child.name === name) {
                return path.join(folderName, scriptPath).replace(/\\/g, '/');
            }
        }
    }
}

function getScriptFilePathSingular(placeId, scriptLocation) {
    const rojoProjects = getRojoProjects();

    for (const rojo of rojoProjects) {
        const servePlaceIds = (rojo.project.servePlaceIds || rojo.project.placeIds);
        const folder = path.join("..", rojo.folder.name);

        const parts = scriptLocation.split(".");

        let scriptName = parts.pop();
        let location = parts

        const filePath = searchSourcemapForScript(rojo.sourcemap, [scriptName, location], folder);

        if (servePlaceIds) {
            if (servePlaceIds.includes(placeId)) {
                return filePath;
            }
        }
        else if (filePath) {
            return filePath;
        }
    }
    return null;
}

module.exports = {
    getScriptFilePathSingular
}
