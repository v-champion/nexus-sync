local Tween = require(script.Parent.Tween)

local Interface = {}
Interface.List = {}

function Interface:Get(Name, Value)
	if Value then
		return Interface.List[Name][Value]
	end
	return Interface.List[Name]
end

function Interface:Apply(GuiObject, Data)
	if Data[GuiObject.ClassName] then
		for Property, Value in (Data[GuiObject.ClassName]) do
			GuiObject[Property] = Value
		end
	end
	
	for i, v in (GuiObject:GetChildren()) do
		local TweenData = Data[v.ClassName]
		
		if TweenData then
			for Property, Value in (TweenData) do
				v[Property] = Value
			end	
		end
	end
end

function Interface:Tween(GuiObject, Data, Duration)
	if Data[GuiObject.ClassName] then
		Tween(GuiObject, Data[GuiObject.ClassName], Duration)
	end

	for i, v in (GuiObject:GetChildren()) do
		local TweenData = Data[v.ClassName]
		
		if TweenData then
			Tween(v, TweenData, Duration)
		end
	end
end

for i, v in (script:GetChildren()) do
	if v.ClassName == "ModuleScript" then
		Interface.List[v.Name] = require(v)
	end
end

return Interface