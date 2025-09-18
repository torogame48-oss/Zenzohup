--// LangHub Zenzo Edition - Small Menu + Rainbow Border

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = game:GetService("Workspace").CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LangHub"
ScreenGui.Parent = game:GetService("CoreGui")

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
Frame.BackgroundTransparency = 0.3
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.4,0,0.4,0)
Frame.Size = UDim2.new(0,200,0,120) -- nhỏ hơn trước
Frame.Active = true
Frame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0,12)
UICorner.Parent = Frame

-- Viền cầu vồng
local RainbowStroke = Instance.new("UIStroke")
RainbowStroke.Parent = Frame
RainbowStroke.Thickness = 3
RainbowStroke.Transparency = 0.5
RainbowStroke.Color = Color3.fromHSV(0,1,1)

-- Chạy hiệu ứng cầu vồng xoay
local hue = 0
RunService.RenderStepped:Connect(function()
    hue = (hue + 0.002) % 1
    RainbowStroke.Color = Color3.fromHSV(hue,1,1)
end)

local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1,0,0,25)
Title.Text = "✨ LangHub - Zenzo"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18

local AimToggle = Instance.new("TextButton")
AimToggle.Parent = Frame
AimToggle.BackgroundColor3 = Color3.fromRGB(30,30,30)
AimToggle.BackgroundTransparency = 0.2
AimToggle.Size = UDim2.new(0,180,0,35)
AimToggle.Position = UDim2.new(0.05,0,0.5,0)
AimToggle.Text = "AimLock: OFF"
AimToggle.TextColor3 = Color3.fromRGB(255,255,255)
AimToggle.Font = Enum.Font.SourceSansBold
AimToggle.TextSize = 16

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0,8)
ToggleCorner.Parent = AimToggle

-- Biến AimLock
local AimLockEnabled = false
local Target = nil

-- Toggle AimLock
AimToggle.MouseButton1Click:Connect(function()
    AimLockEnabled = not AimLockEnabled
    AimToggle.Text = "AimLock: " .. (AimLockEnabled and "ON" or "OFF")
    if not AimLockEnabled then Target = nil end
end)

-- Tìm player ở trung tâm màn hình
local function getCenterTarget()
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character.Head.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X,pos.Y) - center).magnitude
                if dist < 30 then
                    return player
                end
            end
        end
    end
    return nil
end

-- AimLock
RunService.RenderStepped:Connect(function()
    if AimLockEnabled then
        if not Target then
            local centerPlayer = getCenterTarget()
            if centerPlayer then
                Target = centerPlayer
            end
        end

        if Target and Target.Character and Target.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Character.Head.Position)
        end
    end
end)

-- Nhấn R để reset target
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.R then
        Target = nil
    end
end)
