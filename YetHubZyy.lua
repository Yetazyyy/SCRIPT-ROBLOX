-- Dead Rails Mobile Script
-- Works on most executors

-- Load required libraries
if not is_sirhurt_closure and syn and syn.protect_gui then
    syn.protect_gui(game:GetService("CoreGui"))
end

-- Main variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local AutoFarm = Instance.new("TextButton")
local AutoCollect = Instance.new("TextButton")
local TeleportToTrack = Instance.new("TextButton")
local SpeedHack = Instance.new("TextButton")
local Close = Instance.new("TextButton")

ScreenGui.Name = "DeadRailsMobileGUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Frame.BorderColor3 = Color3.fromRGB(25, 25, 25)
Frame.Position = UDim2.new(0.1, 0, 0.1, 0)
Frame.Size = UDim2.new(0.8, 0, 0.8, 0)
Frame.Active = true
Frame.Draggable = true

Title.Name = "Title"
Title.Parent = Frame
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Size = UDim2.new(1, 0, 0.1, 0)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Dead Rails Mobile"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true

-- Button setup function
local function createButton(name, text, position)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Parent = Frame
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.BorderColor3 = Color3.fromRGB(40, 40, 40)
    button.Position = position
    button.Size = UDim2.new(0.9, 0, 0.15, 0)
    button.Font = Enum.Font.SourceSans
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    return button
end

-- Create buttons
AutoFarm = createButton("AutoFarm", "Auto Farm (Toggle)", UDim2.new(0.05, 0, 0.15, 0))
AutoCollect = createButton("AutoCollect", "Auto Collect (Toggle)", UDim2.new(0.05, 0, 0.35, 0))
TeleportToTrack = createButton("TeleportToTrack", "Teleport to Track", UDim2.new(0.05, 0, 0.55, 0))
SpeedHack = createButton("SpeedHack", "Speed Hack (Toggle)", UDim2.new(0.05, 0, 0.75, 0))
Close = createButton("Close", "Close GUI", UDim2.new(0.05, 0, 0.9, 0))

-- Variables for toggles
local farming = false
local collecting = false
local speedHack = false
local originalWalkSpeed = Humanoid.WalkSpeed

-- Auto Farm function
local function toggleAutoFarm()
    farming = not farming
    AutoFarm.Text = farming and "Auto Farm (ON)" or "Auto Farm (OFF)"
    
    while farming do
        -- Find nearest enemy and attack
        local closestEnemy = nil
        local closestDistance = math.huge
        
        for _, enemy in ipairs(workspace:GetChildren()) do
            if enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") then
                local distance = (HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestEnemy = enemy
                end
            end
        end
        
        if closestEnemy and closestDistance < 50 then
            HumanoidRootPart.CFrame = closestEnemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2)
            wait(0.5)
        else
            wait(1)
        end
        
        if not farming then break end
    end
end

-- Auto Collect function
local function toggleAutoCollect()
    collecting = not collecting
    AutoCollect.Text = collecting and "Auto Collect (ON)" or "Auto Collect (OFF)"
    
    while collecting do
        -- Collect nearby items
        for _, item in ipairs(workspace:GetChildren()) do
            if item:IsA("BasePart") and item.Name:lower():find("coin") or item.Name:lower():find("cash") then
                if (HumanoidRootPart.Position - item.Position).magnitude < 50 then
                    firetouchinterest(HumanoidRootPart, item, 0) -- Touch start
                    firetouchinterest(HumanoidRootPart, item, 1) -- Touch end
                end
            end
        end
        wait(0.5)
        if not collecting then break end
    end
end

-- Teleport to Track function
local function teleportToTrack()
    local track = workspace:FindFirstChild("Track") or workspace:FindFirstChild("Rail") or workspace:FindFirstChild("TrainTrack")
    if track then
        HumanoidRootPart.CFrame = track:FindFirstChildWhichIsA("BasePart").CFrame * CFrame.new(0, 3, 0)
    else
        LocalPlayer:SetAttribute("LastPosition", HumanoidRootPart.Position)
        -- Try to find track by teleporting around
        for x = -500, 500, 100 do
            for z = -500, 500, 100 do
                HumanoidRootPart.CFrame = CFrame.new(x, 100, z)
                wait(0.1)
                if workspace:FindFirstChild("Track") then
                    teleportToTrack()
                    return
                end
            end
        end
        -- If not found, return to original position
        if LocalPlayer:GetAttribute("LastPosition") then
            HumanoidRootPart.CFrame = CFrame.new(LocalPlayer:GetAttribute("LastPosition"))
        end
    end
end

-- Speed Hack function
local function toggleSpeedHack()
    speedHack = not speedHack
    SpeedHack.Text = speedHack and "Speed Hack (ON)" or "Speed Hack (OFF)"
    
    if speedHack then
        originalWalkSpeed = Humanoid.WalkSpeed
        Humanoid.WalkSpeed = 50
    else
        Humanoid.WalkSpeed = originalWalkSpeed
    end
end

-- Button connections
AutoFarm.MouseButton1Click:Connect(toggleAutoFarm)
AutoCollect.MouseButton1Click:Connect(toggleAutoCollect)
TeleportToTrack.MouseButton1Click:Connect(teleportToTrack)
SpeedHack.MouseButton1Click:Connect(toggleSpeedHack)
Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Mobile optimization
if game:GetService("UserInputService").TouchEnabled then
    Frame.Size = UDim2.new(0.9, 0, 0.9, 0)
    Frame.Position = UDim2.new(0.05, 0, 0.05, 0)
    
    for _, button in ipairs(Frame:GetChildren()) do
        if button:IsA("TextButton") then
            button.TextSize = 18
        end
    end
end

-- Notification
game.StarterGui:SetCore("SendNotification", {
    Title = "Dead Rails Mobile",
    Text = "Script loaded successfully!",
    Duration = 5
})
