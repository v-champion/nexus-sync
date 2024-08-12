# Roblox Nexus Sync
Displays Roblox Studio output to an output channel in Visual Studio Code, with added Rojo support for click to open script functionality.
 
 Useful for certain Rojo projects where you want to quickly open scripts that error without having to navigate through your folders and file structures.

 ![VSCode output view](https://raw.githubusercontent.com/v-champion/nexus-sync/main/images/screenshots/1.png)

## Features
* Colorised output messages, formatted based on message type 

* Connects automatically or manually via plugin settings

* Rojo support: clickable stack trace file sources

## Installation

* Install the Visual Studio Code [Extension](https://marketplace.visualstudio.com/items?itemName=v-champion.nexus-sync) from the marketplace or package it yourself
* Install the [Roblox Plugin](https://create.roblox.com/store/asset/18890584157/Nexus-Sync) from Roblox or build it yourself using Rojo

## Usage

1. Start the server by running the `Nexus Sync: Start Server` command
2. Navigate to `View > Output`, click on the dropdown, and select `Roblox Studio`
3.  Next to the dropdown, click the settings cog icon and select `Trace`, then select `Set As Default`
4. Open your place in Roblox Studio, and you should be connected!

### Automatically start output server on launch
If you want Nexus Sync to start automatically, right click the extension and select `Extension Settings`, then enable the `Auto Start` setting. It is recommended you enable this in your workspace settings only!

### Missing output messages

If you are missing any output messages, set the "Roblox Studio" output channel log level to "Trace", then set it as default like shown below:

![How to set output log level](https://raw.githubusercontent.com/v-champion/nexus-sync/main/images/screenshots/2.gif)

## Limitations

### If you are using Rojo
For Rojo users, this extension relies on your Rojo sourcemap file(s) to locate scripts that error, so if it does not exist, your output  will not contain clickable output text for script errors.

### Output Flooding
If the studio output is flooded with prints/errors etc in a very short period of time (i.e. RunService events) the plugin may throttle the messages sent because of HttpService constraints

### Singular Channel

Currently there is only one `Roblox Studio` channel that all the output messages will be logged to. You can still however log multiple studio places.

### Play Tests

As of this time there are no detections in place to clear the output whenever a test session is launched.