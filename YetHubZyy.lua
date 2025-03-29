-- The Strongest Battleground 2025 Script by YetHubZyy
-- Mobile compatible with anti-kick protection
-- WARNING: Using exploits can get your account banned

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Anti-kick protection
local function AntiKick()
    -- Prevent common kick methods
    for _, connection in pairs(getconnections(LocalPlayer.Idled)) do
        connection:Disable()
    end

    -- Hook remote events to prevent kicks
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if tostring(self) == "Kick" or tostring(self) == "Teleport" or tostring(method) == "Kick" then
            return nil
        end
        return oldNamecall(self, ...)
    end)

    -- Protect character
    LocalPlayer.CharacterAdded:Connect(function(char)
        if Humanoid then
            Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            task.wait(0.5)
            Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end)
end

-- Mobile compatibility functions
local function IsMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

local function MobileCompatibleClick()
    if IsMobile() then
        -- Simulate touch input for mobile
        local touchInput = {
            UserInputType = Enum.UserInputType.Touch,
            Position = Vector2.new(100, 100),
            KeyCode = Enum.KeyCode.ButtonA
        }
        game:GetService("VirtualInputManager"):SendTouchEvent(1, Enum.TouchState.Began, touchInput)
        task.wait(0.1)
        game:GetService("VirtualInputManager"):SendTouchEvent(1, Enum.TouchState.Ended, touchInput)
    else
        -- Standard mouse click for PC
        mouse1click()
    end
end

local function MobileCompatibleKeyPress(keyCode)
    if IsMobile() then
        -- Simulate mobile button press
        game:GetService("VirtualInputManager"):SendKeyEvent(true, keyCode, false, nil)
        task.wait(0.1)
        game:GetService("VirtualInputManager"):SendKeyEvent(false, keyCode, false, nil)
    else
        -- Standard key press for PC
        keypress(keyCode)
        task.wait(0.1)
        keyrelease(keyCode)
    end
end

-- UI Library with mobile scaling
local YetHubZyy = {}

function YetHubZyy:CreateWindow(name)
    local YetHubZyy = {}
    
    -- Adjust size based on platform
    local windowWidth = IsMobile() and 350 or 300
    local windowHeight = IsMobile() and 450 or 400
    
    -- Main GUI
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local TabHolder = Instance.new("Frame")
    local UIListLayout = Instance.new("UIListLayout")
    
    ScreenGui.Name = "YetHubZyyUI"
    ScreenGui.Parent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
    MainFrame.Position = UDim2.new(0.5, -windowWidth/2, 0.5, -windowHeight/2)
    MainFrame.Size = UDim2.new(0, windowWidth, 0, windowHeight)
    MainFrame.Active = true
    MainFrame.Draggable = not IsMobile() -- Disable dragging on mobile
    
    Title.Name = "Title"
    Title.Parent = MainFrame
    Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Title.BorderColor3 = Color3.fromRGB(60, 60, 60)
    Title.Size = UDim2.new(0, windowWidth, 0, 30)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "YetHubZyy | "..name
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = IsMobile() and 16 or 14
    
    TabHolder.Name = "TabHolder"
    TabHolder.Parent = MainFrame
    TabHolder.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    TabHolder.BorderSizePixel = 0
    TabHolder.Position = UDim2.new(0, 0, 0, 30)
    TabHolder.Size = UDim2.new(0, windowWidth, 0, windowHeight - 30)
    
    UIListLayout.Parent = TabHolder
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5)
    
    function YetHubZyy:CreateButton(text, callback)
        local Button = Instance.new("TextButton")
        
        Button.Name = text.."Button"
        Button.Parent = TabHolder
        Button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        Button.BorderColor3 = Color3.fromRGB(60, 60, 60)
        Button.Size = UDim2.new(0, windowWidth - 20, 0, IsMobile() and 40 or 30)
        Button.Font = Enum.Font.Gotham
        Button.Text = text
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = IsMobile() and 16 or 14
        Button.AutoButtonColor = true
        
        Button.MouseButton1Click:Connect(function()
            callback()
        end)
        
        -- Add touch support for mobile
        if IsMobile() then
            Button.TouchTap:Connect(function()
                callback()
            end)
        end
        
        return Button
    end
    
    -- Rest of the UI functions remain the same as before...
    -- [Previous UI code for CreateToggle and CreateLabel would go here]
    -- For brevity, I've included the essential mobile changes
    
    return YetHubZyy
end

-- Initialize anti-kick
AntiKick()

-- Create the UI
local Window = YetHubZyy:CreateWindow("TSBG 2025 Mobile")

-- [Rest of your existing features with mobile-compatible input]
-- Example modified Auto Combo for mobile:
local AutoComboEnabled = false
Window:CreateToggle("Auto Combo", false, function(state)
    AutoComboEnabled = state
    
    if AutoComboEnabled then
        spawn(function()
            while AutoComboEnabled do
                local closestPlayer = GetClosestPlayer()
                if closestPlayer and closestPlayer.Character then
                    local targetHRP = closestPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if targetHRP then
                        local distance = (HumanoidRootPart.Position - targetHRP.Position).Magnitude
                        
                        if distance < 10 then
                            -- Mobile compatible combo
                            MobileCompatibleClick() -- M1
                            task.wait(0.2)
                            MobileCompatibleKeyPress(Enum.KeyCode.ButtonX) -- M2 alternative for mobile
                            task.wait(0.2)
                            MobileCompatibleClick() -- M1 again
                            task.wait(1.5) -- Cooldown
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
    end
end)

-- Mobile-specific controls help
if IsMobile() then
    Window:CreateLabel("Mobile Controls:")
    Window:CreateLabel("M1 = Screen Tap")
    Window:CreateLabel("M2 = Virtual Button X")
    Window:CreateLabel("Block = Virtual Button Y")
end

-- [Include all your other features with mobile adaptations]
