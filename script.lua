-- Wait until game is loaded
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Blox Fruits Basic Hub", HidePremium = false, SaveConfig = true, ConfigFolder = "BloxFruitsBasic"})

-- [ Variables ]
_G.AutoFarm = false
_G.AutoClick = false
_G.AutoStatsMelee = false
_G.AutoStatsDefense = false
_G.AutoStatsSword = false
_G.AutoStatsFruit = false
_G.WalkSpeed = 16
_G.JumpPower = 50

-- [ Services ]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

-- [ Functions ]
local function getClosestEnemy()
    local closestEnemy = nil
    local shortestDistance = math.huge
    
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    
    -- Blox Fruits enemies are usually in Workspace.Enemies or Workspace
    local enemiesFolder = workspace:FindFirstChild("Enemies") or workspace
    
    for _, v in pairs(enemiesFolder:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
            local distance = (v.HumanoidRootPart.Position - character.HumanoidRootPart.Position).magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestEnemy = v
            end
        end
    end
    return closestEnemy
end

-- [ Auto Farm Loop ]
spawn(function()
    while wait() do
        if _G.AutoFarm then
            pcall(function()
                local target = getClosestEnemy()
                if target and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    -- Teleport slightly above the enemy
                    LocalPlayer.Character.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                    
                    -- Equipping Tool if not equipped
                    local tool = LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
                    if tool then
                        LocalPlayer.Character.Humanoid:EquipTool(tool)
                    end
                end
            end)
        end
    end
end)

-- [ Auto Click Loop ]
spawn(function()
    while wait(0.1) do
        if _G.AutoFarm or _G.AutoClick then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new(1280, 720))
            end)
        end
    end
end)

-- [ Auto Stats Loop ]
spawn(function()
    while wait(1) do
        pcall(function()
            local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if remote then
                if _G.AutoStatsMelee then
                    remote:InvokeServer("AddPoint", "Melee", 1)
                end
                if _G.AutoStatsDefense then
                    remote:InvokeServer("AddPoint", "Defense", 1)
                end
                if _G.AutoStatsSword then
                    remote:InvokeServer("AddPoint", "Sword", 1)
                end
                if _G.AutoStatsFruit then
                    remote:InvokeServer("AddPoint", "Demon Fruit", 1)
                end
            end
        end)
    end
end)

-- [ Character Modification Loop ]
spawn(function()
    while wait(0.5) do
        pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = _G.WalkSpeed
                LocalPlayer.Character.Humanoid.JumpPower = _G.JumpPower
            end
        end)
    end
end)

-- [ GUI Tabs ]
local FarmTab = Window:MakeTab({
	Name = "Farming",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local StatsTab = Window:MakeTab({
	Name = "Auto Stats",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local PlayerTab = Window:MakeTab({
	Name = "Player",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

-- [ Farming Tab Elements ]
FarmTab:AddToggle({
	Name = "Auto Farm Closest Enemies",
	Default = false,
	Callback = function(Value)
		_G.AutoFarm = Value
	end    
})

FarmTab:AddToggle({
	Name = "Auto Click/Attack",
	Default = false,
	Callback = function(Value)
		_G.AutoClick = Value
	end    
})

-- [ Stats Tab Elements ]
StatsTab:AddToggle({
	Name = "Auto Stats Melee",
	Default = false,
	Callback = function(Value)
		_G.AutoStatsMelee = Value
	end    
})

StatsTab:AddToggle({
	Name = "Auto Stats Defense",
	Default = false,
	Callback = function(Value)
		_G.AutoStatsDefense = Value
	end    
})

StatsTab:AddToggle({
	Name = "Auto Stats Sword",
	Default = false,
	Callback = function(Value)
		_G.AutoStatsSword = Value
	end    
})

StatsTab:AddToggle({
	Name = "Auto Stats Fruit",
	Default = false,
	Callback = function(Value)
		_G.AutoStatsFruit = Value
	end    
})

-- [ Player Tab Elements ]
PlayerTab:AddSlider({
	Name = "Walk Speed",
	Min = 16,
	Max = 150,
	Default = 16,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "Speed",
	Callback = function(Value)
		_G.WalkSpeed = Value
	end    
})

PlayerTab:AddSlider({
	Name = "Jump Power",
	Min = 50,
	Max = 250,
	Default = 50,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "Jump",
	Callback = function(Value)
		_G.JumpPower = Value
	end    
})

OrionLib:Init()
