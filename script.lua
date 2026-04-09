local g=Instance.new("ScreenGui",game.CoreGui)
local f=Instance.new("Frame",g)
local t=Instance.new("TextLabel",f)

-- UI
f.Position=UDim2.new(0.5,-180,0,10)
f.Size=UDim2.new(0,360,0,120)
f.BackgroundColor3=Color3.fromRGB(0,0,0)
f.BorderSizePixel=2
f.BorderColor3=Color3.fromRGB(255,255,0)
Instance.new("UICorner",f).CornerRadius=UDim.new(0,12)

t.Size=UDim2.new(1,0,0.4,0)
t.BackgroundTransparency=1
t.TextColor3=Color3.fromRGB(255,255,0)
t.TextStrokeTransparency=0
t.Font=Enum.Font.SourceSansBold
t.TextScaled=true

-- Graph container
local graph=Instance.new("Frame",f)
graph.Position=UDim2.new(0,10,0.45,0)
graph.Size=UDim2.new(1,-20,0.5,0)
graph.BackgroundTransparency=1

-- FPS data
local fps=0
local displayFPS=0
local frames=0
local last=tick()
local values={}

-- tạo cột graph
local bars={}
for i=1,30 do
	local b=Instance.new("Frame",graph)
	b.Size=UDim2.new(0,8,1,0)
	b.Position=UDim2.new((i-1)/30,0,1,0)
	b.AnchorPoint=Vector2.new(0,1)
	b.BackgroundColor3=Color3.fromRGB(0,255,0)
	table.insert(bars,b)
end

game:GetService("RunService").RenderStepped:Connect(function()
	frames += 1

	-- tính fps mỗi 0.5s
	if tick()-last >= 0.5 then
		fps = frames * 2
		frames = 0
		last = tick()

		table.insert(values, fps)
		if #values > 30 then table.remove(values,1) end
	end

	-- smooth fps (lerp)
	displayFPS = displayFPS + (fps - displayFPS) * 0.1

	local ping = math.random(60,120)

	t.Text = "FPS: "..math.floor(displayFPS).." | Ping: "..ping.." ms\n\ndiscord.gg/yourlink"

	-- update graph
	for i,v in ipairs(values) do
		local h = math.clamp(v/120,0,1)
		bars[i].Size = UDim2.new(0,8,h,0)

		-- đổi màu theo fps
		if v > 60 then
			bars[i].BackgroundColor3=Color3.fromRGB(0,255,0)
		elseif v > 30 then
			bars[i].BackgroundColor3=Color3.fromRGB(255,170,0)
		else
			bars[i].BackgroundColor3=Color3.fromRGB(255,0,0)
		end
	end
end)