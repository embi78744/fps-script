local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- GUI Setup
local sg = Instance.new("ScreenGui", game.CoreGui)
sg.Name = "BaAnhStatsUI_V3"

local mainFrame = Instance.new("Frame", sg)
mainFrame.Size = UDim2.new(0, 240, 0, 270) -- Tăng chiều cao để chứa thêm nút
mainFrame.Position = UDim2.new(0.5, -120, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true 

local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0, 12)

local uiStroke = Instance.new("UIStroke", mainFrame)
uiStroke.Color = Color3.fromRGB(255, 105, 180)
uiStroke.Thickness = 2.5
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local titleLabel = Instance.new("TextLabel", mainFrame)
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🌸 MAKE BY BAANH"
titleLabel.TextColor3 = Color3.fromRGB(255, 182, 193)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 18

local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Size = UDim2.new(1, -20, 1, -40)
contentFrame.Position = UDim2.new(0, 10, 0, 35)
contentFrame.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", contentFrame)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 5)

-- Hàm tạo Nút bấm chung
local function createButton(parent, text, color)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 22)
    btn.BackgroundColor3 = color or Color3.fromRGB(40, 40, 45)
    btn.BackgroundTransparency = 0.5
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 4)
    return btn
end

-- 1. Thông tin cơ bản
local function createInfoLabel(parent, text, color)
    local label = Instance.new("TextLabel", parent)
    label.Size = UDim2.new(1, 0, 0, 18)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or Color3.fromRGB(230, 230, 230)
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 15
    label.TextXAlignment = Enum.TextXAlignment.Left
    return label
end

createInfoLabel(contentFrame, "Tên: " .. LocalPlayer.Name)

-- 2. Đơn Input
local donContainer = Instance.new("Frame", contentFrame)
donContainer.Size = UDim2.new(1, 0, 0, 20)
donContainer.BackgroundTransparency = 1
local donInput = Instance.new("TextBox", donContainer)
donInput.Size = UDim2.new(1, 0, 1, 0)
donInput.BackgroundTransparency = 0.9
donInput.Text = "Đơn: don tk"
donInput.TextColor3 = Color3.fromRGB(255, 255, 100)
donInput.Font = Enum.Font.SourceSansBold
donInput.TextSize = 15
donInput.TextXAlignment = Enum.TextXAlignment.Left

local fpsLabel = createInfoLabel(contentFrame, "FPS: 0")
local pingLabel = createInfoLabel(contentFrame, "Ping: 0 ms")

-- 3. FIX LAG (POTATO)
local isOptimized = false
local fixLagBtn = createButton(contentFrame, "Fix Lag: TỐI ƯU (OFF) ❌", Color3.fromRGB(150, 0, 0))
fixLagBtn.TextColor3 = Color3.fromRGB(255, 150, 150)

-- (Logic Potato giữ nguyên từ bản trước của bạn)
local materialHistory = {}
fixLagBtn.MouseButton1Click:Connect(function()
    isOptimized = not isOptimized
    if isOptimized then
        fixLagBtn.Text = "Fix Lag: TỐI ƯU (ON) ✅"
        fixLagBtn.TextColor3 = Color3.fromRGB(150, 255, 150)
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation") then
                materialHistory[v] = v.Material
                v.Material = Enum.Material.SmoothPlastic
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.LocalTransparencyModifier = 0.8
            end
        end
    else
        fixLagBtn.Text = "Fix Lag: TỐI ƯU (OFF) ❌"
        fixLagBtn.TextColor3 = Color3.fromRGB(255, 150, 150)
        for v, mat in pairs(materialHistory) do if v and v.Parent then v.Material = mat end end
        materialHistory = {}
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Decal") or v:IsA("Texture") then v.LocalTransparencyModifier = 0 end
        end
    end
end)

-- --- MỤC 3: TIỆN ÍCH ---
createInfoLabel(contentFrame, "--- TIỆN ÍCH ---", Color3.fromRGB(255, 105, 180))

-- Rejoin Button
local rejoinBtn = createButton(contentFrame, "Rejoin Server 🔄")
rejoinBtn.MouseButton1Click:Connect(function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

-- Server Hop Button
local hopBtn = createButton(contentFrame, "Server Hop 🚀")
hopBtn.MouseButton1Click:Connect(function()
    local servers = {}
    local res = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
    local data = HttpService:JSONDecode(res)
    for _, s in pairs(data.data) do
        if s.playing < s.maxPlayers and s.id ~= game.JobId then
            table.insert(servers, s.id)
        end
    end
    if #servers > 0 then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
    end
end)

-- Copy JobID Button
local copyBtn = createButton(contentFrame, "Copy JobID 📋")
copyBtn.MouseButton1Click:Connect(function()
    setclipboard(tostring(game.JobId))
    copyBtn.Text = "Đã copy mã server!"
    wait(2)
    copyBtn.Text = "Copy JobID 📋"
end)

-- Logic Update FPS/Ping
local fps, frames, lastTime = 0, 0, tick()
RunService.RenderStepped:Connect(function()
    frames = frames + 1
    if tick() - lastTime >= 1 then
        fps, frames, lastTime = frames, 0, tick()
    end
    fpsLabel.Text = "FPS: " .. fps
    local p = 0
    pcall(function() p = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
    if p <= 0 then pcall(function() p = math.floor(LocalPlayer:GetNetworkPing() * 1000) end) end
    pingLabel.Text = "Ping: " .. p .. " ms"
end)