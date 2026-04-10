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
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Hàm tạo âm thanh click
local function playClickSound()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://12221967"  -- ID âm thanh click mặc định
    sound.Volume = 0.5
    sound.Parent = SoundService
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end

-- Biến cache và trạng thái
local cachedEffects = {}
local cachedLights = {}
local cachedParts = {}
local cachedDecals = {}
local cachedLightingEffects = {}
local particlesEnabled = true
local shadowsEnabled = true
local optActive = false
local originalQuality = settings().Rendering.QualityLevel
local originalShadows = Lighting.GlobalShadows
local originalOutdoorAmbient = Lighting.OutdoorAmbient
local originalAmbient = Lighting.Ambient
local originalFogStart = Lighting.FogStart
local originalFogEnd = Lighting.FogEnd
local originalFogColor = Lighting.FogColor
local originalBrightness = Lighting.Brightness
local originalEnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale
local originalEnvironmentSpecularScale = Lighting.EnvironmentSpecularScale

-- Hàm cache descendants (chỉ loop 1 lần)
local function cacheDescendants()
    cachedEffects = {}
    cachedLights = {}
    cachedParts = {}
    cachedDecals = {}
    cachedLightingEffects = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") or v:IsA("Fire") or v:IsA("Sparkles") or v:IsA("Smoke") or v:IsA("Flame") then
            table.insert(cachedEffects, v)
        elseif v:IsA("PointLight") or v:IsA("SurfaceLight") or v:IsA("SpotLight") then
            table.insert(cachedLights, v)
        elseif v:IsA("Decal") or v:IsA("Texture") then
            table.insert(cachedDecals, v)
        elseif v:IsA("BasePart") then
            table.insert(cachedParts, v)
        elseif v:IsA("Atmosphere") or v:IsA("Sky") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("BloomEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("DepthOfFieldEffect") then
            table.insert(cachedLightingEffects, v)
        end
    end
end

-- Hàm xóa UI cũ
local function clearOldUI()
    for _, container in pairs({game.CoreGui, PlayerGui}) do
        for _, v in pairs(container:GetChildren()) do
            if v.Name == "NGUOITINH_AI_V60" then
                v:Destroy()
            end
        end
    end
end

-- Hàm tạo UI chính
local function createMainUI()
    local sg = Instance.new("ScreenGui")
    sg.Name = "NGUOITINH_AI_V60"
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.Parent = PlayerGui

    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, 400, 0, 380)
    main.Position = UDim2.new(0.5, 0, 0.2, 0)
    main.AnchorPoint = Vector2.new(0.5, 0)
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
    btn.Size = UDim2.new(1, -30, 0, 40)
    btn.Position = position
    btn.BackgroundTransparency = 1
    btn.AutoButtonColor = true
    btn.Text = text
    btn.TextColor3 = color or Color3.fromRGB(255, 69, 0)
    btn.TextSize = 15
    btn.TextScaled = false
    btn.TextWrapped = true
    btn.TextTruncate = Enum.TextTruncate.AtEnd
    btn.Font = Enum.Font.SourceSansBold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.TextYAlignment = Enum.TextYAlignment.Center
    return btn
end

local function applyParticleState(enabled)
    for _, v in ipairs(cachedEffects) do
        pcall(function()
            v.Enabled = enabled
        end)
    end
end

local function applyLightingState(enable)
    if enable then
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(20, 20, 20)
        Lighting.Ambient = Color3.fromRGB(20, 20, 20)
        Lighting.FogStart = 0
        Lighting.FogEnd = 80
        Lighting.FogColor = Color3.fromRGB(15, 15, 15)
        Lighting.Brightness = 0.2
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
    else
        Lighting.GlobalShadows = shadowsEnabled and originalShadows or false
        Lighting.OutdoorAmbient = originalOutdoorAmbient
        Lighting.Ambient = originalAmbient
        Lighting.FogStart = originalFogStart
        Lighting.FogEnd = originalFogEnd
        Lighting.FogColor = originalFogColor
        Lighting.Brightness = originalBrightness
        Lighting.EnvironmentDiffuseScale = originalEnvironmentDiffuseScale
        Lighting.EnvironmentSpecularScale = originalEnvironmentSpecularScale
    end
end

-- Hàm tối ưu hóa đồ họa (sử dụng cache)
local function applyLightingEffectsState(enable)
    for _, v in ipairs(cachedLightingEffects) do
        pcall(function()
            v.Enabled = enable
        end)
    end
end

