local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({
    Name = "⚡ Blox Fruits Basic Hub | UI Edition ⚡", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "BloxFruitsBasicHub",
    IntroText = "Welcome to Basic Hub"
})

-- [ Variables ]
_G.AutoFarmLevel = false
_G.AutoFarm = false
_G.AutoClick = false
_G.AutoStatsMelee = false
_G.AutoStatsDefense = false
_G.AutoStatsSword = false
_G.AutoStatsFruit = false
_G.SelectedWeapon = "Melee"
_G.WalkSpeed = 16
_G.JumpPower = 50
_G.InfGeppo = false

-- [ Services ]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")

-- [ Database for Sea 1 Quests & Levels ]
local QuestList = {
    {Level = 0, QuestName = "BanditQuest1", QuestNumber = 1, MobName = "Bandit", NPCName = "Bandit Quest Giver", NPCCFrame = CFrame.new(1059, 15, 1549), MobCFrame = CFrame.new(1145, 17, 1630)},
    {Level = 10, QuestName = "JungleQuest", QuestNumber = 1, MobName = "Monkey", NPCName = "Adventurer", NPCCFrame = CFrame.new(-1598, 35, 153), MobCFrame = CFrame.new(-1610, 36, 147)},
    {Level = 15, QuestName = "JungleQuest", QuestNumber = 2, MobName = "Gorilla", NPCName = "Adventurer", NPCCFrame = CFrame.new(-1598, 35, 153), MobCFrame = CFrame.new(-1231, 6, -486)},
    {Level = 30, QuestName = "BuggyQuest1", QuestNumber = 1, MobName = "Pirate", NPCName = "Pirate Cove Quest Giver", NPCCFrame = CFrame.new(-1141, 4, 3824), MobCFrame = CFrame.new(-1203, 4, 3889)},
    {Level = 60, QuestName = "DesertQuest", QuestNumber = 1, MobName = "Desert Bandit", NPCName = "Desert Quest Giver", NPCCFrame = CFrame.new(894, 6, 4383), MobCFrame = CFrame.new(990, 6, 4426)},
    {Level = 90, QuestName = "SnowQuest", QuestNumber = 1, MobName = "Snow Bandit", NPCName = "Snow Quest Giver", NPCCFrame = CFrame.new(1386, 86, -1297), MobCFrame = CFrame.new(1324, 86, -1341)},
    {Level = 120, QuestName = "MarineQuest", QuestNumber = 1, MobName = "Chief Petty Officer", NPCName = "Marine Quest Giver", NPCCFrame = CFrame.new(-5039, 28, 4324), MobCFrame = CFrame.new(-4892, 22, 4224)},
    {Level = 150, QuestName = "SkyQuest", QuestNumber = 1, MobName = "Sky Bandit", NPCName = "Sky Quest Giver", NPCCFrame = CFrame.new(-1240, 357, -5900), MobCFrame = CFrame.new(-1261, 389, -5726)},
    {Level = 190, QuestName = "SkyQuest", QuestNumber = 2, MobName = "Dark Master", NPCName = "Sky Quest Giver", NPCCFrame = CFrame.new(-1240, 357, -5900), MobCFrame = CFrame.new(-1143, 389, -5750)},
    {Level = 250, QuestName = "ColosseumQuest", QuestNumber = 1, MobName = "Toga Warrior", NPCName = "Colosseum Quest Giver", NPCCFrame = CFrame.new(-1575, 7, -2982), MobCFrame = CFrame.new(-1800, 7, -2800)},
    {Level = 300, QuestName = "MagmaQuest", QuestNumber = 1, MobName = "Military Soldier", NPCName = "Magma Officer", NPCCFrame = CFrame.new(-5313, 12, 8517), MobCFrame = CFrame.new(-5411, 11, 8511)},
    {Level = 375, QuestName = "FishmanQuest", QuestNumber = 1, MobName = "Fishman Warrior", NPCName = "Fishman Quest Giver", NPCCFrame = CFrame.new(61122, 18, 1565), MobCFrame = CFrame.new(60900, 18, 1500)},
    {Level = 450, QuestName = "PirateIslandQuest", QuestNumber = 1, MobName = "God's Guard", NPCName = "Island Quest Giver", NPCCFrame = CFrame.new(-5119, 300, -5000), MobCFrame = CFrame.new(-5200, 310, -5100)},
    {Level = 525, QuestName = "ZombieQuest", QuestNumber = 1, MobName = "Zombie", NPCName = "Zombie Quest Giver", NPCCFrame = CFrame.new(-5192, 51, 10000), MobCFrame = CFrame.new(-5100, 51, 10100)},
    {Level = 625, QuestName = "WarshipQuest", QuestNumber = 1, MobName = "Ship Officer", NPCName = "Ship Quest Giver", NPCCFrame = CFrame.new(-15000, 0, 0), MobCFrame = CFrame.new(-15100, 0, 100)},
}

