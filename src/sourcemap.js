const vscode = require('vscode');
const path = require('path');
const fs = require('fs');

const parse = require('./parse');

function getScriptNameAndLocationArray(scriptLocation) {
    const parts = scriptLocation.split(".");

    let scriptName = parts.pop();
    let location = parts

    return [scriptName, location];
}

function getRojoProjects() {
    const workspaceFolders = vscode.workspace.workspaceFolders || [];
    const rojoProjects = [];

    for (const folder of workspaceFolders) {
        try {
            const projectPath = path.join(folder.uri.fsPath, 'default.project.json');
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

function getScriptFilePath(placeId, message, type) {
    const scriptLocation = parse.extractScriptLocation(message, type, true);

    if (!scriptLocation) {
        return null;
    }
    
    const rojoProjects = getRojoProjects();

    for (const rojo of rojoProjects) {
        const servePlaceIds = rojo.project.servePlaceIds;

        if (servePlaceIds && !servePlaceIds.includes(placeId)) {
            continue;
        }

        const [name, location] = getScriptNameAndLocationArray(scriptLocation);

        return searchForScriptInSourcemap(
            rojo.sourcemap, name, location, 
            path.join("..", rojo.folder.name)
        );
    }
	return null;
}

function searchForScriptInSourcemap(node, name, location, folderName, parent) {
    if (node.className.includes("Script") && node.filePaths) {
        const luauFilePath = node.filePaths.find(filePath => filePath.includes('.lua'));

        if (luauFilePath) {
            const filePath = path.join(folderName, luauFilePath).replace(/\\/g, '/');
            const parentName = parent.name || parent.className;

            if (node.name === name && parentName === location[location.length - 1]) {
                return filePath;
            }
        }
    }
    
    if (node.children) {
        for (const child of node.children) {
            const result = searchForScriptInSourcemap(child, name, location, folderName, node);
            if (result) {
                return result;
            }
        }
    }
    return null;
}

module.exports = {
    getScriptFilePath
}