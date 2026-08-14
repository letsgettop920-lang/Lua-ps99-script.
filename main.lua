-- // PS99 Professional Modern Hub
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("PS99ProHub") then playerGui.PS99ProHub:Destroy() end
if CoreGui:FindFirstChild("PS99ProHub") then CoreGui.PS99ProHub:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PS99ProHub"
screenGui.ResetOnSpawn = false
pcall(function() screenGui.Parent = CoreGui end)
if not screenGui.Parent then screenGui.Parent = playerGui end

-- Main Window Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 420)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Gradient Background for Depth
local bgGradient = Instance.new("UIGradient")
bgGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 36)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 18))
})
bgGradient.Rotation = 45
bgGradient.Parent = mainFrame

-- Sleek Glowing Border Stroke
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(138, 43, 226)
stroke.Transparency = 0.3
stroke.Thickness = 1.8
stroke.Parent = mainFrame

-- Top Header Bar
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 48)
topBar.BackgroundTransparency = 1
topBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 1, 0)
title.Position = UDim2.new(0, 16, 0, 0)
title.BackgroundTransparency = 1
title.Text = "✨ PET SIMULATOR 99 // PRO HUB"
title.TextColor3 = Color3.fromRGB(240, 240, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 13
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -24, 0, 1)
divider.Position = UDim2.new(0, 12, 0, 48)
divider.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
divider.BorderSizePixel = 0
divider.Parent = mainFrame

-- Scrolling Content Panel
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -16, 1, -60)
scrollFrame.Position = UDim2.new(0, 8, 0, 54)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 360)
scrollFrame.ScrollBarThickness = 3
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(138, 43, 226)
scrollFrame.Parent = mainFrame

local uiList = Instance.new("UIListLayout")
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0, 8)
uiList.Parent = scrollFrame

local function createButton(text, color, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -8, 0, 40)
	btn.BackgroundColor3 = color or Color3.fromRGB(35, 35, 50)
	btn.TextColor3 = Color3.fromRGB(240, 240, 255)
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 13
	btn.Text = text
	btn.AutoButtonColor = false
	btn.Parent = scrollFrame
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = btn
	
	local btnStroke = Instance.new("UIStroke")
	btnStroke.Color = Color3.fromRGB(60, 60, 90)
	btnStroke.Transparency = 0.5
	btnStroke.Thickness = 1
	btnStroke.Parent = btn
	
	-- Smooth Interactive Hover & Click Effects
	btn.MouseEnter:Connect(function()
		btnStroke.Transparency = 0.1
	end)
	btn.MouseLeave:Connect(function()
		btnStroke.Transparency = 0.5
	end)
	
	btn.MouseButton1Down:Connect(callback)
	btn.Activated:Connect(callback)
	
	return btn
end

-- 1. SPEED BOOST
local speedActive = false
local speedBtn
speedBtn = createButton("Speed Boost: OFF", Color3.fromRGB(35, 35, 50), function()
	speedActive = not speedActive
	speedBtn.Text = speedActive and "Speed Boost: ON (32)" or "Speed Boost: OFF"
	speedBtn.BackgroundColor3 = speedActive and Color3.fromRGB(46, 139, 87) or Color3.fromRGB(35, 35, 50)
	
	if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
		player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = speedActive and 32 or 16
	end
end)

-- 2. NOCLIP
local noclipActive = false
local noclipBtn
noclipBtn = createButton("Toggle Noclip: OFF", Color3.fromRGB(35, 35, 50), function()
	noclipActive = not noclipActive
	noclipBtn.Text = noclipActive and "Toggle Noclip: ON" or "Toggle Noclip: OFF"
	noclipBtn.BackgroundColor3 = noclipActive and Color3.fromRGB(46, 139, 87) or Color3.fromRGB(35, 35, 50)
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
infJumpBtn = createButton("Infinite Jump: OFF", Color3.fromRGB(35, 35, 50), function()
	infJumpActive = not infJumpActive
	infJumpBtn.Text = infJumpActive and "Infinite Jump: ON" or "Infinite Jump: OFF"
	infJumpBtn.BackgroundColor3 = infJumpActive and Color3.fromRGB(46, 139, 87) or Color3.fromRGB(35, 35, 50)
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
brightBtn = createButton("Fullbright: OFF", Color3.fromRGB(35, 35, 50), function()
	fullbrightActive = not fullbrightActive
	brightBtn.Text = fullbrightActive and "Fullbright: ON" or "Fullbright: OFF"
	brightBtn.BackgroundColor3 = fullbrightActive and Color3.fromRGB(46, 139, 87) or Color3.fromRGB(35, 35, 50)
	
	Lighting.Brightness = fullbrightActive and 2 or 1
	Lighting.ClockTime = fullbrightActive and 14 or 12
	Lighting.GlobalShadows = not fullbrightActive
end)

-- 5. RESET CHARACTER
createButton("Reset Character", Color3.fromRGB(139, 34, 34), function()
	if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
		player.Character:FindFirstChildOfClass("Humanoid").Health = 0
	end
end)

-- 6. REJOIN SERVER
createButton("Rejoin Server", Color3.fromRGB(75, 0, 130), function()
	TeleportService:Teleport(game.PlaceId, player)
end)

print("[PS99 Pro Hub]: Loaded with clean professional layout!")
