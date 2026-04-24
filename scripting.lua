-- سكريبت: نقل الضغطة إلى أقرب عدو
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local userInput = game:GetService("UserInputService")

-- واجهة تحكم (تشغيل/إيقاف)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ClickTransfer"
screenGui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0, 50)
frame.Position = UDim2.new(0.5, -90, 0.8, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.5
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(0, 255, 0)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 160, 0, 30)
toggleButton.Position = UDim2.new(0.5, -80, 0.5, -15)
toggleButton.Text = "🔘 نقل النقر OFF"
toggleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 12
toggleButton.Parent = frame

local active = false

-- وظيفة البحث عن أقرب لاعب إلى نقطة على الشاشة
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

-- وظيفة محاكاة الضغط على اللاعب
local function clickOnPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    local hrp = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        -- طريقتان لمحاكاة الضغط:
        -- 1. إرسال RemoteEvent (إذا كانت اللعبة تستخدمه)
        -- 2. محاكاة ضغطة الماوس فوق الجسم (غير فعال في معظم ألعاب Roblox لأن الضغط يعتمد على واجهة اللاعب)
        -- الحل الأكثر واقعية: استدعاء دالة الضرب مباشرة (إذا عرفت اسمها)
        print("🔫 تم ضرب:", targetPlayer.Name)
        -- مثال: (لو اللعبة تستخدم Remote)
        -- game:GetService("ReplicatedStorage"):FindFirstChild("Hit"):FireServer(targetPlayer.Character)
    end
end

-- بديل عملي (للهاتف): استخدام Touch
userInput.TouchTap:Connect(function(touch)
    if not active then return end
    local screenPos = touch.Position
    local target, dist = getClosestPlayerToScreenPoint(screenPos.X, screenPos.Y)
    if target and dist < 80 then
        clickOnPlayer(target)
        -- إظهار دائرة حمراء لتأكيد النقل
        local circle = Instance.new("ImageLabel")
        circle.Size = UDim2.new(0, 40, 0, 40)
        circle.Position = UDim2.new(0, screenPos.X - 20, 0, screenPos.Y - 20)
        circle.Image = "rbxassetid://1458486919"
        circle.BackgroundTransparency = 1
        circle.Parent = screenGui
        game:GetService("Debris"):AddItem(circle, 0.2)
    end
end)

-- للكمبيوتر (نقر الماوس)
mouse.Button1Down:Connect(function()
    if not active then return end
    local target, dist = getClosestPlayerToScreenPoint(mouse.X, mouse.Y)
    if target and dist < 80 then
        clickOnPlayer(target)
        -- دائرة حمراء
        local circle = Instance.new("ImageLabel")
        circle.Size = UDim2.new(0, 40, 0, 40)
        circle.Position = UDim2.new(0, mouse.X - 20, 0, mouse.Y - 20)
        circle.Image = "rbxassetid://1458486919"
        circle.BackgroundTransparency = 1
        circle.Parent = screenGui
        game:GetService("Debris"):AddItem(circle, 0.2)
    end
end)

-- تشغيل/إيقاف
toggleButton.MouseButton1Click:Connect(function()
    active = not active
    if active then
        toggleButton.Text = "🔘 نقل النقر ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    else
        toggleButton.Text = "🔘 نقل النقر OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    end
end)

print("✅ سكريبت نقل النقر يعمل - اضغط على زر التشغيل")
