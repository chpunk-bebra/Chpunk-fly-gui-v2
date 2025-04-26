-- Chpunk Fly GUI v1 by ChatGPT

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local flying = false
local speed = 50

-- Создание GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChpunkFlyGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 150)
frame.Position = UDim2.new(0.5, -125, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
title.Text = "Chpunk Fly GUI v1"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255, 0, 0)
title.TextScaled = true
title.Parent = frame

local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0.8, 0, 0, 30)
flyButton.Position = UDim2.new(0.1, 0, 0, 40)
flyButton.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
flyButton.Text = "Fly: OFF"
flyButton.Font = Enum.Font.Gotham
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.TextScaled = true
flyButton.Parent = frame

local plusButton = Instance.new("TextButton")
plusButton.Size = UDim2.new(0.35, 0, 0, 30)
plusButton.Position = UDim2.new(0.1, 0, 0, 80)
plusButton.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
plusButton.Text = "+"
plusButton.Font = Enum.Font.Gotham
plusButton.TextColor3 = Color3.fromRGB(255, 255, 255)
plusButton.TextScaled = true
plusButton.Parent = frame

local minusButton = Instance.new("TextButton")
minusButton.Size = UDim2.new(0.35, 0, 0, 30)
minusButton.Position = UDim2.new(0.55, 0, 0, 80)
minusButton.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
minusButton.Text = "-"
minusButton.Font = Enum.Font.Gotham
minusButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minusButton.TextScaled = true
minusButton.Parent = frame

local function updateFly()
    if flying then
        flyButton.Text = "Fly: ON"
    else
        flyButton.Text = "Fly: OFF"
    end
end

flyButton.MouseButton1Click:Connect(function()
    flying = not flying
    updateFly()
end)

plusButton.MouseButton1Click:Connect(function()
    speed = speed + 5
end)

minusButton.MouseButton1Click:Connect(function()
    speed = math.max(5, speed - 5)
end)

RunService.RenderStepped:Connect(function()
    if flying then
        if character and humanoidRootPart then
            humanoidRootPart.Velocity = Vector3.new(0,0,0)
            local moveVector = Vector3.zero
            if UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1)[1] then
                moveVector = UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1)[1].Position
            else
                moveVector = Vector3.new(
                    (UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.A) and 1 or 0),
                    (UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and 1 or 0),
                    (UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0)
                )
            end

            local camCF = workspace.CurrentCamera.CFrame
            local direction = (camCF.RightVector * moveVector.X + camCF.UpVector * moveVector.Y + camCF.LookVector * -moveVector.Z)
            humanoidRootPart.Velocity = direction * speed
            humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position, humanoidRootPart.Position + camCF.LookVector)
        end
    end
end)
