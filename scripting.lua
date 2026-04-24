-- سكريبت: X-Ray شامل (لاعبين + أسلحة) + نقل النقر التلقائي
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
            -- إزالة الـ Highlight القديم إذا وجد
            local oldHighlight = otherPlayer.Character:FindFirstChild("Highlight")
            if oldHighlight then oldHighlight:Destroy() end
            addPlayerHighlight(otherPlayer.Character)
        end
    end
end

-- تحديث الـ X-Ray كل ثانيتين
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
    highlight.FillColor = Color3.fromRGB(0, 255, 0)  -- لون أخضر للأسلحة (يميزها)
    highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
    highlight.FillTransparency = 0.3
    highlight.Adornee = weapon
    highlight.Parent = weapon
end

local function refreshWeaponHighlights()
    -- البحث عن الأسلحة في أيدي اللاعبين
    for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local character = otherPlayer.Character
            -- الأسلحة غالباً تكون في الـ Character (مثلاً: "Tool" أو "Weapon")
            for _, child in ipairs(character:GetChildren()) do
                if child:IsA("Tool") or child:IsA("BasePart") and child.Name:lower():find("knife") or child.Name:lower():find("gun") then
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
    -- محاكاة الضرب (حسب اللعبة)
    print("🔫 تم ضرب:", targetPlayer.Name)
    -- مثال: لو اللعبة تستخدم RemoteEvent
    -- local hitEvent = game:GetService("ReplicatedStorage"):FindFirstChild("Hit")
    -- if hitEvent then hitEvent:FireServer(targetPlayer.Character) end
end

-- للهاتف (اللمس)
userInput.TouchTap:Connect(function(touch)
    local screenPos = touch.Position
    local target, dist = getClosestPlayerToScreenPoint(screenPos.X, screenPos.Y)
    if target and dist < 80 then
        clickOnPlayer(target)
        -- دائرة تأكيد (اختياري)
        local circle = Instance.new("ImageLabel")
        circle.Size = UDim2.new(0, 40, 0, 40)
        circle.Position = UDim2.new(0, screenPos.X - 20, 0, screenPos.Y - 20)
        circle.Image = "rbxassetid://1458486919"
        circle.BackgroundTransparency = 1
        circle.Parent = game.Players.LocalPlayer.PlayerGui
        game:GetService("Debris"):AddItem(circle, 0.2)
    end
end)

-- للكمبيوتر (الماوس)
mouse.Button1Down:Connect(function()
    local target, dist = getClosestPlayerToScreenPoint(mouse.X, mouse.Y)
    if target and dist < 80 then
        clickOnPlayer(target)
        local circle = Instance.new("ImageLabel")
        circle.Size = UDim2.new(0, 40, 0, 40)
        circle.Position = UDim2.new(0, mouse.X - 20, 0, mouse.Y - 20)
        circle.Image = "rbxassetid://1458486919"
        circle.BackgroundTransparency = 1
        circle.Parent = game.Players.LocalPlayer.PlayerGui
        game:GetService("Debris"):AddItem(circle, 0.2)
    end
end)

print("✅ السكريبت يعمل: X-Ray (لاعبين + أسلحة) + نقل النقر التلقائي")
