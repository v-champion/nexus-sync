const scriptServiceLocations = [
    "Players",
    "ReplicatedFirst",
    "ReplicatedStorage",
    "ServerScriptService",
]

const scriptRegexFromLog = new RegExp(`\\s?.*((${scriptServiceLocations.join("|")})\\.(.*?)(?::(\\d+):?))`, "g")
const scriptRegexFromTrace = new RegExp(`(Script\\s+'(${scriptServiceLocations.join("|")})\\.(.*?)',?\\sLine\\s(\\d+))`, "g");

function parseScriptLocation(input) {
    if (input.startsWith("Players")) {
        let transformed = input.replace("Players", "StarterPlayer");
        transformed = transformed.replace("PlayerScripts", "StarterPlayerScripts")

        let parts = transformed.split(".");

        if (parts.length > 1) {
            parts.splice(1, 1);
        }
        return parts.join(".");
    }
    return input;
}

function extractScriptLocationsAndLineNumbers(input) {
    const locations = [];

    let match;
    for (const regex of [scriptRegexFromLog, scriptRegexFromTrace]) {
        while ((match = regex.exec(input)) !== null) {
            const message = match[1];
            const startIndex = input.indexOf(match[1], match.index);
            const scriptPath = parseScriptLocation(`${match[2]}.${match[3]}`);
            const lineNumber = parseInt(match[4], 10);

            if (startIndex === -1) {
                continue;
            }

            locations.push({
                scriptPath,
                lineNumber,
                startIndex,
                message,
            });
        }
    }

    return locations;
}

module.exports = {
    extractScriptLocationsAndLineNumbers,
}
