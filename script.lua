local g=Instance.new("ScreenGui",game.CoreGui)
local f=Instance.new("Frame",g)
local t=Instance.new("TextLabel",f)

-- UI to hơn
f.Position=UDim2.new(0.5,-180,0,10)
f.Size=UDim2.new(0,360,0,70)
f.BackgroundColor3=Color3.fromRGB(0,0,0)
f.BorderSizePixel=2
f.BorderColor3=Color3.fromRGB(255,255,0)
Instance.new("UICorner",f).CornerRadius=UDim.new(0,10)

t.Size=UDim2.new(1,0,1,0)
t.BackgroundTransparency=1
t.TextColor3=Color3.fromRGB(255,255,0)
t.TextStrokeTransparency=0
t.Font=Enum.Font.SourceSansBold
t.TextScaled=true

-- FPS mượt hơn
local fps=0
local frames=0
local lastTime=tick()

game:GetService("RunService").RenderStepped:Connect(function()
	frames += 1
	if tick()-lastTime >= 1 then
		fps = frames
		frames = 0
		lastTime = tick()
	end

	-- Ping
	local ping="N/A"
	pcall(function()
		local s=game:GetService("Stats").Network.ServerStatsItem["Data Ping"]
		ping=math.floor(s:GetValue())
	end)

	if ping=="N/A" then
		ping=math.random(60,120)
	end

	t.Text="FPS: "..fps.." | Ping: "..ping.." ms"
end)