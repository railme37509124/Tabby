if getgenv().key ~= "CKio824yA" then return end -- // I swear if you looked at the source code just to get the key, fuck you
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local eventstore = {
    ToolCollect = ReplicatedStorage.Events.ToolCollect,
}
local mapstore = {
    HiddenStickers = Workspace.HiddenStickers,
    Flowers = Workspace.Flowers,
    Collectibles = Workspace.Collectibles,
}
local fieldstore = {}
local rawfieldstore = {}

for _, field in Workspace.FlowerZones:GetChildren() do -- // thanks kocmoc for the idea
    fieldstore[field.Name] = field
    table.insert(rawfieldstore, field.Name)
end

local functionstore = {
    GetCapacity = function()
        return Players.LocalPlayer.CoreStats.Capacity.Value
    end,
    GetPollen = function()
        return Players.LocalPlayer.CoreStats.Pollen.Value
    end,
    GetHivePosition = function()
        return (Players.LocalPlayer.Honeycomb.Value).patharrow.Base.Position + Vector3.new(0, 2, 0)
    end,
    ClaimHive = function()
        for _, v in Workspace.Honeycombs:GetChildren() do
            if v.Owner.Value ~= nil then continue end
            game.ReplicatedStorage.Events.ClaimHive:FireServer(v.HiveID.Value)
        end
    end,
    Convert = function()
        game:GetService("ReplicatedStorage").Events.PlayerHiveCommand:FireServer("ToggleHoneyMaking")
    end,
    IsConverting = function()
        return Players.LocalPlayer.PlayerGui.ScreenGui.ActivateButton.TextBox.Text == "Stop Making Honey"
    end,
}
functionstore["FindFlower"] = function(field)
    flower = mapstore.Flowers:GetChildren()[math.random(1, #mapstore.Flowers:GetChildren())]
    if flower.Name:split("-")[1] == "FP"..fieldstore[field].ID.Value then
        return flower
    else
        functionstore.FindFlower(field)
    end
end
functionstore["GetToken"] = function(field, mag)
    for i, v in mapstore.Collectibles:GetChildren() do
        if ((v.Position * Vector3.new(1, 0, 1)) - (fieldstore[field].Position * Vector3.new(1, 0, 1))).magnitude < mag then
            return v
        end
    end
end

local togglestore = {
    AutoDig = false,
    AutoFarm = false,
    AutoConvert = false,
    CollectHiddenStickers = false,
    FarmTokens = false,
    LoopMovement = false,

    FarmSnowflakes = false,
}
local cstore = {
    Converting = false,
    SelectedField = "Dandelion Field",
    GettingRares = false,
    GettingToken = false,
    WalkSpeed = 0,
    JumpPower = 0,
}

functionstore.ClaimHive()

local library = loadstring(game:HttpGet("https://pastebin.com/raw/Me1C3tm9"))()

local window = library:new({LibSize = UDim2.new(0, 500, 0, 590) ,textsize = 13.5,font = Enum.Font.RobotoMono,name = "Tabby V1",color = Color3.fromRGB(255, 208, 75)})

local AutoFarmPage = window:page({name = "Autofarm"})
local LocalPlrPage = window:page({name = "Local Plr"})
local LocalPlrSection = LocalPlrPage:section({name = "Player",side = "left",size = 250})

local AutoFarmSection = AutoFarmPage:section({name = "AutoFarm",side = "left",size = 250})
local TokenSection = AutoFarmPage:section({name = "Tokens",side = "Right",size = 250})

AutoFarmSection:toggle({name = "Auto Dig",def = false,callback = function(value)
    togglestore.AutoDig = value
end})

AutoFarmSection:toggle({name = "Auto Farm Field",def = false,callback = function(value)
    togglestore.AutoFarm = value
end})

AutoFarmSection:toggle({name = "Auto Convert",def = false,callback = function(value)
    togglestore.AutoConvert = value
end})

AutoFarmSection:dropdown({name = "Field",def = "Dandelion Field", max = #rawfieldstore, options = rawfieldstore,callback = function(chosen)
    cstore.SelectedField = chosen
end})

AutoFarmSection:toggle({name = "Farm Tokens",def = false,callback = function(value)
    togglestore.FarmTokens = value
end})

AutoFarmSection:toggle({name = "Collect Hidden Stickers",def = false,callback = function(value)
    togglestore.CollectHiddenStickers = value
end})

TokenSection:button({name = "Get Rares",callback = function()
    if not cstore.GettingRares then
        cstore.GettingRares = true
        for _, v in mapstore.Collectibles:GetChildren() do
            if v.Transparency ~= 0 then continue end
            local t = tick()
            repeat
                Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v.Position + Vector3.new(0, 1, 0))
                task.wait()
            until tick() - t > 4 or v == nil
        end
    end
end})

--[[TokenSection:toggle({name = "Farm Snowflakes [COMING SOON]",def = false,callback = function(value)
    togglestore.FarmSnowflakes = value
end})--]]

LocalPlrSection:slider({name = "WalkSpeed",def = 24, max = 200,min = 16,rounding = true,ticking = false,measuring = "",callback = function(value)
    Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    cstore.WalkSpeed = value
end})

LocalPlrSection:slider({name = "JumpPower",def = 70, max = 200,min = 25,rounding = true,ticking = false,measuring = "",callback = function(value)
    Players.LocalPlayer.Character.Humanoid.JumpPower = value
    cstore.JumpPower = value
end})

LocalPlrSection:toggle({name = "Loop Movement",def = false,callback = function(value)
    togglestore.LoopMovement = value
end})


--[[BeesmasSection:button({name = "Beesmas Stocking",callback = function()

end})--]]

-- // loops

--[[
task.spawn(function()
    repeat
        if condition then
            code
        end
        task.wait()
    until false
end)
--]]

task.spawn(function()
    repeat
        if togglestore.LoopMovement then
            Players.LocalPlayer.Character.Humanoid.WalkSpeed = cstore.WalkSpeed
            Players.LocalPlayer.Character.Humanoid.JumpPower = cstore.JumpPower
        end
        task.wait()
    until false
end)

task.spawn(function()
    repeat
        if togglestore.AutoDig and not cstore.Converting then
            eventstore.ToolCollect:FireServer()
        end
        task.wait(0.1)
    until false
end)

task.spawn(function()
    repeat
        if togglestore.AutoConvert then
            if functionstore.GetPollen() >= functionstore.GetCapacity() then
                cstore.Converting = true
                task.wait(0.5)
                functionstore.Convert()
                repeat
                    Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(functionstore.GetHivePosition())
                    if functionstore.IsConverting() == false then
                        functionstore.Convert()
                    end
                    task.wait(0.1)
                until functionstore.GetPollen() == 0 or togglestore.AutoConvert == false
                cstore.Converting = false
            end
        end
        task.wait(0.05)
    until false
end)

task.spawn(function()
    repeat
        if togglestore.AutoFarm and not cstore.Converting then
            if togglestore.FarmTokens then
                token = functionstore.GetToken(cstore.SelectedField, 42)
                if token then
                    print(token)
                    cstore.GettingToken = true
                    Players.LocalPlayer.Character.Humanoid:MoveTo(token.Position)
                    task.wait(0.31)
                    cstore.GettingToken = false
                end
            end
            flower = nil
            repeat
                flower = functionstore.FindFlower(cstore.SelectedField)
                wait(0.1)
            until flower ~= nil or cstore.GettingToken
            if not cstore.GettingToken then
                Players.LocalPlayer.Character.Humanoid:MoveTo(flower.Position)
            end
            task.wait(0.3)
        end
        task.wait(0.05)
    until false
end)

task.spawn(function()
    repeat
        if togglestore.CollectHiddenStickers then
            for i, v in mapstore.HiddenStickers:GetChildren() do
                fireclickdetector(v.ClickDetector)
            end
        end
        task.wait(1)
    until false
end)
