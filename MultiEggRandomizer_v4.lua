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

-- Create toggle switch UI
local toggleFrame = Instance.new("Frame")
toggleFrame.Name = "ToggleFrame"
toggleFrame.Size = UDim2.new(0, 60, 0, 30)
toggleFrame.Position = UDim2.new(1, -70, 0, 10)
toggleFrame.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
toggleFrame.BorderSizePixel = 0
toggleFrame.AnchorPoint = Vector2.new(1, 0)
toggleFrame.Parent = screenGui
toggleFrame.BackgroundTransparency = 0.15
toggleFrame.ZIndex = 2
toggleFrame.ClipsDescendants = true
toggleFrame.AutomaticSize = Enum.AutomaticSize.None
local uiCorner = Instance.new("UICorner", toggleFrame)
uiCorner.CornerRadius = UDim.new(1, 0)

local knob = Instance.new("Frame")
knob.Size = UDim2.new(0, 26, 0, 26)
knob.Position = UDim2.new(0, 2, 0, 2)
knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
knob.BorderSizePixel = 0
knob.Parent = toggleFrame
knob.ZIndex = 3
local knobCorner = Instance.new("UICorner", knob)
knobCorner.CornerRadius = UDim.new(1, 0)

-- Enable click handling on toggle
toggleFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        active = not active
        -- Animate the knob
        local tweenService = game:GetService("TweenService")
        local goal = {}
        local bgGoal = {}

        if active then
            goal.Position = UDim2.new(1, -28, 0, 2)
            bgGoal.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        else
            goal.Position = UDim2.new(0, 2, 0, 2)
            bgGoal.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        end

        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        tweenService:Create(knob, tweenInfo, goal):Play()
        tweenService:Create(toggleFrame, tweenInfo, bgGoal):Play()
    end
end)

-- Setup for toggle sound effects
local toggleOnSound = Instance.new("Sound")
toggleOnSound.Name = "ToggleOnBoom"
toggleOnSound.SoundId = "rbxassetid://9118823102"  -- Deep bass boom (on)
toggleOnSound.Volume = 1
toggleOnSound.Parent = toggleFrame

local toggleOffSound = Instance.new("Sound")
toggleOffSound.Name = "ToggleOffDoom"
toggleOffSound.SoundId = "rbxassetid://130790104"  -- Dark impact (off)
toggleOffSound.Volume = 1
toggleOffSound.Parent = toggleFrame

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
    label.Text = text
    boards[egg] = bb
end


-- Main update loop: shows only the category name
task.spawn(function()
    while true do
        if active then
            local eggs = findEggs()
            local category = drop.Text:match("^Category: (.+)$") or "Common"
            for _, egg in pairs(eggs) do
                show(egg, category)
                playSound()
            end
            wait(spinInterval)
        else
            wait(1)
        end
    end
end)
