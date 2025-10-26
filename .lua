local Services = setmetatable({}, {
    __index = function(self, key)
        local Service = game:GetService(key)
        rawset(self, key, Service)
        return Service
    end
})

local TweenService = Services.TweenService
local Players = Services.Players
local RunService = Services.RunService
local ReplicatedStorage = Services.ReplicatedStorage
local LocalPlayer = Players.LocalPlayer
local workspace = game:GetService("Workspace")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "IceHubModernUI"
screenGui.ResetOnSpawn = false
local GUIParent = game:GetService("CoreGui")
if gethui then GUIParent = gethui() end
screenGui.Parent = GUIParent

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 240, 0, 280)
mainFrame.Position = UDim2.new(0.5, -120, 0.5, -140)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
mainFrame.BackgroundTransparency = 0
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true 
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(0, 200, 255)
mainStroke.Thickness = 2
mainStroke.Transparency = 0.2
mainStroke.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🧊 ICE HUB | C-69"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextYAlignment = Enum.TextYAlignment.Center
titleLabel.Parent = mainFrame

local titleLine = Instance.new("Frame")
titleLine.Size = UDim2.new(1, 0, 0, 2)
titleLine.Position = UDim2.new(0, 0, 0, 30)
titleLine.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
titleLine.BorderSizePixel = 0
titleLine.Parent = mainFrame

local buttonContainer = Instance.new("Frame")
buttonContainer.Size = UDim2.new(1, -10, 1, -40)
buttonContainer.Position = UDim2.new(0, 5, 0, 35)
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
    button.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    button.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 200, 255)
    stroke.Thickness = 1
    stroke.Transparency = 0.7
    stroke.Parent = button
    
    button.Parent = buttonContainer
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.1), {Transparency = 0.5}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        if button.BackgroundColor3 == Color3.fromRGB(0, 150, 75) then return end
        TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(25, 25, 30)}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.1), {Transparency = 0.7}):Play()
    end)
    
    return button, stroke
end


local speedButton, speedStroke = createButton("Speed Boost (x1.5)", "⚡") -- ИЗМЕНЕНО: 1.5x
local floorButton, floorStroke = createButton("3rd Floor Glitch", "🏢")
local extraButton, extraStroke = createButton("Invisible - Desync", "🔄")
local lagButton, lagStroke = createButton("Lag Server (Need Aura)", "💥")

local antiLagLabel = Instance.new("TextLabel")
antiLagLabel.Size = UDim2.new(1, 0, 0, 20)
antiLagLabel.Text = "🧹 Anti-Lag: ACTIVE (Auto)"
antiLagLabel.Font = Enum.Font.Gotham
antiLagLabel.TextSize = 10
antiLagLabel.TextColor3 = Color3.fromRGB(0, 150, 75)
antiLagLabel.BackgroundTransparency = 1
antiLagLabel.Parent = buttonContainer


local telegramBtn = Instance.new("TextButton")
telegramBtn.Size = UDim2.new(1, 0, 0, 28)
telegramBtn.Text = "📱 Telegram: @scriptmausrb"
telegramBtn.Font = Enum.Font.GothamBold
telegramBtn.TextSize = 12
telegramBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
telegramBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
telegramBtn.AutoButtonColor = false
telegramBtn.Parent = buttonContainer

local telegramCorner = Instance.new("UICorner")
telegramCorner.CornerRadius = UDim.new(0, 6)
telegramCorner.Parent = telegramBtn

telegramBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard("https://t.me/scriptmausrb")
    elseif toclipboard then
        toclipboard("https://t.me/scriptmausrb")
    end
    local originalText = telegramBtn.Text
    telegramBtn.Text = "✅ Ссылка скопирована!"
    task.wait(2)
    telegramBtn.Text = originalText
end)

local function cleanPlayer(player)
    local character = player.Character
    if not character then return end

    for _, item in pairs(character:GetChildren()) do
        if item:IsA("Accessory") or item:IsA("Hat") then
            item:Destroy()
        end
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        for _, item in pairs(humanoid:GetChildren()) do
            if item:IsA("Shirt") or item:IsA("Pants") or item:IsA("TShirt") then
                item:Destroy()
            end
        end
    end
end

task.spawn(function()
    while true do
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                cleanPlayer(player)
            end
        end
        task.wait(0.5)
    end
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)
        cleanPlayer(player)
    end)
end)

LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(1)
    cleanPlayer(LocalPlayer)
end)

local ACTIVE_COLOR = Color3.fromRGB(0, 150, 75)
local INACTIVE_COLOR = Color3.fromRGB(25, 25, 30)
local STROKE_COLOR = Color3.fromRGB(0, 200, 255)

local function toggleButtonState(button, stroke, isActive)
    if isActive then
        button.BackgroundColor3 = ACTIVE_COLOR
        stroke.Color = ACTIVE_COLOR
        stroke.Transparency = 0.3
    else
        button.BackgroundColor3 = INACTIVE_COLOR
        stroke.Color = STROKE_COLOR
        stroke.Transparency = 0.7
    end
end

