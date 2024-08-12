local Cleanup = require(script.Parent.Cleanup)
local Http = require(script.Parent.Http)

local Signal = require(script.Signal)

local Server = {
	["LastUpdate"] = os.time();
	["Changed"] = Signal.new();
	["Disconnected"] = false;
	["Connecting"] = false;
}

function Server:Connect(Yield: boolean | nil)
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
end

function Server:Update()
	Server.LastUpdate = os.clock()
	
	if Server.Connected and not Server.Connecting then
		if Http:Ping() then
			return
		end
		Server.Connected = false
		Server.Changed:Fire(false)
	end
end

function Server:UpdateStartTime()
	Server.StartTime = os.clock() - 0.1
end

function Server:Disconnect()
	Server.Disconnected = true		
	Server.Connected = false
	Server.StartTime = false
	task.wait(1)
	Server.Changed:Fire(false)
end

return Server