-- Gui to Lua
-- Version: 3.2
-- test
-- Instances:

local keysys = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Frame_2 = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")
local Frame_3 = Instance.new("Frame")
local TextLabel_2 = Instance.new("TextLabel")
local TextLabel_3 = Instance.new("TextLabel")
local Key = Instance.new("TextBox")
local UICorner = Instance.new("UICorner")
local Submit = Instance.new("TextButton")
local UICorner_2 = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")
local UIStroke_2 = Instance.new("UIStroke")
local UIStroke_3 = Instance.new("UIStroke")
local UIStroke_4 = Instance.new("UIStroke")
local UIStroke_5 = Instance.new("UIStroke")

--Properties:

keysys.Name = "keysys"
keysys.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
keysys.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = keysys
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame.Size = UDim2.new(0, 300, 0, 400)

Frame_2.Parent = Frame
Frame_2.AnchorPoint = Vector2.new(0.5, 0.5)
Frame_2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame_2.BorderSizePixel = 0
Frame_2.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame_2.Size = UDim2.new(0, 298, 0, 398)

TextLabel.Parent = Frame_2
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(0.0335570462, 0, 0.0150753772, 0)
TextLabel.Size = UDim2.new(0, 130, 0, 21)
TextLabel.Font = Enum.Font.RobotoMono
TextLabel.Text = utf8.char(0x1F511).." Key System"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true
TextLabel.TextXAlignment = Enum.TextXAlignment.Left

Frame_3.Parent = Frame_2
Frame_3.AnchorPoint = Vector2.new(0.5, 0)
Frame_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame_3.BackgroundTransparency = 1.000
Frame_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame_3.BorderSizePixel = 0
Frame_3.Position = UDim2.new(0.5, 0, 0.0854271352, 0)
Frame_3.Size = UDim2.new(0, 279, 0, 356)

TextLabel_2.Parent = Frame_3
TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_2.BackgroundTransparency = 1.000
TextLabel_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_2.BorderSizePixel = 0
TextLabel_2.Position = UDim2.new(0.0335570835, 0, 0.0150753409, 0)
TextLabel_2.Size = UDim2.new(0, 265, 0, 24)
TextLabel_2.Font = Enum.Font.RobotoMono
TextLabel_2.Text = "Please enter your key to continue"
TextLabel_2.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_2.TextScaled = true
TextLabel_2.TextSize = 14.000
TextLabel_2.TextWrapped = true

TextLabel_3.Parent = Frame_3
TextLabel_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_3.BackgroundTransparency = 1.000
TextLabel_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_3.BorderSizePixel = 0
TextLabel_3.Position = UDim2.new(0.0335570835, 0, 0.911142766, 0)
TextLabel_3.Size = UDim2.new(0, 265, 0, 30)
TextLabel_3.Font = Enum.Font.RobotoMono
TextLabel_3.Text = "Obtain a key at discord.gg/mpQbaNJXDb"
TextLabel_3.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_3.TextScaled = true
TextLabel_3.TextSize = 14.000
TextLabel_3.TextWrapped = true

Key.Name = "Key"
Key.Parent = Frame_3
Key.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Key.BorderColor3 = Color3.fromRGB(0, 0, 0)
Key.BorderSizePixel = 0
Key.Position = UDim2.new(0.136200711, 0, 0.354962975, 0)
Key.Size = UDim2.new(0, 200, 0, 20)
Key.Font = Enum.Font.RobotoMono
Key.PlaceholderColor3 = Color3.fromRGB(179, 179, 179)
Key.PlaceholderText = "Key"
Key.Text = ""
Key.TextColor3 = Color3.fromRGB(255, 255, 255)
Key.TextSize = 19.000

UICorner.CornerRadius = UDim.new(0, 1)
UICorner.Parent = Key

Submit.Name = "Submit"
Submit.Parent = Frame_3
Submit.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Submit.BorderColor3 = Color3.fromRGB(0, 0, 0)
Submit.BorderSizePixel = 0
Submit.Position = UDim2.new(0.136200711, 0, 0.433614671, 0)
Submit.Size = UDim2.new(0, 200, 0, 20)
Submit.AutoButtonColor = false
Submit.Font = Enum.Font.RobotoMono
Submit.Text = "Submit"
Submit.TextColor3 = Color3.fromRGB(255, 255, 255)
Submit.TextSize = 19.000

UICorner_2.CornerRadius = UDim.new(0, 1)
UICorner_2.Parent = Submit

UIStroke.Parent = Frame

UIStroke_2.Parent = Frame_3
UIStroke_2.Color = Color3.fromRGB(56, 56, 56)

UIStroke_3.Parent = Submit

UIStroke_4.Parent = Submit
UIStroke_4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

UIStroke_5.Parent = TextLabel_2

	Submit.MouseButton1Click:Connect(function()
		if Key.Text == "OCtJMbFu8sjUusoHgUSgB2Ho0cIjj1o0MMAtNs2hd5PYdty9VB" then
                    keysys.Enabled = false
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/railme37509124/Tabby/main/TabbyPassedKey.lua", true))()
		    keysys:Destroy()
                 else
                    Submit.Text = "Wrong key!"
                    wait(2)
                    Submit.Text = "Submit"
                  end
	 end)
