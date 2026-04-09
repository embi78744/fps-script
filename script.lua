local ADMIN_KEY = "1111"

local g=Instance.new("ScreenGui",game.CoreGui)

-- LOGIN UI
local login=Instance.new("Frame",g)
login.Size=UDim2.new(0,300,0,150)
login.Position=UDim2.new(0.5,-150,0.5,-75)
login.BackgroundColor3=Color3.fromRGB(20,20,20)
Instance.new("UICorner",login)

local box=Instance.new("TextBox",login)
box.Size=UDim2.new(0.8,0,0.3,0)
box.Position=UDim2.new(0.1,0,0.2,0)
box.PlaceholderText="Enter Code..."
box.TextScaled=true

local btn=Instance.new("TextButton",login)
btn.Size=UDim2.new(0.8,0,0.3,0)
btn.Position=UDim2.new(0.1,0,0.6,0)
btn.Text="Login"
btn.TextScaled=true

-- LOAD HUB
local function loadHub()
	login:Destroy()

	local main=Instance.new("Frame",g)
	main.Size=UDim2.new(0,500,0,300)
	main.Position=UDim2.new(0.5,-250,0.5,-150)
	main.BackgroundColor3=Color3.fromRGB(15,15,15)
	Instance.new("UICorner",main)

	-- TOP
	local top=Instance.new("Frame",main)
	top.Size=UDim2.new(1,0,0,40)
	top.BackgroundColor3=Color3.fromRGB(20,20,20)
	Instance.new("UICorner",top)

	local title=Instance.new("TextLabel",top)
	title.Size=UDim2.new(1,0,1,0)
	title.Text="⚡ FULL HUB"
	title.TextColor3=Color3.fromRGB(255,255,0)
	title.BackgroundTransparency=1
	title.TextScaled=true

	-- DRAG
	local drag=false
	local startPos,framePos
	top.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 then
			drag=true
			startPos=i.Position
			framePos=main.Position
		end
	end)
	top.InputEnded:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 then
			drag=false
		end
	end)
	game:GetService("UserInputService").InputChanged:Connect(function(i)
		if drag and i.UserInputType==Enum.UserInputType.MouseMovement then
			local delta=i.Position-startPos
			main.Position=UDim2.new(framePos.X.Scale,framePos.X.Offset+delta.X,framePos.Y.Scale,framePos.Y.Offset+delta.Y)
		end
	end)

	-- SIDEBAR
	local side=Instance.new("Frame",main)
	side.Position=UDim2.new(0,0,0,40)
	side.Size=UDim2.new(0,140,1,-40)
	side.BackgroundColor3=Color3.fromRGB(18,18,18)

	local pages=Instance.new("Frame",main)
	pages.Position=UDim2.new(0,140,0,40)
	pages.Size=UDim2.new(1,-140,1,-40)
	pages.BackgroundTransparency=1

	local function newPage()
		local p=Instance.new("Frame",pages)
		p.Size=UDim2.new(1,0,1,0)
		p.Visible=false
		p.BackgroundTransparency=1
		return p
	end

	local mainPage=newPage()
	local settingsPage=newPage()
	local modulesPage=newPage()
	local creditsPage=newPage()
	mainPage.Visible=true

	local function tab(name,page,pos)
		local b=Instance.new("TextButton",side)
		b.Size=UDim2.new(1,0,0,40)
		b.Position=UDim2.new(0,0,0,pos)
		b.Text=name
		b.BackgroundColor3=Color3.fromRGB(25,25,25)
		b.TextColor3=Color3.fromRGB(255,255,255)
		b.TextScaled=true

		b.MouseButton1Click:Connect(function()
			mainPage.Visible=false
			settingsPage.Visible=false
			modulesPage.Visible=false
			creditsPage.Visible=false
			page.Visible=true
		end)
	end

	tab("Main",mainPage,0)
	tab("Settings",settingsPage,40)
	tab("Modules",modulesPage,80)
	tab("Credits",creditsPage,120)

	-- FPS SYSTEM
	local info=Instance.new("TextLabel",mainPage)
	info.Size=UDim2.new(1,0,1,0)
	info.BackgroundTransparency=1
	info.TextColor3=Color3.fromRGB(255,255,0)
	info.TextScaled=true

	local fps=0
	local displayFPS=0
	local frames=0

	game:GetService("RunService").RenderStepped:Connect(function()
		frames+=1
	end)

	task.spawn(function()
		while true do
			task.wait(0.5)
			fps=frames*2
			frames=0
		end
	end)

	local show=true

	game:GetService("RunService").RenderStepped:Connect(function()
		displayFPS = displayFPS + (fps-displayFPS)*0.1
		if show then
			info.Text="FPS: "..math.floor(displayFPS)
		else
			info.Text="Hidden"
		end
	end)

	-- SETTINGS
	local toggle=Instance.new("TextButton",settingsPage)
	toggle.Size=UDim2.new(0.6,0,0.2,0)
	toggle.Position=UDim2.new(0.2,0,0.3,0)
	toggle.Text="FPS: ON"
	toggle.TextScaled=true

	toggle.MouseButton1Click:Connect(function()
		show=not show
		toggle.Text="FPS: "..(show and "ON" or "OFF")
	end)

	-- MODULE SYSTEM
	local function addModule(name,callback,pos)
		local b=Instance.new("TextButton",modulesPage)
		b.Size=UDim2.new(0.7,0,0.15,0)
		b.Position=UDim2.new(0.15,0,0,pos)
		b.Text=name
		b.TextScaled=true
		b.BackgroundColor3=Color3.fromRGB(30,30,30)

		local enabled=false
		b.MouseButton1Click:Connect(function()
			enabled=not enabled
			b.Text=name.." ["..(enabled and "ON" or "OFF").."]"
			callback(enabled)
		end)
	end

	addModule("Rainbow UI", function(state)
		if state then
			task.spawn(function()
				while state do
					task.wait()
					main.BackgroundColor3=Color3.fromHSV(tick()%5/5,1,1)
				end
			end)
		else
			main.BackgroundColor3=Color3.fromRGB(15,15,15)
		end
	end,0.1)

	-- CREDITS
	local credit=Instance.new("TextLabel",creditsPage)
	credit.Size=UDim2.new(1,0,1,0)
	credit.Text="Made by You 😎"
	credit.TextScaled=true
	credit.BackgroundTransparency=1
end

-- LOGIN CHECK
btn.MouseButton1Click:Connect(function()
	if box.Text==ADMIN_KEY then
		loadHub()
	else
		btn.Text="Wrong!"
	end
end)