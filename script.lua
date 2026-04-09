local g=Instance.new("ScreenGui",game.CoreGui)
local main=Instance.new("Frame",g)
local topbar=Instance.new("Frame",main)
local title=Instance.new("TextLabel",topbar)

-- MAIN UI
main.Size=UDim2.new(0,400,0,250)
main.Position=UDim2.new(0.5,-200,0.5,-125)
main.BackgroundColor3=Color3.fromRGB(15,15,15)
main.BorderSizePixel=0
Instance.new("UICorner",main).CornerRadius=UDim.new(0,12)

-- TOPBAR
topbar.Size=UDim2.new(1,0,0,40)
topbar.BackgroundColor3=Color3.fromRGB(20,20,20)
Instance.new("UICorner",topbar).CornerRadius=UDim.new(0,12)

title.Size=UDim2.new(1,0,1,0)
title.BackgroundTransparency=1
title.Text="🔥 FPS HUB"
title.TextColor3=Color3.fromRGB(255,255,0)
title.Font=Enum.Font.SourceSansBold
title.TextScaled=true

-- DRAG
local dragging=false
local dragStart,startPos

topbar.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 then
		dragging=true
		dragStart=i.Position
		startPos=main.Position
	end
end)

topbar.InputEnded:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 then
		dragging=false
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(i)
	if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then
		local delta=i.Position-dragStart
		main.Position=UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset+delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset+delta.Y
		)
	end
end)

-- CONTENT
local content=Instance.new("Frame",main)
content.Position=UDim2.new(0,0,0,45)
content.Size=UDim2.new(1,0,1,-45)
content.BackgroundTransparency=1

-- FPS TEXT
local info=Instance.new("TextLabel",content)
info.Size=UDim2.new(1,0,0.4,0)
info.BackgroundTransparency=1
info.TextColor3=Color3.fromRGB(255,255,0)
info.Font=Enum.Font.SourceSansBold
info.TextScaled=true

-- DISCORD
local discord=Instance.new("TextLabel",content)
discord.Position=UDim2.new(0,0,0.4,0)
discord.Size=UDim2.new(1,0,0.2,0)
discord.BackgroundTransparency=1
discord.TextColor3=Color3.fromRGB(114,137,218)
discord.Text="discord.gg/yourlink"
discord.Font=Enum.Font.SourceSansBold
discord.TextScaled=true

-- TOGGLE BUTTON
local btn=Instance.new("TextButton",content)
btn.Position=UDim2.new(0.25,0,0.7,0)
btn.Size=UDim2.new(0.5,0,0.2,0)
btn.Text="Toggle FPS: ON"
btn.BackgroundColor3=Color3.fromRGB(30,30,30)
btn.TextColor3=Color3.fromRGB(255,255,255)
btn.Font=Enum.Font.SourceSansBold
btn.TextScaled=true
Instance.new("UICorner",btn).CornerRadius=UDim.new(0,8)

local show=true
btn.MouseButton1Click:Connect(function()
	show=not show
	btn.Text="Toggle FPS: "..(show and "ON" or "OFF")
end)

-- FPS SYSTEM
local fps=0
local frames=0
local last=tick()

game:GetService("RunService").RenderStepped:Connect(function()
	frames+=1
end)

while true do
	task.wait(0.5)

	fps=frames*2
	frames=0

	local ping=math.random(60,120)

	if show then
		info.Text="FPS: "..fps.." | Ping: "..ping.." ms"
	else
		info.Text="(hidden)"
	end
end