do
    local speedConn
    local baseSpeed = 24 -- ИЗМЕНЕНО: 24 (1.5x от 16)
    local active = false
    
    local function GetCharacter()
        local Char = LocalPlayer.Character
        local HRP = Char and Char:FindFirstChild("HumanoidRootPart")
        local Hum = Char and Char:FindFirstChildOfClass("Humanoid")
        return Char, HRP, Hum
    end
    
    local function startSpeedControl()
        if speedConn then return end
        speedConn = RunService.Heartbeat:Connect(function()
            local Char, HRP, Hum = GetCharacter()
            if not Char or not HRP or not Hum then return end
            
            local moveVector = Hum.MoveDirection
            if moveVector.Magnitude > 0.1 then
                local inputDirection = Vector3.new(moveVector.X, 0, moveVector.Z).Unit
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
        if speedConn then  speedConn:Disconnect(); speedConn = nil end
        local Char, HRP = GetCharacter()
        if HRP then  HRP.AssemblyLinearVelocity = Vector3.new(0, HRP.AssemblyLinearVelocity.Y, 0) end
    end
    
    speedButton.MouseButton1Click:Connect(function()
        active = not active
        toggleButtonState(speedButton, speedStroke, active)
        if active then
            startSpeedControl()
        else
            stopSpeedControl()
        end
    end)
end

do
    local platform, connection
    local active = false
    local isRising = false
    local RISE_SPEED = 15
    
    local function destroyPlatform()
        if platform then platform:Destroy(); platform = nil end
        isRising = false
        if connection then connection:Disconnect(); connection = nil end
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
        
        local function canRise()
            if not platform then return false end
            local origin = platform.Position + Vector3.new(0, platform.Size.Y / 2, 0)
            local direction = Vector3.new(0, 2, 0)
            local rayParams = RaycastParams.new()
            rayParams.FilterDescendantsInstances = {platform, LocalPlayer.Character}
            rayParams.FilterType = Enum.RaycastFilterType.Exclude
            return not workspace:Raycast(origin, direction, rayParams)
        end
        
        isRising = true
        
        connection = RunService.Heartbeat:Connect(function(dt)
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
        else
            destroyPlatform()
        end
        toggleButtonState(floorButton, floorStroke, active)
    end)
    
    LocalPlayer.CharacterAdded:Connect(function()
        destroyPlatform()
        active = false
        toggleButtonState(floorButton, floorStroke, false)
    end)
end

do
    local desyncActive = false
    
    local function enableMobileDesync()
        local success = pcall(function()
            local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local humanoid = character:WaitForChild("Humanoid")
            local backpack = LocalPlayer:WaitForChild("Backpack")
            
            local netFolder = ReplicatedStorage:FindFirstChild("Packages") and ReplicatedStorage.Packages:FindFirstChild("Net")
            if not netFolder then return end
            
            local useItemRemote = netFolder:FindFirstChild("RE/UseItem", true)
            local teleportRemote = netFolder:FindFirstChild("RE/QuantumCloner/OnTeleport", true)
            
            if not useItemRemote or not teleportRemote then
                return
            end
            
            local tool
            local toolNames = {"Quantum Cloner", "Brainrot", "brainrot"}
            for _, toolName in ipairs(toolNames) do
                tool = backpack:FindFirstChild(toolName) or character:FindFirstChild(toolName)
                if tool then break end
            end
            
            if tool and tool.Parent == backpack then humanoid:EquipTool(tool); task.wait(0.3) end
            
            if setfflag then setfflag("WorldStepMax", "-9999999999") end
            
            task.spawn(function() useItemRemote:FireServer() end)
            task.wait(0.1)
            task.spawn(function() teleportRemote:FireServer() end)
            task.wait(1)
            
            if setfflag then setfflag("WorldStepMax", "-1") end
            
        end)
        return success
    end
    
    local function disableMobileDesync()
        pcall(function()
            if setfflag then setfflag("WorldStepMax", "-1") end
        end)
    end
    
    extraButton.MouseButton1Click:Connect(function()
        desyncActive = not desyncActive
        if desyncActive then
            local success = enableMobileDesync()
            if success then
                toggleButtonState(extraButton, extraStroke, true)
            else
                desyncActive = false
                toggleButtonState(extraButton, extraStroke, false)
            end
        else
            disableMobileDesync()
            toggleButtonState(extraButton, extraStroke, false)
        end
    end)

    LocalPlayer.CharacterAdded:Connect(function()
        desyncActive = false
        toggleButtonState(extraButton, extraStroke, false)
    end)
end

do
    local lagServerActive = false
    local lagServerConnection
    
    local function keepDarkMatterEquipped()
        if lagServerConnection then return end
        
        lagServerConnection = RunService.Heartbeat:Connect(function()
            if not lagServerActive then return end
            
            local character = LocalPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
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
            lagServerActive = false
            return
        end
        
        local darkMatterSlap = backpack:FindFirstChild("Dark Matter Slap") or character:FindFirstChild("Dark Matter Slap")
        
        if not darkMatterSlap then
            lagServerActive = false
            toggleButtonState(lagButton, lagStroke, false)
            return
        end
        
        if lagServerActive then
            keepDarkMatterEquipped()
            toggleButtonState(lagButton, lagStroke, true)
        else
            stopKeepingEquipped()
            toggleButtonState(lagButton, lagStroke, false)
        end
    end)
    
    LocalPlayer.CharacterAdded:Connect(function()
        lagServerActive = false
        if lagServerConnection then lagServerConnection:Disconnect(); lagServerConnection = nil end
        toggleButtonState(lagButton, lagStroke, false)
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
            if player.Character then onCharacterAdded(player.Character, player) end
            player.CharacterAdded:Connect(function(char)
                onCharacterAdded(char, player)
            end)
        end
    end
    
    for _, p in ipairs(Players:GetPlayers()) do onPlayerAdded(p) end
    Players.PlayerAdded:Connect(onPlayerAdded)
end
