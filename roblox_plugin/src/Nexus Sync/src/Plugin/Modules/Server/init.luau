local Cleanup = require(script.Parent.Cleanup)
local Http = require(script.Parent.Http)

local Signal = require(script.Signal)

local Server = {}
Server.Changed = Signal.new()
Server.Disconnected = false
Server.Connecting = false
Server.Ready = false

function Server:Connect(Yield: boolean | nil)
	if not Server.Connecting then
		Server.Connecting = true
		Server.Connected = false
		
		Server.Changed:Fire(false)
		
		Cleanup:Hook().PingCheck = task.spawn(function()
			local Timeout = 5
			
			while task.wait(1) and Timeout > 0 and not Server.Connected do
				Server.Connected = Http:Ping()
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

function Server:UpdateStartTime()
	Server.StartTime = os.time() - 0.1
end

function Server:Disconnect()
	Server.Disconnected = true		
	Server.Connected = false
	Server.StartTime = false
	task.wait(1)
	Server.Changed:Fire(false)
end

return Server