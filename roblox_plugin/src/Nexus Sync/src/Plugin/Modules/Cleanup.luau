local ScriptEditorService = game:GetService("ScriptEditorService")

local Cleanup = {}
Cleanup.Functions = {}
Cleanup.List = {}

function Cleanup:Hook(Service: string | nil, Tag: string | nil)
	if Service and Tag then
		Cleanup.Functions[Service] = Tag
		return true
	end
	return Cleanup.List
end

function Cleanup:Clear()
	for Service, Tag in (Cleanup.Functions) do
		if Service == "ScriptAnalysisCallback" then
			ScriptEditorService:DeregisterScriptAnalysisCallback(Tag)
		end
	end
    
	table.clear(Cleanup.Functions)

	for _, Connection in (Cleanup.List) do
		if typeof(Connection) == "thread" then
			task.cancel(Connection)
		else
			Connection:Disconnect()	
		end
	end
	
	table.clear(Cleanup.List)
end

return Cleanup