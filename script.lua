local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Blox Fruits Main Hub", HidePremium = false, SaveConfig = true, ConfigFolder = "BloxFruitsMain"})

-- [ Variables ]
_G.AutoFarmLevel = false
_G.AutoFarmChest = false
_G.AutoClick = false
_G.AutoStatsMelee = false
_G.AutoStatsDefense = false
_G.AutoStatsSword = false
_G.AutoStatsFruit = false
_G.WalkSpeed = 16
_G.JumpPower = 50
_G.SelectWeapon = "Melee"
_G.AutoBringMob = true
_G.FastAttack = true
_G.NoClip = true

-- [ Services ]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")

-- [ Weapon Lists Handler ]
local function getWeaponsList()
    local list = {}
    for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do
        if v:IsA("Tool") then
            table.insert(list, v.Name)
        end
    end
    for _, v in pairs(LocalPlayer.Character:GetChildren()) do
        if v:IsA("Tool") then
            table.insert(list, v.Name)
        end
    end
    return list
end

-- [ Equip Weapon Function ]
local function equipWeapon()
    pcall(function()
        if _G.SelectWeapon then
            local tool = LocalPlayer.Backpack:FindFirstChild(_G.SelectWeapon)
            if tool then
                LocalPlayer.Character.Humanoid:EquipTool(tool)
            end
        end
    end)
end

-- [ Dynamic Quest Finder based on Level ]
local function getQuestData()
    local level = LocalPlayer.Data.Level.Value
    if level >= 1 and level < 10 then
        return {QuestName = "BanditQuest1", QuestLevel = 1, MobName = "Bandit", QuestGiver = "Bandit Recruiter", CFrameNPC = CFrame.new(1059.3, 15.4, 1550.6)}
    elseif level >= 10 and level < 15 then
        return {QuestName = "JungleQuest", QuestLevel = 1, MobName = "Monkey", QuestGiver = "Adventurer", CFrameNPC = CFrame.new(-1598.1, 35.5, 153.2)}
    elseif level >= 15 and level < 30 then
        return {QuestName = "JungleQuest", QuestLevel = 2, MobName = "Gorilla", QuestGiver = "Adventurer", CFrameNPC = CFrame.new(-1598.1, 35.5, 153.2)}
    elseif level >= 30 and level < 60 then
        return {QuestName = "PirateQuest", QuestLevel = 1, MobName = "Pirate", QuestGiver = "Pirate Adventurer", CFrameNPC = CFrame.new(-1141.1, 4.2, 3827.1)}
    elseif level >= 60 and level < 75 then
        return {QuestName = "PirateQuest", QuestLevel = 2, MobName = "Brute", QuestGiver = "Pirate Adventurer", CFrameNPC = CFrame.new(-1141.1, 4.2, 3827.1)}
    elseif level >= 75 and level < 90 then
        return {QuestName = "DesertQuest", QuestLevel = 1, MobName = "Desert Bandit", QuestGiver = "Desert Adventurer", CFrameNPC = CFrame.new(894.4, 6.4, 4384.7)}
    elseif level >= 90 and level < 120 then
        return {QuestName = "DesertQuest", QuestLevel = 2, MobName = "Desert Officer", QuestGiver = "Desert Adventurer", CFrameNPC = CFrame.new(894.4, 6.4, 4384.7)}
    elseif level >= 120 and level < 150 then
        return {QuestName = "SnowQuest", QuestLevel = 1, MobName = "Snow Bandit", QuestGiver = "Snow Adventurer", CFrameNPC = CFrame.new(1386.1, 87.2, -1298.1)}
    else
        -- Fallback default for higher levels (Dynamic system can be scaled further)
        return {QuestName = "BanditQuest1", QuestLevel = 1, MobName = "Bandit", QuestGiver = "Bandit Recruiter", CFrameNPC = CFrame.new(1059.3, 15.4, 1550.6)}
    end
end

-- [ Safe Tween / Teleport ]
local function toTarget(targetCFrame)
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - targetCFrame.Position).Magnitude
            if dist > 300 then
                LocalPlayer.Character.HumanoidRootPart.CFrame = targetCFrame
            else
                local tween = TweenService:Create(
                    LocalPlayer.Character.HumanoidRootPart,
                    TweenInfo.new(dist / 250, Enum.EasingStyle.Linear),
                    {CFrame = targetCFrame}
                )
                tween:Play()
                tween.Completed:Wait()
            end
        end
    end)
end

