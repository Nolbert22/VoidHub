-- BlockSpin Menu Scripts

-- Configuration
local targetDistance = math.huge -- Maximum distance to detect enemies
local aimSpeed = 0.016 -- Aim speed adjustment

-- Create a simple GUI for the menu
local screenGui = Instance.new("ScreenGui")
local mainFrame = Instance.new("Frame")
local titleLabel = Instance.new("TextLabel")
local aimbotButton = Instance.new("TextButton")
local autoWorkButton = Instance.new("TextButton")
local espButton = Instance.new("TextButton")

screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
mainFrame.Size = UDim2.new(0, 200, 0, 150)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
mainFrame.BorderSizePixel = 2
mainFrame.Parent = screenGui

titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.new(0, 0, 0)
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Text = "BlockSpin Menu"
titleLabel.TextScaled = true
titleLabel.Parent = mainFrame

aimbotButton.Size = UDim2.new(1, 0, 0, 50)
aimbotButton.Position = UDim2.new(0, 0, 0, 50)
aimbotButton.BackgroundColor3 = Color3.new(0, 0, 0)
aimbotButton.TextColor3 = Color3.new(1, 1, 1)
aimbotButton.Text = "Aimbot"
aimbotButton.TextScaled = true
aimbotButton.Parent = mainFrame

autoWorkButton.Size = UDim2.new(1, 0, 0, 50)
autoWorkButton.Position = UDim2.new(0, 0, 0, 100)
autoWorkButton.BackgroundColor3 = Color3.new(0, 0, 0)
autoWorkButton.TextColor3 = Color3.new(1, 1, 1)
autoWorkButton.Text = "Auto Work"
autoWorkButton.TextScaled = true
autoWorkButton.Parent = mainFrame

espButton.Size = UDim2.new(1, 0, 0, 50)
espButton.Position = UDim2.new(0, 0, 0, 150)
espButton.BackgroundColor3 = Color3.new(0, 0, 0)
espButton.TextColor3 = Color3.new(1, 1, 1)
espButton.Text = "ESP"
espButton.TextScaled = true
espButton.Parent = mainFrame

-- Aimbot Functions
local function findClosestEnemy()
    local closestEnemy = nil
    local shortestDistance = math.huge

    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance and distance <= targetDistance then
                shortestDistance = distance
                closestEnemy = player
            end
        end
    end

    return closestEnemy
end

local function aimAtEnemy(enemy)
    if enemy and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
        local targetPosition = enemy.Character.HumanoidRootPart.Position
        local mouse = game.Players.LocalPlayer:GetMouse()
        mouse.Hit = targetPosition
        game.Players.LocalPlayer.Character.Humanoid:MoveTo(targetPosition)
        wait(aimSpeed)
    end
end

-- Auto Work Functions
local function autoWork()
    while true do
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid:MoveTo(game.Players.LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0))
            wait(0.1)
        end
        wait()
    end
end

-- ESP Functions
local function drawESP(player)
    local screenPoint, onScreen = workspace.CurrentCamera:WorldToScreenPoint(player.Character.HumanoidRootPart.Position)
    if onScreen then
        draw.Text(screenPoint.X, screenPoint.Y - 25, player.Name, 14, Color3.new(1, 0, 0))
    end
end

local function enableESP()
    game:GetService("RunService").RenderStepped:Connect(function()
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                drawESP(player)
            end
        end
    end)
end

-- Toggle aimbot on/off
local aimbotEnabled = false
aimbotButton.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
end)

-- Toggle auto work on/off
autoWorkButton.MouseButton1Click:Connect(function()
    autoWork()
end)

-- Toggle ESP on/off
local espEnabled = false
espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        enableESP()
    else
        game:GetService("RunService").RenderStepped:Disconnect()
    end
end)

-- Main aimbot loop
while true do
    if aimbotEnabled then
        local enemy = findClosestEnemy()
        if enemy then
            aimAtEnemy(enemy)
        end
    end
    wait()
end
