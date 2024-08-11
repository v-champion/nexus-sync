local plugin = plugin or script:FindFirstAncestorWhichIsA("Plugin")
local toolbar = plugin:CreateToolbar("Nexus Sync")

local Settings = require(script.Parent.Settings)
local Server = require(script.Parent.Server)

local Interface = require(script.Interface)
local Gui = require(script.Gui)

local Widget = {}

local button = toolbar:CreateButton("Nexus Sync", "Open the widget", "rbxassetid://18892374862")
button.ClickableWhenViewportHidden = true

local widgetInfo = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Float, false, false, 250, 230
)

local widgetGui = plugin:CreateDockWidgetPluginGui("Nexus Sync", widgetInfo)
widgetGui.Title = "Nexus Sync"
widgetGui.Name = "Nexus Sync"

local Frame = Gui()
Frame.Visible = true
Frame.Parent = widgetGui

button.Click:Connect(function()
	widgetGui.Enabled = not widgetGui.Enabled
end)

local function GetButtonState(Name, On)
	if (Name == "On" and On) or (Name == "Off" and not On) then	
		return true
	end
	return false
end

local function AnimateToggleButton(Button, On)
	local Data = Interface:Get("Toggle")

	for i, StateFrame in(Button:GetChildren()) do
		local ButtonState = GetButtonState(StateFrame.Name, On)
		Interface:Tween(StateFrame, Data[StateFrame.Name][ButtonState])
	end
end

local function UpdateStatus(Type)
	local Data = Interface:Get("Status")
	Interface:Tween(Frame.Status, Data[Type], 1/30)
	
	local Text = Interface:Get("Text")
	Frame.Status.Label.Text = Text[Type]
end

local function UpdateConnectButton(Toggle, Text)
	local Data = Interface:Get("Status")["Connect"]
	Interface:Tween(Frame.Connect, Data[Toggle], 0.1)
	
	Frame.Connect.AutoButtonColor = Toggle
	Frame.Connect.Label.Text = Text
end

local function Connect()
	if not Server.Connected and not Server.Connecting then
		UpdateConnectButton(false, "Connect")
		UpdateStatus("Connecting")
		Server:Connect(true)		
	end
end

local function Disconnect()
	if Server.Connected then
		UpdateConnectButton(false, "Disconnect")
		Server:Disconnect()
	end
end

function Widget:Close()
	widgetGui.Enabled = false
end

function Widget:Load()	
	widgetGui.Enabled = false
	
	UpdateConnectButton(true, "Connect")
	UpdateStatus("Disconnected")
	
	for i, SettingFrame in(Frame.List:GetChildren()) do
		local Toggle = Settings.autoConnect
		
		if SettingFrame:FindFirstChild("Toggle") then
			AnimateToggleButton(SettingFrame.Toggle, Toggle)
			
			SettingFrame.Toggle.MouseButton1Click:Connect(function()
				Toggle = not Toggle
				
				AnimateToggleButton(SettingFrame.Toggle, Toggle)
				
				Settings.autoConnect = Toggle
				Settings:Save()
			end)
			
		elseif SettingFrame:FindFirstChild("Text") then
			SettingFrame.Text.Box.Text = Settings.port
			
			SettingFrame.Text.Box.FocusLost:Connect(function()
				if not tonumber(SettingFrame.Text.Box) then
					SettingFrame.Text.Box.Text = Settings.port
				else
					Settings:Save()
				end
			end)
		end
	end
	
	Frame.Connect.MouseButton1Click:Connect(function()
		if Server.Connected then
			Disconnect()
		else
			Connect()
		end
	end)
	
	Server.Changed:Connect(function(Connected)
		if Connected then
			UpdateConnectButton(true, "Disconnect")
			UpdateStatus("Connected")	
			
		elseif not Server.Connecting then
			UpdateConnectButton(true, "Connect")
			UpdateStatus("Disconnected")	
		end
	end)
end

return Widget