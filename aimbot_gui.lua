-- VoidAuto Aimbot GUI by MaxGoneBed
-- Optimized for Delta Mobile Executor
-- Features: Draggable, Collapsible, Body Part Selection, Wall Check, Alive Check

pcall(function()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    
    -- Config
    local Config = {
        Enabled = false,
        TargetPart = "Head",
        FOV = 200,
        TeamCheck = true,
        WallCheck = true,
        Dragging = false,
        DragOffset = Vector2.new(0, 0),
        Collapsed = false
    }
    
    -- Create ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "VoidAimbotGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    -- Main Frame - Pure Black
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 250, 0, 280)
    mainFrame.Position = UDim2.new(0.5, -125, 0.5, -140)
    mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = Color3.fromRGB(100, 200, 100)
    mainFrame.Parent = screenGui
    
    -- Add rounded corners with multiple frames
    local cornerTL = Instance.new("Frame")
    cornerTL.Size = UDim2.new(0, 10, 0, 10)
    cornerTL.Position = UDim2.new(0, 0, 0, 0)
    cornerTL.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    cornerTL.BorderSizePixel = 0
    cornerTL.Parent = mainFrame
    
    local cornerTR = Instance.new("Frame")
    cornerTR.Size = UDim2.new(0, 10, 0, 10)
    cornerTR.Position = UDim2.new(1, -10, 0, 0)
    cornerTR.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    cornerTR.BorderSizePixel = 0
    cornerTR.Parent = mainFrame
    
    local cornerBL = Instance.new("Frame")
    cornerBL.Size = UDim2.new(0, 10, 0, 10)
    cornerBL.Position = UDim2.new(0, 0, 1, -10)
    cornerBL.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    cornerBL.BorderSizePixel = 0
    cornerBL.Parent = mainFrame
    
    local cornerBR = Instance.new("Frame")
    cornerBR.Size = UDim2.new(0, 10, 0, 10)
    cornerBR.Position = UDim2.new(1, -10, 1, -10)
    cornerBR.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    cornerBR.BorderSizePixel = 0
    cornerBR.Parent = mainFrame
    
    -- Title Bar (Draggable)
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    -- Title Text
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -50, 1, 0)
    titleText.Position = UDim2.new(0, 5, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.TextColor3 = Color3.fromRGB(0, 0, 0)
    titleText.TextSize = 16
    titleText.Font = Enum.Font.GothamBold
    titleText.Text = "VOID'S AIMBOT"
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar
    
    -- Collapse Button
    local collapseBtn = Instance.new("TextButton")
    collapseBtn.Name = "CollapseBtn"
    collapseBtn.Size = UDim2.new(0, 40, 1, 0)
    collapseBtn.Position = UDim2.new(1, -40, 0, 0)
    collapseBtn.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
    collapseBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    collapseBtn.TextSize = 14
    collapseBtn.Font = Enum.Font.GothamBold
    collapseBtn.Text = "−"
    collapseBtn.BorderSizePixel = 0
    collapseBtn.Parent = titleBar
    
    -- Content Frame
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "Content"
    contentFrame.Size = UDim2.new(1, 0, 1, -40)
    contentFrame.Position = UDim2.new(0, 0, 0, 40)
    contentFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = mainFrame
    
    -- Create button function
    local function CreateButton(name, position, callback)
        local button = Instance.new("TextButton")
        button.Name = name
        button.Size = UDim2.new(1, -10, 0, 32)
        button.Position = position
        button.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        button.TextColor3 = Color3.fromRGB(200, 200, 220)
        button.TextSize = 12
        button.Font = Enum.Font.Gotham
        button.BorderSizePixel = 1
        button.BorderColor3 = Color3.fromRGB(100, 200, 100)
        button.Parent = contentFrame
        
        button.MouseButton1Click:Connect(callback)
        return button
    end
    
    -- Enable/Disable Toggle
    local enableBtn = CreateButton("EnableBtn", UDim2.new(0, 5, 0, 5), function()
        Config.Enabled = not Config.Enabled
        enableBtn.BackgroundColor3 = Config.Enabled and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(40, 40, 55)
        enableBtn.Text = Config.Enabled and "⚡ AIMBOT: ON" or "⚡ AIMBOT: OFF"
    end)
    enableBtn.Text = "⚡ AIMBOT: OFF"
    
    -- Wall Check Toggle
    local wallCheckBtn = CreateButton("WallCheckBtn", UDim2.new(0, 5, 0, 42), function()
        Config.WallCheck = not Config.WallCheck
        wallCheckBtn.BackgroundColor3 = Config.WallCheck and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(40, 40, 55)
        wallCheckBtn.Text = Config.WallCheck and "🧱 WALL CHECK: ON" or "🧱 WALL CHECK: OFF"
    end)
    wallCheckBtn.Text = "🧱 WALL CHECK: ON"
    
    -- Team Check Toggle
    local teamCheckBtn = CreateButton("TeamCheckBtn", UDim2.new(0, 5, 0, 79), function()
        Config.TeamCheck = not Config.TeamCheck
        teamCheckBtn.BackgroundColor3 = Config.TeamCheck and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(40, 40, 55)
        teamCheckBtn.Text = Config.TeamCheck and "👥 TEAM CHECK: ON" or "👥 TEAM CHECK: OFF"
    end)
    teamCheckBtn.Text = "👥 TEAM CHECK: ON"
    
    -- Body Part Selector Label
    local partLabel = Instance.new("TextLabel")
    partLabel.Size = UDim2.new(1, -10, 0, 20)
    partLabel.Position = UDim2.new(0, 5, 0, 116)
    partLabel.BackgroundTransparency = 1
    partLabel.TextColor3 = Color3.fromRGB(100, 200, 100)
    partLabel.TextSize = 11
    partLabel.Font = Enum.Font.GothamBold
    partLabel.Text = "💀 TARGET BODY PART:"
    partLabel.TextXAlignment = Enum.TextXAlignment.Left
    partLabel.Parent = contentFrame
    
    -- Head Button
    local headBtn = CreateButton("HeadBtn", UDim2.new(0, 5, 0, 138), function()
        Config.TargetPart = "Head"
        headBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
        torsoBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        headBtn.Text = "HEAD (Selected)"
        torsoBtn.Text = "TORSO"
    end)
    headBtn.Text = "HEAD (Selected)"
    
    -- Torso Button
    local torsoBtn = CreateButton("TorsoBtn", UDim2.new(0, 5, 0, 175), function()
        Config.TargetPart = "Torso"
        torsoBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
        headBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        torsoBtn.Text = "TORSO (Selected)"
        headBtn.Text = "HEAD"
    end)
    torsoBtn.Text = "TORSO"
    
    -- Status Label
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, -10, 0, 20)
    statusLabel.Position = UDim2.new(0, 5, 0, 212)
    statusLabel.BackgroundTransparency = 1
    statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    statusLabel.TextSize = 10
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Text = "Status: Idle"
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = contentFrame
    
    -- Dragging Setup
    titleBar.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Config.Dragging = true
            Config.DragOffset = Players:GetMouse().Position - mainFrame.AbsolutePosition
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Config.Dragging = false
        end
    end)
    
    -- Collapse functionality
    collapseBtn.MouseButton1Click:Connect(function()
        Config.Collapsed = not Config.Collapsed
        if Config.Collapsed then
            contentFrame.Visible = false
            mainFrame.Size = UDim2.new(0, 250, 0, 40)
            collapseBtn.Text = "+"
        else
            contentFrame.Visible = true
            mainFrame.Size = UDim2.new(0, 250, 0, 280)
            collapseBtn.Text = "−"
        end
    end)
    
    -- Check if player is alive
    local function IsPlayerAlive(player)
        if not player or not player.Character then return false end
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if not humanoid then return false end
        return humanoid.Health > 0
    end
    
    -- Find closest target
    local function FindTarget()
        local closest = nil
        local closestDist = Config.FOV
        
        for _, player in pairs(Players:GetPlayers()) do
            if player == LocalPlayer or not player.Character then continue end
            
            -- Check if alive
            if not IsPlayerAlive(player) then continue end
            
            local targetPart = player.Character:FindFirstChild(Config.TargetPart)
            if not targetPart then continue end
            
            -- Team check
            if Config.TeamCheck and player.Team == LocalPlayer.Team then continue end
            
            -- Wall check
            if Config.WallCheck then
                local rayOrigin = Camera.CFrame.Position
                local rayDirection = (targetPart.Position - rayOrigin).Unit * 1000
                local raycastParams = RaycastParams.new()
                raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
                
                local rayResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
                if rayResult and not rayResult.Instance:IsDescendantOf(player.Character) then
                    continue
                end
            end
            
            -- Distance calculation
            local screenPos = Camera:WorldToScreenPoint(targetPart.Position)
            local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude
            
            if dist < closestDist then
                closestDist = dist
                closest = targetPart
            end
        end
        
        return closest
    end
    
    -- Main loop
    RunService.RenderStepped:Connect(function()
        -- Handle dragging
        if Config.Dragging then
            mainFrame.Position = UDim2.new(0, Players:GetMouse().Position.X - Config.DragOffset.X, 0, Players:GetMouse().Position.Y - Config.DragOffset.Y)
        end
        
        -- Update status
        if Config.Enabled then
            local target = FindTarget()
            if target then
                statusLabel.Text = "Status: Targeting"
                statusLabel.TextColor3 = Color3.fromRGB(100, 200, 100)
                if Config.Enabled then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
                end
            else
                statusLabel.Text = "Status: No Target"
                statusLabel.TextColor3 = Color3.fromRGB(200, 100, 100)
            end
        else
            statusLabel.Text = "Status: Disabled"
            statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        end
    end)
    
    print("✅ VOID'S AIMBOT Loaded - Made by MaxGoneBed")
end)
