const notification = require('./notification');
const output = require('./output');
const http = require('http');

const contentType = {"Content-Type": "application/json"};

let mostRecentLogIndex = 0;
let stackTrace = false;

let debugRequestsReceived = 0;
let server;

function parseOutputLogs(body) {
    const {StartTime, Cleared, PlaceId, Logs} = JSON.parse(body);

    if (Cleared) {
        mostRecentLogIndex = 0;
        stackTrace = false;
    }
    
    const sortedLogs = Object.entries(Logs).sort((a, b) => Number(a[0]) - Number(b[0]));
    
    sortedLogs.forEach(([key, log]) => {
        const logNumber = Number(key);

        if (logNumber > mostRecentLogIndex && log !== null) {
            mostRecentLogIndex = logNumber;
            
            if (log.timestamp >= StartTime) {
                if (log.message === "Stack Begin") {
                    stackTrace = true;
                }
    
                if (log.message.startsWith("TestService")) {
                    log.message = log.message.replace("TestService: ", "");
                    log.messageType = "MessageDebug";
                }
    
                if (stackTrace) {
                    log.messageType = "MessageTrace";
                }
    
                output.logToOutput(PlaceId, log.message, log.messageType);
    
                if (log.message === "Stack End") {
                    stackTrace = false;
                }
            }
        }
    });

    debugRequestsReceived += 1;
    console.log(debugRequestsReceived + " requests received!");
}

function handleRequest(body, res) {
    try {
        parseOutputLogs(body);

        res.writeHead(200, contentType);
        res.end(JSON.stringify({message: "Data received successfully"}));
    } catch (err) {
        console.log(err);
        console.log(body);
        res.writeHead(400, contentType);
        res.end(JSON.stringify({error: "Error parsing JSON data"}));
    }
}

function startServer(port) {
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

function stopServer() {
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

module.exports = {
    startServer,
    stopServer,
};