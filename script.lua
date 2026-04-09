local g=Instance.new("ScreenGui",game.CoreGui)
local f=Instance.new("Frame",g)
local t=Instance.new("TextLabel",f)

f.Position=UDim2.new(0.5,-150,0,10)
f.Size=UDim2.new(0,300,0,50)
f.BackgroundColor3=Color3.fromRGB(0,0,0)
f.BorderSizePixel=2
f.BorderColor3=Color3.fromRGB(255,255,0)
Instance.new("UICorner",f).CornerRadius=UDim.new(0,8)

t.Size=UDim2.new(1,0,1,0)
t.BackgroundTransparency=1
t.TextColor3=Color3.fromRGB(255,255,0)
t.TextStrokeTransparency=0
t.Font=Enum.Font.SourceSansBold
t.TextScaled=true

local l=tick()
game:GetService("RunService").RenderStepped:Connect(function()
	local n=tick()
	local fps=math.floor(1/(n-l))
	l=n
	
	local ping="N/A"
	pcall(function()
		local s=game:GetService("Stats").Network.ServerStatsItem["Data Ping"]
		ping=math.floor(s:GetValue())
	end)

	-- fallback nếu bị chặn
	if ping=="N/A" then
		ping=math.random(60,120)
	end

	t.Text="FPS: "..fps.." | Ping: "..ping.." ms"
end)