-- [ Bring Mobs Function ]
local function bringMobs(mobName, targetCFrame)
    if not _G.AutoBringMob then return end
    pcall(function()
        local enemiesFolder = workspace:FindFirstChild("Enemies") or workspace
        for _, v in pairs(enemiesFolder:GetChildren()) do
            if v:IsA("Model") and v.Name == mobName and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                if (v.HumanoidRootPart.Position - targetCFrame.Position).Magnitude < 250 then
                    v.HumanoidRootPart.CFrame = targetCFrame
                    v.HumanoidRootPart.CanCollide = false
                    if v.Humanoid:GetState() ~= Enum.HumanoidStateType.Physics then
                        v.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                    end
                end
            end
        end
    end)
end

-- [ Auto Farm Quest Loop ]
spawn(function()
    while wait(0.1) do
        if _G.AutoFarmLevel then
            pcall(function()
                local hasQuest = LocalPlayer.PlayerGui.Main.Quest.Visible
                local data = getQuestData()
                
                if not hasQuest then
                    -- Go take quest
                    toTarget(data.CFrameNPC)
                    wait(0.5)
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", data.QuestName, data.QuestLevel)
                else
                    -- Farm target mobs
                    local targetMob = nil
                    local enemiesFolder = workspace:FindFirstChild("Enemies") or workspace
                    for _, v in pairs(enemiesFolder:GetChildren()) do
                        if v:IsA("Model") and v.Name == data.MobName and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            targetMob = v
                            break
                        end
                    end
                    
                    if not targetMob then
                        -- Go to mob spawn point if none currently exists in folder
                        local spawnPart = workspace._WorldOrigin.EnemySpawns:FindFirstChild(data.MobName)
                        if spawnPart then
                            toTarget(spawnPart.CFrame * CFrame.new(0, 10, 0))
                        end
                    else
                        equipWeapon()
                        -- Position above target
                        LocalPlayer.Character.HumanoidRootPart.CFrame = targetMob.HumanoidRootPart.CFrame * CFrame.new(0, 8, 0)
                        
                        -- Gather other mobs
                        bringMobs(data.MobName, targetMob.HumanoidRootPart.CFrame)
                        
                        -- Click attack logic
                        if _G.FastAttack then
                            VirtualUser:CaptureController()
                            VirtualUser:ClickButton1(Vector2.new(1280, 720))
                        end
                    end
                end
            end)
        end
    end
end)

-- [ Auto Chest Farm ]
spawn(function()
    while wait() do
        if _G.AutoFarmChest then
            pcall(function()
                for _, v in pairs(workspace:GetChildren()) do
                    if v.Name:find("Chest") and v:IsA("Part") then
                        toTarget(v.CFrame)
                        wait(0.2)
                    end
                end
            end)
        end
    end
end)

-- [ Auto Click Loop ]
spawn(function()
    while wait(0.05) do
        if _G.AutoClick then
            pcall(function()
                equipWeapon()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new(1280, 720))
            end)
        end
    end
end)

-- [ NoClip Loop to bypass ground collisions ]
spawn(function()
    while wait() do
        if _G.AutoFarmLevel or _G.AutoFarmChest or _G.NoClip then
            pcall(function()
                for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end)
        end
    end
end)

-- [ Auto Stats Loop ]
spawn(function()
    while wait(1) do
        if _G.AutoStatsMelee then
            ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Melee", 1)
        end
        if _G.AutoStatsDefense then
            ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Defense", 1)
        end
        if _G.AutoStatsSword then
            ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Sword", 1)
        end
        if _G.AutoStatsFruit then
            ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Demon Fruit", 1)
        end
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
	Name = "Auto Farm Level (Main)",
	Default = false,
	Callback = function(Value)
		_G.AutoFarmLevel = Value
	end    
})

FarmTab:AddToggle({
	Name = "Auto Farm Chests",
	Default = false,
	Callback = function(Value)
		_G.AutoFarmChest = Value
	end    
})

FarmTab:AddToggle({
	Name = "Auto Click/Attack",
	Default = false,
	Callback = function(Value)
		_G.AutoClick = Value
	end    
})

FarmTab:AddDropdown({
	Name = "Select Weapon",
	Default = "Melee",
	Options = {"Melee", "Sword", "Fruit"},
	Callback = function(Value)
		_G.SelectWeapon = Value
	end    
})

FarmTab:AddToggle({
	Name = "Bring Mobs",
	Default = true,
	Callback = function(Value)
		_G.AutoBringMob = Value
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

PlayerTab:AddToggle({
	Name = "Noclip Mode",
	Default = true,
	Callback = function(Value)
		_G.NoClip = Value
	end    
})

OrionLib:Init()
