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

* Start the server by running the `Nexus Sync: Start Server` command
* Navigate to `View > Output`, click on the dropdown, and select `Roblox Studio`
* Next to the dropdown, click the settings cog icon and select `Trace`, then select `Set As Default`
* Open your place in Roblox Studio, and you should be connected!

If you want Nexus Sync to start automatically, right click the extension and select `Extension Settings`, then enable the `Auto Start` setting. It is recommended you enable this in your workspace settings only!

## Extra Notes
This extension relies on your Rojo sourcemap file(s) to locate scripts that error, so if it does not exist, your output  will not contain clickable output text for script errors, but otherwise should run as normal.

 `Work in progress, some things may not work correctly!`