--[[
  The Strongest Battlegrounds Ultimate Script
  - Fixed 404 Error
  - Works on Public/Private Servers
  - Mobile & PC Support
  - YetazyHub UI with fallback
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

-- =============================================
-- FIXED UI LOADER WITH FALLBACK
-- =============================================
local UI
local success, err = pcall(function()
    -- Try main source first
    UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    
    if not UI then
        -- Fallback 1
        UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Vcsk/RobloxScripts/main/Universal/BracketV3.lua"))()
    end
end)

if not success then
    -- Simple fallback UI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.CoreGui
    
    local Frame = Instance.new("Frame")
    Frame.Parent = ScreenGui
    Frame.Size = UDim2.new(0, 300, 0, 400)
    Frame.Position = UDim2.new(0.7, 0, 0.2, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.Active = true
    Frame.Draggable = true
    
    UI = {
        CreateWindow = function(options)
            local Title = Instance.new("TextLabel")
            Title.Parent = Frame
            Title.Text = options.Title or "TSB Script"
            Title.Size = UDim2.new(1, 0, 0, 30)
            Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            
            return {
                CreateTab = function(tabName)
                    local tabY = 40
                    for _,child in pairs(Frame:GetChildren()) do
                        if child:IsA("TextButton") then
                            tabY = tabY + 35
                        end
                    end
                    
                    local TabButton = Instance.new("TextButton")
                    TabButton.Parent = Frame
                    TabButton.Text = tabName
                    TabButton.Position = UDim2.new(0, 10, 0, tabY)
                    TabButton.Size = UDim2.new(0, 80, 0, 30)
                    
                    local TabFrame = Instance.new("Frame")
                    TabFrame.Parent = Frame
                    TabFrame.Size = UDim2.new(1, -20, 1, -tabY - 10)
                    TabFrame.Position = UDim2.new(0, 10, 0, tabY + 35)
                    TabFrame.BackgroundTransparency = 1
                    TabFrame.Visible = false
                    
                    TabButton.MouseButton1Click = function()
                        for _,child in pairs(Frame:GetChildren()) do
                            if child:IsA("Frame") and child ~= Title then
                                child.Visible = false
                            end
                        end
                        TabFrame.Visible = true
                    end
                    
                    return {
                        AddToggle = function(self, id, options)
                            local toggle = Instance.new("TextButton")
                            toggle.Parent = TabFrame
                            toggle.Text = options.Title..": OFF"
                            toggle.Size = UDim2.new(1, 0, 0, 30)
                            toggle.Position = UDim2.new(0, 0, 0, #TabFrame:GetChildren() * 35)
                            
                            local state = false
                            toggle.MouseButton1Click = function()
                                state = not state
                                toggle.Text = options.Title..": "..(state and "ON" or "OFF")
                                if options.Callback then
                                    options.Callback(state)
                                end
                            end
                        end,
                        
                        AddSlider = function(self, id, options)
                            -- Slider implementation
                        end
                    }
                end
            }
        end
    }
    
    -- Show first tab by default
    spawn(function()
        wait(0.5)
        for _,child in pairs(Frame:GetChildren()) do
            if child:IsA("TextButton") then
                child:MouseButton1Click()
                break
            end
        end
    end)
end

-- =============================================
-- MAIN SCRIPT FEATURES
-- =============================================
local Window = UI:CreateWindow({
    Title = "TSB Ultimate",
    SubTitle = "v2.1 Fixed",
    Key = Enum.KeyCode.RightShift
})

-- Remote Detection
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
            Humanoid.Health = Humanoid.MaxHealth
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

-- Credits
Window:CreateTab("Info"):AddLabel("Script Fixed by YetazyHub")
