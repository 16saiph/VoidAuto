-- VoidAuto Aimbot GUI by MaxGoneBed
-- Compatible with Delta Executor
-- Features: Toggle, FOV Changer, Show FOV, Team Check, Wall Check, FPS Boost, Mobile Friendly, Body Part Selection

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Configuration
local Config = {
    AimbotEnabled = false,
    ShowFOV = false,
    FOV = 100,
    TeamCheck = true,
    WallCheck = true,
    FPSBoost = false,
    TargetBodyPart = "Head",
    Dragging = false,
    DragStart = Vector2.new(0, 0),
    Offset = Vector2.new(0, 0)
}

-- Play notification sound
local function PlayNotification()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://9124144408"
    sound.Volume = 0.5
    sound.Parent = workspace
    game:GetService("Debris"):AddItem(sound, 1)
    sound:Play()
end

-- Create main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AimbotGui"
screenGui.ResetOnSpawn = false
screenGui.TopLevel = true
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main frame with modern design
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 280, 0, 380)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -190)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- Add corner radius
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 20)
corner.Parent = mainFrame

-- Add stroke for sleek look
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(60, 60, 80)
stroke.Thickness = 2
stroke.Parent = mainFrame

-- Title bar (draggable)
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 20)
titleCorner.Parent = titleBar

-- Title text
local titleText = Instance.new("TextLabel")
titleText.Name = "Title"
titleText.Size = UDim2.new(1, -40, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.TextColor3 = Color3.fromRGB(200, 200, 220)
titleText.TextScaled = true
titleText.Font = Enum.Font.GothamBold
titleText.Text = "⚡ AIMBOT"
titleText.Parent = titleBar

-- Collapse button
local collapseBtn = Instance.new("TextButton")
collapseBtn.Name = "CollapseBtn"
collapseBtn.Size = UDim2.new(0, 35, 0, 35)
collapseBtn.Position = UDim2.new(1, -40, 0.5, -17.5)
collapseBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
collapseBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
collapseBtn.TextSize = 20
collapseBtn.Font = Enum.Font.GothamBold
collapseBtn.Text = "−"
collapseBtn.BorderSizePixel = 0
collapseBtn.Parent = titleBar

local collapseBtnCorner = Instance.new("UICorner")
collapseBtnCorner.CornerRadius = UDim.new(0, 10)
collapseBtnCorner.Parent = collapseBtn

-- Content frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "Content"
contentFrame.Size = UDim2.new(1, 0, 1, -45)
contentFrame.Position = UDim2.new(0, 0, 0, 45)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Scroll frame for mobile friendliness
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ScrollFrame"
scrollFrame.Size = UDim2.new(1, 0, 1, 0)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 500)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 5
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
scrollFrame.Parent = contentFrame

-- Create UIListLayout for scrollFrame
local mainLayout = Instance.new("UIListLayout")
mainLayout.Padding = UDim.new(0, 10)
mainLayout.Parent = scrollFrame

-- Create toggle button
local function CreateToggle(name, defaultState, callback)
    local toggleContainer = Instance.new("Frame")
    toggleContainer.Name = name
    toggleContainer.Size = UDim2.new(1, 0, 0, 50)
    toggleContainer.BackgroundTransparency = 1
    toggleContainer.Parent = scrollFrame
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(200, 200, 220)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.Text = name
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleContainer
    
    local toggleButton = Instance.new("Frame")
    toggleButton.Name = "Toggle"
    toggleButton.Size = UDim2.new(0, 45, 0, 25)
    toggleButton.Position = UDim2.new(1, -55, 0.5, -12.5)
    toggleButton.BackgroundColor3 = defaultState and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(60, 60, 80)
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = toggleContainer
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 12)
    toggleCorner.Parent = toggleButton
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Name = "Circle"
    toggleCircle.Size = UDim2.new(0, 21, 0, 21)
    toggleCircle.Position = defaultState and UDim2.new(1, -24, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleCircle.BorderSizePixel = 0
    toggleCircle.Parent = toggleButton
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(0, 10)
    circleCorner.Parent = toggleCircle
    
    local state = defaultState
    
    local function updateToggle()
        state = not state
        callback(state)
        
        if state then
            toggleButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
            game:GetService("TweenService"):Create(
                toggleCircle,
                TweenInfo.new(0.2),
                {Position = UDim2.new(1, -24, 0.5, -10.5)}
            ):Play()
        else
            toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            game:GetService("TweenService"):Create(
                toggleCircle,
                TweenInfo.new(0.2),
                {Position = UDim2.new(0, 2, 0.5, -10.5)}
            ):Play()
        end
        PlayNotification()
    end
    
    toggleButton.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            updateToggle()
        end
    end)
    
    return toggleContainer, function() return state end
