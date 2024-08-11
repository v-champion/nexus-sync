# Roblox Nexus Sync
Displays Roblox Studio output to an output channel in Visual Studio Code, with added Rojo support for click to open script functionality.
 
 Useful for certain Rojo projects where you want to quickly open scripts that error without having to navigate through your folders and file structures.

## Features
* Output messages are automatically formatted and colorised depending on message type and your vscode theme, without the need to install external extensions.

* Supports multi place Rojo projects for clickable stack trace file sources whenever scripts error in the output.

## Installation

* Install the Visual Studio Code extension
* Install the Roblox Plugin via Creator Marketplace or build it yourself from the GitHub repository

## Usage

By default, the server does not start automatically when you install the extension. 

You can manually start/stop the server by opening the command palette and running the "**Nexus Sync**" commands.

You can make the server automatically start by enabling the `nexus-sync.server.autoStart` configuration. It is recommended you only enable this for workspace only.

**Highly Recommended:**

In VS Code, set your output **Log Level** to "Trace" and then "Set As Default" by clicking the settings cog next to the output channels dropdown.

## Extra Notes
This extension relies on your Rojo sourcemap file(s) to locate scripts that error, so if it does not exist, your output  will not contain clickable output text for script errors, but otherwise should run as normal.

The plugin may become unstable if there are large amounts of output spam, i.e. errors/prints tied to RunService events.
