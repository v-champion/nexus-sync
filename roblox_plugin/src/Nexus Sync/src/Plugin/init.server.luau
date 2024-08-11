local Settings = require(script.Modules.Settings)
local Cleanup = require(script.Modules.Cleanup)
local Widget = require(script.Modules.Widget)
local Output = require(script.Modules.Output)

Settings:Load()
Widget:Load()
Output:Load()

local function Deactivate()
	Cleanup:Stop()
	Widget:Close()
end

plugin.Unloading:Connect(function()
	Deactivate()
end)

plugin.Deactivation:Connect(function()
	Deactivate()
end)