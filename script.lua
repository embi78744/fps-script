--[[
    🌸 NGUOITINHMUADONG - V45 COMPACT OVERLAY
    - Phong cách mới: Nhỏ gọn, hiện góc màn hình (Giống ảnh mẫu).
    - Tự động cập nhật: FPS, Ping, Players, Time.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Dọn dẹp bản cũ
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v.Name == "NGUOITINH_OVERLAY" then v:Destroy() end
end

local sg = Instance.new("ScreenGui", game.CoreGui)
sg.Name = "NGUOITINH_OVERLAY"

-- --- [1] BẢNG THÔNG SỐ GÓC TRÁI (FPS, PING, PLAYERS) ---
local statsFrame = Instance.new("Frame", sg)
statsFrame.Size = UDim2.new(0, 150, 0, 100)
statsFrame.Position = UDim2.new(0, 10, 0, 150) -- Vị trí bên trái màn hình
statsFrame.BackgroundTransparency = 1

local function createLabel(name, pos, color)
    local l = Instance.new("TextLabel", statsFrame)
    l.Name = name
    l.Size = UDim2.new(1, 0, 0, 25)
    l.Position = pos
    l.BackgroundTransparency = 1
    l.TextColor3 = color
    l.TextSize = 18
    l.Font = Enum.Font.SourceSansBold
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextStrokeTransparency = 0 -- Giúp chữ dễ nhìn hơn trên mọi nền
    return l
end

local fpsLabel = createLabel("FPS", UDim2.new(0, 0, 0, 0), Color3.fromRGB(0, 255, 0))
local plrLabel = createLabel("Plrs", UDim2.new(0, 0, 0, 25), Color3.fromRGB(0, 255, 0))
local pngLabel = createLabel("Ping", UDim2.new(0, 0, 0, 50), Color3.fromRGB(0, 255, 0))
local timeLabel = createLabel("Time", UDim2.new(0, 0, 0, 75), Color3.fromRGB(0, 255, 0))

-- --- [2] BẢNG THÔNG TIN ĐƠN HÀNG (GÓC PHẢI) ---
local orderFrame = Instance.new("Frame", sg)
orderFrame.Size = UDim2.new(0, 250, 0, 80)
orderFrame.Position = UDim2.new(1, -260, 0.3, 0) -- Nằm bên phải giống ảnh mẫu
orderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
orderFrame.BackgroundTransparency = 0.3
Instance.new("UICorner", orderFrame)
local stroke = Instance.new("UIStroke", orderFrame)
stroke.Color = Color3.fromRGB(255, 105, 180)
stroke.Thickness = 2

local orderTitle = Instance.new("TextLabel", orderFrame)
orderTitle.Size = UDim2.new(1, 0, 0, 40); orderTitle.Position = UDim2.new(0, 10, 0, 0)
orderTitle.BackgroundTransparency = 1; orderTitle.Text = "Đơn: 100 Mythical + 50 Legendary"
orderTitle.TextColor3 = Color3.fromRGB(255, 255, 255); orderTitle.TextSize = 16; orderTitle.Font = Enum.Font.SourceSansBold; orderTitle.TextXAlignment = Enum.TextXAlignment.Left

local nameLabel = Instance.new("TextLabel", orderFrame)
nameLabel.Size = UDim2.new(1, 0, 0, 30); nameLabel.Position = UDim2.new(0, 10, 0, 40)
nameLabel.BackgroundTransparency = 1; nameLabel.Text = "Tên: " .. LocalPlayer.Name
nameLabel.TextColor3 = Color3.fromRGB(255, 255, 0); nameLabel.TextSize = 16; nameLabel.Font = Enum.Font.SourceSansBold; nameLabel.TextXAlignment = Enum.TextXAlignment.Left

-- --- [3] LOGIC CẬP NHẬT THÔNG SỐ ---
local lastTime = os.clock()
local frameCount = 0

RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    if os.clock() - lastTime >= 1 then
        fpsLabel.Text = "FPS: " .. frameCount
        frameCount = 0
        lastTime = os.clock()
    end
    
    local ping = math.floor(LocalPlayer:GetNetworkPing() * 1000)
    pngLabel.Text = "Ping: " .. ping .. " ms"
    plrLabel.Text = "Players: " .. #Players:GetPlayers()
    timeLabel.Text = "Time: " .. os.date("%X")
end)

-- Anti AFK (Luôn chạy ngầm)
LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)