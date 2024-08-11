return function()
	local Settings = Instance.new("Frame")
	Settings.Name = "Settings"
	Settings.AnchorPoint = Vector2.new(0.5, 0.5)
	Settings.BackgroundColor3 = Color3.fromRGB(46, 46, 46)
	Settings.BorderColor3 = Color3.fromRGB(43, 43, 43)
	Settings.Position = UDim2.fromScale(0.5, 0.5)
	Settings.Size = UDim2.fromOffset(250, 206)
	Settings.Visible = false

	local Label = Instance.new("TextLabel")
	Label.Name = "Label"
	Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Label.BackgroundTransparency = 1
	Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Label.BorderSizePixel = 0
	Label.FontFace = Font.new(
		"rbxasset://fonts/families/GothamSSm.json",
		Enum.FontWeight.Medium,
		Enum.FontStyle.Normal
	)
	Label.Size = UDim2.new(1, 0, 0, 50)
	Label.Text = "Plugin Settings"
	Label.TextColor3 = Color3.fromRGB(255, 255, 255)
	Label.TextSize = 18
	Label.TextWrapped = true
	Label.Parent = Settings

	local Divider = Instance.new("Frame")
	Divider.Name = "Divider"
	Divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Divider.BackgroundTransparency = 0.5
	Divider.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Divider.BorderSizePixel = 0
	Divider.Position = UDim2.fromOffset(0, 50)
	Divider.Size = UDim2.new(1, 0, 0, 1)

	local UIGradient = Instance.new("UIGradient")
	UIGradient.Name = "UIGradient"
	UIGradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.2, 0.75),
		NumberSequenceKeypoint.new(0.466, 0.731),
		NumberSequenceKeypoint.new(0.799, 0.737),
		NumberSequenceKeypoint.new(1, 1),
	})
	UIGradient.Parent = Divider

	Divider.Parent = Settings

	local List = Instance.new("Frame")
	List.Name = "List"
	List.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	List.BackgroundTransparency = 1
	List.BorderColor3 = Color3.fromRGB(0, 0, 0)
	List.BorderSizePixel = 0
	List.Position = UDim2.fromOffset(0, 50)
	List.Size = UDim2.new(1, 0, 1, -50)

	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.Name = "UIListLayout"
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Parent = List

	local Port = Instance.new("Frame")
	Port.Name = "Port"
	Port.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Port.BackgroundTransparency = 1
	Port.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Port.BorderSizePixel = 0
	Port.Size = UDim2.new(1, 0, 0, 50)

	local Desc = Instance.new("TextLabel")
	Desc.Name = "Desc"
	Desc.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Desc.BackgroundTransparency = 1
	Desc.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Desc.BorderSizePixel = 0
	Desc.FontFace = Font.new(
		"rbxasset://fonts/families/GothamSSm.json",
		Enum.FontWeight.Medium,
		Enum.FontStyle.Normal
	)
	Desc.Position = UDim2.fromOffset(15, 22)
	Desc.Size = UDim2.new(1, 0, 0, 20)
	Desc.Text = "vscode port"
	Desc.TextColor3 = Color3.fromRGB(166, 166, 166)
	Desc.TextSize = 14
	Desc.TextWrapped = true
	Desc.TextXAlignment = Enum.TextXAlignment.Left
	Desc.Parent = Port

	local Text = Instance.new("Frame")
	Text.Name = "Text"
	Text.AnchorPoint = Vector2.new(1, 0.5)
	Text.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
	Text.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Text.BorderSizePixel = 0
	Text.Position = UDim2.new(1, -15, 0.5, 0)
	Text.Size = UDim2.fromOffset(60, 25)

	local UICorner = Instance.new("UICorner")
	UICorner.Name = "UICorner"
	UICorner.CornerRadius = UDim.new(0, 4)
	UICorner.Parent = Text

	local UIStroke = Instance.new("UIStroke")
	UIStroke.Name = "UIStroke"
	UIStroke.Color = Color3.fromRGB(97, 97, 97)
	UIStroke.Thickness = 1.33
	UIStroke.Parent = Text

	local Box = Instance.new("TextBox")
	Box.Name = "Box"
	Box.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Box.BackgroundTransparency = 1
	Box.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Box.BorderSizePixel = 0
	Box.CursorPosition = -1
	Box.ClearTextOnFocus = false
	Box.FontFace = Font.new(
		"rbxasset://fonts/families/GothamSSm.json",
		Enum.FontWeight.Bold,
		Enum.FontStyle.Normal
	)
	Box.PlaceholderColor3 = Color3.fromRGB(178, 178, 178)
	Box.PlaceholderText = "50583"
	Box.Size = UDim2.fromScale(1, 1)
	Box.Text = "50583"
	Box.TextColor3 = Color3.fromRGB(255, 255, 255)
	Box.TextSize = 14
	Box.TextWrapped = true
	Box.Parent = Text

	Text.Parent = Port

	local Title = Instance.new("TextLabel")
	Title.Name = "Title"
	Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Title.BackgroundTransparency = 1
	Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Title.BorderSizePixel = 0
	Title.FontFace = Font.new(
		"rbxasset://fonts/families/GothamSSm.json",
		Enum.FontWeight.SemiBold,
		Enum.FontStyle.Normal
	)
	Title.Position = UDim2.fromOffset(15, -1)
	Title.Size = UDim2.new(1, 0, 0, 35)
	Title.Text = "port number"
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.TextSize = 14
	Title.TextWrapped = true
	Title.TextXAlignment = Enum.TextXAlignment.Left

	local UIGradient1 = Instance.new("UIGradient")
	UIGradient1.Name = "UIGradient"
	UIGradient1.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(0.505, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(0.576, Color3.fromRGB(223, 223, 223)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
	})
	UIGradient1.Rotation = 90
	UIGradient1.Parent = Title

	Title.Parent = Port

	local Divider1 = Instance.new("Frame")
	Divider1.Name = "Divider"
	Divider1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Divider1.BackgroundTransparency = 0.5
	Divider1.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Divider1.BorderSizePixel = 0
	Divider1.Position = UDim2.fromOffset(0, 50)
	Divider1.Size = UDim2.new(1, 0, 0, 1)

	local UIGradient2 = Instance.new("UIGradient")
	UIGradient2.Name = "UIGradient"
	UIGradient2.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.2, 0.75),
		NumberSequenceKeypoint.new(0.466, 0.731),
		NumberSequenceKeypoint.new(0.799, 0.737),
		NumberSequenceKeypoint.new(1, 1),
	})
	UIGradient2.Parent = Divider1

	Divider1.Parent = Port

	Port.Parent = List

	local Auto = Instance.new("Frame")
	Auto.Name = "Auto"
	Auto.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Auto.BackgroundTransparency = 1
	Auto.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Auto.BorderSizePixel = 0
	Auto.Size = UDim2.new(1, 0, 0, 50)

	local Desc1 = Instance.new("TextLabel")
	Desc1.Name = "Desc"
	Desc1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Desc1.BackgroundTransparency = 1
	Desc1.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Desc1.BorderSizePixel = 0
	Desc1.FontFace = Font.new(
		"rbxasset://fonts/families/GothamSSm.json",
		Enum.FontWeight.Medium,
		Enum.FontStyle.Normal
	)
	Desc1.Position = UDim2.fromOffset(15, 22)
	Desc1.Size = UDim2.new(1, 0, 0, 20)
	Desc1.Text = "connect on startup"
	Desc1.TextColor3 = Color3.fromRGB(166, 166, 166)
	Desc1.TextSize = 14
	Desc1.TextWrapped = true
	Desc1.TextXAlignment = Enum.TextXAlignment.Left
	Desc1.Parent = Auto

	local Title1 = Instance.new("TextLabel")
	Title1.Name = "Title"
	Title1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Title1.BackgroundTransparency = 1
	Title1.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Title1.BorderSizePixel = 0
	Title1.FontFace = Font.new(
		"rbxasset://fonts/families/GothamSSm.json",
		Enum.FontWeight.SemiBold,
		Enum.FontStyle.Normal
	)
	Title1.Position = UDim2.fromOffset(15, -1)
	Title1.Size = UDim2.new(1, 0, 0, 35)
	Title1.Text = "auto connect"
	Title1.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title1.TextSize = 14
	Title1.TextWrapped = true
	Title1.TextXAlignment = Enum.TextXAlignment.Left

	local UIGradient3 = Instance.new("UIGradient")
	UIGradient3.Name = "UIGradient"
	UIGradient3.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(0.505, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(0.576, Color3.fromRGB(223, 223, 223)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
	})
	UIGradient3.Rotation = 90
	UIGradient3.Parent = Title1

	Title1.Parent = Auto

	local Divider2 = Instance.new("Frame")
	Divider2.Name = "Divider"
	Divider2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Divider2.BackgroundTransparency = 0.5
	Divider2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Divider2.BorderSizePixel = 0
	Divider2.Position = UDim2.fromOffset(0, 50)
	Divider2.Size = UDim2.new(1, 0, 0, 1)

	local UIGradient4 = Instance.new("UIGradient")
	UIGradient4.Name = "UIGradient"
	UIGradient4.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.2, 0.75),
		NumberSequenceKeypoint.new(0.466, 0.731),
		NumberSequenceKeypoint.new(0.799, 0.737),
		NumberSequenceKeypoint.new(1, 1),
	})
	UIGradient4.Parent = Divider2

	Divider2.Parent = Auto

	local Toggle = Instance.new("TextButton")
	Toggle.Name = "Toggle"
	Toggle.Active = false
	Toggle.AnchorPoint = Vector2.new(1, 0.5)
	Toggle.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
	Toggle.BackgroundTransparency = 1
	Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Toggle.BorderSizePixel = 0
	Toggle.Position = UDim2.new(1, -15, 0.5, 0)
	Toggle.Selectable = false
	Toggle.Size = UDim2.fromOffset(25, 25)
	Toggle.Text = ""
	Toggle.TextScaled = true
	Toggle.TextWrapped = true

	local Off = Instance.new("Frame")
	Off.Name = "Off"
	Off.BackgroundColor3 = Color3.fromRGB(53, 53, 53)
	Off.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Off.BorderSizePixel = 0
	Off.Size = UDim2.fromScale(1, 1)

	local Icon = Instance.new("ImageLabel")
	Icon.Name = "Icon"
	Icon.AnchorPoint = Vector2.new(0.5, 0.5)
	Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Icon.BackgroundTransparency = 1
	Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Icon.BorderSizePixel = 0
	Icon.Image = "http://www.roblox.com/asset/?id=18892569568"
	Icon.ImageTransparency = 0.9
	Icon.Position = UDim2.fromScale(0.5, 0.5)
	Icon.Size = UDim2.fromOffset(21, 21)
	Icon.Parent = Off

	local Stroke = Instance.new("UIStroke")
	Stroke.Name = "Stroke"
	Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	Stroke.Color = Color3.fromRGB(97, 97, 97)
	Stroke.Thickness = 1.33
	Stroke.Transparency = 0.6
	Stroke.Parent = Off

	local Corner = Instance.new("UICorner")
	Corner.Name = "Corner"
	Corner.CornerRadius = UDim.new(0, 4)
	Corner.Parent = Off

	Off.Parent = Toggle

	local On = Instance.new("Frame")
	On.Name = "On"
	On.BackgroundColor3 = Color3.fromRGB(42, 144, 74)
	On.BorderColor3 = Color3.fromRGB(0, 0, 0)
	On.BorderSizePixel = 0
	On.Size = UDim2.fromScale(1, 1)
	On.ZIndex = 3

	local Corner1 = Instance.new("UICorner")
	Corner1.Name = "Corner"
	Corner1.CornerRadius = UDim.new(0, 4)
	Corner1.Parent = On

	local Gradient = Instance.new("UIGradient")
	Gradient.Name = "Gradient"
	Gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 220, 220)),
	})
	Gradient.Parent = On

	local Stroke1 = Instance.new("UIStroke")
	Stroke1.Name = "Stroke"
	Stroke1.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	Stroke1.Color = Color3.fromRGB(45, 45, 45)
	Stroke1.Thickness = 1.33
	Stroke1.Parent = On

	local Icon1 = Instance.new("ImageLabel")
	Icon1.Name = "Icon"
	Icon1.AnchorPoint = Vector2.new(0.5, 0.5)
	Icon1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Icon1.BackgroundTransparency = 1
	Icon1.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Icon1.BorderSizePixel = 0
	Icon1.Image = "http://www.roblox.com/asset/?id=18892566181"
	Icon1.Position = UDim2.fromScale(0.5, 0.5)
	Icon1.Size = UDim2.fromOffset(21, 21)
	Icon1.ZIndex = 3
	Icon1.Parent = On

	On.Parent = Toggle

	Toggle.Parent = Auto

	Auto.Parent = List

	List.Parent = Settings

	local Status = Instance.new("Frame")
	Status.Name = "Status"
	Status.Active = true
	Status.AnchorPoint = Vector2.new(1, 1)
	Status.BackgroundColor3 = Color3.fromRGB(37, 43, 32)
	Status.BackgroundTransparency = 1
	Status.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Status.BorderSizePixel = 0
	Status.Position = UDim2.new(1, -15, 1, -15)
	Status.Size = UDim2.new(0.5, -20, 0, 25)

	local UICorner1 = Instance.new("UICorner")
	UICorner1.Name = "UICorner"
	UICorner1.CornerRadius = UDim.new(0, 4)
	UICorner1.Parent = Status

	local Stroke2 = Instance.new("UIStroke")
	Stroke2.Name = "Stroke"
	Stroke2.Color = Color3.fromRGB(65, 65, 65)
	Stroke2.Thickness = 1.33
	Stroke2.Parent = Status

	local Label1 = Instance.new("TextLabel")
	Label1.Name = "Label"
	Label1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Label1.BackgroundTransparency = 1
	Label1.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Label1.BorderSizePixel = 0
	Label1.FontFace = Font.new(
		"rbxasset://fonts/families/GothamSSm.json",
		Enum.FontWeight.SemiBold,
		Enum.FontStyle.Normal
	)
	Label1.Size = UDim2.fromScale(1, 1)
	Label1.Text = "not connected"
	Label1.TextColor3 = Color3.fromRGB(111, 111, 111)
	Label1.TextSize = 14
	Label1.TextWrapped = true
	Label1.Parent = Status

	Status.Parent = Settings

	local Connect = Instance.new("TextButton")
	Connect.Name = "Connect"
	Connect.AnchorPoint = Vector2.new(0, 1)
	Connect.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
	Connect.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Connect.BorderSizePixel = 0
	Connect.Position = UDim2.new(0, 15, 1, -15)
	Connect.Selectable = false
	Connect.Size = UDim2.new(0.5, -20, 0, 25)
	Connect.Text = ""
	Connect.TextScaled = true
	Connect.TextWrapped = true

	local UICorner2 = Instance.new("UICorner")
	UICorner2.Name = "UICorner"
	UICorner2.CornerRadius = UDim.new(0, 4)
	UICorner2.Parent = Connect

	local Stroke3 = Instance.new("UIStroke")
	Stroke3.Name = "Stroke"
	Stroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	Stroke3.Color = Color3.fromRGB(97, 97, 97)
	Stroke3.Thickness = 1.33
	Stroke3.Parent = Connect

	local Label2 = Instance.new("TextLabel")
	Label2.Name = "Label"
	Label2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Label2.BackgroundTransparency = 1
	Label2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Label2.BorderSizePixel = 0
	Label2.FontFace = Font.new(
		"rbxasset://fonts/families/GothamSSm.json",
		Enum.FontWeight.SemiBold,
		Enum.FontStyle.Normal
	)
	Label2.Size = UDim2.fromScale(1, 1)
	Label2.Text = "connect"
	Label2.TextColor3 = Color3.fromRGB(255, 255, 255)
	Label2.TextSize = 14
	Label2.TextWrapped = true
	Label2.Parent = Connect

	Connect.Parent = Settings
	
	return Settings
end