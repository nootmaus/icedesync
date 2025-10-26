local screenGui = Instance.new("ScreenGui")
screenGui.Name = "IceHubUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")


local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 70, 0, 70)
toggleButton.Position = UDim2.new(0, 20, 0.5, -35)
toggleButton.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
toggleButton.BackgroundTransparency = 0.1
toggleButton.Text = "ICE"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 14
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Active = true
toggleButton.Draggable = true
toggleButton.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1, 0)
toggleCorner.Parent = toggleButton

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = Color3.fromRGB(100, 200, 255)
toggleStroke.Thickness = 3
toggleStroke.Parent = toggleButton

local toggleGradient = Instance.new("UIGradient")
toggleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 200, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 150, 255))
})
toggleGradient.Rotation = 45
toggleGradient.Parent = toggleButton


local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 340)
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -170)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 15)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(100, 200, 255)
mainStroke.Thickness = 2
mainStroke.Transparency = 0.3
mainStroke.Parent = mainFrame


local titleFrame = Instance.new("Frame")
titleFrame.Size = UDim2.new(1, 0, 0, 40)
titleFrame.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
titleFrame.BorderSizePixel = 0
titleFrame.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 15)
titleCorner.Parent = titleFrame

local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 200, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 150, 255))
})
titleGradient.Rotation = 90
titleGradient.Parent = titleFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "ICE HUB"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Parent = titleFrame


local buttonContainer = Instance.new("Frame")
buttonContainer.Size = UDim2.new(1, -20, 1, -50)
buttonContainer.Position = UDim2.new(0, 10, 0, 45)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = mainFrame


local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.FillDirection = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = buttonContainer


local function createButton(name, icon)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 36)
    button.Text = icon .. " " .. name
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    button.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = button
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(100, 200, 255)
    stroke.Thickness = 2
    stroke.Transparency = 0.5
    stroke.Parent = button
    
    button.Parent = buttonContainer
    

    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        stroke.Transparency = 0
    end)
    
    button.MouseLeave:Connect(function()
        stroke.Transparency = 0.5
    end)
    
    return button, stroke
end


local fpsButton, fpsStroke = createButton("Fly", "🎯")
local speedButton, speedStroke = createButton("Speed Boost", "⚡")
local floorButton, floorStroke = createButton("3rd Floor", "🏢")
local extraButton, extraStroke = createButton("Invisible - Desync", "🔄")
local lagButton, lagStroke = createButton("Lag Server (Need Aura)", "💥")

----------------------------------------------------------------------
-- desync -- кстати а че ты код чекаешь хуесос мелкий?
----------------------------------------------------------------------

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local desyncActive = false

local function enableMobileDesync()
    local success = pcall(function()
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        local backpack = LocalPlayer:WaitForChild("Backpack")
        
     
        local packages = ReplicatedStorage:WaitForChild("Packages", 3)
        if not packages then 
            warn("❌ Packages не найден")
            return 
        end
        
        local netFolder = packages:WaitForChild("Net", 3)
        if not netFolder then 
            warn("❌ Net folder не найден")
            return 
        end
        
        
        local useItemRemote = netFolder:FindFirstChild("RE/UseItem", true)
        local teleportRemote = netFolder:FindFirstChild("RE/QuantumCloner/OnTeleport", true)
        
        if not useItemRemote then
            
            for _, v in pairs(netFolder:GetDescendants()) do
                if v.Name == "UseItem" and v:IsA("RemoteEvent") then
                    useItemRemote = v
                    break
                end
            end
        end
        
        if not teleportRemote then
            for _, v in pairs(netFolder:GetDescendants()) do
                if v.Name == "OnTeleport" and v:IsA("RemoteEvent") then
                    teleportRemote = v
                    break
                end
            end
        end
        
        if not useItemRemote or not teleportRemote then
            warn("❌ Ремоуты не найдены")
            return
        end
        
        
        local toolNames = {"Quantum Cloner", "Brainrot", "brainrot"}
        local tool
        
        for _, toolName in ipairs(toolNames) do
            tool = backpack:FindFirstChild(toolName) or character:FindFirstChild(toolName)
            if tool then break end
        end
        
        if not tool then
            for _, item in ipairs(backpack:GetChildren()) do
                if item:IsA("Tool") then 
                    tool = item 
                    break 
                end
            end
        end
        
        
        if tool and tool.Parent == backpack then
            humanoid:EquipTool(tool)
            task.wait(0.3)
        end
        
        
        if setfflag then 
            setfflag("WorldStepMax", "-9999999999")
        end
        
        
        task.spawn(function()
            useItemRemote:FireServer()
        end)
        
        task.wait(0.1)
        
        task.spawn(function()
            teleportRemote:FireServer()
        end)
        
        task.wait(1)
        
        if setfflag then 
            setfflag("WorldStepMax", "-1")
        end
        
        print("✅ Desync активирован моментально!")
    end)
    
    if not success then
        warn("❌ Ошибка активации Desync")
        return false
    end
    return true
