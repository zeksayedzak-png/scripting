-- سكريبت: X-Ray + عرض محتويات الحقيبة فوق الرأس (تحديث 0.2 ثانية)
local player = game.Players.LocalPlayer
local userInput = game:GetService("UserInputService")
local mouse = player:GetMouse()

-- ================= 1. X-Ray على اللاعبين =================
local function addPlayerHighlight(character)
    local highlight = character:FindFirstChild("Highlight")
    if highlight then highlight:Destroy() end
    highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
    highlight.FillTransparency = 0.4
    highlight.Adornee = character
    highlight.Parent = character
end

local function refreshHighlights()
    for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            addPlayerHighlight(otherPlayer.Character)
        end
    end
end

refreshHighlights()
spawn(function()
    while true do
        wait(2)
        refreshHighlights()
    end
end)

-- ================= 2. عرض محتويات الحقيبة فوق الرأس =================
local function getPlayerItems(targetPlayer)
    local items = {}
    -- 1. العتاد (Backpack)
    for _, item in ipairs(targetPlayer.Backpack:GetChildren()) do
        if item:IsA("Tool") then
            table.insert(items, item.Name)
        end
    end
    -- 2. المعدات الحالية (Character)
    if targetPlayer.Character then
        for _, item in ipairs(targetPlayer.Character:GetChildren()) do
            if item:IsA("Tool") then
                table.insert(items, item.Name)
            end
        end
    end
    -- 3. عملات (leaderstats)
    local leaderstats = targetPlayer:FindFirstChild("leaderstats")
    if leaderstats then
        for _, stat in ipairs(leaderstats:GetChildren()) do
            if stat:IsA("IntValue") or stat:IsA("NumberValue") then
                table.insert(items, stat.Name .. ": " .. stat.Value)
            end
        end
    end
    return items
end

local function createBillboard(player)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ItemDisplay"
    billboard.Size = UDim2.new(0, 200, 0, 60)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = player.Character:FindFirstChild("Head")
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextStrokeTransparency = 0
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.GothamBold
    textLabel.Parent = billboard
    
    return billboard, textLabel
end

local function updateBillboard(player, textLabel)
    local items = getPlayerItems(player)
    local displayText = ""
    for i, item in ipairs(items) do
        if i > 4 then
            displayText = displayText .. "\n..." 
            break
        end
        displayText = displayText .. "\n📦 " .. item
    end
    if displayText == "" then
        displayText = "📭 فارغ"
    end
    textLabel.Text = displayText
end

-- إنشاء اللوحات وتحديثها
for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
    if otherPlayer ~= player and otherPlayer.Character then
        local head = otherPlayer.Character:FindFirstChild("Head")
        if head then
            local billboard, textLabel = createBillboard(otherPlayer)
            updateBillboard(otherPlayer, textLabel)
            -- تحديث دوري سريع (كل 0.2 ثانية)
            spawn(function()
                while billboard and billboard.Parent do
                    wait(0.2)
                    updateBillboard(otherPlayer, textLabel)
                end
            end)
        end
    end
end

-- مراقبة إضافة لاعبين جدد
game.Players.PlayerAdded:Connect(function(newPlayer)
    if newPlayer == player then return end
    newPlayer.CharacterAdded:Connect(function(character)
        wait(1) -- انتظر تحميل الشخصية
        local head = character:FindFirstChild("Head")
        if head then
            local billboard, textLabel = createBillboard(newPlayer)
            updateBillboard(newPlayer, textLabel)
            spawn(function()
                while billboard and billboard.Parent do
                    wait(0.2)
                    updateBillboard(newPlayer, textLabel)
                end
            end)
        end
    end)
end)

-- ================= 3. نقل النقر التلقائي (بدون أزرار) =================
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
    -- أضف حدث الضرب الخاص بلعبتك هنا
end

-- للهاتف
userInput.TouchTap:Connect(function(touch)
    local target, dist = getClosestPlayerToScreenPoint(touch.Position.X, touch.Position.Y)
    if target and dist < 80 then
        clickOnPlayer(target)
        -- دائرة تأكيد
        local circle = Instance.new("ImageLabel")
        circle.Size = UDim2.new(0, 40, 0, 40)
        circle.Position = UDim2.new(0, touch.Position.X - 20, 0, touch.Position.Y - 20)
        circle.Image = "rbxassetid://1458486919"
        circle.BackgroundTransparency = 1
        circle.Parent = player.PlayerGui
        game:GetService("Debris"):AddItem(circle, 0.2)
    end
end)

-- للكمبيوتر
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

print("✅ السكريبت المتطور يعمل: X-Ray + عرض الحقيبة (تحديث 0.2 ثانية) + نقل النقر")
