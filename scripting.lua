-- سكريبت: X-Ray شامل + نقل النقر التلقائي + قائمة لاعبين يدوية
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local userInput = game:GetService("UserInputService")

-- ================= 1. X-Ray على اللاعبين =================
local function addPlayerHighlight(character)
    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
    highlight.FillTransparency = 0.4
    highlight.Adornee = character
    highlight.Parent = character
end

local function refreshPlayerHighlights()
    for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local oldHighlight = otherPlayer.Character:FindFirstChild("Highlight")
            if oldHighlight then oldHighlight:Destroy() end
            addPlayerHighlight(otherPlayer.Character)
        end
    end
end

refreshPlayerHighlights()
spawn(function()
    while true do
        wait(2)
        refreshPlayerHighlights()
    end
end)

-- ================= 2. X-Ray على الأسلحة =================
local function addWeaponHighlight(weapon)
    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(0, 255, 0)
    highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
    highlight.FillTransparency = 0.3
    highlight.Adornee = weapon
    highlight.Parent = weapon
end

local function refreshWeaponHighlights()
    for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local character = otherPlayer.Character
            for _, child in ipairs(character:GetChildren()) do
                if child:IsA("Tool") or child:IsA("BasePart") and (child.Name:lower():find("knife") or child.Name:lower():find("gun")) then
                    local oldHighlight = child:FindFirstChild("Highlight")
                    if oldHighlight then oldHighlight:Destroy() end
                    addWeaponHighlight(child)
                end
            end
        end
    end
end

refreshWeaponHighlights()
spawn(function()
    while true do
        wait(2)
        refreshWeaponHighlights()
    end
end)

-- ================= 3. نقل النقر التلقائي =================
local function getClosestPlayerToScreenPoint(x, y)
    local camera = workspace.CurrentCamera
    local closestPlayer = nil
    local closestDist = math.huge

    for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local hrp = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local screenPos, onScreen = camera:WorldToScreenPoint(hrp.Position)
                if onScreen then
                    local dist = (Vector2.new(x, y) - Vector2.new(screenPos.X, screenPos.Y)).magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closestPlayer = otherPlayer
                    end
                end
            end
        end
    end
    return closestPlayer, closestDist
end

local function clickOnPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    print("🔫 تم ضرب:", targetPlayer.Name)
    -- مثال: لو اللعبة تستخدم RemoteEvent
    -- local hitEvent = game:GetService("ReplicatedStorage"):FindFirstChild("Hit")
    -- if hitEvent then hitEvent:FireServer(targetPlayer.Character) end
end

userInput.TouchTap:Connect(function(touch)
    local target, dist = getClosestPlayerToScreenPoint(touch.Position.X, touch.Position.Y)
    if target and dist < 80 then
        clickOnPlayer(target)
        local circle = Instance.new("ImageLabel")
        circle.Size = UDim2.new(0, 40, 0, 40)
        circle.Position = UDim2.new(0, touch.Position.X - 20, 0, touch.Position.Y - 20)
        circle.Image = "rbxassetid://1458486919"
        circle.BackgroundTransparency = 1
        circle.Parent = player.PlayerGui
        game:GetService("Debris"):AddItem(circle, 0.2)
    end
end)

mouse.Button1Down:Connect(function()
    local target, dist = getClosestPlayerToScreenPoint(mouse.X, mouse.Y)
    if target and dist < 80 then
        clickOnPlayer(target)
        local circle = Instance.new("ImageLabel")
        circle.Size = UDim2.new(0, 40, 0, 40)
        circle.Position = UDim2.new(0, mouse.X - 20, 0, mouse.Y - 20)
        circle.Image = "rbxassetid://1458486919"
        circle.BackgroundTransparency = 1
        circle.Parent = player.PlayerGui
        game:GetService("Debris"):AddItem(circle, 0.2)
    end
end)

-- ================= 4. القائمة اليدوية (أسماء اللاعبين + زر ضرب) =================
local playerListGui = Instance.new("ScreenGui")
playerListGui.Name = "PlayerListGUI"
playerListGui.Parent = player.PlayerGui

