const scriptServiceLocations = [
    "Players",
    "ReplicatedFirst",
    "ReplicatedStorage",
    "ServerScriptService",
    "StarterPlayer",
]

const scriptRegexFromLog = new RegExp(`\\s?.*(${scriptServiceLocations.join("|")})\\.(.*?)(?::(\\d+):?)`, "g")
const scriptRegexFromTrace = new RegExp(`Script\\s+'(${scriptServiceLocations.join("|")})\\.(.*?)',?\\sLine\\s(\\d+)`, "g");

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
	for (const regex of [ scriptRegexFromLog, scriptRegexFromTrace ]) {
		while ((match = regex.exec(input)) !== null) {
			const scriptPath = parseScriptLocation(`${match[1]}.${match[2]}`);
			const lineNumber = parseInt(match[3], 10);
			const startIndex = input.indexOf(scriptPath, match.index);

			locations.push({
				scriptPath,
				lineNumber,
				startIndex,
			});
		}
	}

    return locations;
}

module.exports = {
	extractScriptLocationsAndLineNumbers,
}
