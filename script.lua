local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")

ScreenGui.Parent = game.CoreGui

-- Frame (nền đen)
Frame.Parent = ScreenGui
Frame.Position = UDim2.new(0.5, -150, 0, 10)
Frame.Size = UDim2.new(0, 300, 0, 50)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 2
Frame.BorderColor3 = Color3.fromRGB(255, 255, 0)

-- Bo góc
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Frame

-- Text
TextLabel.Parent = Frame
TextLabel.Size = UDim2.new(1, 0, 1, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
TextLabel.TextStrokeTransparency = 0
TextLabel.Font = Enum.Font.SourceSansBold
TextLabel.TextScaled = true

-- FPS
local last = tick()
local fps = 0

game:GetService("RunService").RenderStepped:Connect(function()
    local now = tick()
    fps = math.floor(1 / (now - last))
    last = now
end)

-- Ping thật (nếu lấy được)
local Stats = game:GetService("Stats")

while true do
    task.wait(0.5)

    local ping = "N/A"

    pcall(function()
        local network = Stats:FindFirstChild("Network")
        if network then
            local server = network:FindFirstChild("ServerStatsItem")
            if server then
                for _, v in pairs(server:GetChildren()) do
                    if string.find(v.Name, "Ping") then
                        ping = math.floor(v:GetValue())
                    end
                end
            end
        end
    end)

    TextLabel.Text = "FPS: "..fps.." | Ping: "..ping.." ms | discord.gg/yourserver"
end