-- BloodyEggRandomizer.lua
-- Created by Blood.lust

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local egg = workspace:WaitForChild("Egg") -- Adjust if the egg model has a different name
local rewards = {"Legendary Plant", "Golden Seeds", "Mega Water", "Bloody Pet", "XP Boost"}
local active = true
local currentBillboard
local debounce = false

-- Create UI Button
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local ToggleBtn = Instance.new("TextButton", ScreenGui)

ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 10, 0, 100)
ToggleBtn.Text = "🅱️"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Name = "BloodEggToggle"

ToggleBtn.MouseButton1Click:Connect(function()
	active = not active
	ToggleBtn.BackgroundColor3 = active and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(50, 50, 50)
end)

-- Create Billboard GUI
local function showReward(text)
	if currentBillboard then currentBillboard:Destroy() end

	local bb = Instance.new("BillboardGui", egg)
	bb.Size = UDim2.new(0, 200, 0, 50)
	bb.StudsOffset = Vector3.new(0, 2, 0)
	bb.AlwaysOnTop = true

	local label = Instance.new("TextLabel", bb)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.Text = text
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(200, 0, 0)
	label.TextStrokeTransparency = 0
	label.Font = Enum.Font.GothamBold
	label.TextScaled = true

	currentBillboard = bb
end

-- Spin logic every 10 seconds
task.spawn(function()
	while true do
		if active and not debounce then
			debounce = true
			local reward = rewards[math.random(1, #rewards)]
			showReward("🎁 " .. reward)
			wait(10)
			debounce = false
		else
			wait(1)
		end
	end
end)
