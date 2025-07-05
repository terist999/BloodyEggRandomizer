-- BloodyEggRandomizer.lua (v2)
-- Created by Blood.lust

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local egg = workspace:WaitForChild("Egg") -- Adjust if needed
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
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextScaled = true
ToggleBtn.Name = "BloodEggToggle"
ToggleBtn.AutoButtonColor = false
ToggleBtn.BackgroundTransparency = 0

-- Hover effect
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

-- Create Billboard GUI
local function showReward(text)
	if currentBillboard then
		-- Fade out and remove old billboard
		for i = 1, 10 do
			currentBillboard.TextLabel.TextTransparency = i * 0.1
			currentBillboard.TextLabel.TextStrokeTransparency = i * 0.1
			wait(0.03)
		end
		currentBillboard:Destroy()
		currentBillboard = nil
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

	currentBillboard = bb

	-- Scale animation
	label.TextTransparency = 1
	label.TextStrokeTransparency = 1
	for i = 1, 10 do
		label.TextTransparency = 1 - i * 0.1
		label.TextStrokeTransparency = 1 - i * 0.1
		wait(0.03)
	end
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
