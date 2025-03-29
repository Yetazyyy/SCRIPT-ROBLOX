--[[
  The Strongest Battleground 2025 ULTIMATE SCRIPT
  - Auto-Combo (All Characters)
  - Auto-Block (Smart Detection)
  - Anti-Kick / Anti-Ban
  - Mobile & PC Support
  - Works on Most Executors
  - Optimized Performance
--]]

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Anti-Kick & Anti-Ban
do
    for _, v in pairs(getconnections(LocalPlayer.Idled)) do
        v:Disable()
    end

    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" or method == "Teleport" then
            return nil
        end
        return oldNamecall(self, ...)
    end)
end

-- Mobile Check
local IS_MOBILE = UserInputService.TouchEnabled

-- Character Abilities & Combos
local CharacterDB = {
    ["The Strongest Hero"] = { combo = {"M1","M1","M2","Jump"}, blockDelay = 0.2, specialKey = Enum.KeyCode.R },
    ["Hero Hunter"] = { combo = {"M1","M2","M1"}, blockDelay = 0.3, specialKey = Enum.KeyCode.T },
    ["Destructive Cyborg"] = { combo = {"M2","M1","Jump","M1"}, blockDelay = 0.25, specialKey = Enum.KeyCode.Y },
    ["Deadly Ninja"] = { combo = {"M1","M1","M1","M2"}, blockDelay = 0.15, specialKey = Enum.KeyCode.U },
    ["Brutal Demon"] = { combo = {"M2","M2","M1","Jump"}, blockDelay = 0.3, specialKey = Enum.KeyCode.P },
    ["Blade Master"] = { combo = {"M1","M2","M1","M1"}, blockDelay = 0.2, specialKey = Enum.KeyCode.F },
    ["Wild Psychic"] = { combo = {"M1","Jump","M2","M1"}, blockDelay = 0.25, specialKey = Enum.KeyCode.G },
    ["Martial Artist"] = { combo = {"M1","M1","M2","Jump"}, blockDelay = 0.2, specialKey = Enum.KeyCode.H },
    ["Tech Prodigy"] = { combo = {"M2","M1","M1","M2"}, blockDelay = 0.3, specialKey = Enum.KeyCode.J },
    ["Sorcerer"] = { combo = {"M1","M2","Jump","M1"}, blockDelay = 0.25, specialKey = Enum.KeyCode.K },
    ["KJ"] = { combo = {"M1","M1","M1","M2"}, blockDelay = 0.15, specialKey = Enum.KeyCode.L },
    ["The Frozen Soul"] = { combo = {"M2","M1","M2","Jump"}, blockDelay = 0.3, specialKey = Enum.KeyCode.Z },
    ["Crab Boss"] = { combo = {"M1","M2","M1","M1"}, blockDelay = 0.2, specialKey = Enum.KeyCode.X }
}

-- Get Current Character
local function GetCurrentCharacter()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        local charName = char:FindFirstChild("NameTag") and char.NameTag.Text or "Unknown"
        return CharacterDB[charName] or CharacterDB["The Strongest Hero"]
    end
    return CharacterDB["The Strongest Hero"]
end

-- Input Simulator (Mobile & PC)
local function InputAction(action)
    if action == "M1" then
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, nil, 0)
        task.wait(0.1)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, nil, 0)
    elseif action == "M2" then
        VirtualInputManager:SendMouseButtonEvent(0, 0, 1, true, nil, 0)
        task.wait(0.1)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 1, false, nil, 0)
    elseif action == "Jump" then
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, nil)
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, nil)
    elseif action == "Block" then
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, nil)
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, nil)
    elseif action == "Special" then
        local charData = GetCurrentCharacter()
        VirtualInputManager:SendKeyEvent(true, charData.specialKey, false, nil)
        task.wait(0.5)
        VirtualInputManager:SendKeyEvent(false, charData.specialKey, false, nil)
    end
end

