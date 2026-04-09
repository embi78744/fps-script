local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Khởi tạo giao diện chính
local sg = Instance.new("ScreenGui", game.CoreGui)
sg.Name = "BaAnh_Potato_Hub"

local mainFrame = Instance.new("Frame", sg)
mainFrame.Size = UDim2.new(0, 240, 0, 280)
mainFrame.Position = UDim2.new(0.5, -120, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true 

local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0, 10)

local uiStroke = Instance.new("UIStroke", mainFrame)
uiStroke.Color = Color3.fromRGB(255, 105, 180)
uiStroke.Thickness = 2

-- Tiêu đề
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "🌸 MAKE BY BAANH"
title.TextColor3 = Color3.fromRGB(255, 182, 193)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

local content = Instance.new("Frame", mainFrame)
content.Size = UDim2.new(1, -20, 1, -45)
content.Position = UDim2.new(0, 10, 0, 40)
content.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", content)
layout.Padding = UDim.new(0, 6)

-- Hàm tạo nhãn và nút
local function createLabel(text, color)
    local l = Instance.new("TextLabel", content)
    l.Size = UDim2.new(1, 0, 0, 20)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    l.Font = Enum.Font.SourceSansBold
    l.TextSize = 15
    l.TextXAlignment = Enum.TextXAlignment.Left
    return l
end

local function createBtn(text, color)
    local b = Instance.new("TextButton", content)
    b.Size = UDim2.new(1, 0, 0, 25)
    b.BackgroundColor3 = color or Color3.fromRGB(45, 45, 45)
    b.Text = text
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 14
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    return b
end

-- Hiển thị thông tin
createLabel("Tên: " .. LocalPlayer.Name)
local donInput = Instance.new("TextBox", content)
donInput.Size = UDim2.new(1, 0, 0, 20)
donInput.BackgroundTransparency = 1
donInput.Text = "Đơn: don tk"
donInput.TextColor3 = Color3.fromRGB(255, 255, 100)
donInput.Font = Enum.Font.SourceSansBold
donInput.TextSize = 15
donInput.TextXAlignment = Enum.TextXAlignment.Left

local fpsL = createLabel("FPS: 0")
local pingL = createLabel("Ping: 0 ms")

-- CHỨC NĂNG POTATO (FIX LỖI HIỂN THỊ)
local isPotato = false
local potBtn = createBtn("Đồ họa: BÌNH THƯỜNG ❌", Color3.fromRGB(80, 20, 20))
local history = {}

local function togglePotato(state)
    if state then
        -- Kích hoạt Potato Mode
        settings().Rendering.QualityLevel = 1
        Lighting.GlobalShadows = false
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation") then
                history[v] = v.Material
                v.Material = Enum.Material.SmoothPlastic
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.LocalTransparencyModifier = 0.8 -- Làm mờ texture thay vì xóa hẳn
            end
        end
    else
        -- Khôi phục đồ họa cũ
        settings().Rendering.QualityLevel = 0
        Lighting.GlobalShadows = true
        for v, mat in pairs(history) do
            if v and v.Parent then v.Material = mat end
        end
        history = {}
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Decal") or v:IsA("Texture") then
                v.LocalTransparencyModifier = 0
            end
        end
    end
end

potBtn.MouseButton1Click:Connect(function()
    isPotato = not isPotato
    if isPotato then
        potBtn.Text = "Đồ họa: POTATO ✅"
        potBtn.BackgroundColor3 = Color3.fromRGB(20, 80, 20)
        togglePotato(true)
    else
        potBtn.Text = "Đồ họa: BÌNH THƯỜNG ❌"
        potBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
        togglePotato(false)
    end
end)

-- Nhóm nút Tiện ích
createLabel("--- TIỆN ÍCH ---", Color3.fromRGB(255, 105, 180))
createBtn("Rejoin Server").MouseButton1Click:Connect(function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

createBtn("Copy JobID").MouseButton1Click:Connect(function()
    setclipboard(tostring(game.JobId))
end)

-- Cập nhật FPS/Ping liên tục
RunService.RenderStepped:Connect(function()
    local fps = math.floor(1 / RunService.RenderStepped:Wait())
    fpsL.Text = "FPS: " .. fps
    local p = 0
    pcall(function() p = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
    if p <= 0 then pcall(function() p = math.floor(LocalPlayer:GetNetworkPing() * 1000) end) end
    pingL.Text = "Ping: " .. p .. " ms"
end)