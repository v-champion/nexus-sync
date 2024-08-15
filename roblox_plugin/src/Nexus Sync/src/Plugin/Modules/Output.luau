local LogService = game:GetService("LogService")

local Cleanup = require(script.Parent.Cleanup)
local Server = require(script.Parent.Server)
local Http = require(script.Parent.Http)

local GUID = Http:GUID()

local Output = {
	UploadInterval = 1/15;
	PendingLogs = false;
	Busy = false;
	Logs = {
		Uploaded = 0;
		Count = 0;
		Data = {};
	};
}

export type OutputLog = {
	["messageType"]: string;
	["stackTrace"]: StackTrace | nil;
	["timestamp"]: number;
	["message"]: string;
}

export type OutputLogs = {
	[string]: OutputLog;
}

export type StackTrace = {
	[number]: string
}

function Output:Upload(Logs: OutputLogs, Count: number)
	local Data = {
		["StartTime"] = Server.StartTime;
		["PlaceId"] = game.PlaceId;
		["GUID"] = GUID;
		["Logs"] = Logs
	}
	
	local HttpRequest = Http:Post(Data)

	if HttpRequest then
		if HttpRequest == "Ratelimited" then
			task.wait(Output.UploadInterval)
			Output:Upload(Logs, Count)
		else
			for i = Output.Logs.Uploaded, Count do
				Output.Logs.Data[i] = nil
			end
			Output.Logs.Uploaded = Count
		end
	end
end

function Output:Collect(Count: number): OutputLogs
	local Logs = {}

	for i = math.max(Output.Logs.Uploaded, 1), Count do
		Logs[tostring(i)] = Output.Logs.Data[i]
	end
	
	return Logs
end

function Output:Flush(Count: number)	
	Server:UpdateStartTime()
	
	if not Output.Busy then
		Output.Busy = true

		local Logs = Output:Collect(Count)

		if Logs then
			Output:Upload(Logs, Count)
		end

		Output.Busy = false	
	end
end

function Output:IsConnected(): boolean
	if Server.Disconnected then
		return false
	end
	
	if not Server.Connected then
		Server:AutoConnect(true)
	end

	return Server.Connected
end

function Output:Insert(Log: OutputLog)
	Output.Logs.Count += 1
	Output.Logs.Data[Output.Logs.Count] = Log
	
	if not Output.PendingLogs and Output:IsConnected() then
		Output.PendingLogs = true
	end
end

function Output:IsTrace(Message: string): boolean
	local StackTrace = false
	
	if string.sub(Message, 1, 8) == "Script '" and string.find(Message, "Line") then
		StackTrace = true
	end
	
	if Message == "Stack Begin" or Message == "Stack End" then
		StackTrace = true
	end
	
	return StackTrace
end

function Output:Load()
	Server:AutoConnect()
	
	Cleanup:Hook().OutputQueue = task.spawn(function()
		while task.wait(Output.UploadInterval) do
			if Output.PendingLogs and Output:IsConnected() then
				Output.PendingLogs = false
				
				Output:Flush(Output.Logs.Count)	
			end
		end
	end)

	Cleanup:Hook().MessageOut = LogService.MessageOut:Connect(function(Message: string, Type: Enum.MessageType)
		local Log = {
			["timestamp"] = DateTime.now().UnixTimestampMillis;
			["messageType"] = Type.Name;
			["message"] = Message;
		}

		if Output:IsTrace(Message) then
			Log.messageType = "MessageTrace"
		end

		Output:Insert(Log)
	end)
end

return Output