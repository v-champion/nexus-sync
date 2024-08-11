plugin.Name = script.Parent.Name

local Settings = require(script.Modules.Settings)
local Cleanup = require(script.Modules.Cleanup)
local Widget = require(script.Modules.Widget)
local Output = require(script.Modules.Output)

Settings:Load()
Widget:Load()
Output:Load()

local function Deactivate()
	Cleanup:Clear()
	Widget:Close()
end

Cleanup:Hook().Ping = task.spawn(function()
	while task.wait(1) do
		Widget:Update()
	end
end)

plugin.Unloading:Connect(function()
	Deactivate()
end)

plugin.Deactivation:Connect(function()
	Deactivate()
end)