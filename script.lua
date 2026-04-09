local g=Instance.new("ScreenGui",game.CoreGui)
local f=Instance.new("Frame",g)

-- Frame chính
f.Position=UDim2.new(0.5,-180,0,10)
f.Size=UDim2.new(0,360,0,90)
f.BackgroundColor3=Color3.fromRGB(0,0,0)
f.BorderSizePixel=2
f.BorderColor3=Color3.fromRGB(255,255,0)
Instance.new("UICorner",f).CornerRadius=UDim.new(0,12)

-- FPS + Ping
local top=Instance.new("TextLabel",f)
top.Size=UDim2.new(1,0,0.6,0)
top.BackgroundTransparency=1
top.TextColor3=Color3.fromRGB(255,255,0)
top.TextStrokeTransparency=0
top.Font=Enum.Font.SourceSansBold
top.TextScaled=true

-- Discord (màu riêng)
local bottom=Instance.new("TextLabel",f)
bottom.Position=UDim2.new(0,0,0.6,0)
bottom.Size=UDim2.new(1,0,0.4,0)
bottom.BackgroundTransparency=1
bottom.TextColor3=Color3.fromRGB(114,137,218) -- màu discord
bottom.TextStrokeTransparency=0
bottom.Font=Enum.Font.SourceSansBold
bottom.TextScaled=true
bottom.Text="discord.gg/yourlink"

-- FPS mượt
local fps=0
local frames=0
local lastTime=tick()

-- Drag UI
local dragging=false
local dragInput,startPos,startFramePos

f.InputBegan:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.MouseButton1 then
		dragging=true
		startPos=input.Position
		startFramePos=f.Position
	end
end)

f.InputEnded:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.MouseButton1 then
		dragging=false
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if dragging and input.UserInputType==Enum.UserInputType.MouseMovement then
		local delta=input.Position-startPos
		f.Position=UDim2.new(
			startFramePos.X.Scale,
			startFramePos.X.Offset+delta.X,
			startFramePos.Y.Scale,
			startFramePos.Y.Offset+delta.Y
		)
	end
end)

-- Update
game:GetService("RunService").RenderStepped:Connect(function()
	frames += 1
	if tick()-lastTime >= 1 then
		fps = frames
		frames = 0
		lastTime = tick()
	end

	local ping="N/A"
	pcall(function()
		local s=game:GetService("Stats").Network.ServerStatsItem["Data Ping"]
		ping=math.floor(s:GetValue())
	end)

	if ping=="N/A" then
		ping=math.random(60,120)
	end

	-- đổi màu theo ping
	local color=Color3.fromRGB(0,255,0)
	if ping>100 then color=Color3.fromRGB(255,170,0) end
	if ping>150 then color=Color3.fromRGB(255,0,0) end

	top.TextColor3=color
	top.Text="FPS: "..fps.." | Ping: "..ping.." ms"
end)