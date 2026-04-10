--[[
    🌸 NGUOITINHMUADONG - V60 ULTIMATE AI OPTIMIZER (IMPROVED)
    - Tiêu đề: MAKE BY AI (Cải thiện bởi Copilot).
    - Chế độ Tối ưu: Xóa hiệu ứng kỹ năng, Particles, Beam, Trails (Fix triệt để lag hiệu ứng).
    - Tính năng: Draggable, Sửa Đơn trực tiếp, Anti AFK ngầm, UI cải thiện, nút đóng.
    - Cải thiện: Tổ chức code tốt hơn, xử lý lỗi cơ bản, tối ưu hóa chi tiết hơn.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

-- Hàm xóa UI cũ
local function clearOldUI()
    for _, v in pairs(game.CoreGui:GetChildren()) do
        if v.Name == "NGUOITINH_AI_V60" then
            v:Destroy()
        end
    end
end

-- Hàm tạo UI chính
local function createMainUI()
    local sg = Instance.new("ScreenGui", game.CoreGui)
    sg.Name = "NGUOITINH_AI_V60"

    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, 280, 0, 220)  -- Tăng kích thước cho thêm nút
    main.Position = UDim2.new(0.5, -140, 0.4, 0)
    main.BackgroundColor3 = Color3.fromRGB(20, 25, 30)
    main.BackgroundTransparency = 0.1
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
    local stroke = Instance.new("UIStroke", main)
    stroke.Color = Color3.fromRGB(255, 105, 180)
    stroke.Thickness = 2.5

    -- Logic Kéo Thả
    local dragging, dragInput, dragStart, startPos
    main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    main.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    return main
end

-- Hàm tạo TextLabel
local function createLabel(parent, text, position, color)
    local label = Instance.new("TextLabel", parent)
    label.Size = UDim2.new(1, -20, 0, 25)
    label.Position = position
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    label.TextSize = 17
    label.Font = Enum.Font.SourceSansBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    return label
end

-- Hàm tạo TextBox
local function createTextBox(parent, text, position, color)
    local box = Instance.new("TextBox", parent)
    box.Size = UDim2.new(0.6, 0, 0, 25)
    box.Position = position
    box.BackgroundTransparency = 1
    box.Text = text
    box.TextColor3 = color or Color3.fromRGB(255, 255, 0)
    box.TextSize = 17
    box.Font = Enum.Font.SourceSansBold
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.ClearTextOnFocus = false
    return box
end

-- Hàm tạo Button
local function createButton(parent, text, position, color)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -30, 0, 30)
    btn.Position = position
    btn.BackgroundTransparency = 1
    btn.Text = text
    btn.TextColor3 = color or Color3.fromRGB(255, 69, 0)
    btn.TextSize = 18
    btn.Font = Enum.Font.SourceSansBold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    return btn
end

-- Hàm tối ưu hóa đồ họa
local function optimizeGraphics(enable)
    if enable then
        settings().Rendering.QualityLevel = 1
        Lighting.GlobalShadows = false
        for _, v in pairs(game:GetDescendants()) do
            pcall(function()  -- Xử lý lỗi cơ bản
                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") or v:IsA("Fire") or v:IsA("Sparkles") then
                    v.Enabled = false
                elseif v:IsA("BasePart") then
                    v.Material = Enum.Material.SmoothPlastic
                end
            end)
        end
    else
        settings().Rendering.QualityLevel = 0
        Lighting.GlobalShadows = true
        for _, v in pairs(game:GetDescendants()) do
            pcall(function()
                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") or v:IsA("Fire") or v:IsA("Sparkles") then
                    v.Enabled = true
                elseif v:IsA("BasePart") then
                    v.Material = Enum.Material.Plastic
                end
            end)
        end
    end
end

-- Hàm cập nhật stats
local function updateStats(fpsLabel, pingLabel)
    local lastUp = os.clock()
    local f = 0
    RunService.Heartbeat:Connect(function()
        f = f + 1
        if os.clock() - lastUp >= 1 then
            fpsLabel.Text = "FPS: " .. f
            pingLabel.Text = string.format("Ping: %.1f ms", Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            f = 0
            lastUp = os.clock()
        end
    end)
end

-- Main script
clearOldUI()
local main = createMainUI()

-- Header
local header = createLabel(main, "🌸 MAKE BY AI (Cải thiện)", UDim2.new(0, 0, 0, 10), Color3.fromRGB(255, 182, 193))
header.Size = UDim2.new(1, 0, 0, 35)
header.TextXAlignment = Enum.TextXAlignment.Center

-- Nút đóng
local closeBtn = Instance.new("TextButton", main)
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 10)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.MouseButton1Click:Connect(function()
    main.Parent:Destroy()
end)

-- Nội dung
local maskName = string.sub(LocalPlayer.Name, 1, 3) .. "******"
createLabel(main, "Tên: " .. maskName, UDim2.new(0, 15, 0, 50))
createLabel(main, "Đơn:", UDim2.new(0, 15, 0, 75), Color3.fromRGB(255, 255, 0))
local donInp = createTextBox(main, "don tk", UDim2.new(0, 55, 0, 75), Color3.fromRGB(255, 255, 0))

local fpsL = createLabel(main, "FPS: 0", UDim2.new(0, 15, 0, 105))
local pingL = createLabel(main, "Ping: 0 ms", UDim2.new(0, 15, 0, 130))

-- Nút tối ưu
local fixLagBtn = createButton(main, "Fix Lag: TỐI ƯU (OFF) ❌", UDim2.new(0, 15, 0, 165), Color3.fromRGB(255, 69, 0))
local optActive = false
fixLagBtn.MouseButton1Click:Connect(function()
    optActive = not optActive
    if optActive then
        fixLagBtn.Text = "Fix Lag: TỐI ƯU (ON) ✅"
        fixLagBtn.TextColor3 = Color3.fromRGB(0, 255, 127)
        optimizeGraphics(true)
    else
        fixLagBtn.Text = "Fix Lag: TỐI ƯU (OFF) ❌"
        fixLagBtn.TextColor3 = Color3.fromRGB(255, 69, 0)
        optimizeGraphics(false)
    end
end)

-- Anti AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Cập nhật stats
updateStats(fpsL, pingL)