end

local function disableMobileDesync()
    pcall(function()
        if setfflag then 
            setfflag("WorldStepMax", "-1")
        end
        print("❌ Desync деактивирован")
    end)
end

extraButton.MouseButton1Click:Connect(function()
    desyncActive = not desyncActive
    if desyncActive then
        local success = enableMobileDesync()
        if success then
            extraButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            extraStroke.Color = Color3.fromRGB(0, 255, 100)
        else
            desyncActive = false
            extraButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            extraStroke.Color = Color3.fromRGB(100, 200, 255)
        end
    else
        disableMobileDesync()
        extraButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        extraStroke.Color = Color3.fromRGB(100, 200, 255)
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    desyncActive = false
    extraButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    extraStroke.Color = Color3.fromRGB(100, 200, 255)
end)

----------------------------------------------------------------------
-- Lag Server (Dark Matter Slap)
----------------------------------------------------------------------

local RunService = game:GetService("RunService")
local lagServerActive = false
local lagServerConnection

local function keepDarkMatterEquipped()
    if lagServerConnection then return end
    
    lagServerConnection = RunService.Heartbeat:Connect(function()
        if not lagServerActive then return end
        
        local character = LocalPlayer.Character
        if not character then return end
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        
        if not humanoid or not backpack then return end
        
        local darkMatterSlap = backpack:FindFirstChild("Dark Matter Slap") or character:FindFirstChild("Dark Matter Slap")
        
        if darkMatterSlap and darkMatterSlap.Parent == backpack then
            humanoid:EquipTool(darkMatterSlap)
        end
    end)
end

local function stopKeepingEquipped()
    if lagServerConnection then
        lagServerConnection:Disconnect()
        lagServerConnection = nil
    end
    
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:UnequipTools()
        end
    end
end

lagButton.MouseButton1Click:Connect(function()
    lagServerActive = not lagServerActive
    
    local character = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    
    if not character or not backpack then
        warn("❌ Персонаж или инвентарь не найден")
        lagServerActive = false
        return
    end
    
    local darkMatterSlap = backpack:FindFirstChild("Dark Matter Slap") or character:FindFirstChild("Dark Matter Slap")
    
    if not darkMatterSlap then
        warn("❌ Dark Matter Slap не найден в инвентаре")
        lagServerActive = false
        lagButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        lagStroke.Color = Color3.fromRGB(100, 200, 255)
        return
    end
    
    if lagServerActive then
        keepDarkMatterEquipped()
        lagButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        lagStroke.Color = Color3.fromRGB(0, 255, 100)
        print("✅ Dark Matter Slap постоянно экипирован")
    else
        stopKeepingEquipped()
        lagButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        lagStroke.Color = Color3.fromRGB(100, 200, 255)
        print("❌ Dark Matter Slap убран")
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    lagServerActive = false
    if lagServerConnection then
        lagServerConnection:Disconnect()
        lagServerConnection = nil
    end
    lagButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    lagStroke.Color = Color3.fromRGB(100, 200, 255)
end)

local telegramBtn = Instance.new("TextButton")
telegramBtn.Size = UDim2.new(1, 0, 0, 32)
telegramBtn.Text = "📱 Telegram"
telegramBtn.Font = Enum.Font.GothamBold
telegramBtn.TextSize = 13
telegramBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
telegramBtn.BackgroundColor3 = Color3.fromRGB(41, 171, 226)
telegramBtn.AutoButtonColor = false
telegramBtn.Parent = buttonContainer

local telegramCorner = Instance.new("UICorner")
telegramCorner.CornerRadius = UDim.new(0, 10)
telegramCorner.Parent = telegramBtn

local telegramStroke = Instance.new("UIStroke")
telegramStroke.Color = Color3.fromRGB(64, 196, 255)
telegramStroke.Thickness = 2
telegramStroke.Parent = telegramBtn

telegramBtn.MouseButton1Click:Connect(function()
    if setclipboard then 
        setclipboard("https://t.me/scriptmausrb")
    elseif toclipboard then 
        toclipboard("https://t.me/scriptmausrb") 
    end
    local originalText = telegramBtn.Text
    telegramBtn.Text = "✅ Скопировано!"
    task.wait(2)
    telegramBtn.Text = originalText
end)


local uiVisible = false
toggleButton.MouseButton1Click:Connect(function()
    uiVisible = not uiVisible
    mainFrame.Visible = uiVisible
    

    if uiVisible then
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        mainFrame:TweenSize(
            UDim2.new(0, 200, 0, 340),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Back,
            0.3,
            true
        )
    end
end)


