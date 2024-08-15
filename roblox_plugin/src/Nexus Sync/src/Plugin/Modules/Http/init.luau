local HttpService = game:GetService("HttpService")

local Settings = require(script.Parent.Settings)
local Ratelimit = require(script.Ratelimit)

local CooldownCheck = Ratelimit(6, 3)
local CooldownDelay = 1

local Http = {}

function Http:Post(Data)
	if CooldownCheck("Http") then
		local Success, Result = pcall(function()
			local response = HttpService:RequestAsync({
				Url = `http://localhost:{Settings.port}/data`, 
				Method = "POST",
				Headers = {
					["Content-Type"] = "application/json",
				},
				Body = HttpService:JSONEncode(Data),
			})

			if response.Success then
				return response
			end
            return response
		end)
        
		if Success and Result and Result.Success then
			return true
		else
			warn("[Nexus Sync]:", Result)
		end
	else
		task.wait(CooldownDelay)
		return "Ratelimited"
	end
    return false
end

function Http:Ping()
	local Success, Result = pcall(function()
		local response = HttpService:RequestAsync({
			Url = `http://localhost:{Settings.port}/data`,
			Method = "GET",
		})
		return response.StatusCode == 404
	end)

	if Success and Result then
		return true
	end
    return false
end

function Http:GUID()
	return HttpService:GenerateGUID(false)
end

return Http