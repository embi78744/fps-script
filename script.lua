--[[
    🌸 NGUOITINHMUADONG - V25 FINAL MASTER
    Tối ưu hóa: Xóa bóng đổ, Tắt Render 3D, Join Server chuẩn xác
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

-- Kiểm tra và xóa UI cũ
local existing = game.CoreGui:FindFirstChild("NGUOITINHMUADONG_FINAL")
if existing then existing:Destroy() end

local sg = Instance.new("ScreenGui", game.CoreGui)
sg.Name = "NGUOITINHMUADONG_FINAL"
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- --- [1] WHITE SCREEN (Lớp nền trắng tuyệt đối) ---
local wsFrame = Instance.new("Frame", sg)
wsFrame.Size = UDim2.new(1, 0, 1, 0)
wsFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
wsFrame.Visible = false
wsFrame.ZIndex = 1 -- Đảm bảo luôn nằm dưới menu

-- --- [2] GIAO DIỆN CHÍNH ---
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 240, 0, 560)
main.Position = UDim2.new(0.5, -120, 0.1, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.Active = true
main.Draggable = true 
main.ZIndex = 10

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(255, 105, 180) -- Viền hồng chuẩn
stroke.Thickness = 2.5

-- Tiêu đề
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, -40, 0, 35)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🌸 MADE BY NGUOITINHMUADONG"
title.TextColor3 = Color3.fromRGB(255, 182, 193)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 13
title.TextXAlignment = Enum.TextXAlignment.Left

-- Nút thu gọn
local miniBtn = Instance.new("TextButton", main)
miniBtn.Size = UDim2.new(0, 25, 0, 25)
miniBtn.Position = UDim2.new(1, -35, 0, 5)
miniBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
miniBtn.Text = "-"
miniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(0, 6)

local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, -20, 1, -45)
content.Position = UDim2.new(0, 10, 0, 40)
content.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", content)
layout.Padding = UDim.new(0, 6)

miniBtn.MouseButton1Click:Connect(function()
    content.Visible = not content.Visible
    main:TweenSize(content.Visible and UDim2.new(0, 240, 0, 560) or UDim2.new(0, 240, 0, 35), "Out", "Quart", 0.3, true)
    miniBtn.Text = content.Visible and "-" or "+"
end)

-- --- [3] HÀM TẠO LINH KIỆN ---
local function createBtn(txt, clr)
    local b = Instance.new("TextButton", content)
    b.Size = UDim2.new(1, 0, 0, 30)
    b.BackgroundColor3 = clr or Color3.fromRGB(45, 45, 45)
    b.Text = txt
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 12
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    return b
end

local function createLabel(txt, clr)
    local l = Instance.new("TextLabel", content)
    l.Size = UDim2.new(1, 0, 0, 20)
    l.BackgroundTransparency = 1
    l.Text = txt
    l.TextColor3 = clr or Color3.fromRGB(255, 255, 255)
    l.Font = Enum.Font.SourceSansBold
    l.TextSize = 14
    l.TextXAlignment = Enum.TextXAlignment.Left
    return l
end

-- --- [4] KHỞI TẠO CÁC NÚT BẤM ---
local antiBtn = createBtn("1. Anti AFK: ON ✅", Color3.fromRGB(30, 100, 30))
local potBtn = createBtn("2. Đồ họa: BÌNH THƯỜNG ❌", Color3.fromRGB(80, 20, 20))
local copyJobBtn = createBtn("4. Copy JobID Server Hiện Tại 📋")
local wsBtn = createBtn("5. White Screen: OFF 🔋")

local joinInput = Instance.new("TextBox", content)
joinInput.Size = UDim2.new(1, 0, 0, 32)
joinInput.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
joinInput.PlaceholderText = "Nhập JobID tại đây..."
joinInput.Text = ""
joinInput.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", joinInput)

local joinBtn = createBtn("JOIN SERVER THEO ID", Color3.fromRGB(60, 60, 60))
local rejoinBtn = createBtn("Rejoin Server")
local dcBtn = createBtn("COPY LINK DISCORD 💬", Color3.fromRGB(88, 101, 242))

