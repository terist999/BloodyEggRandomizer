-- MultiEggSpecific_v1.lua
-- Created by Blood.lust (@terist999)
-- Now shows a specific pet per category (no randomization)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- Pet categories with specific first pet as selected
local petCategories = {
    ["Common"] = {"Bunny", "Dog", "Golden Lab"},
    ["Uncommon"] = {"Black Bunny", "Cat", "Chicken", "Deer"},
    ["Rare"] = {"Monkey", "Orange Tabby", "Pig", "Rooster", "Spotted Deer"},
    ["Legendary"] = {"Cow", "Polar Bear", "Sea Otter", "Silver Monkey", "Turtle"},
    ["Mythical"] = {"Brown Mouse", "Caterpillar", "Giant Ant", "Grey Mouse", "Praying Mantis", "Red Fox", "Red Giant Ant", "Snail", "Squirrel"},
    ["Divine"] = {"Dragonfly", "Honey Bee", "Bear Bee", "Petal Bee", "Queen Bee"},
    ["Anti‑Bee"] = {"Wasp", "Tarantula Hawk", "Moth", "Butterfly", "Disco Bee"},
    ["Lunar Glow"] = {"Hedgehog", "Kiwi", "Frog", "Mole", "Moon Cat", "Blood Kiwi", "Echo Frog", "Night Owl", "Raccoon"},
    ["Unobtainable"] = {"Panda", "Blood Hedgehog", "Chicken Zombie", "Firefly", "Owl", "Golden Bee", "Cooked Owl", "Blood Owl"}
}

local selectedCategory = "Common"
local active = true
local cooldown = 10
local lastUsed = 0

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false

local categories = {}
for name in pairs(petCategories) do table.insert(categories, name) end
table.sort(categories)

local drop = Instance.new("TextButton", gui)
drop.Size = UDim2.new(0, 160, 0, 30)
drop.Position = UDim2.new(0, 10, 0, 10)
drop.Font = Enum.Font.GothamBold
drop.TextScaled = true
drop.Text = "Category: Common"
drop.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
drop.TextColor3 = Color3.new(1, 1, 1)

local list = Instance.new("Frame", gui)
list.Size = UDim2.new(0, 160, 0, #categories * 30)
list.Position = UDim2.new(0, 10, 0, 40)
list.Visible = false
list.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

for i, name in ipairs(categories) do
    local btn = Instance.new("TextButton", list)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.Position = UDim2.new(0, 0, 0, (i - 1) * 30)
    btn.Font = Enum.Font.Gotham
    btn.TextScaled = true
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    btn.TextColor3 = Color3.new(1, 1, 1)

    btn.MouseButton1Click:Connect(function()
        selectedCategory = name
        drop.Text = "Category: " .. name
        list.Visible = false
    end)
end

drop.MouseButton1Click:Connect(function()
    list.Visible = not list.Visible
end)

-- Toggle UI (🅱️)
local toggle = Instance.new("TextButton", gui)
toggle.Size = UDim2.new(0, 40, 0, 40)
toggle.Position = UDim2.new(1, -50, 0, 10)
toggle.AnchorPoint = Vector2.new(1, 0)
toggle.Text = "🅱️"
toggle.Font = Enum.Font.GothamBold
toggle.TextScaled = true
toggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
toggle.TextColor3 = Color3.new(1, 1, 1)

toggle.MouseButton1Click:Connect(function()
    active = not active
    toggle.BackgroundColor3 = active and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(255, 0, 0)
end)

-- Show billboard
local function showLabel(egg, pet)
    local old = egg:FindFirstChild("EggLabel")
    if old then old:Destroy() end

    local bb = Instance.new("BillboardGui", egg)
    bb.Name = "EggLabel"
    bb.Size = UDim2.new(0, 160, 0, 50)
    bb.StudsOffset = Vector3.new(0, 2, 0)
    bb.AlwaysOnTop = true

    local label = Instance.new("TextLabel", bb)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true
    label.TextColor3 = Color3.fromRGB(255, 255, 100)
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.Text = pet .. " (" .. selectedCategory .. ")"
end

-- Click egg to reveal pet
workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("BasePart") and obj.Name:lower():find("egg") then
        local click = Instance.new("ClickDetector", obj)
        click.MaxActivationDistance = 20
        click.MouseClick:Connect(function(plr)
            if not active or plr ~= player then return end
            if tick() - lastUsed < cooldown then return end
            lastUsed = tick()

            local pets = petCategories[selectedCategory]
            if pets then
                local pet = pets[1]
                showLabel(obj, pet)
            end
        end)
    end
end)

-- Add ClickDetector to already spawned eggs
for _, egg in pairs(workspace:GetDescendants()) do
    if egg:IsA("BasePart") and egg.Name:lower():find("egg") and not egg:FindFirstChildOfClass("ClickDetector") then
        local click = Instance.new("ClickDetector", egg)
        click.MaxActivationDistance = 20
        click.MouseClick:Connect(function(plr)
            if not active or plr ~= player then return end
            if tick() - lastUsed < cooldown then return end

            lastUsed = tick()
            local pets = petCategories[selectedCategory]
            if pets then
                local pet = pets[1]
                showLabel(egg, pet)
            end
        end)
    end
end
