local ScriptEditorService = game:GetService("ScriptEditorService")

local Connections = {}
Connections.Functions = {}
Connections.List = {}

function Connections:Hook(Service: string | nil, Tag: string | nil)
	if Service and Tag then
		Connections.Functions[Service] = Tag
		return true
	end
	return Connections.List
end

function Connections:Stop()
	for Service, Tag in (Connections.Functions) do
		if Service == "ScriptAnalysisCallback" then
			ScriptEditorService:DeregisterScriptAnalysisCallback(Tag)
		end
	end
    
	table.clear(Connections.Functions)

	for _, Connection in (Connections.List) do
		if typeof(Connection) == "thread" then
			task.cancel(Connection)
		else
			Connection:Disconnect()	
		end
	end
	
	table.clear(Connections.List)
end

return Connections