-- سكريبت: X-Ray شامل + نقل النقر التلقائي + Noclip (اختراق الجدران)
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
    -- أضف آلية الضرب المناسبة هنا
end

userInput.TouchTap:Connect(function(touch)
    local target, dist = getClosestPlayerToScreenPoint(touch.Position.X, touch.Position.Y)
    if target and dist < 80 then
        clickOnPlayer(target)
    end
end)

mouse.Button1Down:Connect(function()
    local target, dist = getClosestPlayerToScreenPoint(mouse.X, mouse.Y)
    if target and dist < 80 then
        clickOnPlayer(target)
    end
end)

-- ================= 4. اختراق الجدران (Noclip) =================
local function enableNoclip()
    local character = player.Character
    if not character then return end
    
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

local function noclipLoop()
    while true do
        enableNoclip()
        wait(0.2) -- تحديث سريع
    end
end

-- تشغيل Noclip فوراً
spawn(noclipLoop)

-- إعادة تطبيق Noclip عند تغيير الشخصية (إذا مات اللاعب)
player.CharacterAdded:Connect(function()
    wait(1)
    enableNoclip()
end)

print("✅ السكريبت يعمل: X-Ray + نقل النقر التلقائي + Noclip (اختراق الجدران)")