do
    local RunService = game:GetService("RunService")
    local speedConn
    local baseSpeed = 27
    local active = false
    
    local function GetCharacter()
        local Char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local HRP = Char:WaitForChild("HumanoidRootPart")
        local Hum = Char:FindFirstChildOfClass("Humanoid")
        return Char, HRP, Hum
    end
    
    local function getMovementInput()
        local Char, HRP, Hum = GetCharacter()
        if not Char or not HRP or not Hum then return Vector3.new(0,0,0) end
        local moveVector = Hum.MoveDirection
        if moveVector.Magnitude > 0.1 then
            return Vector3.new(moveVector.X, 0, moveVector.Z).Unit
        end
        return Vector3.new(0,0,0)
    end
    
    local function startSpeedControl()
        if speedConn then return end
        speedConn = RunService.Heartbeat:Connect(function()
            local Char, HRP, Hum = GetCharacter()
            if not Char or not HRP or not Hum then return end
            local inputDirection = getMovementInput()
            if inputDirection.Magnitude > 0 then
                HRP.AssemblyLinearVelocity = Vector3.new(
                    inputDirection.X * baseSpeed,
                    HRP.AssemblyLinearVelocity.Y,
                    inputDirection.Z * baseSpeed
                )
            else
                HRP.AssemblyLinearVelocity = Vector3.new(0, HRP.AssemblyLinearVelocity.Y, 0)
            end
        end)
    end
    
    local function stopSpeedControl()
        if speedConn then 
            speedConn:Disconnect() 
            speedConn = nil 
        end
        local Char, HRP = GetCharacter()
        if HRP then 
            HRP.AssemblyLinearVelocity = Vector3.new(0, HRP.AssemblyLinearVelocity.Y, 0) 
        end
    end
    
    speedButton.MouseButton1Click:Connect(function()
        active = not active
        if active then
            startSpeedControl()
            speedButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            speedStroke.Color = Color3.fromRGB(0, 255, 100)
        else
            stopSpeedControl()
            speedButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            speedStroke.Color = Color3.fromRGB(100, 200, 255)
        end
    end)
end


local function setTransparencySpecific(part, transparency)
    if part and part:IsA("BasePart") then
        if not part:GetAttribute("OriginalTransparency") then
            part:SetAttribute("OriginalTransparency", part.Transparency)
        end
        if not part:GetAttribute("OriginalCanCollide") then
            part:SetAttribute("OriginalCanCollide", part.CanCollide)
        end
        part.Transparency = transparency
        part.CanCollide = false
    end
end

local function processAnimalPodium(podium)
    local claim = podium:FindFirstChild("Claim")
    if claim then
        local hitbox = claim:FindFirstChild("Hitbox")
        if hitbox then
            pcall(function()
                if not hitbox:GetAttribute("OriginalTransparency") then
                    hitbox:SetAttribute("OriginalTransparency", hitbox.Transparency)
                    hitbox:SetAttribute("OriginalCanCollide", hitbox.CanCollide)
                end
                hitbox.Transparency = 0.5
                hitbox.CanCollide = false
            end)
        end
    end
    
    local base = podium:FindFirstChild("Base")
    if base then
        local spawn = base:FindFirstChild("Spawn")
        setTransparencySpecific(spawn, 0.5)
        local decorations = base:FindFirstChild("Decorations")
        if decorations then
            for _, child in pairs(decorations:GetChildren()) do
                if child:IsA("BasePart") then
                    setTransparencySpecific(child, 0.5)
                end
            end
        end
    end
end

