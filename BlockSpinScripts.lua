-- BlockSpin Aimbot, Auto Work, and ESP Script

-- Configuration
local targetDistance = math.huge -- Maximum distance to detect enemies
local aimSpeed = 0.016 -- Aim speed adjustment
local keybindAimbot = Enum.KeyCode.E -- Key to toggle aimbot on/off
local keybindAutoWork = Enum.KeyCode.R -- Key to toggle auto work on/off
local espEnabled = true -- Toggle ESP on/off

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
game.Players.LocalPlayer:GetMouse().KeyDown:Connect(function(key)
    if key == keybindAimbot then
        aimbotEnabled = not aimbotEnabled
    elseif key == keybindAutoWork then
        autoWork()
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
    if espEnabled then
        enableESP()
    end
    wait()
end
