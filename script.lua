--[[
    🌸 NGUOITINHMUADONG - V48 PINK EDITION
    - Đổi màu giao diện sang màu Hồng.
    - Fix triệt để Ping lệch & Lỗi đen màn hình.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer

-- Dọn dẹp bản cũ để tránh đè UI
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v.Name == "NGUOITINH_PINK_V48" then v:Destroy() end
end

local sg = Instance.new("ScreenGui", game.CoreGui)
sg.Name = "NGUOITINH_PINK_V48"

-- --- GIAO DIỆN OVERLAY (MÀU HỒNG ĐẶC TRƯNG) ---
local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 180, 0, 100)
frame.Position = UDim2.new(0, 15, 0, 150)
frame.BackgroundTransparency = 1

local function createLabel(name, yPos)
    local l = Instance.new("TextLabel", frame)
    l.Size = UDim2.new(1, 0, 0, 22)
    l.Position = UDim2.new(0, 0, 0, yPos)
    
    -- MÀU HỒNG NEON CHÍNH (HOT PINK)
    l.TextColor3 = Color3.fromRGB(255, 105, 180) 
    l.TextSize = 19
    l.Font = Enum.Font.RobotoMono -- Giữ font kỹ thuật giống hệ thống
    l.BackgroundTransparency = 1
    l.TextXAlignment = Enum.TextXAlignment.Left
    
    -- VIỀN CHỮ MÀU HỒNG PHẤN (DEEP PINK) ĐỂ DỄ NHÌN HƠN
    l.TextStrokeTransparency = 0
    l.TextStrokeColor3 = Color3.fromRGB(255, 20, 147) 
    return l
end

local fpsLabel = createLabel("FPS", 0)
local pingLabel = createLabel("Ping", 25)
local plrLabel = createLabel("Plrs", 50)

-- --- LOGIC ĐO KHỚP 100% HỆ THỐNG ---
local lastUpdate = os.clock()
local frames = 0

RunService.Heartbeat:Connect(function()
    frames = frames + 1
    if os.clock() - lastUpdate >= 1 then
        fpsLabel.Text = "FPS: " .. frames
        frames = 0
        lastUpdate = os.clock()
    end
    
    -- Lấy Ping trực tiếp từ Replicator Stats (Khớp với image_d6615e.png)
    local systemPing = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    
    -- Ping: %.1f ms đẻ hiện 1 chữ số thập phân, VD: 194.5 ms
    pingLabel.Text = string.format("Ping: %.1f ms", systemPing)
    
    plrLabel.Text = "Players: " .. #Players:GetPlayers()
end)

-- Anti AFK
LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)