end

-- Create slider
local function CreateSlider(name, min, max, default, callback)
    local sliderContainer = Instance.new("Frame")
    sliderContainer.Name = name
    sliderContainer.Size = UDim2.new(1, 0, 0, 70)
    sliderContainer.BackgroundTransparency = 1
    sliderContainer.Parent = scrollFrame
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(200, 200, 220)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.Text = name .. ": " .. default
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderContainer
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Name = "Background"
    sliderBg.Size = UDim2.new(1, -20, 0, 8)
    sliderBg.Position = UDim2.new(0, 10, 0, 30)
    sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = sliderContainer
    
    local sliderBgCorner = Instance.new("UICorner")
    sliderBgCorner.CornerRadius = UDim.new(0, 4)
    sliderBgCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "Fill"
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    
    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(0, 4)
    sliderFillCorner.Parent = sliderFill
    
    local sliderHandle = Instance.new("Frame")
    sliderHandle.Name = "Handle"
    sliderHandle.Size = UDim2.new(0, 18, 0, 18)
    sliderHandle.Position = UDim2.new((default - min) / (max - min), -9, 0.5, -9)
    sliderHandle.BackgroundColor3 = Color3.fromRGB(200, 200, 220)
    sliderHandle.BorderSizePixel = 0
    sliderHandle.Parent = sliderBg
    
    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(0, 9)
    handleCorner.Parent = sliderHandle
    
    local dragging = false
    
    sliderHandle.InputBegan:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        if dragging then
            local mouse = Players:GetMouse()
            local relativeX = mouse.X - sliderBg.AbsolutePosition.X
            relativeX = math.clamp(relativeX, 0, sliderBg.AbsoluteSize.X)
            local ratio = relativeX / sliderBg.AbsoluteSize.X
            local value = math.floor(min + (max - min) * ratio)
            
            sliderFill.Size = UDim2.new(ratio, 0, 1, 0)
            sliderHandle.Position = UDim2.new(ratio, -9, 0.5, -9)
            label.Text = name .. ": " .. value
            callback(value)
        end
    end)
    
    return sliderContainer
end

-- Create button group (for body part selection)
local function CreateButtonGroup(name, options, defaultValue, callback)
    local groupContainer = Instance.new("Frame")
    groupContainer.Name = name
    groupContainer.Size = UDim2.new(1, 0, 0, 70)
    groupContainer.BackgroundTransparency = 1
    groupContainer.Parent = scrollFrame
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, -20, 0, 25)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(200, 200, 220)
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.Text = name
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = groupContainer
    
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Name = "ButtonContainer"
    buttonContainer.Size = UDim2.new(1, -20, 0, 35)
    buttonContainer.Position = UDim2.new(0, 10, 0, 30)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = groupContainer
    
    local buttonLayout = Instance.new("UIListLayout")
    buttonLayout.FillDirection = Enum.FillDirection.Horizontal
    buttonLayout.Padding = UDim.new(0, 8)
    buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.SpaceBetween
    buttonLayout.Parent = buttonContainer
    
    local currentValue = defaultValue
    local buttons = {}
    
    for _, option in ipairs(options) do
        local button = Instance.new("TextButton")
        button.Name = option
        button.Size = UDim2.new(0.47, 0, 1, 0)
        button.BackgroundColor3 = (option == defaultValue) and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(60, 60, 80)
        button.TextColor3 = Color3.fromRGB(200, 200, 220)
        button.TextSize = 12
        button.Font = Enum.Font.GothamBold
        button.Text = option
        button.BorderSizePixel = 0
        button.Parent = buttonContainer
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 10)
        buttonCorner.Parent = button
        
        buttons[option] = button
        
        button.MouseButton1Click:Connect(function()
            if currentValue ~= option then
                buttons[currentValue].BackgroundColor3 = Color3.fromRGB(60, 60, 80)
                button.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
                currentValue = option
                callback(option)
                PlayNotification()
            end
        end)
    end
    
    return groupContainer
