--[[
    🌸 NGUOITINHMUADONG - V41 OMNI-CORRECTION
    - FIX TRIỆT ĐỂ: Lỗi đen màn hình & Lỗi RenderService.
    - FIX TRIỆT ĐỂ: FPS ảo (Precision Measurement).
    - CƠ CHẾ: Auto-Recovery (Tự phục hồi nếu UI lỗi).
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

-- [CÀI ĐẶT HỆ THỐNG KEY]
local KEY_DATA = {
    Key = "NGUOITINH-2026",
    Link = "https://discord.gg/sh5ontop"
}

-- Dọn dẹp bản cũ
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v.Name == "NGUOITINH_V41" then v:Destroy() end
end

local sg = Instance.new("ScreenGui", game.CoreGui)
sg.Name = "NGUOITINH_V41"
sg.ZIndexBehavior = Enum.ZIndexBehavior.Global

-- --- [1] GIAO DIỆN XÁC THỰC (BỀN BỈ) ---
local auth = Instance.new("Frame", sg)
auth.Size = UDim2.new(0, 350, 0, 200); auth.Position = UDim2.new(0.5, -175, 0.4, 0)
auth.BackgroundColor3 = Color3.fromRGB(15, 15, 15); auth.ZIndex = 100
Instance.new("UICorner", auth); Instance.new("UIStroke", auth).Color = Color3.fromRGB(255, 105, 180)

local input = Instance.new("TextBox", auth)
input.Size = UDim2.new(0, 280, 0, 45); input.Position = UDim2.new(0.5, -140, 0.3, 0); input.PlaceholderText = "Nhập Key Discord..."; input.BackgroundColor3 = Color3.fromRGB(30, 30, 30); input.TextColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", input)

local sub = Instance.new("TextButton", auth)
sub.Size = UDim2.new(0, 140, 0, 40); sub.Position = UDim2.new(0.5, -70, 0.7, 0); sub.Text = "XÁC NHẬN"; sub.BackgroundColor3 = Color3.fromRGB(255, 105, 180); sub.TextColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", sub)

-- --- [2] HUB CHÍNH & CƠ CHẾ CHỐNG ĐEN MÀN HÌNH ---
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 260, 0, 520); main.Position = UDim2.new(0.5, -130, 0.1, 0); main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); main.Visible = false; main.Active = true; main.Draggable = true; main.ZIndex = 10
Instance.new("UICorner", main); Instance.new("UIStroke", main).Color = Color3.fromRGB(255, 105, 180)

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, -20, 1, -60); scroll.Position = UDim2.new(0, 10, 0, 50); scroll.BackgroundTransparency = 1; scroll.CanvasSize = UDim2.new(0, 0, 2, 0); scroll.ZIndex = 11

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 8); layout.SortOrder = Enum.SortOrder.LayoutOrder

local function addBtn(name, color)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(1, 0, 0, 38); b.BackgroundColor3 = color or Color3.fromRGB(35, 35, 40); b.Text = name; b.TextColor3 = Color3.fromRGB(255, 255, 255); b.Font = Enum.Font.SourceSansBold; b.ZIndex = 12
    Instance.new("UICorner", b); return b
end

-- Khởi tạo nội dung (Tách riêng để có thể gọi lại nếu lỗi)
local function PopulateHub()
    scroll:ClearAllChildren()
    Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 8)
    
    local anti = addBtn("1. Anti AFK: ON ✅", Color3.fromRGB(30, 90, 30))
    local pot = addBtn("2. Đồ họa: POTATO ❌", Color3.fromRGB(90, 30, 30))
    local ws = addBtn("3. White Screen: OFF 🔋")
    local job = addBtn("4. Copy JobID Server 📋")
    local info = Instance.new("TextLabel", scroll); info.Size = UDim2.new(1, 0, 0, 100); info.BackgroundTransparency = 1; info.TextColor3 = Color3.fromRGB(255, 255, 255); info.TextXAlignment = Enum.TextXAlignment.Left; info.Font = Enum.Font.SourceSansBold; info.ZIndex = 12
    
    -- Logic đo thông số chuẩn
    local lastTime = os.clock(); local frames = 0; local fps = 0
    RunService.Heartbeat:Connect(function()
        frames = frames + 1
        if os.clock() - lastTime >= 1 then
            fps = frames; frames = 0; lastTime = os.clock()
        end
        if main.Visible then
            local ping = math.floor(LocalPlayer:GetNetworkPing() * 1000)
            info.Text = string.format("Tên: %s\nFPS: %d\nPing: %d ms\nGiờ: %s\n--- TIỆN ÍCH ---", LocalPlayer.Name, fps, ping, os.date("%H:%M:%S"))
        end
    end)

    -- Sự kiện các nút
    pot.MouseButton1Click:Connect(function()
        local active = (pot.Text:find("❌") ~= nil)
        pot.Text = active and "2. Đồ họa: POTATO ✅" or "2. Đồ họa: BÌNH THƯỜNG ❌"
        pot.BackgroundColor3 = active and Color3.fromRGB(20, 90, 20) or Color3.fromRGB(90, 20, 20)
        Lighting.GlobalShadows = not active
        for _, v in pairs(game:GetDescendants()) do
            if active and v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic v.CastShadow = false
            elseif not active and v:IsA("BasePart") then v.Material = Enum.Material.Plastic v.CastShadow = true end
        end
    end)

    local whiteF = Instance.new("Frame", sg); whiteF.Size = UDim2.new(1,0,1,0); whiteF.BackgroundColor3 = Color3.fromRGB(255,255,255); whiteF.Visible = false; whiteF.ZIndex = 1
    ws.MouseButton1Click:Connect(function()
        whiteF.Visible = not whiteF.Visible
        ws.Text = whiteF.Visible and "3. White Screen: ON ✅" or "3. White Screen: OFF 🔋"
        RunService:Set3dRenderingEnabled(not whiteF.Visible)
    end)

    job.MouseButton1Click:Connect(function() setclipboard(tostring(game.JobId)) end)
end

-- Kiểm tra và kích hoạt Hub
sub.MouseButton1Click:Connect(function()
    if input.Text == KEY_DATA.Key then
        auth:Destroy()
        PopulateHub()
        main.Visible = true
        -- Chống đen màn hình: Nếu sau 1 giây không có nút nào, nạp lại lần nữa
        task.delay(1, function() if #scroll:GetChildren() < 2 then PopulateHub() end end)
    else
        input.Text = ""; input.PlaceholderText = "SAI KEY RỒI!"
    end
end)

-- Anti AFK chuẩn
LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)