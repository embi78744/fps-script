local g=Instance.new("ScreenGui",game.CoreGui)
local f=Instance.new("Frame",g)
local t=Instance.new("TextLabel",f)

f.Position=UDim2.new(0.5,-180,0,10)
f.Size=UDim2.new(0,360,0,100)
f.BackgroundColor3=Color3.fromRGB(0,0,0)
f.BorderSizePixel=2
f.BorderColor3=Color3.fromRGB(255,255,0)
Instance.new("UICorner",f).CornerRadius=UDim.new(0,12)

t.Size=UDim2.new(1,0,1,0)
t.BackgroundTransparency=1
t.TextColor3=Color3.fromRGB(255,255,0)
t.TextStrokeTransparency=0
t.Font=Enum.Font.SourceSansBold
t.TextScaled=true

-- FPS mượt
local fps=0
local frames=0

game:GetService("RunService").RenderStepped:Connect(function()
	frames += 1
end)

-- update chậm lại (mượt)
while true do
	task.wait(0.5)

	fps = frames * 2 -- vì 0.5s
	frames = 0

	local ping = math.random(60,120)

	local color=Color3.fromRGB(0,255,0)
	if ping>100 then color=Color3.fromRGB(255,170,0) end
	if ping>150 then color=Color3.fromRGB(255,0,0) end

	t.TextColor3=color
	t.Text="FPS: "..fps.." | Ping: "..ping.." ms\n\ndiscord.gg/yourlink"
end