do
    local runService = game:GetService("RunService")
    local platform, connection
    local active = false
    local isRising = false
    local RISE_SPEED = 15
    
    local function destroyPlatform()
        if platform then 
            platform:Destroy() 
            platform = nil 
        end
        isRising = false
        if connection then 
            connection:Disconnect() 
            connection = nil 
        end
    end
    
    local function canRise()
        if not platform then return false end
        local origin = platform.Position + Vector3.new(0, platform.Size.Y / 2, 0)
        local direction = Vector3.new(0, 2, 0)
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {platform, LocalPlayer.Character}
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        return not workspace:Raycast(origin, direction, rayParams)
    end
    
    local function createPlatform()
        local character = LocalPlayer.Character
        if not character then return end
        
        local root = character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
       
        destroyPlatform()
        
        
        platform = Instance.new("Part")
        platform.Size = Vector3.new(6, 0.5, 6)
        platform.Anchored = true
        platform.CanCollide = true
        platform.Transparency = 0
        platform.Material = Enum.Material.Neon
        platform.Color = Color3.fromRGB(100, 200, 255)
        platform.Position = root.Position - Vector3.new(0, root.Size.Y / 2 + platform.Size.Y / 2, 0)
        platform.Parent = workspace
        
        local platformCorner = Instance.new("UICorner")
        platformCorner.CornerRadius = UDim.new(0, 10)
        platformCorner.Parent = platform
        
       
        local plots = workspace:FindFirstChild("Plots")
        if plots then
            for _, plot in pairs(plots:GetChildren()) do
                for _, part in pairs(plot:GetDescendants()) do
                    if part:IsA("BasePart") and (part.Name:lower():find("base") or part.Name:lower():find("plot")) then
                        part.Transparency = 0.5
                    end
                end
                
                local animalPodiums = plot:FindFirstChild("AnimalPodiums")
                if animalPodiums then
                    for _, podium in pairs(animalPodiums:GetChildren()) do
                        if podium:IsA("Model") or podium:IsA("Folder") then
                            processAnimalPodium(podium)
                        end
                    end
                end
            end
        end
        
        isRising = true
        
      
        connection = runService.Heartbeat:Connect(function(dt)
            if platform and active and root then
                local cur = platform.Position
                local newXZ = Vector3.new(root.Position.X, cur.Y, root.Position.Z)
                
                if isRising and canRise() then
                    platform.Position = newXZ + Vector3.new(0, dt * RISE_SPEED, 0)
                else
                    isRising = false
                    platform.Position = newXZ
                end
            end
        end)
    end
    
    floorButton.MouseButton1Click:Connect(function()
        active = not active
        
        if active then
            createPlatform()
            floorButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            floorStroke.Color = Color3.fromRGB(0, 255, 100)
        else
            destroyPlatform()
            active = false
            floorButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            floorStroke.Color = Color3.fromRGB(100, 200, 255)
        end
    end)
    
 
    LocalPlayer.CharacterAdded:Connect(function()
        destroyPlatform()
        active = false
        floorButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        floorStroke.Color = Color3.fromRGB(100, 200, 255)
    end)
end


do
    local RunService = game:GetService("RunService")
    local guidedOn = false
    local guidedConn
    
    fpsButton.MouseButton1Click:Connect(function()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hum = char:FindFirstChildOfClass("Humanoid")
        guidedOn = not guidedOn
        
        if guidedOn then
            fpsButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            fpsStroke.Color = Color3.fromRGB(0, 255, 100)
            
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                guidedConn = RunService.RenderStepped:Connect(function()
                    if guidedOn and hrp then
                        hrp.Velocity = workspace.CurrentCamera.CFrame.LookVector * 25
                    end
                end)
            end
        else
            fpsButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            fpsStroke.Color = Color3.fromRGB(100, 200, 255)
            
            if guidedConn then 
                guidedConn:Disconnect() 
                guidedConn = nil 
            end
            if hum then 
                hum:ChangeState(Enum.HumanoidStateType.GettingUp) 
            end
        end
    end)
end


do
    local BOX_COLOR = Color3.fromRGB(100, 200, 255)
    local BOX_TRANSPARENCY = 0.7
    
    local function createESP(character, player)
        if character:FindFirstChild("HumanoidRootPart") then
            local hrp = character.HumanoidRootPart
            
            local box = Instance.new("BoxHandleAdornment")
            box.Size = character:GetExtentsSize()
            box.Adornee = character
            box.Color3 = BOX_COLOR
            box.Transparency = BOX_TRANSPARENCY
            box.AlwaysOnTop = true
            box.ZIndex = 5
            box.Parent = hrp
            
            local nameBillboard = Instance.new("BillboardGui")
            nameBillboard.Adornee = hrp
            nameBillboard.Size = UDim2.new(0, 100, 0, 20)
            nameBillboard.StudsOffset = Vector3.new(0, 3, 0)
            nameBillboard.AlwaysOnTop = true
            nameBillboard.Parent = hrp
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 1, 0)
            nameLabel.BackgroundTransparency = 0.3
            nameLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
            nameLabel.Text = player.Name
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.TextSize = 12
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.TextStrokeTransparency = 0
            nameLabel.Parent = nameBillboard
            
            local nameCorner = Instance.new("UICorner")
            nameCorner.CornerRadius = UDim.new(0, 6)
            nameCorner.Parent = nameLabel
        end
    end
    
    local function onCharacterAdded(character, player)
        task.wait(1)
        createESP(character, player)
    end
    
    local function onPlayerAdded(player)
        if player ~= LocalPlayer then
            if player.Character then 
                onCharacterAdded(player.Character, player) 
            end
            player.CharacterAdded:Connect(function(char)
                onCharacterAdded(char, player)
            end)
        end
    end
    
    for _, p in ipairs(Players:GetPlayers()) do 
        onPlayerAdded(p) 
    end
    Players.PlayerAdded:Connect(onPlayerAdded)
end