end

-- Create toggles
local _, getAimbotEnabled = CreateToggle("🎯 Aimbot Toggle", false, function(state)
    Config.AimbotEnabled = state
end)

local _, getShowFOV = CreateToggle("👁️ Show FOV", false, function(state)
    Config.ShowFOV = state
end)

local _, getTeamCheck = CreateToggle("👥 Team Check", true, function(state)
    Config.TeamCheck = state
end)

local _, getWallCheck = CreateToggle("🧱 Wall Check", true, function(state)
    Config.WallCheck = state
end)

local _, getFPSBoost = CreateToggle("⚙️ FPS Boost", false, function(state)
    Config.FPSBoost = state
    if state then
        for _, obj in pairs(workspace:FindDescendants()) do
            if obj:IsA("BasePart") then
                pcall(function()
                    obj.Material = Enum.Material.Neon
                end)
            end
        end
    end
end)

-- Create body part selector
CreateButtonGroup("💀 Target Body Part", {"Head", "Torso"}, "Head", function(value)
    Config.TargetBodyPart = value
end)

-- Create FOV slider
CreateSlider("FOV Range", 10, 500, 100, function(value)
    Config.FOV = value
end)

-- Dragging functionality
titleBar.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Config.Dragging = true
        Config.DragStart = Players:GetMouse().Position
        Config.Offset = mainFrame.Position
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Config.Dragging = false
    end
end)

-- Collapse functionality
local isCollapsed = false
collapseBtn.MouseButton1Click:Connect(function()
    isCollapsed = not isCollapsed
    if isCollapsed then
        scrollFrame.Visible = false
        mainFrame.Size = UDim2.new(0, 280, 0, 45)
        collapseBtn.Text = "+"
    else
        scrollFrame.Visible = true
        mainFrame.Size = UDim2.new(0, 280, 0, 380)
        collapseBtn.Text = "−"
    end
    PlayNotification()
end)

-- Update dragging
RunService.RenderStepped:Connect(function()
    if Config.Dragging then
        local mouse = Players:GetMouse()
        local delta = mouse.Position - Config.DragStart
        mainFrame.Position = Config.Offset + UDim2.new(0, delta.X, 0, delta.Y)
    end
end)

-- Aimbot logic
local function GetClosestTarget()
    local closest = nil
    local closestDistance = Config.FOV
    
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if not player.Character then continue end
        
        local targetPart = player.Character:FindFirstChild(Config.TargetBodyPart)
        if not targetPart then continue end
        
        if Config.TeamCheck and player.Team == LocalPlayer.Team then continue end
        
        local screenPos = Camera:WorldToScreenPoint(targetPart.Position)
        local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude
        
        if Config.WallCheck then
            local rayOrigin = Camera.CFrame.Position
            local rayDirection = (targetPart.Position - rayOrigin).Unit * 1000
            local raycastParams = RaycastParams.new()
            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
            raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
            
            local rayResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
            if rayResult and rayResult.Instance:IsDescendantOf(player.Character) == false then
                continue
            end
        end
        
        if distance < closestDistance then
            closestDistance = distance
            closest = targetPart
        end
    end
    
    return closest
end

-- Main aimbot loop
RunService.RenderStepped:Connect(function()
    if not getAimbotEnabled() then return end
    
    local target = GetClosestTarget()
    if target then
        local targetPos = target.Position
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
    end
end)

-- Play startup notification
wait(0.5)
PlayNotification()

print("✅ VoidAuto Aimbot by MaxGoneBed loaded successfully!")
print("📍 Target body part: " .. Config.TargetBodyPart)
