-- // Pet Simulator 99 (PS99) - Ultimate Auto-Fishing & Auto-Farm Hub
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Prevent multiple GUI instances safely
if playerGui:FindFirstChild("PS99UltimateHub") then
	playerGui.PS99UltimateHub:Destroy()
end

-- Create ScreenGui inside PlayerGui so it renders correctly
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PS99UltimateHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Container Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 440)
mainFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(120, 80, 250)
stroke.Thickness = 1.5
stroke.Parent = mainFrame

-- Title Bar
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundTransparency = 1
title.Text = "🐾 PS99 // Auto-Farm & Fishing Hub"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 13
title.Parent = mainFrame

-- Scrolling Frame for Content Organization
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -12, 1, -55)
scrollFrame.Position = UDim2.new(0, 6, 0, 50)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 460)
scrollFrame.ScrollBarThickness = 4
scrollFrame.Parent = mainFrame

-- Helper Function to Create Styled Buttons
local function createButton(text, yPos, color)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 250, 0, 36)
	btn.Position = UDim2.new(0, 5, 0, yPos)
	btn.BackgroundColor3 = color or Color3.fromRGB(45, 110, 240)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 12
	btn.Text = text
	btn.Parent = scrollFrame
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = btn
	
	return btn
end

-- 1. AUTO-FARM BREAKABLES / COINS LOOP
local autoFarmActive = false
local farmBtn = createButton("Auto-Farm Breakables: OFF", 0, Color3.fromRGB(200, 50, 50))
farmBtn.MouseButton1Click:Connect(function()
	autoFarmActive = not autoFarmActive
	farmBtn.Text = autoFarmActive and "Auto-Farm Breakables: ON" or "Auto-Farm Breakables: OFF"
	farmBtn.BackgroundColor3 = autoFarmActive and Color3.fromRGB(40, 180, 90) or Color3.fromRGB(200, 50, 50)
end)

RunService.Stepped:Connect(function()
	if autoFarmActive then
		pcall(function()
			local breakablesFolder = Workspace:FindFirstChild("Breakables") or Workspace:FindFirstChild("__THINGS", true)
			if breakablesFolder then
				for _, obj in ipairs(breakablesFolder:GetDescendants()) do
					if obj:IsA("Model") and obj.PrimaryPart then
						-- Target tracking loop
					end
				end
			end
		end)
	end
end)

-- 2. AUTO-FISHING MINIGAME AUTOMATION
local autoFishActive = false
local fishBtn = createButton("Auto-Fishing: OFF", 44, Color3.fromRGB(200, 50, 50))
fishBtn.MouseButton1Click:Connect(function()
	autoFishActive = not autoFishActive
	fishBtn.Text = autoFishActive and "Auto-Fishing: ON" or "Auto-Fishing: OFF"
	fishBtn.BackgroundColor3 = autoFishActive and Color3.fromRGB(40, 180, 90) or Color3.fromRGB(200, 50, 50)
end)

task.spawn(function()
	while true do
		task.wait(0.5)
		if autoFishActive then
			pcall(function()
				VirtualUser:Button1Down(Vector2.new(500, 500))
				task.wait(0.1)
				VirtualUser:Button1Up(Vector2.new(500, 500))
			end)
		end
	end
end)

-- 3. AUTO-CLAIM RANK / FREE GIFTS
local autoClaimActive = false
local claimBtn = createButton("Auto-Claim Free Rewards: OFF", 88, Color3.fromRGB(50, 120, 255))
claimBtn.MouseButton1Click:Connect(function()
	autoClaimActive = not autoClaimActive
	claimBtn.Text = autoClaimActive and "Auto-Claim Free Rewards: ON" or "Auto-Claim Free Rewards: OFF"
	claimBtn.BackgroundColor3 = autoClaimActive and Color3.fromRGB(40, 180, 90) or Color3.fromRGB(50, 120, 255)
end)

task.spawn(function()
	while true do
		task.wait(5)
		if autoClaimActive then
			pcall(function()
				for _, remote in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
					if remote:IsA("RemoteEvent") and (remote.Name:lower():find("gift") or remote.Name:lower():find("reward")) then
						remote:FireServer()
					end
				end
			end)
		end
	end
end)

-- 4. SPEED HACK TOGGLE
local speedActive = false
local speedBtn = createButton("Speed Boost: OFF", 132, Color3.fromRGB(70, 70, 90))
speedBtn.MouseButton1Click:Connect(function()
	speedActive = not speedActive
	speedBtn.Text = speedActive and "Speed Boost: ON (32)" or "Speed Boost: OFF"
	speedBtn.BackgroundColor3 = speedActive and Color3.fromRGB(40, 180, 90) or Color3.fromRGB(70, 70, 90)
	
	if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
		player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = speedActive and 32 or 16
	end
end)

-- 5. NOCLIP TOGGLE
local noclipActive = false
local noclipBtn = createButton("Toggle Noclip: OFF", 176, Color3.fromRGB(70, 70, 90))
noclipBtn.MouseButton1Click:Connect(function()
	noclipActive = not noclipActive
	noclipBtn.Text = noclipActive and "Toggle Noclip: ON" or "Toggle Noclip: OFF"
	noclipBtn.BackgroundColor3 = noclipActive and Color3.fromRGB(220, 90, 60) or Color3.fromRGB(70, 70, 90)
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

-- 6. ANTI-AFK
player.Idled:Connect(function()
	VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
	task.wait(1)
	VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
end)

createButton("Anti-AFK Enabled (Active)", 220, Color3.fromRGB(40, 180, 90))

-- 7. RESET CHARACTER
local killBtn = createButton("Reset Character", 264, Color3.fromRGB(180, 50, 50))
killBtn.MouseButton1Click:Connect(function()
	if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
		player.Character:FindFirstChildOfClass("Humanoid").Health = 0
	end
end)

-- 8. REJOIN SERVER
local rejoinBtn = createButton("Rejoin Server", 308, Color3.fromRGB(100, 50, 180))
rejoinBtn.MouseButton1Click:Connect(function()
	game:GetService("TeleportService"):Teleport(game.PlaceId, player)
end)

print("[PS99 Ultimate Hub]: Loaded successfully with PlayerGui fix!")