-- Auto-Block System
local AutoBlockEnabled = false
local function AutoBlock()
    if not AutoBlockEnabled then return end
    
    local charData = GetCurrentCharacter()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                if distance < 15 and player.Character:FindFirstChild("Attacking") then
                    InputAction("Block")
                    task.wait(charData.blockDelay)
                    InputAction("Block") -- Release
                    break
                end
            end
        end
    end
end

-- Auto-Combo System
local AutoComboEnabled = false
local function AutoCombo()
    if not AutoComboEnabled then return end
    
    local charData = GetCurrentCharacter()
    local closestPlayer = nil
    local minDistance = math.huge
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                if distance < minDistance then
                    minDistance = distance
                    closestPlayer = player
                end
            end
        end
    end
    
    if closestPlayer and minDistance < 12 then
        for _, action in ipairs(charData.combo) do
            InputAction(action)
            task.wait(0.2)
        end
        InputAction("Special") -- Use Character Special
    end
end

-- UI Library
local YetHubZyyUI = {}
function YetHubZyyUI:Create()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game:GetService("CoreGui")
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 300, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.Parent = ScreenGui
    MainFrame.Active = true
    MainFrame.Draggable = true
    
    local Title = Instance.new("TextLabel")
    Title.Text = "YetHubZyy | TSBG 2025"
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Title.Parent = MainFrame
    
    local ToggleAutoCombo = Instance.new("TextButton")
    ToggleAutoCombo.Text = "Auto-Combo: OFF"
    ToggleAutoCombo.Size = UDim2.new(0.9, 0, 0, 30)
    ToggleAutoCombo.Position = UDim2.new(0.05, 0, 0.1, 0)
    ToggleAutoCombo.Parent = MainFrame
    
    local ToggleAutoBlock = Instance.new("TextButton")
    ToggleAutoBlock.Text = "Auto-Block: OFF"
    ToggleAutoBlock.Size = UDim2.new(0.9, 0, 0, 30)
    ToggleAutoBlock.Position = UDim2.new(0.05, 0, 0.2, 0)
    ToggleAutoBlock.Parent = MainFrame
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Text = "CLOSE"
    CloseButton.Size = UDim2.new(0.9, 0, 0, 30)
    CloseButton.Position = UDim2.new(0.05, 0, 0.8, 0)
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseButton.Parent = MainFrame
    
    -- Toggle Logic
    ToggleAutoCombo.MouseButton1Click:Connect(function()
        AutoComboEnabled = not AutoComboEnabled
        ToggleAutoCombo.Text = AutoComboEnabled and "Auto-Combo: ON" or "Auto-Combo: OFF"
    end)
    
    ToggleAutoBlock.MouseButton1Click:Connect(function()
        AutoBlockEnabled = not AutoBlockEnabled
        ToggleAutoBlock.Text = AutoBlockEnabled and "Auto-Block: ON" or "Auto-Block: OFF"
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Mobile Support
    if IS_MOBILE then
        MainFrame.Draggable = false
        local MoveButton = Instance.new("TextButton")
        MoveButton.Text = "MOVE"
        MoveButton.Size = UDim2.new(0, 60, 0, 30)
        MoveButton.Position = UDim2.new(1, -60, 0, 0)
        MoveButton.Parent = MainFrame
        
        local dragStart, frameStart
        MoveButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                dragStart = input.Position
                frameStart = MainFrame.Position
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch and dragStart then
                MainFrame.Position = UDim2.new(
                    frameStart.X.Scale, frameStart.X.Offset + (input.Position.X - dragStart.X),
                    frameStart.Y.Scale, frameStart.Y.Offset + (input.Position.Y - dragStart.Y)
                )
            end
        end)
        
        MoveButton.InputEnded:Connect(function()
            dragStart = nil
        end)
    end
    
    return ScreenGui
end

-- Main Execution
local UI = YetHubZyyUI:Create()
RunService.Heartbeat:Connect(AutoBlock)
RunService.Heartbeat:Connect(AutoCombo)

print("✅ YetHubZyy TSBG 2025 Script Loaded!")
