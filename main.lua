-- // PS99 Ultimate Pro Hub - Final Fixed & Clean Edition
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

-- Clean up any old existing GUI versions instantly
if playerGui:FindFirstChild("PS99UltimateProHub") then playerGui.PS99UltimateProHub:Destroy() end
if CoreGui:FindFirstChild("PS99UltimateProHub") then CoreGui.PS99UltimateProHub:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PS99UltimateProHub"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

pcall(function()
	screenGui.Parent = CoreGui
end)
if not screenGui.Parent then
	screenGui.Parent = playerGui
end

-- Main Window Container (Modern Dark Theme)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 440)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -220)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(138, 43, 226)
stroke.Thickness = 2
stroke.Parent = mainFrame

-- Top Title Bar
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "⚡ PET SIMULATOR 99 // PRO HUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 13
title.Parent = mainFrame

-- Scroll Frame for Clean List Layout
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -16, 1, -60)
scrollFrame.Position = UDim2.new(0, 8, 0, 55)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 400)
scrollFrame.ScrollBarThickness = 3
scrollFrame.Parent = mainFrame

local uiList = Instance.new("UIListLayout")
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0, 8)
uiList.Parent = scrollFrame

local function createButton(text, color, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -8, 0, 42)
	btn.BackgroundColor3 = color or Color3.fromRGB(35, 35, 50)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 12
	btn.Text = text
	btn.AutoButtonColor = true
	btn.Parent = scrollFrame
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = btn
	
	-- Robust input connections to guarantee click firing across executors
	btn.MouseButton1Click:Connect(callback)
	btn.MouseButton1Down:Connect(callback)
	btn.Activated:Connect(callback)
	
	return btn
end

-- 1. SPEED BOOST
local speedActive = false
local speedBtn
speedBtn = createButton("Speed Boost: OFF", Color3.fromRGB(45, 45, 65), function()
	speedActive = not speedActive
	speedBtn.Text = speedActive and "Speed Boost: ON (32)" or "Speed Boost: OFF"
	speedBtn.BackgroundColor3 = speedActive and Color3.fromRGB(40, 160, 80) or Color3.fromRGB(45, 45, 65)
	
	if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
		player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = speedActive and 32 or 16
	end
end)

-- 2. NOCLIP
local noclipActive = false
local noclipBtn
noclipBtn = createButton("Toggle Noclip: OFF", Color3.fromRGB(45, 45, 65), function()
	noclipActive = not noclipActive
	noclipBtn.Text = noclipActive and "Toggle Noclip: ON" or "Toggle Noclip: OFF"
	noclipBtn.BackgroundColor3 = noclipActive and Color3.fromRGB(40, 160, 80) or Color3.fromRGB(45, 45, 65)
end)

RunService.Stepped:Connect(function()
	if noclipActive and player.Character then
		for _, part in ipairs(player.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

-- 3. INFINITE JUMP
local infJumpActive = false
local infJumpBtn
infJumpBtn = createButton("Infinite Jump: OFF", Color3.fromRGB(45, 45, 65), function()
	infJumpActive = not infJumpActive
	infJumpBtn.Text = infJumpActive and "Infinite Jump: ON" or "Infinite Jump: OFF"
	infJumpBtn.BackgroundColor3 = infJumpActive and Color3.fromRGB(40, 160, 80) or Color3.fromRGB(45, 45, 65)
end)

UserInputService.JumpRequest:Connect(function()
	if infJumpActive and player.Character then
		local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end)

-- 4. FULLBRIGHT
local fullbrightActive = false
local brightBtn
brightBtn = createButton("Fullbright: OFF", Color3.fromRGB(45, 45, 65), function()
	fullbrightActive = not fullbrightActive
	brightBtn.Text = fullbrightActive and "Fullbright: ON" or "Fullbright: OFF"
	brightBtn.BackgroundColor3 = fullbrightActive and Color3.fromRGB(40, 160, 80) or Color3.fromRGB(45, 45, 65)
	
	Lighting.Brightness = fullbrightActive and 2 or 1
	Lighting.ClockTime = fullbrightActive and 14 or 12
	Lighting.GlobalShadows = not fullbrightActive
end)

-- 5. AUTO FISHING / REEL-IN LOOP
local autoFishActive = false
local fishBtn
fishBtn = createButton("Auto Fishing: OFF", Color3.fromRGB(45, 45, 65), function()
	autoFishActive = not autoFishActive
	fishBtn.Text = autoFishActive and "Auto Fishing: ON" or "Auto Fishing: OFF"
	fishBtn.BackgroundColor3 = autoFishActive and Color3.fromRGB(40, 160, 80) or Color3.fromRGB(45, 45, 65)
end)

task.spawn(function()
	while true do
		task.wait(0.25)
		if autoFishActive then
			pcall(function()
				-- Automatically looks for fishing mini-game remotes or triggers network functions
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

-- 6. RESET CHARACTER
createButton("Reset Character", Color3.fromRGB(180, 50, 50), function()
	if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
		player.Character:FindFirstChildOfClass("Humanoid").Health = 0
	end
end)

-- 7. REJOIN SERVER
createButton("Rejoin Server", Color3.fromRGB(100, 50, 180), function()
	TeleportService:Teleport(game.PlaceId, player)
end)

print("[PS99 Ultimate Pro Hub]: Successfully Loaded with Auto Fishing!")