local nameL = createLabel("Tên: " .. LocalPlayer.Name)
local fpsL = createLabel("FPS: --")
local pingL = createLabel("Ping: -- ms")
local timeL = createLabel("3. Giờ: --")
local dcLinkL = createLabel("Discord: discord.gg/abcxyz", Color3.fromRGB(114, 137, 218))
createLabel("--- TIỆN ÍCH ---", Color3.fromRGB(255, 105, 180))

-- --- [5] XỬ LÝ LOGIC CHI TIẾT ---

-- Chức năng Đồ họa Potato (Xóa bóng đổ & tăng FPS)
local potatoActive = false
potBtn.MouseButton1Click:Connect(function()
    potatoActive = not potatoActive
    potBtn.Text = potatoActive and "2. Đồ họa: POTATO ✅" or "2. Đồ họa: BÌNH THƯỜNG ❌"
    potBtn.BackgroundColor3 = potatoActive and Color3.fromRGB(20, 80, 20) or Color3.fromRGB(80, 20, 20)
    
    Lighting.GlobalShadows = not potatoActive
    if potatoActive then
        settings().Rendering.QualityLevel = 1
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.SmoothPlastic
                v.CastShadow = false
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Enabled = false
            end
        end
    else
        settings().Rendering.QualityLevel = 0
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("BasePart") then v.Material = Enum.Material.Plastic v.CastShadow = true end
            if v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 0 end
        end
    end
end)

-- Chức năng Copy JobID
copyJobBtn.MouseButton1Click:Connect(function()
    setclipboard(tostring(game.JobId))
    copyJobBtn.Text = "ĐÃ COPY! ✅"
    task.wait(1)
    copyJobBtn.Text = "4. Copy JobID Server Hiện Tại 📋"
end)

-- Chức năng White Screen (Tắt render 3D để treo máy)
wsBtn.MouseButton1Click:Connect(function()
    wsFrame.Visible = not wsFrame.Visible
    wsBtn.Text = wsFrame.Visible and "5. White Screen: ON ✅" or "5. White Screen: OFF 🔋"
    RunService:Set3dRenderingEnabled(not wsFrame.Visible)
end)

-- Chức năng Join Server ID chuẩn
joinBtn.MouseButton1Click:Connect(function()
    local id = joinInput.Text:gsub("%s+", "") -- Loại bỏ mọi khoảng trắng
    if id ~= "" then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, id, LocalPlayer)
    end
end)

rejoinBtn.MouseButton1Click:Connect(function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

-- Chức năng Copy Discord
dcBtn.MouseButton1Click:Connect(function()
    setclipboard("discord.gg/abcxyz")
    dcBtn.Text = "ĐÃ COPY LINK! ✅"
    task.wait(1)
    dcBtn.Text = "COPY LINK DISCORD 💬"
end)

-- --- [6] CẬP NHẬT THÔNG SỐ HỆ THỐNG ---
local fpsCount = 0
RunService.Heartbeat:Connect(function() fpsCount = fpsCount + 1 end)

task.spawn(function()
    while true do
        local start = fpsCount
        task.wait(1)
        fpsL.Text = "FPS: " .. (fpsCount - start)
        timeL.Text = "3. Giờ: " .. os.date("%H:%M:%S")
        pingL.Text = "Ping: " .. math.floor(LocalPlayer:GetNetworkPing() * 1000) .. " ms"
    end
end)

-- Anti AFK
local antiAfkEnabled = true
LocalPlayer.Idled:Connect(function()
    if antiAfkEnabled then
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Unknown, false, game)
    end
end)

antiBtn.MouseButton1Click:Connect(function()
    antiAfkEnabled = not antiAfkEnabled
    antiBtn.Text = antiAfkEnabled and "1. Anti AFK: ON ✅" or "1. Anti AFK: OFF ❌"
    antiBtn.BackgroundColor3 = antiAfkEnabled and Color3.fromRGB(30, 100, 30) or Color3.fromRGB(60, 60, 60)
end)