-- [ Helper Functions ]
local function getMyQuest()
    local currentLevel = LocalPlayer.Data.Level.Value
    local bestQuest = QuestList[1]
    for _, quest in ipairs(QuestList) do
        if currentLevel >= quest.Level then
            bestQuest = quest
        end
    end
    return bestQuest
end

local function hasQuestActive()
    local questGui = LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
    return questGui and questGui.Visible
end

local function getClosestEnemy(enemyName)
    local closestEnemy = nil
    local shortestDistance = math.huge
    local enemiesFolder = workspace:FindFirstChild("Enemies") or workspace
    
    for _, v in pairs(enemiesFolder:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
            if not enemyName or (enemyName and v.Name == enemyName) then
                local distance = (v.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestEnemy = v
                end
            end
        end
    end
    return closestEnemy
end

local function equipSelectedWeapon()
    pcall(function()
        local backpack = LocalPlayer.Backpack
        local character = LocalPlayer.Character
        if character then
            local toolToEquip = nil
            for _, tool in pairs(backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    if _G.SelectedWeapon == "Melee" and (tool.ToolTip == "Melee" or tool:FindFirstChild("Combat")) then
                        toolToEquip = tool
                    elseif _G.SelectedWeapon == "Sword" and tool.ToolTip == "Sword" then
                        toolToEquip = tool
                    elseif _G.SelectedWeapon == "Blox Fruit" and tool.ToolTip == "Blox Fruit" then
                        toolToEquip = tool
                    end
                end
            end
            if toolToEquip then
                character.Humanoid:EquipTool(toolToEquip)
            end
        end
    end)
end

-- [ Noclip Bypass ]
RunService.Stepped:Connect(function()
    if _G.AutoFarmLevel or _G.AutoFarm then
        pcall(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end)

-- [ Inf Geppo Feature ]
game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfGeppo then
        pcall(function()
            LocalPlayer.Character.Humanoid:ChangeState("Jumping")
        end)
    end
end)

-- [ Auto Farm Level Loop ]
spawn(function()
    while wait() do
        if _G.AutoFarmLevel then
            pcall(function()
                local activeQuest = hasQuestActive()
                local currentQuestData = getMyQuest()
                
                if not activeQuest then
                    -- Teleport to NPC and get Quest
                    local questNpc = workspace.NPCs:FindFirstChild(currentQuestData.NPCName) or workspace:FindFirstChild(currentQuestData.NPCName)
                    if questNpc and questNpc:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = questNpc.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                        wait(0.5)
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", currentQuestData.QuestName, currentQuestData.QuestNumber)
                    else
                        -- Backup teleport to static coordinates
                        LocalPlayer.Character.HumanoidRootPart.CFrame = currentQuestData.NPCCFrame
                        wait(0.5)
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", currentQuestData.QuestName, currentQuestData.QuestNumber)
                    end
                else
                    -- Complete Active Quest
                    local targetMob = getClosestEnemy(currentQuestData.MobName)
                    if targetMob then
                        -- Safe positioning above the enemy to avoid getting hit
                        LocalPlayer.Character.HumanoidRootPart.CFrame = targetMob.HumanoidRootPart.CFrame * CFrame.new(0, 6, 0)
                        equipSelectedWeapon()
                    else
                        -- Teleport to mob spawn area if none are active nearby
                        LocalPlayer.Character.HumanoidRootPart.CFrame = currentQuestData.MobCFrame
                    end
                end
            end)
        end
    end
end)

-- [ Auto Farm Closest Loop ]
spawn(function()
    while wait() do
        if _G.AutoFarm and not _G.AutoFarmLevel then
            pcall(function()
                local target = getClosestEnemy()
                if target then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 6, 0)
                    equipSelectedWeapon()
                end
            end)
        end
    end
end)

-- [ Auto Click Loop ]
spawn(function()
    while wait(0.05) do
        if _G.AutoFarmLevel or _G.AutoFarm or _G.AutoClick then
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

-- [ WalkSpeed & JumpPower Loop ]
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

-- [ GUI Layout ]
local FarmTab = Window:MakeTab({
    Name = "🔥 Auto Farm",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local StatsTab = Window:MakeTab({
    Name = "📈 Auto Stats",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local PlayerTab = Window:MakeTab({
    Name = "⚡ Character",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- [ Farm Tab Controls ]
FarmTab:AddParagraph("AUTO FARM LEVEL", "Optimized pathfinding and level selection for Sea 1.")

FarmTab:AddDropdown({
    Name = "Select Weapon Type",
    Default = "Melee",
    Options = {"Melee", "Sword", "Blox Fruit"},
    Callback = function(Value)
        _G.SelectedWeapon = Value
    end    
})

FarmTab:AddToggle({
    Name = "Auto Farm Level (Auto Quest)",
    Default = false,
    Callback = function(Value)
        _G.AutoFarmLevel = Value
    end    
})

FarmTab:AddToggle({
    Name = "Auto Farm Closest Enemies",
    Default = false,
    Callback = function(Value)
        _G.AutoFarm = Value
    end    
})

FarmTab:AddToggle({
    Name = "Fast Auto Clicker",
    Default = false,
    Callback = function(Value)
        _G.AutoClick = Value
    end    
})

-- [ Stats Tab Controls ]
StatsTab:AddParagraph("STATS AUTO ALLOCATION", "Distribute points automatically.")

StatsTab:AddToggle({
    Name = "Auto Stats: Melee",
    Default = false,
    Callback = function(Value)
        _G.AutoStatsMelee = Value
    end    
})

StatsTab:AddToggle({
    Name = "Auto Stats: Defense",
    Default = false,
    Callback = function(Value)
        _G.AutoStatsDefense = Value
    end    
})

StatsTab:AddToggle({
    Name = "Auto Stats: Sword",
    Default = false,
    Callback = function(Value)
        _G.AutoStatsSword = Value
    end    
})

StatsTab:AddToggle({
    Name = "Auto Stats: Blox Fruit",
    Default = false,
    Callback = function(Value)
        _G.AutoStatsFruit = Value
    end    
})

-- [ Player Tab Controls ]
PlayerTab:AddParagraph("MODIFICATIONS", "Enhance player movement and mechanics.")

PlayerTab:AddSlider({
    Name = "Walk Speed Bypass",
    Min = 16,
    Max = 250,
    Default = 16,
    Color = Color3.fromRGB(0,255,150),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        _G.WalkSpeed = Value
    end    
})

PlayerTab:AddSlider({
    Name = "Jump Power Bypass",
    Min = 50,
    Max = 350,
    Default = 50,
    Color = Color3.fromRGB(0,150,255),
    Increment = 1,
    ValueName = "Jump",
    Callback = function(Value)
        _G.JumpPower = Value
    end    
})

PlayerTab:AddToggle({
    Name = "Infinite Geppo (Skyjump)",
    Default = false,
    Callback = function(Value)
        _G.InfGeppo = Value
    end    
})

OrionLib:Init()
