-- سكريبت: X-Ray + 3 Teleports (كل مكان مستقل)
local player = game.Players.LocalPlayer

-- 1. إنشاء واجهة (ScreenGui)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "XRayTeleport"
screenGui.Parent = player.PlayerGui

-- 2. الإطار الرئيسي (قابل للتحريك)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 260, 0, 160)
mainFrame.Position = UDim2.new(0.5, -130, 0.7, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BackgroundTransparency = 0.5
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(0, 255, 0)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- 3. زر X-Ray (تشغيل/إيقاف)
local xrayButton = Instance.new("TextButton")
xrayButton.Size = UDim2.new(0, 240, 0, 30)
xrayButton.Position = UDim2.new(0.5, -120, 0, 5)
xrayButton.Text = "🔘 تفعيل الـ X-Ray"
xrayButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
xrayButton.TextColor3 = Color3.fromRGB(0, 0, 0)
xrayButton.Font = Enum.Font.GothamBold
xrayButton.TextSize = 14
xrayButton.Parent = mainFrame

-- 4. متغيرات التخزين (ثلاثة أماكن مختلفة)
local savedPos1 = nil
local savedPos2 = nil
local savedPos3 = nil

local activeXRay = false

-- دوال X-Ray
local function addHighlight(character)
    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
    highlight.FillTransparency = 0.5
    highlight.Adornee = character
    highlight.Parent = character
end

local function removeHighlights()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Highlight") then
            obj:Destroy()
        end
    end
end

local function refreshXRay()
    removeHighlights()
    if not activeXRay then return end
    for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            addHighlight(otherPlayer.Character)
        end
    end
end

xrayButton.MouseButton1Click:Connect(function()
    activeXRay = not activeXRay
    if activeXRay then
        xrayButton.Text = "🔴 إيقاف الـ X-Ray"
        xrayButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        refreshXRay()
        spawn(function()
            while activeXRay do
                refreshXRay()
                wait(2)
            end
        end)
    else
        xrayButton.Text = "🔘 تفعيل الـ X-Ray"
        xrayButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        removeHighlights()
    end
end)

-- وظيفة النقل الآمن
local function teleportTo(position)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = CFrame.new(position)
    end
end

-- ===================== المستطيل الأول =====================
local slot1 = Instance.new("Frame")
slot1.Size = UDim2.new(0, 240, 0, 30)
slot1.Position = UDim2.new(0.5, -120, 0, 45)
slot1.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
slot1.BackgroundTransparency = 0.3
slot1.BorderSizePixel = 1
slot1.BorderColor3 = Color3.fromRGB(0, 255, 0)
slot1.Parent = mainFrame

local save1 = Instance.new("TextButton")
save1.Size = UDim2.new(0, 110, 0, 26)
save1.Position = UDim2.new(0.5, -115, 0, 2)
save1.Text = "💾 حفظ 1"
save1.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
save1.TextColor3 = Color3.fromRGB(0, 0, 0)
save1.Font = Enum.Font.GothamBold
save1.TextSize = 11
save1.Parent = slot1

local tele1 = Instance.new("TextButton")
tele1.Size = UDim2.new(0, 110, 0, 26)
tele1.Position = UDim2.new(0.5, 5, 0, 2)
tele1.Text = "🌀 تنقل 1"
tele1.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
tele1.TextColor3 = Color3.fromRGB(255, 255, 255)
tele1.Font = Enum.Font.GothamBold
tele1.TextSize = 11
tele1.Parent = slot1

save1.MouseButton1Click:Connect(function()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        savedPos1 = hrp.Position
        save1.Text = "✅ حفظ 1"
        wait(1)
        save1.Text = "💾 حفظ 1"
    end
end)

tele1.MouseButton1Click:Connect(function()
    if savedPos1 then
        teleportTo(savedPos1)
        tele1.Text = "✅ تم"
        wait(1)
        tele1.Text = "🌀 تنقل 1"
    else
        tele1.Text = "⚠️ احفظ أولاً"
        wait(1)
        tele1.Text = "🌀 تنقل 1"
    end
end)

-- ===================== المستطيل الثاني =====================
local slot2 = Instance.new("Frame")
slot2.Size = UDim2.new(0, 240, 0, 30)
slot2.Position = UDim2.new(0.5, -120, 0, 80)
slot2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
slot2.BackgroundTransparency = 0.3
slot2.BorderSizePixel = 1
slot2.BorderColor3 = Color3.fromRGB(0, 255, 0)
slot2.Parent = mainFrame

local save2 = Instance.new("TextButton")
save2.Size = UDim2.new(0, 110, 0, 26)
save2.Position = UDim2.new(0.5, -115, 0, 2)
save2.Text = "💾 حفظ 2"
save2.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
save2.TextColor3 = Color3.fromRGB(0, 0, 0)
save2.Font = Enum.Font.GothamBold
save2.TextSize = 11
save2.Parent = slot2

local tele2 = Instance.new("TextButton")
tele2.Size = UDim2.new(0, 110, 0, 26)
tele2.Position = UDim2.new(0.5, 5, 0, 2)
tele2.Text = "🌀 تنقل 2"
tele2.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
tele2.TextColor3 = Color3.fromRGB(255, 255, 255)
tele2.Font = Enum.Font.GothamBold
tele2.TextSize = 11
tele2.Parent = slot2

save2.MouseButton1Click:Connect(function()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        savedPos2 = hrp.Position
        save2.Text = "✅ حفظ 2"
        wait(1)
        save2.Text = "💾 حفظ 2"
    end
end)

tele2.MouseButton1Click:Connect(function()
    if savedPos2 then
        teleportTo(savedPos2)
        tele2.Text = "✅ تم"
        wait(1)
        tele2.Text = "🌀 تنقل 2"
    else
        tele2.Text = "⚠️ احفظ أولاً"
        wait(1)
        tele2.Text = "🌀 تنقل 2"
    end
end)

-- ===================== المستطيل الثالث =====================
local slot3 = Instance.new("Frame")
slot3.Size = UDim2.new(0, 240, 0, 30)
slot3.Position = UDim2.new(0.5, -120, 0, 115)
slot3.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
slot3.BackgroundTransparency = 0.3
slot3.BorderSizePixel = 1
slot3.BorderColor3 = Color3.fromRGB(0, 255, 0)
slot3.Parent = mainFrame

local save3 = Instance.new("TextButton")
save3.Size = UDim2.new(0, 110, 0, 26)
save3.Position = UDim2.new(0.5, -115, 0, 2)
save3.Text = "💾 حفظ 3"
save3.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
save3.TextColor3 = Color3.fromRGB(0, 0, 0)
save3.Font = Enum.Font.GothamBold
save3.TextSize = 11
save3.Parent = slot3

local tele3 = Instance.new("TextButton")
tele3.Size = UDim2.new(0, 110, 0, 26)
tele3.Position = UDim2.new(0.5, 5, 0, 2)
tele3.Text = "🌀 تنقل 3"
tele3.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
tele3.TextColor3 = Color3.fromRGB(255, 255, 255)
tele3.Font = Enum.Font.GothamBold
tele3.TextSize = 11
tele3.Parent = slot3

save3.MouseButton1Click:Connect(function()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        savedPos3 = hrp.Position
        save3.Text = "✅ حفظ 3"
        wait(1)
        save3.Text = "💾 حفظ 3"
    end
end)

tele3.MouseButton1Click:Connect(function()
    if savedPos3 then
        teleportTo(savedPos3)
        tele3.Text = "✅ تم"
        wait(1)
        tele3.Text = "🌀 تنقل 3"
    else
        tele3.Text = "⚠️ احفظ أولاً"
        wait(1)
        tele3.Text = "🌀 تنقل 3"
    end
end)

-- تعليمات
local instruction = Instance.new("TextLabel")
instruction.Size = UDim2.new(0, 240, 0, 14)
instruction.Position = UDim2.new(0.5, -120, 0, 145)
instruction.Text = "اضغط مع الاستمرار لتحريك النافذة"
instruction.BackgroundTransparency = 1
instruction.TextColor3 = Color3.fromRGB(0, 255, 0)
instruction.TextSize = 9
instruction.Font = Enum.Font.Gotham
instruction.Parent = mainFrame

print("✅ السكريبت جاهز - 3 أماكن مستقلة + X-Ray")
