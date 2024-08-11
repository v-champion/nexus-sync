local plugin = plugin or script:FindFirstAncestorWhichIsA("Plugin")

local Settings = {
	["autoConnect"] = true;
	["port"] = 50583;
}

local function Update(Save: boolean | nil)
	for Setting, Value in (Settings) do
		if typeof(Value) ~= "function" then
			local SavedValue = nil

			if not Save then
				SavedValue = plugin:GetSetting(`NexusSync_{Setting}`)
			end

			if SavedValue == nil then 
				Settings[Setting] = Value
				task.spawn(plugin.SetSetting, plugin, `NexusSync_{Setting}`, Value)	
			else
				Settings[Setting] = SavedValue
			end	
		end
	end
end

function Settings:Save()
	Update(true)
end

function Settings:Load()
	if plugin then
		Update()	
	end	
end

return Settings