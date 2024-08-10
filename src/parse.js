function scriptLocationFromTrace(string) {
    const firstQuoteIndex = string.indexOf("'");
    const lastQuoteIndex = string.lastIndexOf("'");
    
    if (firstQuoteIndex !== -1 && lastQuoteIndex !== -1 && firstQuoteIndex !== lastQuoteIndex) {
        return string.substring(firstQuoteIndex + 1, lastQuoteIndex);
    }
    return null; 
}

function scriptLocationFromError(string) {
    const regex = /\[.*?\]/;
    const match = string.match(regex);

    if (match) {
        const afterPattern = string.split(match[0])[1].trim();
        const result = afterPattern.split(':')[0].trim();

        return result;
    }
    return null;
}

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

function extractScriptLocation(string, type, parse) {
    let scriptLocation = null;

    if (type === "MessageTrace") {
        scriptLocation = scriptLocationFromTrace(string);
    } 
    else {
        scriptLocation = scriptLocationFromError(string);
    }
    if (scriptLocation && parse) {
        return parseScriptLocation(scriptLocation);
    }
    return scriptLocation;
}

function extractScriptLineNumber(input, type) {
    if (type === "MessageError" || input.includes("[error]")) {
        const match = input.match(/.*:(\d+):/);

        if (match) {
            const number = match[1];
            return number;
        }
    }
    else {
        const regex = /Line (\d+)/;
        const match = input.match(regex);
        
        if (match) {
            return match[1];
        }
    }
    return 1;
}

module.exports = {
    extractScriptLineNumber,
    extractScriptLocation
}