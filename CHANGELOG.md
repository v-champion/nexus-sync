# Change Log

All notable changes to Nexus Sync will be documented in this file.

## `0.4.5` - May 22nd, 2024

- Added a vscode setting to help prevent duplicated output logs

## `0.4.0` - December 22nd, 2024

- Fixed a bug where sometimes linked scripts that have identical names but different paths couldn't be differentiated
- Improved the detection and linking of script traces 

## `0.3.5` - August 28th, 2024

- Fixed duplicated output messages by disabling the plugin in Test Play.
- Improved output messages when an Instance is passed in the output
- Added project json file name setting for the extension
- Argon is now supported for multi place projects

## `0.3.0` - August 15th, 2024

- Fixed not being able to adjust port number in plugin settings
- Fixed problems finding scripts if there are multiple rojo projects in the same workspace
- Fixed messages being marked as "trace" when they are not apart of a stack trace
- Fixed issue where output stops sending logs upon connection loss
- Slightly improved reliability if you have multiple Roblox Studios open

## `0.2.0` - August 12th, 2024

- Improved reliability of output logging
- Fixed connecting issues

## `0.1.0` - August 11th, 2024

- Initial release