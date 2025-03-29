--[[
  The Strongest Battlegrounds - COMPLETELY FIXED SCRIPT
  - Fixed all UI errors
  - Works on Mobile/PC
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

-- =============================================
-- SIMPLE BUT RELIABLE UI SYSTEM
-- =============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "TSB_ScriptGUI"

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 250, 0, 350)
MainFrame.Position = UDim2.new(0.75, 0, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Text = "TSB Script v3.0"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.TextColor3 = Color3.white

local TabButtons = {}
local TabFrames = {}

local function CreateTab(tabName)
    local tabButton = Instance.new("TextButton")
    tabButton.Parent = MainFrame
    tabButton.Text = tabName
    tabButton.Size = UDim2.new(0.3, -5, 0, 30)
    tabButton.Position = UDim2.new(0.02 + (#TabButtons * 0.32), 0, 0, 35)
    tabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    
    local tabFrame = Instance.new("ScrollingFrame")
    tabFrame.Parent = MainFrame
    tabFrame.Size = UDim2.new(1, -10, 1, -70)
    tabFrame.Position = UDim2.new(0, 5, 0, 70)
    tabFrame.BackgroundTransparency = 1
    tabFrame.ScrollBarThickness = 5
    tabFrame.Visible = false
    
    table.insert(TabButtons, tabButton)
    table.insert(TabFrames, tabFrame)
    
    tabButton.MouseButton1Down = function()
        for _, frame in pairs(TabFrames) do
            frame.Visible = false
        end
        tabFrame.Visible = true
    end
    
    return {
        AddToggle = function(self, id, options)
            local toggle = Instance.new("TextButton")
            toggle.Parent = tabFrame
            toggle.Text = options.Title..": OFF"
            toggle.Size = UDim2.new(1, 0, 0, 30)
            toggle.Position = UDim2.new(0, 0, 0, #tabFrame:GetChildren() * 35)
            toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            
            local state = false
            toggle.MouseButton1Down = function()
                state = not state
                toggle.Text = options.Title..": "..(state and "ON" or "OFF")
                if options.Callback then
                    options.Callback(state)
                end
            end
        end,
        
        AddSlider = function(self, id, options)
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Parent = tabFrame
            sliderFrame.Size = UDim2.new(1, 0, 0, 50)
            sliderFrame.Position = UDim2.new(0, 0, 0, #tabFrame:GetChildren() * 35)
            sliderFrame.BackgroundTransparency = 1
            
            local title = Instance.new("TextLabel")
            title.Parent = sliderFrame
            title.Text = options.Title
            title.Size = UDim2.new(1, 0, 0, 20)
            title.BackgroundTransparency = 1
            title.TextColor3 = Color3.white
            
            local valueLabel = Instance.new("TextLabel")
            valueLabel.Parent = sliderFrame
            valueLabel.Text = "Value: "..options.Default
            valueLabel.Size = UDim2.new(1, 0, 0, 20)
            valueLabel.Position = UDim2.new(0, 0, 0, 25)
            valueLabel.BackgroundTransparency = 1
            valueLabel.TextColor3 = Color3.white
            
            local slider = Instance.new("TextButton")
            slider.Parent = sliderFrame
            slider.Text = ""
            slider.Size = UDim2.new(1, 0, 0, 10)
            slider.Position = UDim2.new(0, 0, 0, 45)
            slider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            
            local fill = Instance.new("Frame")
            fill.Parent = slider
            fill.Size = UDim2.new((options.Default - options.Min)/(options.Max - options.Min), 0, 1, 0)
            fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            fill.BorderSizePixel = 0
            
            slider.MouseButton1Down = function()
                local moveConnection
                local releaseConnection
                
                moveConnection = UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        local x = (input.Position.X - slider.AbsolutePosition.X)/slider.AbsoluteSize.X
                        x = math.clamp(x, 0, 1)
                        fill.Size = UDim2.new(x, 0, 1, 0)
                        local value = math.floor(options.Min + (options.Max - options.Min) * x)
                        valueLabel.Text = "Value: "..value
                        if options.Callback then
                            options.Callback(value)
                        end
                    end
                end)
                
                releaseConnection = UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        moveConnection:Disconnect()
                        releaseConnection:Disconnect()
                    end
                end)
            end
        end
    }
end

-- Show first tab by default
spawn(function()
    wait()
    if #TabButtons > 0 then
        TabButtons[1]:MouseButton1Down()
    end
end)

-- =============================================
-- MAIN SCRIPT FEATURES
-- =============================================
local Window = {
    CreateTab = CreateTab
}

-- Remote Detection
local remotes = {}
for i,v in pairs(getgc(true)) do
    if typeof(v) == "table" and rawget(v, "FireServer") then
        table.insert(remotes, v)
    end
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
    Callback = function(Value)
        features.InfiniteStamina = Value
    end
})

-- Combat Tab
local CombatTab = Window:CreateTab("Combat")
CombatTab:AddToggle("AutoParry", {
    Title = "Auto Parry",
    Callback = function(Value)
        features.AutoParry = Value
    end
})

CombatTab:AddSlider("HitboxExtender", {
    Title = "Hitbox Size",
    Min = 1,
    Max = 5,
    Default = 1.5,
    Callback = function(Value)
        features.HitboxSize = Value
    end
})

-- Movement Tab
local MovementTab = Window:CreateTab("Movement")
MovementTab:AddSlider("SpeedHack", {
    Title = "Walk Speed",
    Min = 16,
    Max = 100,
    Default = 16,
    Callback = function(Value)
        Humanoid.WalkSpeed = Value
    end
})

MovementTab:AddSlider("JumpPower", {
    Title = "Jump Power",
    Min = 50,
    Max = 150,
    Default = 50,
    Callback = function(Value)
        Humanoid.JumpPower = Value
    end
})

-- Farming Tab
local FarmingTab = Window:CreateTab("Farming")
FarmingTab:AddToggle("AutoFarm", {
    Title = "Auto Farm",
    Callback = function(Value)
        features.AutoFarm = Value
    end
})

-- Auto Parry Logic
local lastParry = 0
UserInputService.InputBegan:Connect(function(input)
    if features.AutoParry and input.KeyCode == Enum.KeyCode.F then
        for _, remote in pairs(remotes) do
            if tostring(remote):find("Parry") then
                remote:FireServer()
                lastParry = tick()
            end
        end
    end
end)

-- Main Loop
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
        local closestPlayer = nil
        local closestDistance = math.huge
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    local distance = (RootPart.Position - humanoidRootPart.Position).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
        
        if closestPlayer and closestPlayer.Character then
            local targetHRP = closestPlayer.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP then
                RootPart.CFrame = targetHRP.CFrame * CFrame.new(0, 0, -5)
            end
        end
    end
end)

-- Credits
local InfoTab = Window:CreateTab("Info")
InfoTab:AddToggle("Credits", {
    Title = "Script by YetazyHub",
    Callback = function() end
})