local listFrame = Instance.new("Frame")
listFrame.Size = UDim2.new(0, 180, 0, 250)
listFrame.Position = UDim2.new(0.05, 0, 0.2, 0) -- يسار الشاشة
listFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
listFrame.BackgroundTransparency = 0.4
listFrame.BorderSizePixel = 2
listFrame.BorderColor3 = Color3.fromRGB(0, 255, 0)
listFrame.Active = true
listFrame.Draggable = true
listFrame.Parent = playerListGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 25)
title.Text = "🎯 قائمة اللاعبين"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(0, 255, 0)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = listFrame

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, 0, 1, -50)
scrollingFrame.Position = UDim2.new(0, 0, 0, 30)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.ScrollBarThickness = 8
scrollingFrame.Parent = listFrame

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.Name
listLayout.Padding = UDim.new(0, 2)
listLayout.Parent = scrollingFrame

local hitButton = Instance.new("TextButton")
hitButton.Size = UDim2.new(0, 100, 0, 30)
hitButton.Position = UDim2.new(0.5, -50, 1, -40)
hitButton.Text = "🔫 احتر (يدوي)"
hitButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
hitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
hitButton.Font = Enum.Font.GothamBold
hitButton.TextSize = 12
hitButton.Parent = listFrame

local selectedPlayer = nil

-- وظيفة تحديث القائمة
local function updatePlayerList()
    for _, child in ipairs(scrollingFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player then
            local nameButton = Instance.new("TextButton")
            nameButton.Size = UDim2.new(1, -10, 0, 25)
            nameButton.Text = otherPlayer.Name
            nameButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            nameButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameButton.Font = Enum.Font.Gotham
            nameButton.TextSize = 12
            nameButton.Parent = scrollingFrame
            
            nameButton.MouseButton1Click:Connect(function()
                selectedPlayer = otherPlayer
                for _, btn in ipairs(scrollingFrame:GetChildren()) do
                    if btn:IsA("TextButton") then
                        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                    end
                end
                nameButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
                print("✅ تم اختيار:", selectedPlayer.Name)
            end)
        end
    end
    
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
end

updatePlayerList()
game.Players.PlayerAdded:Connect(updatePlayerList)
game.Players.PlayerRemoved:Connect(updatePlayerList)

-- زر الضرب اليدوي
hitButton.MouseButton1Click:Connect(function()
    if selectedPlayer then
        clickOnPlayer(selectedPlayer)
        print("🔫 ضرب يدوي على:", selectedPlayer.Name)
        -- دائرة تأكيد مؤقتة
        local confirm = Instance.new("TextLabel")
        confirm.Size = UDim2.new(0, 150, 0, 30)
        confirm.Position = UDim2.new(0.5, -75, 0.5, -15)
        confirm.Text = "✅ تم ضرب " .. selectedPlayer.Name
        confirm.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        confirm.TextColor3 = Color3.fromRGB(0, 0, 0)
        confirm.Font = Enum.Font.GothamBold
        confirm.TextSize = 14
        confirm.Parent = player.PlayerGui
        game:GetService("Debris"):AddItem(confirm, 1)
    else
        print("⚠️ لم يتم اختيار لاعب")
        local warn = Instance.new("TextLabel")
        warn.Size = UDim2.new(0, 200, 0, 30)
        warn.Position = UDim2.new(0.5, -100, 0.5, -15)
        warn.Text = "⚠️ اختر لاعباً أولاً"
        warn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        warn.TextColor3 = Color3.fromRGB(255, 255, 255)
        warn.Font = Enum.Font.GothamBold
        warn.TextSize = 14
        warn.Parent = player.PlayerGui
        game:GetService("Debris"):AddItem(warn, 1)
    end
end)

print("✅ السكريبت يعمل: X-Ray + نقل النقر التلقائي + قائمة لاعبين يدوية")
