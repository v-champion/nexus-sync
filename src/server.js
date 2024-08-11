const notification = require('./notification');
const output = require('./output');
const http = require('http');

const contentType = {'Content-Type': 'application/json'};

let mostRecentLogIndex = 0;
let stackTrace = false;

let server;

function parseOutputLogs(body) {
    const {StartTime, Cleared, PlaceId, Logs} = JSON.parse(body);
    console.log(StartTime);

    if (Cleared) {
        //console.log("Cleared logs");
        mostRecentLogIndex = 0;
    }

    const sortedLogs = Object.entries(Logs).sort((a, b) => Number(a[0]) - Number(b[0]));
    
    sortedLogs.forEach(([key, log]) => {
        const logNumber = Number(key);

        if (logNumber > mostRecentLogIndex) {
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
    //output.logToOutput(PlaceId, Message, Type);
}

function startServer(port) {
    output.start();

    server = http.createServer((req, res) => {
        if (req.method === 'POST' && req.url === '/data') {
            let body = '';

            req.on('data', (chunk) => {
              body += chunk.toString();
            });

            req.on('end', () => {
                try {
                    parseOutputLogs(body);

                    res.writeHead(200, contentType);
                    res.end(JSON.stringify({message: 'Data received successfully'}));

                } catch (err) {
                    console.log(err);

                    res.writeHead(400, contentType);
                    res.end(JSON.stringify({error: 'Invalid JSON data'}));
                }
            });
        } else {
            res.writeHead(404, contentType);
            res.end(JSON.stringify({error: 'Endpoint not found'}));
        }
    });
    
    server.listen(port, () => {
        notification.send(`Nexus Sync plugin server running on port ${port}`);
        console.log(`Nexus Sync: Server running at http://localhost:${port}/`);
    });
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

module.exports = {
    startServer,
    stopServer,
};