local LogService = game:GetService("LogService")

local Settings = require(script.Parent.Settings)
local Cleanup = require(script.Parent.Cleanup)
local Server = require(script.Parent.Server)
local Http = require(script.Parent.Http)

local Output = {
	["UploadInterval"] = 1/15;
	["PendingLogs"] = false;
	["Busy"] = false;
	["Logs"] = {
		["Uploaded"] = 0;
		["Count"] = 0;
		["Data"] = {};
	};
}

function Output:Upload(Logs, Count, Clear)
	Server.LastUpdate = os.clock()

	local Data = {
		["StartTime"] = Server.StartTime;
		["PlaceId"] = game.PlaceId;
		["Cleared"] = Clear;
		["Logs"] = Logs
	}

	local HttpRequest = Http:Post(Data)

	if HttpRequest == "Ratelimited" then
		task.wait(Output.UploadInterval)
		Output:Upload(Logs, Count, Clear)
		
	elseif not HttpRequest then
		Server:Connect(true)
	else
		Output.Logs.Uploaded = Count
	end
end

function Output:Collect(Count)
	local NewSession = false
	local Logs = {}

	for i = Output.Logs.Uploaded, Count do
		if i == 0 then
			NewSession = true
			continue
		end
		Logs[tostring(i)] = Output.Logs.Data[i]
		Output.Logs.Data[i] = nil
	end
	
	return Logs, NewSession
end

function Output:Flush(Count)	
	if not Output.Busy then
		Output.Busy = true

		local Logs, Clear = Output:Collect(Count)

		if Logs then
			Output:Upload(Logs, Count, Clear)
		end

		Output.Busy = false	
	end
end

function Output:IsConnected()
	if Server.Disconnected then
		return
	end
	
	if not Server.Connected then
		if not Server.Connecting and Settings.autoConnect then
			Server:Connect()
		end
		return
	end

	if not Server.StartTime then
		Server:UpdateStartTime()
	end

	return true
end

function Output:Load()
	if Settings.autoConnect then
		Server:Connect()
	end
	
	Cleanup:Hook().OutputQueue = task.spawn(function()
		while task.wait(Output.UploadInterval) do
			if Output.PendingLogs and Output:IsConnected() then
				Output.PendingLogs = false
				Output:Flush(Output.Logs.Count)	
			end
		end
	end)

	Cleanup:Hook().MessageOut = LogService.MessageOut:Connect(function(Message, Type)
		Output.Logs.Count += 1

		Output.Logs.Data[Output.Logs.Count] = {
			["message"] = Message;
			["timestamp"] = os.clock();
			["messageType"] = Type.Name;
		}

		if not Output.PendingLogs and Output:IsConnected() then
			Output.PendingLogs = true
		end
	end)
end

return Output