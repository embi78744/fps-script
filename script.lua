local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

-- Cài đặt Key
local KEY_CONFIG = {
    CorrectKey = "NGUOITINH-2026",
    Discord = "https://discord.gg/sh5ontop"
}

-- Xóa UI cũ để tránh chồng chéo lỗi
for _, v in pairs(game.CoreGui:GetChildren()) do
    if v.Name == "NGUOITINH_V43" then v:Destroy() end
end

local sg = Instance.new("ScreenGui", game.CoreGui)
sg.Name = "NGUOITINH_V43"
sg.ZIndexBehavior = Enum.ZIndexBehavior.Global

-- --- [1] KHUNG XÁC THỰC (Bền bỉ) ---
local auth = Instance.new("Frame", sg)
auth.Size = UDim2.new(0, 340, 0, 180); auth.Position = UDim2.new(0.5, -170, 0.4, 0)
auth.BackgroundColor3 = Color3.fromRGB(15, 15, 15); auth.ZIndex = 100
Instance.new("UICorner", auth); Instance.new("UIStroke", auth).Color = Color3.fromRGB(255, 105, 180)

local kInp = Instance.new("TextBox", auth)
kInp.Size = UDim2.new(0, 260, 0, 40); kInp.Position = UDim2.new(0.5, -130, 0.3, 0); kInp.PlaceholderText = "Nhập Key..."; kInp.BackgroundColor3 = Color3.fromRGB(30, 30, 30); kInp.TextColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", kInp)

local kSub = Instance.new("TextButton", auth)
kSub.Size = UDim2.new(0, 120, 0, 35); kSub.Position = UDim2.new(0.5, -60, 0.7, 0); kSub.Text = "XÁC NHẬN"; kSub.BackgroundColor3 = Color3.fromRGB(255, 105, 180); kSub.TextColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", kSub)

-- --- [2] MAIN HUB (Cơ chế tự phục hồi) ---
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 250, 0, 500); main.Position = UDim2.new(0.5, -125, 0.1, 0)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); main.Visible = false; main.Active = true; main.Draggable = true; main.ZIndex = 10
Instance.new("UICorner", main); Instance.new("UIStroke", main).Color = Color3.fromRGB(255, 105, 180)

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, -20, 1, -60); scroll.Position = UDim2.new(0, 10, 0, 50)
scroll.BackgroundTransparency = 1; scroll.CanvasSize = UDim2.new(0, 0, 2, 0); scroll.ZIndex = 11
local layout = Instance.new("UIListLayout", scroll); layout.Padding = UDim.new(0, 7)

local function buildUI()
    local function createBtn(t, c)
        local b = Instance.new("TextButton", scroll)
        b.Size = UDim2.new(1, 0, 0, 36); b.BackgroundColor3 = c or Color3.fromRGB(40, 40, 45)
        b.Text = t; b.TextColor3 = Color3.fromRGB(255, 255, 255); b.Font = Enum.Font.SourceSansBold; b.ZIndex = 12
        Instance.new("UICorner", b); return b
    end

    local antiAfk = createBtn("1. Anti AFK: ON ✅", Color3.fromRGB(30, 80, 30))
    local potato = createBtn("2. Đồ họa: POTATO ❌", Color3.fromRGB(80, 30, 30))
    local ws = createBtn("3. White Screen: OFF 🔋")
    local info = Instance.new("TextLabel", scroll)
    info.Size = UDim2.new(1, 0, 0, 100); info.BackgroundTransparency = 1; info.TextColor3 = Color3.fromRGB(255, 255, 255); info.Font = Enum.Font.SourceSansBold; info.ZIndex = 12

    -- Đo FPS chuẩn xác (Fix lỗi số ảo)
    local lastT = os.clock(); local frames = 0; local fps = 0
    RunService.RenderStepped:Connect(function()
        frames = frames + 1
        if os.clock() - lastT >= 1 then fps = frames; frames = 0; lastT = os.clock() end
        if main.Visible then
            info.Text = string.format("FPS: %d\nPing: %d ms\nGiờ: %s", fps, math.floor(LocalPlayer:GetNetworkPing()*1000), os.date("%X"))
        end
    end)
    
    -- Potato Mode
    potato.MouseButton1Click:Connect(function()
        local on = not potato.Text:find("✅")
        potato.Text = on and "2. Đồ họa: POTATO ✅" or "2. Đồ họa: BÌNH THƯỜNG ❌"
        potato.BackgroundColor3 = on and Color3.fromRGB(20, 70, 20) or Color3.fromRGB(80, 20, 20)
        Lighting.GlobalShadows = not on
        for _, v in pairs(game:GetDescendants()) do
            if on and v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic v.CastShadow = false end
        end
    end)
end

-- --- [3] KÍCH HOẠT ---
kSub.MouseButton1Click:Connect(function()
    if kInp.Text == KEY_CONFIG.CorrectKey then
        auth:Destroy()
        buildUI()
        task.wait(0.2)
        main.Visible = true
    else
        kInp.PlaceholderText = "SAI KEY!"
        kInp.Text = ""
    end
end)