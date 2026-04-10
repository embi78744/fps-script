--[[ 
    🌸 NGUOITINHMUADONG - V42 GLOBAL FIX (FIXED BLACK SCREEN & RENDER ERROR)
    - Fix triệt để lỗi 'RenderService' tại dòng 9.
    - Fix triệt để lỗi đen màn hình bằng cơ chế Task Yield.
    - Chuẩn hóa bộ đo FPS/Ping theo thời gian thực.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService") -- Sửa lỗi từ RenderService
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

-- [CÀI ĐẶT KEY HỆ THỐNG]
local CORRECT_KEY = "NGUOITINH-2026"
local DISCORD_LINK = "https://discord.gg/sh5ontop"

-- Dọn dẹp bản cũ triệt để trước khi chạy
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v.Name == "NGUOITINH_FIX_V42" then v:Destroy() end
end

local sg = Instance.new("ScreenGui", game.CoreGui)
sg.Name = "NGUOITINH_FIX_V42"
sg.ZIndexBehavior = Enum.ZIndexBehavior.Global

-- --- [1] GIAO DIỆN XÁC THỰC (KEY SYSTEM) ---
local auth = Instance.new("Frame", sg)
auth.Size = UDim2.new(0, 350, 0, 200); auth.Position = UDim2.new(0.5, -175, 0.4, 0)
auth.BackgroundColor3 = Color3.fromRGB(15, 15, 15); auth.ZIndex = 100
Instance.new("UICorner", auth); Instance.new("UIStroke", auth).Color = Color3.fromRGB(255, 105, 180)

local kInp = Instance.new("TextBox", auth)
kInp.Size = UDim2.new(0, 280, 0, 45); kInp.Position = UDim2.new(0.5, -140, 0.3, 0); kInp.PlaceholderText = "Nhập Key từ Discord..."; kInp.BackgroundColor3 = Color3.fromRGB(30, 30, 30); kInp.TextColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", kInp)

local kSub = Instance.new("TextButton", auth)
kSub.Size = UDim2.new(0, 140, 0, 40); kSub.Position = UDim2.new(0.5, -70, 0.7, 0); kSub.Text = "XÁC NHẬN"; kSub.BackgroundColor3 = Color3.fromRGB(255, 105, 180); kSub.TextColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", kSub)

-- --- [2] HUB CHÍNH (THIẾT KẾ CHỐNG LỖI HIỂN THỊ) ---
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 260, 0, 500); main.Position = UDim2.new(0.5, -130, 0.1, 0); main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); main.Visible = false; main.Active = true; main.Draggable = true; main.ZIndex = 10
Instance.new("UICorner", main); Instance.new("UIStroke", main).Color = Color3.fromRGB(255, 105, 180)

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, -20, 1, -60); scroll.Position = UDim2.new(0, 10, 0, 50); scroll.BackgroundTransparency = 1; scroll.CanvasSize = UDim2.new(0, 0, 1.5, 0); scroll.ZIndex = 11

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 8); layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Hàm tạo nút bấm an toàn (tránh lỗi UI trống)
local function createBtn(txt, color)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(1, 0, 0, 38); b.BackgroundColor3 = color or Color3.fromRGB(35, 35, 40); b.Text = txt; b.TextColor3 = Color3.fromRGB(255, 255, 255); b.Font = Enum.Font.SourceSansBold; b.ZIndex = 12
    Instance.new("UICorner", b); return b
end

-- Khởi tạo các thành phần bên trong Hub
local anti = createBtn("1. Anti AFK: ON ✅", Color3.fromRGB(30, 90, 30))
local pot = createBtn("2. Đồ họa: POTATO ❌", Color3.fromRGB(90, 30, 30))
local wsBtn = createBtn("3. White Screen: OFF 🔋")
local jobBtn = createBtn("4. Copy JobID Server 📋")
local stats = Instance.new("TextLabel", scroll); stats.Size = UDim2.new(1, 0, 0, 100); stats.BackgroundTransparency = 1; stats.TextColor3 = Color3.fromRGB(255, 255, 255); stats.TextXAlignment = Enum.TextXAlignment.Left; stats.Font = Enum.Font.SourceSansBold; stats.ZIndex = 12

-- --- [3] HỆ THỐNG ĐO FPS/PING CHUẨN XÁC ---
local lastUpdate = os.clock(); local frameCount = 0; local actualFPS = 0
RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    if os.clock() - lastUpdate >= 1 then
        actualFPS = frameCount; frameCount = 0; lastUpdate = os.clock()
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if main.Visible then
            local ping = math.floor(LocalPlayer:GetNetworkPing() * 1000)
            stats.Text = string.format("Tên: %s\nFPS: %d\nPing: %d ms\nGiờ: %s\n--- TIỆN ÍCH ---", 
                LocalPlayer.Name, actualFPS, ping, os.date("%H:%M:%S"))
        end
    end
end)

-- --- [4] LOGIC VẬN HÀNH ---
kSub.MouseButton1Click:Connect(function()
    if kInp.Text == CORRECT_KEY then
        auth:Destroy()
        task.wait(0.1) -- Đợi UI ổn định
        main.Visible = true
    else
        kInp.Text = ""; kInp.PlaceholderText = "SAI KEY RỒI!"
    end
end)

local pActive = false
pot.MouseButton1Click:Connect(function()
    pActive = not pActive
    pot.Text = pActive and "2. Đồ họa: POTATO ✅" or "2. Đồ họa: BÌNH THƯỜNG ❌"
    pot.BackgroundColor3 = pActive and Color3.fromRGB(20, 90, 20) or Color3.fromRGB(90, 20, 20)
    Lighting.GlobalShadows = not pActive
    for _, v in pairs(game:GetDescendants()) do
        if pActive and v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic v.CastShadow = false end
    end
end)

local wsF = Instance.new("Frame", sg); wsF.Size = UDim2.new(1,0,1,0); wsF.BackgroundColor3 = Color3.fromRGB(255,255,255); wsF.Visible = false; wsF.ZIndex = 1
wsBtn.MouseButton1Click:Connect(function()
    wsF.Visible = not wsF.Visible
    wsBtn.Text = wsF.Visible and "3. White Screen: ON ✅" or "3. White Screen: OFF 🔋"
    RunService:Set3dRenderingEnabled(not wsF.Visible)
end)

jobBtn.MouseButton1Click:Connect(function() setclipboard(tostring(game.JobId)) end)

-- Anti AFK chuẩn
LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)