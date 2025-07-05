-- MultiEggRandomizer.lua
-- Created by Blood.lust (@terist999)
-- Automatically detects all eggs in the workspace
-- Shows random reward text above each egg with toggle and sound
-- Updates every 10 seconds (customizable)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local rewards = {
    "Legendary Plant",
    "Golden Seeds",
    "Mega Water",
    "Bloody Pet",
    "XP Boost"
}

local spinInterval = 10 -- seconds
local active = true

-- Sound ID for reward pop (replace if you want)
local soundId = "rbxassetid://12222124" -- example pop sound

-- UI Setup
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "BloodEggRandomizerGUI"

local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 10, 0, 100)
ToggleBtn.Text = "🅱️"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextScaled = true
ToggleBtn.Name = "BloodEggToggle"
ToggleBtn.AutoButtonColor = false
ToggleBtn.BackgroundTransparency = 0

-- Hover effects
ToggleBtn.MouseEnter:Connect(function()
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
end)
ToggleBtn.MouseLeave:Connect(function()
    ToggleBtn.BackgroundColor3 = active and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(50, 50, 50)
end)

ToggleBtn.MouseButton1Click:Connect(function()
    active = not active
    ToggleBtn.BackgroundColor3 = active and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(50, 50, 50)
end)

-- Find all eggs (any part with "Egg" in the name)
local function findEggs()
    local eggs = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find("egg") then
            table.insert(eggs, obj)
        end
    end
    return eggs
end

-- Create/Update BillboardGui above egg
local billboards = {}

local function showReward(egg, text)
    if billboards[egg] then
        billboards[egg]:Destroy()
        billboards[egg] = nil
    end

    local bb = Instance.new("BillboardGui", egg)
    bb.Size = UDim2.new(0, 220, 0, 60)
    bb.StudsOffset = Vector3.new(0, 2, 0)
    bb.AlwaysOnTop = true

    local label = Instance.new("TextLabel", bb)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = text
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 50, 50)
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.GothamBlack
    label.TextScaled = true
    label.TextWrapped = true

    billboards[egg] = bb
end

-- Play pop sound
local function playSound()
    local sound = Instance.new("Sound", player:WaitForChild("PlayerGui"))
    sound.SoundId = soundId
    sound.Volume = 0.6
    sound:Play()
    game.Debris:AddItem(sound, 3)
end

-- Main loop
task.spawn(function()
    while true do
        if active then
            local eggs = findEggs()
            for _, egg in pairs(eggs) do
                local reward = rewards[math.random(1, #rewards)]
                showReward(egg, "🎁 " .. reward)
                playSound()
            end
            wait(spinInterval)
        else
            wait(1)
        end
    end
end)
