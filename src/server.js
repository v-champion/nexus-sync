const notification = require('./notification');
const output = require('./output');
const http = require('http');

const contentType = {"Content-Type": "application/json"};

let outputSessions = new Map();
let server;

function parseOutputLogs(body) {
    const {StartTime, PlaceId, GUID, Logs} = JSON.parse(body);

    if (!outputSessions.has(GUID)) {
        outputSessions.set(GUID, 0);
    }

    return {
        startTime: StartTime,
        placeId: PlaceId, 
        GUID: GUID,
        logs: Logs, 
    };
}

function sortOutputLogs(data) {
    const sortedLogs = Object.entries(data.logs).sort((a, b) => Number(a[0]) - Number(b[0]));
    
    sortedLogs.forEach(([key, log]) => {
        const logNumber = Number(key);

        if (logNumber > outputSessions.get(data.GUID) && log !== null) {
            outputSessions.set(data.GUID, logNumber);

            if (log.timestamp >= data.startTime) {
                if (log.message.startsWith("TestService")) {
                    log.message = log.message.replace("TestService: ", "");
                    log.messageType = "MessageDebug";
                }
                
                output.logToOutput(data.placeId, log.message, log.messageType);
            }
        }
    });
}

function handleRequest(body, res) {
    try {
        sortOutputLogs(parseOutputLogs(body));

        res.writeHead(200, contentType);
        res.end(JSON.stringify({message: "Data received successfully"}));
    } catch (err) {
        console.log(err);
        console.log(body);
        res.writeHead(400, contentType);
        res.end(JSON.stringify({error: "Error parsing JSON data"}));
    }
}

function start(port) {
    if (!isServerRunning()) {
        output.start();

        server = http.createServer((req, res) => {
            if (req.method === "POST" && req.url === "/data") {
                let body = "";

                req.on("data", (chunk) => {
                    body += chunk.toString();
                });

                req.on("end", () => {
                    handleRequest(body, res);
                });
            } else {
                res.writeHead(404, contentType);
                res.end(JSON.stringify({error: "Endpoint not found"}));
            }
        });
        
        server.listen(port, () => {
            notification.send(`Nexus Sync plugin server running on port ${port}`);
            console.log(`Nexus Sync: Server running at http://localhost:${port}/`);
        });
    } else {
        notification.send(`Nexus Sync plugin server is already running`);
    }
}

function stop() {
    if (server) {
        server.close(() => {
            notification.send(`Nexus Sync plugin server stopped`);
            console.log('Nexus Sync: Server stopped');
        });
    }
    output.stop();
}

function isServerRunning() {
    return server && server.listening;
}

module.exports = {start, stop};