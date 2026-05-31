-- VoidAuto Aimbot GUI by MaxGoneBed
-- Ultra-Simplified for Delta Mobile Executor
-- Core Features Only

pcall(function()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    
    -- Simple Config
    local Config = {
        Enabled = false,
        TargetPart = "Head",
        FOV = 150,
        TeamCheck = true,
        WallCheck = false
    }
    
    -- Create simple GUI
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AimbotGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    -- Main frame (simple)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 200, 0, 150)
    mainFrame.Position = UDim2.new(0.5, -100, 0.5, -75)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.BorderSizePixel = 1
    mainFrame.BorderColor3 = Color3.fromRGB(100, 200, 100)
    mainFrame.Parent = screenGui
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
    title.TextColor3 = Color3.fromRGB(0, 0, 0)
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.Text = "AIMBOT"
    title.Parent = mainFrame
    
    -- Toggle Button
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(1, 0, 0, 30)
    toggleBtn.Position = UDim2.new(0, 0, 0, 30)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    toggleBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
    toggleBtn.TextSize = 14
    toggleBtn.Font = Enum.Font.Gotham
    toggleBtn.Text = "Enable: OFF"
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Parent = mainFrame
    
    -- Body Part Selector
    local bodyPartBtn = Instance.new("TextButton")
    bodyPartBtn.Size = UDim2.new(1, 0, 0, 30)
    bodyPartBtn.Position = UDim2.new(0, 0, 0, 60)
    bodyPartBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    bodyPartBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
    bodyPartBtn.TextSize = 12
    bodyPartBtn.Font = Enum.Font.Gotham
    bodyPartBtn.Text = "Part: Head"
    bodyPartBtn.BorderSizePixel = 0
    bodyPartBtn.Parent = mainFrame
    
    -- Team Check Button
    local teamCheckBtn = Instance.new("TextButton")
    teamCheckBtn.Size = UDim2.new(1, 0, 0, 30)
    teamCheckBtn.Position = UDim2.new(0, 0, 0, 90)
    teamCheckBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    teamCheckBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
    teamCheckBtn.TextSize = 12
    teamCheckBtn.Font = Enum.Font.Gotham
    teamCheckBtn.Text = "Team Check: ON"
    teamCheckBtn.BorderSizePixel = 0
    teamCheckBtn.Parent = mainFrame
    
    -- Toggle aimbot
    toggleBtn.MouseButton1Click:Connect(function()
        Config.Enabled = not Config.Enabled
        toggleBtn.Text = Config.Enabled and "Enable: ON" or "Enable: OFF"
        toggleBtn.BackgroundColor3 = Config.Enabled and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(60, 60, 80)
    end)
    
    -- Toggle body part
    bodyPartBtn.MouseButton1Click:Connect(function()
        if Config.TargetPart == "Head" then
            Config.TargetPart = "Torso"
            bodyPartBtn.Text = "Part: Torso"
        else
            Config.TargetPart = "Head"
            bodyPartBtn.Text = "Part: Head"
        end
    end)
    
    -- Toggle team check
    teamCheckBtn.MouseButton1Click:Connect(function()
        Config.TeamCheck = not Config.TeamCheck
        teamCheckBtn.Text = Config.TeamCheck and "Team Check: ON" or "Team Check: OFF"
    end)
    
    -- Aimbot function
    local function FindTarget()
        local closest = nil
        local closestDist = Config.FOV
        
        for _, player in pairs(Players:GetPlayers()) do
            if player == LocalPlayer or not player.Character then continue end
            
            local targetPart = player.Character:FindFirstChild(Config.TargetPart)
            if not targetPart then continue end
            
            if Config.TeamCheck and player.Team == LocalPlayer.Team then continue end
            
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
        if not Config.Enabled then return end
        
        local target = FindTarget()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end)
    
    print("✅ VoidAuto Aimbot Loaded - Made by MaxGoneBed")
end)
