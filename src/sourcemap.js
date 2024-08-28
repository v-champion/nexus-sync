const vscode = require('vscode');
const path = require('path');
const fs = require('fs');

const settings = require('./settings');
const parse = require('./parse');

const projectFileName = settings.fetch("workspace", "projectFile");

function getScriptDetails(message, type) {    
    const scriptLocation = parse.extractScriptLocation(message, type, true);

    if (!scriptLocation) {
        return null;
    }

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

function getScriptFilePath(placeId, message, type) {
    const scriptDetails = getScriptDetails(message, type);
    
    if (!scriptDetails) {
        return null;
    }

    const rojoProjects = getRojoProjects();

    for (const rojo of rojoProjects) {
        const servePlaceIds = (rojo.project.servePlaceIds || rojo.project.placeIds);
        const folder = path.join("..", rojo.folder.name);

        const filePath = searchSourcemapForScript(rojo.sourcemap, scriptDetails, folder);

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

function searchSourcemapForScript(node, scriptDetails, folderName, parentNode) {
    const [name, location] = scriptDetails;
    
    if (node.className.includes("Script") && node.filePaths) {
        const luauFilePath = node.filePaths.find(filePath => filePath.includes('.lua'));

        if (luauFilePath) {
            const filePath = path.join(folderName, luauFilePath).replace(/\\/g, '/');
            const parentName = parentNode.name || parentNode.className;

            if (node.name === name && parentName === location[location.length - 1]) {
                return filePath;
            }
        }
    }
    
    if (node.children) {
        for (const child of node.children) {
            const result = searchSourcemapForScript(child, scriptDetails, folderName, node);
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