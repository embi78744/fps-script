local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

local sg = Instance.new("ScreenGui", game.CoreGui)
sg.Name = "NguoiTinhMuaDong_V18_Ultimate"

local mainFrame = Instance.new("Frame", sg)
mainFrame.Size = UDim2.new(0, 240, 0, 520) 
mainFrame.Position = UDim2.new(0.5, -120, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.Active = true
mainFrame.Draggable = true 

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
local uiStroke = Instance.new("UIStroke", mainFrame)
uiStroke.Color = Color3.fromRGB(255, 105, 180)
uiStroke.Thickness = 2.5

-- Tiêu đề
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, -40, 0, 35)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🌸 MADE BY NGUOITINHMUADONG"
title.TextColor3 = Color3.fromRGB(255, 182, 193)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 13
title.TextXAlignment = Enum.TextXAlignment.Left

-- Nút thu gọn
local isMinimized = false
local miniBtn = Instance.new("TextButton", mainFrame)
miniBtn.Size = UDim2.new(0, 25, 0, 25)
miniBtn.Position = UDim2.new(1, -35, 0, 5)
miniBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
miniBtn.Text = "-"
miniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(0, 6)

local content = Instance.new("Frame", mainFrame)
content.Size = UDim2.new(1, -20, 1, -45)
content.Position = UDim2.new(0, 10, 0, 40)
content.BackgroundTransparency = 1

miniBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    content.Visible = not isMinimized
    mainFrame:TweenSize(isMinimized and UDim2.new(0, 240, 0, 35) or UDim2.new(0, 240, 0, 520), "Out", "Quart", 0.3, true)
    miniBtn.Text = isMinimized and "+" or "-"
end)

local currentY = 0
local function addComp(obj, height)
    obj.Parent = content
    obj.Position = UDim2.new(0, 0, 0, currentY)
    currentY = currentY + height + 5
end

local function createBtn(text, color)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 28)
    b.BackgroundColor3 = color or Color3.fromRGB(45, 45, 45)
    b.Text = text
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 12
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    return b
end

local function createLabel(text, color)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0, 18)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    l.Font = Enum.Font.SourceSansBold
    l.TextSize = 13
    l.TextXAlignment = Enum.TextXAlignment.Left
    return l
end

-- --- THIẾT LẬP CÁC NÚT (FIXED LAYOUT) ---
local antiBtn = createBtn("1. Anti AFK: ON ✅", Color3.fromRGB(30, 100, 30))
addComp(antiBtn, 28)

local potBtn = createBtn("2. Đồ họa: BÌNH THƯỜNG ❌", Color3.fromRGB(80, 20, 20))
addComp(potBtn, 28)

addComp(createBtn("4. Làm sạch Map (Clear) ✨"), 28)
addComp(createBtn("5. White Screen: OFF 🔋"), 28)

-- Ô NHẬP JOBID CỐ ĐỊNH (KHÔNG BAO GIỜ MẤT)
local joinInput = Instance.new("TextBox")
joinInput.Size = UDim2.new(1, 0, 0, 28)
joinInput.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
joinInput.PlaceholderText = "Nhập JobID..."
joinInput.Text = ""
joinInput.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", joinInput).CornerRadius = UDim.new(0, 4)
addComp(joinInput, 28)

addComp(createBtn("JOIN SERVER THEO ID"), 28)
addComp(createBtn("Rejoin Server"), 28)
addComp(createBtn("COPY LINK DISCORD 💬", Color3.fromRGB(88, 101, 242)), 28)

-- Thông số
local nameL = createLabel("Tên: " .. LocalPlayer.Name) addComp(nameL, 18)
local fpsL = createLabel("FPS: --") addComp(fpsL, 18)
local pingL = createLabel("Ping: -- ms") addComp(pingL, 18)
local timeL = createLabel("3. Giờ: --") addComp(timeL, 18)
local dcLabel = createLabel("Discord: discord.gg/abcxyz", Color3.fromRGB(114, 137, 218)) addComp(dcLabel, 18)
addComp(createLabel("--- TIỆN ÍCH ---", Color3.fromRGB(255, 105, 180)), 18)

-- --- LOGIC ĐO FPS CHUẨN 100% ---
local fpsCount = 0
RunService.Heartbeat:Connect(function()
    fpsCount = fpsCount + 1
end)

task.spawn(function()
    while true do
        local startCount = fpsCount
        task.wait(1) -- Đo trong đúng 1 giây
        local currentFps = fpsCount - startCount
        fpsL.Text = "FPS: " .. currentFps
        
        -- Cập nhật thêm các thông số khác mỗi giây
        timeL.Text = "3. Giờ: " .. os.date("%H:%M:%S")
        local p = math.floor(LocalPlayer:GetNetworkPing() * 1000)
        pingL.Text = "Ping: " .. p .. " ms"
    end
end)

-- --- LOGIC POTATO (FIXED) ---
local isPotato = false
potBtn.MouseButton1Click:Connect(function()
    isPotato = not isPotato
    potBtn.Text = isPotato and "2. Đồ họa: POTATO ✅" or "2. Đồ họa: BÌNH THƯỜNG ❌"
    potBtn.BackgroundColor3 = isPotato and Color3.fromRGB(20, 80, 20) or Color3.fromRGB(80, 20, 20)
    if isPotato then
        settings().Rendering.QualityLevel = 1
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Part") or v:IsA("MeshPart") then v.Material = Enum.Material.SmoothPlastic end
            if v:IsA("Decal") then v.Transparency = 1 end
        end
    else
        settings().Rendering.QualityLevel = 0
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Part") or v:IsA("MeshPart") then v.Material = Enum.Material.Plastic end
            if v:IsA("Decal") then v.Transparency = 0 end
        end
    end
end)