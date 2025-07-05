-- MultiEggRandomizer_v4.lua
-- Created by Blood.lust (@terist999)
-- Includes Common, Uncommon, Rare, Legendary, Mythical, Divine, Anti-Bee, Lunar Glow, Unobtainable categories
-- Dropdown to select pet category, plus toggle (🅱️), sound, and 10s timer

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Pet lists by category
local petCategories = {
    ["Common"] = {
        "Bunny", "Dog", "Golden Lab"
    },
    ["Uncommon"] = {
        "Black Bunny", "Cat", "Chicken", "Deer"
    },
    ["Rare"] = {
        "Monkey", "Orange Tabby", "Pig", "Rooster", "Spotted Deer"
    },
    ["Legendary"] = {
        "Cow", "Polar Bear", "Sea Otter", "Silver Monkey", "Turtle"
    },
    ["Mythical"] = {
        "Brown Mouse", "Caterpillar", "Giant Ant", "Grey Mouse", "Praying Mantis",
        "Red Fox", "Red Giant Ant", "Snail", "Squirrel"
    },
    ["Divine"] = {
        "Dragonfly", "Honey Bee", "Bear Bee", "Petal Bee", "Queen Bee"
    },
    ["Anti‑Bee"] = {
        "Wasp", "Tarantula Hawk", "Moth", "Butterfly", "Disco Bee"
    },
    ["Lunar Glow"] = {
        "Hedgehog", "Kiwi", "Frog", "Mole", "Moon Cat", "Blood Kiwi",
        "Echo Frog", "Night Owl", "Raccoon"
    },
    ["Unobtainable"] = {
        "Panda", "Blood Hedgehog", "Chicken Zombie", "Firefly",
        "Owl", "Golden Bee", "Cooked Owl", "Blood Owl"
    }
}

-- UI settings
local spinInterval = 10
local active = true
local soundId = "rbxassetid://12222124" -- pop sound

-- Create ScreenGui
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "BloodEggRandomizerGUI"

-- Dropdown for categories
local categories = {}
for name in pairs(petCategories) do categories[#categories + 1] = name end
table.sort(categories)

local drop = Instance.new("TextButton", gui)
drop.Size = UDim2.new(0, 120, 0, 30)
drop.Position = UDim2.new(0, 10, 0, 10)
drop.Font = Enum.Font.GothamBold
drop.TextScaled = true
drop.Text = "Category: Common"
drop.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
drop.TextColor3 = Color3.new(1, 1, 1)

local list = Instance.new("Frame", gui)
list.Position = drop.Position + UDim2.new(0, 0, 0, 30)
list.Size = UDim2.new(0, 120, 0, #categories * 30)
list.Visible = false
list.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
list.BorderSizePixel = 0

for i, name in ipairs(categories) do
    local btn = Instance.new("TextButton", list)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.Position = UDim2.new(0, 0, 0, (i - 1) * 30)
    btn.Font = Enum.Font.Gotham
    btn.TextScaled = true
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.AutoButtonColor = false
    btn.MouseButton1Click:Connect(function()
        drop.Text = "Category: " .. name
        list.Visible = false
    end)
end

drop.MouseButton1Click:Connect(function()
    list.Visible = not list.Visible
end)

-- Toggle button
local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0, 50, 0, 50)
btn.Position = UDim2.new(0, 10, 0, 50)
btn.Text = "🅱️"
btn.Font = Enum.Font.GothamBold
btn.TextScaled = true
btn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
btn.TextColor3 = Color3.new(1, 1, 1)
btn.AutoButtonColor = false

btn.MouseEnter:Connect(function()
    btn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
end)
btn.MouseLeave:Connect(function()
    btn.BackgroundColor3 = active and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(50, 50, 50)
end)

btn.MouseButton1Click:Connect(function()
    active = not active
    btn.BackgroundColor3 = active and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(50, 50, 50)
end)

-- Sound function
local function playSound()
    local s = Instance.new("Sound", player:WaitForChild("PlayerGui"))
    s.SoundId = soundId
    s.Volume = 0.6
    s:Play()
    game:GetService("Debris"):AddItem(s, 3)
end

-- Find eggs
local function findEggs()
    local eggs = {}
    for _, o in pairs(workspace:GetDescendants()) do
        if o:IsA("BasePart") and o.Name:lower():find("egg") then
            eggs[#eggs+1] = o
        end
    end
    return eggs
end

-- Billboard handling
local boards = {}
local function show(egg, text)
    if boards[egg] then boards[egg]:Destroy() end
    local bb = Instance.new("BillboardGui", egg)
    bb.Size = UDim2.new(0, 220, 0, 60)
    bb.StudsOffset = Vector3.new(0, 2, 0)
    bb.AlwaysOnTop = true
    local label = Instance.new("TextLabel", bb)
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBlack
    label.TextScaled = true
    label.TextColor3 = Color3.fromRGB(255,50,50)
    label.TextStrokeColor3 = Color3.new(0,0,0)
    label.TextStrokeTransparency = 0
    label.Text = text
    boards[egg] = bb
end

-- Main loop
task.spawn(function()
    while true do
        if active then
            local eggs = findEggs()
            local cat = drop.Text:match("^Category: (.+)$")
            for _, e in pairs(eggs) do
                local list = petCategories[cat] or petCategories["Common"]
                local pet = list[math.random(1, #list)]
                show(e, pet)
                playSound()
            end
            wait(spinInterval)
        else
            wait(1)
        end
    end
end)
