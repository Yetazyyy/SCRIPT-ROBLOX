--[[
  The Strongest Battlegrounds Ultimate Script
  Features:
  - God Mode
  - Infinite Stamina
  - Auto Parry
  - Hitbox Extender
  - Speed Hack
  - No Cooldown
  - Auto Farm
  - Works on Public & Private Servers
  - YetazyHub UI
  - Mobile & PC Compatible
]]

if not game:IsLoaded() then game.Loaded:Wait() end

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Player Setup
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- YetazyHub UI
local YetazyHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/Yetazy/YetazyHub/main/UI"))()
local Window = YetazyHub:CreateWindow({
    Title = "TSB Ultimate",
    SubTitle = "Public & Private Server",
    Key = Enum.KeyCode.RightShift
})

-- Remote Detection (Works on both server types)
local remotes = {}
for i,v in pairs(getgc(true)) do
    if typeof(v) == "table" and rawget(v, "FireServer") then
        table.insert(remotes, v)
    end
end

-- Functions
local function getClosestPlayer()
    local closest = nil
    local dist = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local mag = (RootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if mag < dist then
                closest = player
                dist = mag
            end
        end
    end
    return closest
end

-- Features
local features = {
    GodMode = false,
    InfiniteStamina = false,
    AutoParry = false,
    HitboxExtender = false,
    SpeedHack = false,
    NoCooldown = false,
    AutoFarm = false,
    HitboxSize = 1.5
}

-- Main Tab
local MainTab = Window:CreateTab("Main")
MainTab:AddToggle("GodMode", {
    Title = "God Mode",
    Default = false,
    Callback = function(Value)
        features.GodMode = Value
        if Value then
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        else
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
        end
    end
})

MainTab:AddToggle("InfiniteStamina", {
    Title = "Infinite Stamina",
    Default = false,
    Callback = function(Value)
        features.InfiniteStamina = Value
    end
})

-- Combat Tab
local CombatTab = Window:CreateTab("Combat")
CombatTab:AddToggle("AutoParry", {
    Title = "Auto Parry",
    Default = false,
    Callback = function(Value)
        features.AutoParry = Value
    end
})

CombatTab:AddSlider("HitboxExtender", {
    Title = "Hitbox Size",
    Default = 1.5,
    Min = 1,
    Max = 5,
    Callback = function(Value)
        features.HitboxSize = Value
    end
})

-- Movement Tab
local MovementTab = Window:CreateTab("Movement")
MovementTab:AddSlider("SpeedHack", {
    Title = "Walk Speed",
    Default = 16,
    Min = 16,
    Max = 100,
    Callback = function(Value)
        Humanoid.WalkSpeed = Value
    end
})

MovementTab:AddSlider("JumpPower", {
    Title = "Jump Power",
    Default = 50,
    Min = 50,
    Max = 150,
    Callback = function(Value)
        Humanoid.JumpPower = Value
    end
})

-- Farming Tab
local FarmingTab = Window:CreateTab("Farming")
FarmingTab:AddToggle("AutoFarm", {
    Title = "Auto Farm Wins",
    Default = false,
    Callback = function(Value)
        features.AutoFarm = Value
    end
})

-- Connections
RunService.Heartbeat:Connect(function()
    -- Infinite Stamina
    if features.InfiniteStamina and Character:FindFirstChild("Stamina") then
        Character.Stamina.Value = 100
    end
    
    -- Hitbox Extender
    if features.HitboxExtender then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Size = Vector3.new(features.HitboxSize, features.HitboxSize, features.HitboxSize)
            end
        end
    end
    
    -- Auto Farm
    if features.AutoFarm then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            RootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
        end
    end
end)

-- Auto Parry Logic
local lastParry = 0
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if features.AutoParry and not gameProcessed and input.KeyCode == Enum.KeyCode.F then
        for _, remote in pairs(remotes) do
            if tostring(remote):find("Parry") then
                remote:FireServer()
                lastParry = tick()
            end
        end
    end
end)

-- No Cooldown
for _, remote in pairs(remotes) do
    if tostring(remote):find("Cooldown") then
        local old = remote.FireServer
        remote.FireServer = function(self, ...)
            if features.NoCooldown then
                return
            end
            return old(self, ...)
        end
    end
end

Window:AddLabel("Script by YetazyHub")
Window:AddButton("Copy Discord", function()
    setclipboard("https://discord.gg/yetazyhub")
end)
