--[[
    🌸 NGUOITINHMUADONG - V60 ULTIMATE AI OPTIMIZER (FULLY IMPROVED)
    - Tiêu đề: MAKE BY AI (Cải thiện đầy đủ bởi Copilot).
    - Chế độ Tối ưu: Toggle chi tiết hiệu ứng, Particles, Beam, Trails, Shadows (Fix lag hiệu ứng).
    - Tính năng: Draggable, Sửa Đơn, Anti AFK, UI mở rộng, nút đóng, reset, keybind (F), thông báo, mobile support.
    - Cải thiện: Tổ chức code, xử lý lỗi, tối ưu hiệu suất, cache để tránh loop thừa.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Biến cache và trạng thái
local cachedDescendants = {}
local particlesEnabled = true
local shadowsEnabled = true
local optActive = false

-- Hàm cache descendants (chỉ loop 1 lần)
local function cacheDescendants()
    cachedDescendants = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") or v:IsA("Fire") or v:IsA("Sparkles") or v:IsA("BasePart") then
            table.insert(cachedDescendants, v)
        end
    end
end

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
    main.Size = UDim2.new(0, 320, 0, 350)  -- Tăng kích thước cho nhiều nút
    main.Position = UDim2.new(0.5, -160, 0.4, 0)
    main.BackgroundColor3 = Color3.fromRGB(20, 25, 30)
    main.BackgroundTransparency = 0.1
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
    local stroke = Instance.new("UIStroke", main)
    stroke.Color = Color3.fromRGB(255, 105, 180)
    stroke.Thickness = 2.5

    -- Logic Kéo Thả
    local dragging, dragInput, dragStart, startPos
    main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or (UserInputService.TouchEnabled and input.UserInputType == Enum.UserInputType.Touch) then
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
        if input.UserInputType == Enum.UserInputType.MouseMovement or (UserInputService.TouchEnabled and input.UserInputType == Enum.UserInputType.Touch) then
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

-- Hàm tối ưu hóa đồ họa (sử dụng cache)
local function optimizeGraphics(enable)
    if enable then
        settings().Rendering.QualityLevel = 1
        Lighting.GlobalShadows = false
        for _, v in ipairs(cachedDescendants) do
            pcall(function()
                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") or v:IsA("Fire") or v:IsA("Sparkles") then
                    if not particlesEnabled then v.Enabled = false end
                elseif v:IsA("BasePart") then
                    v.Material = Enum.Material.SmoothPlastic
                end
            end)
        end
    else
        settings().Rendering.QualityLevel = 0
        Lighting.GlobalShadows = shadowsEnabled
        for _, v in ipairs(cachedDescendants) do
            pcall(function()
                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") or v:IsA("Fire") or v:IsA("Sparkles") then
                    v.Enabled = particlesEnabled
                elseif v:IsA("BasePart") then
                    v.Material = Enum.Material.Plastic
                end
            end)
        end
    end
end

-- Hàm toggle particles
local function toggleParticles(btn)
    particlesEnabled = not particlesEnabled
    btn.Text = "Particles: " .. (particlesEnabled and "ON ✅" or "OFF ❌")
    btn.TextColor3 = particlesEnabled and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(255, 69, 0)
    if optActive then optimizeGraphics(true) end
    showNotification("Particles " .. (particlesEnabled and "bật" or "tắt"))
end

-- Hàm toggle shadows
local function toggleShadows(btn)
    shadowsEnabled = not shadowsEnabled
    btn.Text = "Shadows: " .. (shadowsEnabled and "ON ✅" or "OFF ❌")
    btn.TextColor3 = shadowsEnabled and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(255, 69, 0)
    Lighting.GlobalShadows = shadowsEnabled
    showNotification("Shadows " .. (shadowsEnabled and "bật" or "tắt"))
end

-- Hàm reset
local function resetSettings(btnParticles, btnShadows, btnOpt)
    particlesEnabled = true
    shadowsEnabled = true
    optActive = false
    btnParticles.Text = "Particles: ON ✅"
    btnParticles.TextColor3 = Color3.fromRGB(0, 255, 127)
    btnShadows.Text = "Shadows: ON ✅"
    btnShadows.TextColor3 = Color3.fromRGB(0, 255, 127)
    btnOpt.Text = "Fix Lag: TỐI ƯU (OFF) ❌"
    btnOpt.TextColor3 = Color3.fromRGB(255, 69, 0)
    optimizeGraphics(false)
    showNotification("Đã reset cài đặt")
end

-- Hàm thông báo
local notificationLabel
local function showNotification(text)
    if not notificationLabel then
        notificationLabel = Instance.new("TextLabel", game.CoreGui:FindFirstChild("NGUOITINH_AI_V60"))
        notificationLabel.Size = UDim2.new(0, 200, 0, 50)
        notificationLabel.Position = UDim2.new(0.5, -100, 0.8, 0)
        notificationLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        notificationLabel.BackgroundTransparency = 0.5
        notificationLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        notificationLabel.TextSize = 20
        notificationLabel.Font = Enum.Font.SourceSansBold
        notificationLabel.TextXAlignment = Enum.TextXAlignment.Center
        Instance.new("UICorner", notificationLabel).CornerRadius = UDim.new(0, 10)
    end
    notificationLabel.Text = text
    notificationLabel.Visible = true
    wait(2)
    notificationLabel.Visible = false
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
cacheDescendants()  -- Cache 1 lần
local main = createMainUI()

-- Header
local header = createLabel(main, "🌸 MAKE BY AI (Full Improved)", UDim2.new(0, 0, 0, 10), Color3.fromRGB(255, 182, 193))
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

-- Nút toggle particles
local particlesBtn = createButton(main, "Particles: ON ✅", UDim2.new(0, 15, 0, 160), Color3.fromRGB(0, 255, 127))
particlesBtn.MouseButton1Click:Connect(function() toggleParticles(particlesBtn) end)

-- Nút toggle shadows
local shadowsBtn = createButton(main, "Shadows: ON ✅", UDim2.new(0, 15, 0, 195), Color3.fromRGB(0, 255, 127))
shadowsBtn.MouseButton1Click:Connect(function() toggleShadows(shadowsBtn) end)

-- Nút tối ưu chính
local fixLagBtn = createButton(main, "Fix Lag: TỐI ƯU (OFF) ❌", UDim2.new(0, 15, 0, 230), Color3.fromRGB(255, 69, 0))
fixLagBtn.MouseButton1Click:Connect(function()
    optActive = not optActive
    if optActive then
        fixLagBtn.Text = "Fix Lag: TỐI ƯU (ON) ✅"
        fixLagBtn.TextColor3 = Color3.fromRGB(0, 255, 127)
        optimizeGraphics(true)
        showNotification("Tối ưu lag bật")
    else
        fixLagBtn.Text = "Fix Lag: TỐI ƯU (OFF) ❌"
        fixLagBtn.TextColor3 = Color3.fromRGB(255, 69, 0)
        optimizeGraphics(false)
        showNotification("Tối ưu lag tắt")
    end
end)

-- Nút reset
local resetBtn = createButton(main, "Reset Cài Đặt", UDim2.new(0, 15, 0, 265), Color3.fromRGB(255, 215, 0))
resetBtn.MouseButton1Click:Connect(function() resetSettings(particlesBtn, shadowsBtn, fixLagBtn) end)

-- Keybind (F key)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F then
        fixLagBtn:Fire()  -- Simulate click
    end
end)

-- Anti AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Cập nhật stats
updateStats(fpsL, pingL)