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

function getScriptFilePath(placeId, message, type) {
    const scriptLocation = parse.extractScriptLocation(message, type, true);

    if (scriptLocation) {
        const workspaceFolders = vscode.workspace.workspaceFolders;

        if (workspaceFolders) {
            for (const folder of workspaceFolders) {
                const sourcemapPath = path.join(folder.uri.fsPath, 'sourcemap.json');
                const projectPath = path.join(folder.uri.fsPath, 'default.project.json');

                // Check if the file exists
                if (fs.existsSync(sourcemapPath) && fs.existsSync(projectPath)) {		
                    const projectContent = fs.readFileSync(projectPath, 'utf8');	
                    const projectJson = JSON.parse(projectContent);

                    if (projectJson.servePlaceIds) {
                        const servePlaceId = projectJson.servePlaceIds.includes(placeId);

                        if (!servePlaceId) {
                            continue;
                        }
                    }

                    const sourcemapContent = fs.readFileSync(sourcemapPath, 'utf8');
                    const sourcemapJson = JSON.parse(sourcemapContent);
                    
                    const [name, location] = getScriptNameAndLocationArray(scriptLocation);
                    
                    const filePath = searchForScriptInSourcemap(sourcemapJson, name, location, path.join("..", folder.name));

                    if (filePath) {
                        return filePath;
                    }
                }
            }
        }
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