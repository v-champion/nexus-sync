local TweenService = game:GetService("TweenService")

return function (Object, Goal, Duration, Style, Direction)
	Direction = Direction or Enum.EasingDirection.Out
	Style = Style or Enum.EasingStyle.Quad
	
	local TweenData = TweenInfo.new(
		Duration,
		Style,
		Direction
	)
	
	local Animation = TweenService:Create(Object, TweenData, Goal)
	Animation:Play()
	
	return Animation
end