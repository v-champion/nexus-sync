local Settings = require(script.Parent.Settings)
local Cleanup = require(script.Parent.Cleanup)
local Http = require(script.Parent.Http)

local Signal = require(script.Signal)

local Server = {
	Changed = Signal.new();
	Disconnected = false;
	Connecting = false;
	Connected = false;
	StartTime = nil;
}

function Server:Connect(Yield: boolean | nil, Force: boolean | nil)
	if Server.Disconnected and not Force then
		return
	end

	if not Server.Connecting then
		Server.Connecting = true
		Server.Connected = false
		
		Server.Changed:Fire(false)
		
		Cleanup:Hook().PingCheck = task.spawn(function()
			local Timeout = 3
			
			while Timeout > 0 and not Server.Connected do
				Server.Connected = Http:Ping()

				task.wait(1)
				Timeout -= 1
			end

			Server.Disconnected = false
			Server.Connecting = false
			
			Server.Changed:Fire(Server.Connected)
		end)	
	end
	
	if Yield and Server.Connecting then
		Server.Changed:Wait()
	end
	
	return Server.Connected
end

function Server:Update()	
	if Server.Connected and not Server.Connecting then
		if Http:Ping() then
			return
		end
		Server:Disconnect(true)
	end
end

function Server:Disconnect(LostConnection: boolean | nil)
	Server.Disconnected = not LostConnection		
	Server.Connected = false
	Server.StartTime = nil
	task.wait(1)
	Server.Changed:Fire(Server.Connected)
end

function Server:AutoConnect(...)
	if Settings.autoConnect then
		return Server:Connect(...)	
	end
	return
end

function Server:UpdateStartTime()
	if not Server.StartTime then
		Server.StartTime = DateTime.now().UnixTimestampMillis - 2000
	end
end

return Server