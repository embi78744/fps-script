local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

-- GUI Setup
local sg = Instance.new("ScreenGui", game.CoreGui)
sg.Name = "BaAnhStatsUI_Fixed"

local mainFrame = Instance.new("Frame", sg)
mainFrame.Size = UDim2.new(0, 240, 0, 175)
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
contentFrame.Size = UDim2.new(1, -20, 1, -45)
contentFrame.Position = UDim2.new(0, 10, 0, 35)
contentFrame.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", contentFrame)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 5)

local function createInfoLabel(parent, text, color)
    local label = Instance.new("TextLabel", parent)
    label.Size = UDim2.new(1, 0, 0, 18)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or Color3.fromRGB(230, 230, 230)
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    return label
end

createInfoLabel(contentFrame, "Tên: " .. LocalPlayer.Name)

-- Đơn Input
local donContainer = Instance.new("Frame", contentFrame)
donContainer.Size = UDim2.new(1, 0, 0, 20)
donContainer.BackgroundTransparency = 1
local donPrefix = Instance.new("TextLabel", donContainer)
donPrefix.Size = UDim2.new(0, 40, 1, 0)
donPrefix.BackgroundTransparency = 1
donPrefix.Text = "Đơn: "
donPrefix.TextColor3 = Color3.fromRGB(255, 255, 100)
donPrefix.Font = Enum.Font.SourceSansBold
donPrefix.TextSize = 16
donPrefix.TextXAlignment = Enum.TextXAlignment.Left
local donInput = Instance.new("TextBox", donContainer)
donInput.Size = UDim2.new(1, -40, 1, 0)
donInput.Position = UDim2.new(0, 40, 0, 0)
donInput.BackgroundTransparency = 0.9
donInput.Text = "don tk"
donInput.TextColor3 = Color3.fromRGB(255, 255, 100)
donInput.Font = Enum.Font.SourceSansBold
donInput.TextSize = 16
donInput.TextXAlignment = Enum.TextXAlignment.Left
donInput.ClearTextOnFocus = false

local fpsLabel = createInfoLabel(contentFrame, "FPS: 0")
local pingLabel = createInfoLabel(contentFrame, "Ping: 0 ms")

-- FIX LAG BUTTON (POTATO MODE)
local isOptimized = false
local fixLagBtn = Instance.new("TextButton", contentFrame)
fixLagBtn.Size = UDim2.new(1, 0, 0, 22)
fixLagBtn.BackgroundTransparency = 1
fixLagBtn.Text = "Fix Lag: TỐI ƯU (OFF) ❌"
fixLagBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
fixLagBtn.Font = Enum.Font.SourceSansBold
fixLagBtn.TextSize = 16
fixLagBtn.TextXAlignment = Enum.TextXAlignment.Left

-- Bảng lưu trữ material gốc để khôi phục
local materialHistory = {}

local function SetPotatoMode(state)
    if state then
        -- BẬT POTATO
        settings().Rendering.QualityLevel = 1
        Lighting.GlobalShadows = false
        
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation") then
                -- Lưu lại material gốc trước khi đổi
                materialHistory[v] = v.Material
                v.Material = Enum.Material.SmoothPlastic
            elseif v:IsA("Decal") or v:IsA("Texture") then
                -- Thay vì xóa hoàn toàn (Transparency=1), ta chỉ làm mờ đi một chút để tránh lỗi engine
                v.LocalTransparencyModifier = 0.8
            end
        end
    else
        -- TẮT POTATO (KHÔI PHỤC)
        settings().Rendering.QualityLevel = 0
        Lighting.GlobalShadows = true
        
        for v, originalMaterial in pairs(materialHistory) do
            if v and v.Parent then
                v.Material = originalMaterial
            end
        end
        materialHistory = {} -- Xóa bảng nhớ sau khi khôi phục xong

        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Decal") or v:IsA("Texture") then
                v.LocalTransparencyModifier = 0 -- Hiện lại hoàn toàn
            end
        end
    end
end

fixLagBtn.MouseButton1Click:Connect(function()
    isOptimized = not isOptimized
    if isOptimized then
        fixLagBtn.Text = "Fix Lag: TỐI ƯU (ON) ✅"
        fixLagBtn.TextColor3 = Color3.fromRGB(50, 255, 100)
        SetPotatoMode(true)
    else
        fixLagBtn.Text = "Fix Lag: TỐI ƯU (OFF) ❌"
        fixLagBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
        SetPotatoMode(false)
    end
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