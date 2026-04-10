--[[
    🌸 NGUOITINHMUADONG - V60 ULTIMATE AI OPTIMIZER
    - Tiêu đề: MAKE BY AI.
    - Chế độ Tối ưu: Xóa hiệu ứng kỹ năng, Particles, Beam, Trails (Fix triệt để lag hiệu ứng).
    - Tính năng: Draggable, Sửa Đơn trực tiếp, Anti AFK ngầm.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

-- Xóa UI cũ
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v.Name == "NGUOITINH_AI_V60" then v:Destroy() end
end

local sg = Instance.new("ScreenGui", game.CoreGui); sg.Name = "NGUOITINH_AI_V60"

-- --- GIAO DIỆN CHÍNH (DRAGGABLE) ---
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 300, 0, 230)
main.Position = UDim2.new(0.5, -150, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 25, 30)
main.BackgroundTransparency = 0.1
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(255, 105, 180); stroke.Thickness = 2.5

-- Logic Kéo Thả
local dragging, dragInput, dragStart, startPos
main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = main.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
RunService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- --- NỘI DUNG ---
local header = Instance.new("TextLabel", main)
header.Size = UDim2.new(1, 0, 0, 35); header.BackgroundTransparency = 1
header.Text = "🌸 MAKE BY AI"; header.TextColor3 = Color3.fromRGB(255, 182, 193); header.TextSize = 16; header.Font = Enum.Font.SourceSansBold

local function createL(txt, y, color)
    local l = Instance.new("TextLabel", main)
    l.Size = UDim2.new(1, -20, 0, 25); l.Position = UDim2.new(0, 15, 0, y)
    l.BackgroundTransparency = 1; l.Text = txt; l.TextColor3 = color or Color3.fromRGB(255, 255, 255); l.TextSize = 17; l.Font = Enum.Font.SourceSansBold; l.TextXAlignment = Enum.TextXAlignment.Left
    return l
end

local maskName = string.sub(LocalPlayer.Name, 1, 3) .. "******"
createL("Tên: " .. maskName, 40)
createL("Đơn:", 65, Color3.fromRGB(255, 255, 0))
local donInp = Instance.new("TextBox", main); donInp.Size = UDim2.new(0.6, 0, 0, 25); donInp.Position = UDim2.new(0, 55, 0, 65); donInp.BackgroundTransparency = 1; donInp.Text = "don tk"; donInp.TextColor3 = Color3.fromRGB(255, 255, 0); donInp.TextSize = 17; donInp.Font = Enum.Font.SourceSansBold; donInp.TextXAlignment = Enum.TextXAlignment.Left; donInp.ClearTextOnFocus = false

local fpsL = createL("FPS: 0", 90); local pingL = createL("Ping: 0 ms", 115)

-- --- NÚT TỐI ƯU CỰC MẠNH ---
local fixLagBtn = Instance.new("TextButton", main)
fixLagBtn.Size = UDim2.new(1, -30, 0, 32); fixLagBtn.Position = UDim2.new(0, 15, 0, 155); fixLagBtn.BackgroundTransparency = 1; fixLagBtn.Text = "Fix Lag: TỐI ƯU (OFF) ❌"; fixLagBtn.TextColor3 = Color3.fromRGB(255, 69, 0); fixLagBtn.TextSize = 18; fixLagBtn.Font = Enum.Font.SourceSansBold; fixLagBtn.TextXAlignment = Enum.TextXAlignment.Left

local optActive = false
fixLagBtn.MouseButton1Click:Connect(function()
    optActive = not optActive
    if optActive then
        fixLagBtn.Text = "Fix Lag: TỐI ƯU (ON) ✅"; fixLagBtn.TextColor3 = Color3.fromRGB(0, 255, 127)
        -- Xóa mọi hiệu ứng gây lag
        settings().Rendering.QualityLevel = 1
        Lighting.GlobalShadows = false
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") or v:IsA("Fire") or v:IsA("Sparkles") then
                pcall(function() v.Enabled = false end)
            elseif v:IsA("BasePart") then
                pcall(function() v.Material = Enum.Material.SmoothPlastic end)
            elseif v:IsA("Decal") then
                pcall(function() v.Transparency = 1 end)  -- Tắt decals để giảm texture load
            end
        end
    else
        fixLagBtn.Text = "Fix Lag: TỐI ƯU (OFF) ❌"; fixLagBtn.TextColor3 = Color3.fromRGB(255, 69, 0)
        settings().Rendering.QualityLevel = 0
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") or v:IsA("Fire") or v:IsA("Sparkles") then
                pcall(function() v.Enabled = true end)
            elseif v:IsA("BasePart") then
                pcall(function() v.Material = Enum.Material.Plastic end)
            elseif v:IsA("Decal") then
                pcall(function() v.Transparency = 0 end)
            end
        end
    end
end)

-- Loop Anti AFK & Stats
if LocalPlayer and LocalPlayer.Idled then
    LocalPlayer.Idled:Connect(function()
        if VirtualUser then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end
    end)
end
local lastUp = os.clock(); local f = 0
RunService.Heartbeat:Connect(function()
    f = f + 1
    if os.clock() - lastUp >= 1 then
        if fpsL and pingL then
            fpsL.Text = "FPS: " .. f
            local pingValue = Stats and Stats.Network and Stats.Network.ServerStatsItem and Stats.Network.ServerStatsItem["Data Ping"] and Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
            pingL.Text = string.format("Ping: %.1f ms", pingValue or 0)
        end
        f = 0; lastUp = os.clock()
    end
end)

-- Thêm nút Reset để khôi phục hiệu ứng
local resetBtn = Instance.new("TextButton", main)
resetBtn.Size = UDim2.new(1, -30, 0, 32); resetBtn.Position = UDim2.new(0, 15, 0, 192); resetBtn.BackgroundTransparency = 1; resetBtn.Text = "Reset Effects"; resetBtn.TextColor3 = Color3.fromRGB(0, 191, 255); resetBtn.TextSize = 16; resetBtn.Font = Enum.Font.SourceSansBold; resetBtn.TextXAlignment = Enum.TextXAlignment.Left
resetBtn.MouseButton1Click:Connect(function()
    if optActive then
        optActive = false
        fixLagBtn.Text = "Fix Lag: TỐI ƯU (OFF) ❌"; fixLagBtn.TextColor3 = Color3.fromRGB(255, 69, 0)
        settings().Rendering.QualityLevel = 0
        for _, v in pairs(game:GetDescendants()) do
            if v and v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") or v:IsA("Fire") or v:IsA("Sparkles") then
                pcall(function() v.Enabled = true end)
            elseif v and v:IsA("BasePart") then
                pcall(function() v.Material = Enum.Material.Plastic end)
            end
        end
    end
end)