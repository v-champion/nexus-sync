# Roblox Nexus Sync
Displays Roblox Studio output to an output channel in Visual Studio Code, with added Rojo support for click to open script functionality.
 
 Useful for certain Rojo projects where you want to quickly open scripts that error without having to navigate through your folders and file structures.

## Features
* Output messages are automatically formatted and colorised depending on message type and your vscode theme, without the need to install external extensions.

* Supports multi place Rojo projects for clickable stack trace file sources whenever scripts error in the output.

![VSCode output view](https://raw.githubusercontent.com/v-champion/nexus-sync/main/images/screenshots/1.png)

## Installation

* Install the Visual Studio Code [extension](https://marketplace.visualstudio.com/items?itemName=v-champion.nexus-sync)
* Install the [Roblox Plugin](https://create.roblox.com/store/asset/18890584157/Nexus-Sync) from Roblox or build it yourself from the GitHub repository using Rojo

## Usage

By default, the server does not start automatically when you install the extension. You can manually start/stop the server by opening the command palette and running the "**Nexus Sync**" commands.

You can make the server automatically start by enabling the `nexus-sync.server.autoStart` configuration. It is recommended you only enable this for workspace only.

**Highly Recommended if logs appear missing or incomplete:**

In VS Code, set your output **Log Level** to "Trace" and then "Set As Default" by clicking the settings cog next to the output channels dropdown.

## Extra Notes
This extension relies on your Rojo sourcemap file(s) to locate scripts that error, so if it does not exist, your output  will not contain clickable output text for script errors, but otherwise should run as normal.

 `Work in progress, some things may not work correctly!`