local function optimizeGraphics(enable)
    if enable then
        settings().Rendering.QualityLevel = 0
        applyLightingState(true)
        applyParticleState(false)
        applyLightingEffectsState(false)

        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            pcall(function()
                terrain.WaterWaveSize = 0
                terrain.WaterWaveSpeed = 0
                terrain.WaterReflectance = 0
                terrain.WaterTransparency = 1
            end)
        end

        for _, v in ipairs(cachedParts) do
            pcall(function()
                v.Material = Enum.Material.SmoothPlastic
                v.CastShadow = false
            end)
        end
        for _, v in ipairs(cachedLights) do
            pcall(function()
                v.Enabled = false
            end)
        end
        for _, v in ipairs(cachedDecals) do
            pcall(function()
                v.Transparency = 1
            end)
        end
    else
        settings().Rendering.QualityLevel = originalQuality
        applyLightingState(false)
        applyParticleState(particlesEnabled)
        applyLightingEffectsState(true)

        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            pcall(function()
                terrain.WaterWaveSize = 0.5
                terrain.WaterWaveSpeed = 0.5
                terrain.WaterReflectance = 0.5
                terrain.WaterTransparency = 0
            end)
        end

        for _, v in ipairs(cachedParts) do
            pcall(function()
                v.Material = Enum.Material.Plastic
                v.CastShadow = true
            end)
        end
        for _, v in ipairs(cachedLights) do
            pcall(function()
                v.Enabled = true
            end)
        end
        for _, v in ipairs(cachedDecals) do
            pcall(function()
                v.Transparency = 0
            end)
        end
    end
end

-- Hàm toggle particles
local function toggleParticles(btn)
    particlesEnabled = not particlesEnabled
    btn.Text = "Particles: " .. (particlesEnabled and "ON ✅" or "OFF ❌")
    btn.TextColor3 = particlesEnabled and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(255, 69, 0)
    applyParticleState(particlesEnabled)
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
        notificationLabel = Instance.new("TextLabel", PlayerGui:FindFirstChild("NGUOITINH_AI_V60"))
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
header.Size = UDim2.new(1, 0, 0, 40)
header.TextSize = 20
header.TextXAlignment = Enum.TextXAlignment.Center

-- Nút đóng và minimize
local closeBtn = Instance.new("TextButton", main)
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 10)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.MouseButton1Click:Connect(function()
    playClickSound()
    main.Parent:Destroy()
end)

local minimizeBtn = Instance.new("TextButton", main)
minimizeBtn.Size = UDim2.new(0, 25, 0, 25)
minimizeBtn.Position = UDim2.new(1, -60, 0, 10)
minimizeBtn.BackgroundTransparency = 1
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 0)
minimizeBtn.TextSize = 20
minimizeBtn.Font = Enum.Font.SourceSansBold
local isMinimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    playClickSound()
    isMinimized = not isMinimized
    for _, child in ipairs(main:GetChildren()) do
        if child ~= header and child ~= closeBtn and child ~= minimizeBtn then
            child.Visible = not isMinimized
        end
    end
    minimizeBtn.Text = isMinimized and "+" or "-"
end)

-- Nội dung
local maskName = string.sub(LocalPlayer.Name, 1, 3) .. "******"
createLabel(main, "DEBUG: UI Loaded", UDim2.new(0, 15, 0, 55), Color3.fromRGB(255, 100, 100))
createLabel(main, "Tên: " .. maskName, UDim2.new(0, 15, 0, 85))
createLabel(main, "Đơn:", UDim2.new(0, 15, 0, 110), Color3.fromRGB(255, 255, 0))
local donInp = createTextBox(main, "don tk", UDim2.new(0, 55, 0, 110), Color3.fromRGB(255, 255, 0))

local fpsL = createLabel(main, "FPS: 0", UDim2.new(0, 15, 0, 145))
local pingL = createLabel(main, "Ping: 0 ms", UDim2.new(0, 15, 0, 170))

-- Nút toggle particles
local particlesBtn = createButton(main, "Particles: ON ✅", UDim2.new(0, 15, 0, 200), Color3.fromRGB(0, 255, 127))
particlesBtn.MouseButton1Click:Connect(function()
    playClickSound()
    toggleParticles(particlesBtn)
end)

-- Nút toggle shadows
local shadowsBtn = createButton(main, "Shadows: ON ✅", UDim2.new(0, 15, 0, 235), Color3.fromRGB(0, 255, 127))
shadowsBtn.MouseButton1Click:Connect(function()
    playClickSound()
    toggleShadows(shadowsBtn)
end)

local function toggleFixLag(button)
    optActive = not optActive
    if optActive then
        button.Text = "Fix Lag: TỐI ƯU (ON) ✅"
        button.TextColor3 = Color3.fromRGB(0, 255, 127)
        optimizeGraphics(true)
        showNotification("Tối ưu lag bật")
    else
        button.Text = "Fix Lag: TỐI ƯU (OFF) ❌"
        button.TextColor3 = Color3.fromRGB(255, 69, 0)
        optimizeGraphics(false)
        showNotification("Tối ưu lag tắt")
    end
end

-- Nút tối ưu chính
local fixLagBtn = createButton(main, "Fix Lag: TỐI ƯU (OFF) ❌", UDim2.new(0, 15, 0, 270), Color3.fromRGB(255, 69, 0))
fixLagBtn.MouseButton1Click:Connect(function()
    playClickSound()
    toggleFixLag(fixLagBtn)
end)

-- Nút reset
local resetBtn = createButton(main, "Reset Cài Đặt", UDim2.new(0, 15, 0, 305), Color3.fromRGB(255, 215, 0))
resetBtn.MouseButton1Click:Connect(function()
    playClickSound()
    resetSettings(particlesBtn, shadowsBtn, fixLagBtn)
end)

-- Keybind (F key)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F then
        playClickSound()
        toggleFixLag(fixLagBtn)
    end
end)

-- Anti AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Cập nhật stats
updateStats(fpsL, pingL)