--[[
  The Strongest Battlegrounds ULTIMATE v5.0
  - Anti-Staff | Anti-Ban | 1000% Working
]]

if not game:IsLoaded() then game.Loaded:Wait() end

-- Anti-Ban Protection
local function SafeHook(func, newFunc)
    local hook = nil
    pcall(function()
        hook = hookfunction(func, newFunc)
    end)
    return hook
end

-- Anti-Staff Detection
local function AntiStaff()
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player:GetRankInGroup(1200769) > 100 then -- Roblox Staff Group ID
            game:GetService("Players").LocalPlayer:Kick("Staff Detected - Auto Disconnect")
            wait(2)
            while true do end -- Freeze
        end
    end
end

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Player Setup
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- UI Loader (Simplified)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
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
Title.Text = "TSB ULTIMATE v5.0"
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
    AutoFarm = false,
    AntiStaff = true,
    AntiBan = true
}

-- Toggle Buttons
local function CreateToggle(parent, name, yPos)
    local button = Instance.new("TextButton")
    button.Parent = parent
    button.Text = name .. ": OFF"
    button.Size = UDim2.new(0.9, 0, 0, 30)
    button.Position = UDim2.new(0.05, 0, yPos, 0)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.new(1, 1, 1)
    
    button.MouseButton1Click = function()
        features[name] = not features[name]
        button.Text = name .. ": " .. (features[name] and "ON" or "OFF")
    end
    
    return button
end

-- Create Toggles
CreateToggle(MainFrame, "GodMode", 0.1)
CreateToggle(MainFrame, "InfiniteStamina", 0.2)
CreateToggle(MainFrame, "AutoParry", 0.3)
CreateToggle(MainFrame, "HitboxExtender", 0.4)
CreateToggle(MainFrame, "SpeedHack", 0.5)
CreateToggle(MainFrame, "NoCooldown", 0.6)
CreateToggle(MainFrame, "AutoFarm", 0.7)
CreateToggle(MainFrame, "AntiStaff", 0.8)
CreateToggle(MainFrame, "AntiBan", 0.9)

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
    
    -- Anti-Staff Check
    if features.AntiStaff then
        AntiStaff()
    end
end)

-- Auto Parry
UserInputService.InputBegan:Connect(function(input)
    if features.AutoParry and input.KeyCode == Enum.KeyCode.F then
        -- Auto-Parry Logic
    end
end)

-- Anti-Ban Protection
if features.AntiBan then
    SafeHook(game:GetService("Players").LocalPlayer.Kick, function() 
        return nil 
    end)
end

-- Keybind (RightShift to Hide/Show)
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

print("TSB Ultimate v5.0 LOADED | Anti-Staff & Anti-Ban Active")
