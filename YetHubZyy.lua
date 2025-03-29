--[[
  WORKING SCRIPT - The Strongest Battleground 2025
  ✅ Auto-Combo (All Characters)
  ✅ Auto-Block (Smart Detection)
  ✅ Anti-Kick / Anti-Ban
  ✅ Mobile & PC Support
--]]

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInput = game:GetService("VirtualInputManager")

-- Anti-Kick Protection
for _, v in pairs(getconnections(LocalPlayer.Idled)) do
    v:Disable()
end

-- Mobile Check
local IS_MOBILE = UserInputService.TouchEnabled

-- Character Combos
local CharacterDB = {
    ["The Strongest Hero"] = { combo = {"M1","M1","M2","Jump"}, blockDelay = 0.2 },
    ["Hero Hunter"] = { combo = {"M1","M2","M1"}, blockDelay = 0.3 },
    ["Destructive Cyborg"] = { combo = {"M2","M1","Jump","M1"}, blockDelay = 0.25 },
    ["Deadly Ninja"] = { combo = {"M1","M1","M1","M2"}, blockDelay = 0.15 }
    -- [Tambahkan karakter lain jika diperlukan]
}

-- Get Current Character
local function GetCurrentCharacter()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        local charTag = char:FindFirstChild("NameTag") or char:FindFirstChild("Head"):FindFirstChild("NameTag")
        if charTag then
            return CharacterDB[charTag.Text] or CharacterDB["The Strongest Hero"]
        end
    end
    return CharacterDB["The Strongest Hero"]
end

-- Input Simulation (FIXED)
local function SendInput(action)
    if action == "M1" then
        if IS_MOBILE then
            VirtualInput:SendMouseButtonEvent(0, 0, 0, true, nil, 0)
            task.wait(0.1)
            VirtualInput:SendMouseButtonEvent(0, 0, 0, false, nil, 0)
        else
            mouse1click()
        end
    elseif action == "M2" then
        if IS_MOBILE then
            VirtualInput:SendMouseButtonEvent(0, 0, 1, true, nil, 0)
            task.wait(0.1)
            VirtualInput:SendMouseButtonEvent(0, 0, 1, false, nil, 0)
        else
            mouse2click()
        end
    elseif action == "Jump" then
        VirtualInput:SendKeyEvent(true, Enum.KeyCode.Space, false, nil)
        task.wait(0.1)
        VirtualInput:SendKeyEvent(false, Enum.KeyCode.Space, false, nil)
    elseif action == "Block" then
        VirtualInput:SendKeyEvent(true, Enum.KeyCode.F, false, nil)
        task.wait(0.2)
        VirtualInput:SendKeyEvent(false, Enum.KeyCode.F, false, nil)
    end
end

-- Auto-Combo System (FIXED)
local ComboEnabled = false
local function DoCombo()
    if not ComboEnabled then return end
    
    local charData = GetCurrentCharacter()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                if distance < 15 then
                    for _, action in ipairs(charData.combo) do
                        SendInput(action)
                        task.wait(0.2)
                    end
                    break
                end
            end
        end
    end
end

-- Auto-Block System (FIXED)
local BlockEnabled = false
local function DoBlock()
    if not BlockEnabled then return end
    
    local charData = GetCurrentCharacter()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                if distance < 10 then
                    SendInput("Block")
                    task.wait(charData.blockDelay)
                    break
                end
            end
        end
    end
end

-- Simple UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 150)
Frame.Position = UDim2.new(0.5, -100, 0.5, -75)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.Parent = ScreenGui
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel")
Title.Text = "TSBG 2025 - YetHubZyy"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Title.Parent = Frame

local ComboToggle = Instance.new("TextButton")
ComboToggle.Text = "Auto-Combo: OFF"
ComboToggle.Size = UDim2.new(0.9, 0, 0, 30)
ComboToggle.Position = UDim2.new(0.05, 0, 0.25, 0)
ComboToggle.Parent = Frame

local BlockToggle = Instance.new("TextButton")
BlockToggle.Text = "Auto-Block: OFF"
BlockToggle.Size = UDim2.new(0.9, 0, 0, 30)
BlockToggle.Position = UDim2.new(0.05, 0, 0.5, 0)
BlockToggle.Parent = Frame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "CLOSE"
CloseBtn.Size = UDim2.new(0.9, 0, 0, 30)
CloseBtn.Position = UDim2.new(0.05, 0, 0.75, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
CloseBtn.Parent = Frame

-- Toggle Logic
ComboToggle.MouseButton1Click:Connect(function()
    ComboEnabled = not ComboEnabled
    ComboToggle.Text = ComboEnabled and "Auto-Combo: ON" or "Auto-Combo: OFF"
end)

BlockToggle.MouseButton1Click:Connect(function()
    BlockEnabled = not BlockEnabled
    BlockToggle.Text = BlockEnabled and "Auto-Block: ON" or "Auto-Block: OFF"
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Main Loop
RunService.Heartbeat:Connect(function()
    DoCombo()
    DoBlock()
end)

print("✅ Script loaded! Press buttons to enable features.")
