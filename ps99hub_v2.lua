
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("PS99UltimateProHub") then playerGui.PS99UltimateProHub:Destroy() end
if CoreGui:FindFirstChild("PS99UltimateProHub") then CoreGui.PS99UltimateProHub:Destroy() end

local screenGui = Instance.new("ScreenGui", CoreGui)
screenGui.Name = "PS99UltimateProHub"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 320, 0, 440)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -220)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
mainFrame.BorderSizePixel = 0
mainFrame.Active, mainFrame.Draggable = true, true

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 14)
local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(138, 43, 226)
stroke.Thickness = 2

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "⚡ PET SIMULATOR 99 // PRO HUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font, title.TextSize = Enum.Font.GothamBold, 13

local scrollFrame = Instance.new("ScrollingFrame", mainFrame)
scrollFrame.Size = UDim2.new(1, -16, 1, -60)
scrollFrame.Position = UDim2.new(0, 8, 0, 55)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 400)
scrollFrame.ScrollBarThickness = 3

local uiList = Instance.new("UIListLayout", scrollFrame)
uiList.SortOrder, uiList.Padding = Enum.SortOrder.LayoutOrder, UDim.new(0, 8)

local function createButton(text, color, callback)
	local btn = Instance.new("TextButton", scrollFrame)
	btn.Size, btn.BackgroundColor3 = UDim2.new(1, -8, 0, 42), color or Color3.fromRGB(45, 45, 65)
	btn.TextColor3, btn.Font, btn.TextSize, btn.Text = Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 12, text
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	
	btn.MouseButton1Click:Connect(callback)
	btn.MouseButton1Down:Connect(callback)
	btn.Activated:Connect(callback)
	return btn
end

-- 1. SPEED BOOST
local speedActive = false
local speedBtn = createButton("Speed Boost: OFF", nil, function()
	speedActive = not speedActive
	speedBtn.Text = speedActive and "Speed Boost: ON (32)" or "Speed Boost: OFF"
	speedBtn.BackgroundColor3 = speedActive and Color3.fromRGB(40, 160, 80) or Color3.fromRGB(45, 45, 65)
	if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
		player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = speedActive and 32 or 16
	end
end)

-- 2. NOCLIP
local noclipActive = false
local noclipBtn = createButton("Toggle Noclip: OFF", nil, function()
	noclipActive = not noclipActive
	noclipBtn.Text = noclipActive and "Toggle Noclip: ON" or "Toggle Noclip: OFF"
	noclipBtn.BackgroundColor3 = noclipActive and Color3.fromRGB(40, 160, 80) or Color3.fromRGB(45, 45, 65)
end)

RunService.Stepped:Connect(function()
	if noclipActive and player.Character then
		for _, part in ipairs(player.Character:GetDescendants()) do
			if part:IsA("BasePart") then part.CanCollide = false end
		end
	end
end)

-- 3. INFINITE JUMP
local infJumpActive = false
createButton("Infinite Jump: OFF", nil, function()
	infJumpActive = not infJumpActive
end)

UserInputService.JumpRequest:Connect(function()
	if infJumpActive and player.Character then
		local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
	end
end)

-- 4. FULLBRIGHT
local fullbrightActive = false
createButton("Fullbright: OFF", nil, function()
	fullbrightActive = not fullbrightActive
	Lighting.Brightness = fullbrightActive and 2 or 1
	Lighting.ClockTime = fullbrightActive and 14 or 12
	Lighting.GlobalShadows = not fullbrightActive
end)

-- 5. AUTO FISHING
local autoFishActive = false
local fishBtn = createButton("Auto Fishing: OFF", nil, function()
	autoFishActive = not autoFishActive
	fishBtn.Text = autoFishActive and "Auto Fishing: ON" or "Auto Fishing: OFF"
	fishBtn.BackgroundColor3 = autoFishActive and Color3.fromRGB(40, 160, 80) or Color3.fromRGB(45, 45, 65)
end)

task.spawn(function()
	while true do
		task.wait(0.25)
		if autoFishActive then
			pcall(function()
				for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
					if remote:IsA("RemoteEvent") and (remote.Name:lower():find("fish") or remote.Name:lower():find("minigame") or remote.Name:lower():find("rod")) then
						remote:FireServer("Click")
						remote:FireServer(true)
					end
				end
			end)
		end
	end
end)

-- 6. UTILITIES
createButton("Reset Character", Color3.fromRGB(180, 50, 50), function()
	if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
		player.Character:FindFirstChildOfClass("Humanoid").Health = 0
	end
end)

createButton("Rejoin Server", Color3.fromRGB(100, 50, 180), function()
	TeleportService:Teleport(game.PlaceId, player)
end)

print("[PS99 Pro Hub]: Successfully Loaded Directly!")
