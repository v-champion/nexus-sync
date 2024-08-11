local LogService = game:GetService("LogService")

local Settings = require(script.Parent.Settings)
local Cleanup = require(script.Parent.Cleanup)
local Server = require(script.Parent.Server)
local Http = require(script.Parent.Http)

local plugin = plugin or script:FindFirstAncestorWhichIsA("Plugin")

local Output = {}
Output.LogCount = 0
Output.Busy = false

function Output:Sanitize()
	local LogHistory, Logs = LogService:GetLogHistory(), {}
	
	local Cleared = false
	
	if #LogHistory > Output.LogCount then
		if Output.LogCount == 0 then
			Cleared = true
		end
		Output.LogCount = #LogHistory
		
	elseif math.abs(Output.LogCount - #LogHistory) > 1 then
		Output.LogCount = #LogHistory
		Cleared = true
	end
	
	for i = math.max(#LogHistory - 25, 1), #LogHistory do
		local Log = LogHistory[i]
		
		if Log then
			Log.messageType = Log.messageType.Name
			Logs[i] = Log	
		end
	end
	
	return Logs, Cleared
end

function Output:Flush()	
	local Logs, Cleared = Output:Sanitize()
	
	if not Output.Busy or Server.Ready then
		Output.Busy = true
		Server.Ready = false
		
		local Data = {
			["StartTime"] = Server.StartTime;
			["PlaceId"] = game.PlaceId;
			["Cleared"] = Cleared;
			["Logs"] = Logs
		}
				
		if not Http:Post(Data) then
			Server:Connect(true)
		end
		
		Output.Busy = false
	else
		task.delay(1/15, function()
			if not Output.Busy then
				Output:Flush()
			end
		end)
	end
end

function Output:Load()
	if Settings.autoConnect then
		Server:Connect()
	end
	
	Cleanup:Hook().MessageOut = LogService.MessageOut:Connect(function(Message, Type)
		if Message:find(plugin.Name) or Server.Disconnected then
			return
		end
				
		if not Server.Connected then
			if not Server.Connecting then
				Server:Connect()
			end
			return
		end
		
		if not Server.StartTime then
			Server:UpdateStartTime()
		end
		
		task.delay(1/15, Output.Flush)
	end)
end

return Output