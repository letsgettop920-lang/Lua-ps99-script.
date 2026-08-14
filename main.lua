-- // Pet Simulator 99 (PS99) - Working Features Hub
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("PS99UltimateHub") then playerGui.PS99UltimateHub:Destroy() end
if CoreGui:FindFirstChild("PS99UltimateHub") then CoreGui.PS99UltimateHub:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PS99UltimateHub"
screenGui.ResetOnSpawn = false
pcall(function() screenGui.Parent = CoreGui end)
if not screenGui.Parent then screenGui.Parent = playerGui end

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

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundTransparency = 1
title.Text = "🐾 PS99 // Working Hub"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 13
title.Parent = mainFrame

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -12, 1, -55)
scrollFrame.Position = UDim2.new(0, 6, 0, 50)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 460)
scrollFrame.ScrollBarThickness = 4
scrollFrame.Parent = mainFrame

local function createButton(text, yPos, color, callback)
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
	
	btn.MouseButton1Down:Connect(callback)
	btn.Activated:Connect(callback)
	
	return btn
end

-- 1. FIXED AUTO-FARM (Scans __THINGS folder where PS99 stores breakables)
local autoFarmActive = false
local farmBtn
farmBtn = createButton("Auto-Farm Breakables: OFF", 0, Color3.fromRGB(200, 50, 50), function()
	autoFarmActive = not autoFarmActive
	farmBtn.Text = autoFarmActive and "Auto-Farm Breakables: ON" or "Auto-Farm Breakables: OFF"
	farmBtn.BackgroundColor3 = autoFarmActive and Color3.fromRGB(40, 180, 90) or Color3.fromRGB(200, 50, 50)
end)

RunService.RenderStepped:Connect(function()
	if autoFarmActive then
		pcall(function()
			local char = player.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				-- PS99 stores breakables inside Workspace.__THINGS.Breakables
				local things = Workspace:FindFirstChild("__THINGS")
				if things then
					local breakables = things:FindFirstChild("Breakables")
					if breakables then
						for _, v in ipairs(breakables:GetChildren()) do
							if v:IsA("Model") and v.PrimaryPart then
								char.HumanoidRootPart.CFrame = v.PrimaryPart.CFrame
								task.wait(0.1)
								break
							end
						end
					end
				end
			end
		end)
	end
end)

-- 2. FIXED AUTO-FISHING (Fires client fishing actions if available)
local autoFishActive = false
local fishBtn
fishBtn = createButton("Auto-Fishing: OFF", 44, Color3.fromRGB(200, 50, 50), function()
	autoFishActive = not autoFishActive
	fishBtn.Text = autoFishActive and "Auto-Fishing: ON" or "Auto-Fishing: OFF"
	fishBtn.BackgroundColor3 = autoFishActive and Color3.fromRGB(40, 180, 90) or Color3.fromRGB(200, 50, 50)
end)

task.spawn(function()
	while true do
		task.wait(0.2)
		if autoFishActive then
			pcall(function()
				-- Automatically looks for fishing remotes in the game network
				for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
					if remote:IsA("RemoteEvent") and (remote.Name:lower():find("fish") or remote.Name:lower():find("minigame")) then
						remote:FireServer("Click")
						remote:FireServer(true)
					end
				end
				-- Backup click simulation for center screen
				VirtualUser:Button1Down(Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2))
				task.wait(0.05)
				VirtualUser:Button1Up(Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2))
			end)
		end
	end
end)

-- 3. AUTO-CLAIM REWARDS
local autoClaimActive = false
local claimBtn
claimBtn = createButton("Auto-Claim Rewards: OFF", 88, Color3.fromRGB(50, 120, 255), function()
	autoClaimActive = not autoClaimActive
	claimBtn.Text = autoClaimActive and "Auto-Claim Rewards: ON" or "Auto-Claim Rewards: OFF"
	claimBtn.BackgroundColor3 = autoClaimActive and Color3.fromRGB(40, 180, 90) or Color3.fromRGB(50, 120, 255)
end)

task.spawn(function()
	while true do
		task.wait(3)
		if autoClaimActive then
			pcall(function()
				for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
					if remote:IsA("RemoteEvent") and (remote.Name:lower():find("gift") or remote.Name:lower():find("reward")) then
						remote:FireServer()
					end
				end
			end)
		end
	end
end)

-- 4. SPEED BOOST
local speedActive = false
local speedBtn
speedBtn = createButton("Speed Boost: OFF", 132, Color3.fromRGB(70, 70, 90), function()
	speedActive = not speedActive
	speedBtn.Text = speedActive and "Speed Boost: ON (32)" or "Speed Boost: OFF"
	speedBtn.BackgroundColor3 = speedActive and Color3.fromRGB(40, 180, 90) or Color3.fromRGB(70, 70, 90)
	
	if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
		player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = speedActive and 32 or 16
	end
end)

-- 5. NOCLIP
local noclipActive = false
local noclipBtn
noclipBtn = createButton("Toggle Noclip: OFF", 176, Color3.fromRGB(70, 70, 90), function()
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
createButton("Anti-AFK Enabled (Active)", 220, Color3.fromRGB(40, 180, 90), function()
	print("Anti-AFK active.")
end)

-- 7. RESET CHARACTER
createButton("Reset Character", 264, Color3.fromRGB(180, 50, 50), function()
	if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
		player.Character:FindFirstChildOfClass("Humanoid").Health = 0
	end
end)

-- 8. REJOIN SERVER
createButton("Rejoin Server", 308, Color3.fromRGB(100, 50, 180), function()
	TeleportService:Teleport(game.PlaceId, player)
end)

print("[PS99 Ultimate Hub]: All features fully hooked up!")
