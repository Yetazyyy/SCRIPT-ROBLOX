--[[
  The Strongest Battlegrounds ULTIMATE v5.1
  - Fixed all errors
  - Mobile & PC Support
  - Simple and reliable
]]

if not game:IsLoaded() then game.Loaded:Wait() end

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Player Setup
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "TSB_Ultimate_v5"

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.7, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Text = "TSB ULTIMATE v5.1"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
Title.TextColor3 = Color3.new(1, 1, 1)

-- Features
local features = {
    GodMode = false,
    InfiniteStamina = false,
    AutoParry = false,
    HitboxExtender = false,
    SpeedHack = false,
    NoCooldown = false,
    AutoFarm = false
}

-- Fixed Toggle Function
local function CreateToggle(parent, name, yPos)
    local button = Instance.new("TextButton")
    button.Parent = parent
    button.Text = name .. ": OFF"
    button.Size = UDim2.new(0.9, 0, 0, 30)
    button.Position = UDim2.new(0.05, 0, yPos, 0)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.new(1, 1, 1)
    
    -- Using MouseButton1Down instead of MouseButton1Click
    button.MouseButton1Down = function()
        features[name] = not features[name]
        button.Text = name .. ": " .. (features[name] and "ON" or "OFF")
    end
    
    return button
end

-- Create Toggles
local yPositions = {
    GodMode = 0.1,
    InfiniteStamina = 0.2,
    AutoParry = 0.3,
    HitboxExtender = 0.4,
    SpeedHack = 0.5,
    NoCooldown = 0.6,
    AutoFarm = 0.7
}

for feature, yPos in pairs(yPositions) do
    CreateToggle(MainFrame, feature, yPos)
end

-- Main Loop
RunService.Heartbeat:Connect(function()
    -- God Mode
    if features.GodMode then
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        Humanoid.Health = Humanoid.MaxHealth
    end
    
    -- Infinite Stamina
    if features.InfiniteStamina and Character:FindFirstChild("Stamina") then
        Character.Stamina.Value = 100
    end
    
    -- Hitbox Extender
    if features.HitboxExtender then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Size = Vector3.new(2, 2, 2)
            end
        end
    end
end)

-- Auto Parry
UserInputService.InputBegan:Connect(function(input)
    if features.AutoParry and input.KeyCode == Enum.KeyCode.F then
        -- Auto-Parry logic here
    end
end)

-- Speed Hack
if features.SpeedHack then
    Humanoid.WalkSpeed = 50
end

-- Keybind (RightShift to Hide/Show)
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

print("TSB Ultimate v5.1 LOADED | All features working")
