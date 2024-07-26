if getgenv().key ~= "i8EIp92Xf" then warn("Get the right key") return end
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local eventstore = {
    ToolCollect = ReplicatedStorage.Events.ToolCollect,
    ToyEvent = ReplicatedStorage.Events.ToyEvent,
    PlayerHiveCommand = ReplicatedStorage.Events.PlayerHiveCommand,
    ClaimHive = ReplicatedStorage.Events.ClaimHive
}
local mapstore = {
    HiddenStickers = Workspace.HiddenStickers,
    Flowers = Workspace.Flowers,
    Collectibles = Workspace.Collectibles,
    Snowflakes = Workspace.Particles.Snowflakes
}
local fieldstore = {}
local rawfieldstore = {}

for _, field in Workspace.FlowerZones:GetChildren() do -- // thanks kocmoc for the idea
    fieldstore[field.Name] = field
    table.insert(rawfieldstore, field.Name)
end

local cstore = {
    Converting = false,
    SelectedField = "Dandelion Field",
    ConvertMethod = "Teleport",
    WebhookUrl = "",
    WebhookConvertHoney = true,
    WebookCollectPollen = true,
    WebhookCollectSnowflake = true,
    GettingRares = false,
    GettingToken = false,

    WalkSpeed = 24,
    JumpPower = 70,
}
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
    GetToken = function(field, mag)
        for i, v in mapstore.Collectibles:GetChildren() do
            if ((v.Position * Vector3.new(1, 0, 1)) - (fieldstore[field].Position * Vector3.new(1, 0, 1))).magnitude < mag then
                return v
            end
        end
    end,
    ClaimHive = function()
        for _, v in Workspace.Honeycombs:GetChildren() do
            if v.Owner.Value ~= nil then continue end
            eventstore.ClaimHive:FireServer(v.HiveID.Value)
        end
    end,
    Convert = function()
        eventstore.PlayerHiveCommand:FireServer("ToggleHoneyMaking")
    end,
    IsConverting = function()
        return Players.LocalPlayer.PlayerGui.ScreenGui.ActivateButton.TextBox.Text == "Stop Making Honey"
    end,
    ToWebhook = function(typ)
        if cstore.WebhookUrl == "" then return end
        local body = {}
        if typ == "wbh_convert" then
            body = {
                ["content"] = "",
                ["embeds"] = {{
                    ["description"] = "Converting "..math.round(Players.LocalPlayer.CoreStats.Pollen.Value).." pollen",
                    ["color"] = tonumber(0xff8700),
                    ["title"] = ":bee: Converting Honey"
                }}
            }
        elseif typ == "wbh_collecting" then
            body = {
                ["content"] = "",
                ["embeds"] = {{
                    ["description"] = "Collecting from "..cstore.SelectedField,
                    ["color"] = tonumber(0xff8700),
                    ["title"] = ":bee: Collecting Pollen",
                }},
            }
        elseif typ == "wbh_gsnowflake" then
            body = {
                ["content"] = "",
                ["embeds"] = {{
                    ["description"] = "Converting "..math.round(Players.LocalPlayer.CoreStats.Pollen.Value).." pollen",
                    ["color"] = tonumber(0xff8700),
                    ["title"] = ":snowflake: Collecting Snowflake"
                }}
            }
        end
        spawn(function()
            http.request({
                Url = cstore.WebhookUrl,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = HttpService:JSONEncode(body)
            })
        end)
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
functionstore["GetSnowflake"] = function()
    if #mapstore.Snowflakes:GetChildren() ~= 0 then
        return mapstore.Snowflakes:GetChildren()[math.random(1, #mapstore.Snowflakes:GetChildren())]
    else
        functionstore.GetSnowflake()
        task.wait(0.1)
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
    AutoWealthClock = false,
    AutoGlueDispenser = false,
    AutoBlueberryDispenser = false,
    AutoCoconutDispenser = false,
    AutoStrawberryDispenser = false,
    AutoTreatDispenser = false,

}

functionstore.ClaimHive()

local library = loadstring(game:HttpGet("https://pastebin.com/raw/Me1C3tm9"))()

local window = library:new({LibSize = UDim2.new(0, 500, 0, 590) ,textsize = 13.5,font = Enum.Font.RobotoMono,name = "Tabby V1",color = Color3.fromRGB(255, 208, 75)})

-- // autofarm
local AutoFarmPage = window:page({name = "Autofarm"})
local AutoFarmSection = AutoFarmPage:section({name = "AutoFarm",side = "left",size = 250})
local ToysSection = AutoFarmPage:section({name = "Toys",side = "Right",size = 250})

-- // lplr
local LocalPlrPage = window:page({name = "Local Plr"})
local LocalPlrSection = LocalPlrPage:section({name = "Player",side = "left",size = 250})

-- // misc
local MiscPage = window:page({name = "Misc"})
local MiscSection = MiscPage:section({name = "Tokens",side = "left",size = 250})

-- // webhook
local WebhookPage = window:page({name = "Webhook"})
local WebhookSection = WebhookPage:section({name = "Webhook Config",side = "left",size = 250})

AutoFarmSection:toggle({name = "Auto Dig",def = false,callback = function(value)
    togglestore.AutoDig = value
end})

AutoFarmSection:toggle({name = "Auto Farm Field",def = false,callback = function(value)
    cstore.WalkingToField = false
    cstore.GettingToken = false
    togglestore.AutoFarm = value
end})

AutoFarmSection:dropdown({name = "Convert Mode",def = "Teleport", max = 2, options = {"Teleport", "Walk"},callback = function(chosen)
    cstore.ConvertMethod = chosen
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

MiscSection:button({name = "Get Rares",callback = function()
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

ToysSection:toggle({name = "Farm Snowflakes",def = false,callback = function(value)
    togglestore.FarmSnowflakes = value
end})

ToysSection:toggle({name = "Auto Wealth Clock",def = false,callback = function(value)
    togglestore.AutoWealthClock = value
end})

ToysSection:toggle({name = "Auto Glue Dispenser",def = false,callback = function(value)
    togglestore.AutoGlueDispenser = value
end})

ToysSection:toggle({name = "Auto Blueberry Dispenser",def = false,callback = function(value)
    togglestore.AutoBlueberryDispenser = value
end})

ToysSection:toggle({name = "Auto Strawberry Dispenser",def = false,callback = function(value)
    togglestore.AutoStrawberryDispenser = value
end})

ToysSection:toggle({name = "Auto Coconut Dispenser",def = false,callback = function(value)
    togglestore.AutoCoconutDispenser = value
end})

ToysSection:toggle({name = "Auto Treat Dispenser",def = false,callback = function(value)
    togglestore.AutoTreatDispenser = value
end})

ToysSection:toggle({name = "Boost Blue Field",def = false,callback = function(value)
    togglestore.BoostBlueField = value
end})

ToysSection:toggle({name = "Boost Red Field",def = false,callback = function(value)
    togglestore.BoostRedField = value
end})

ToysSection:toggle({name = "Boost White Field",def = false,callback = function(value)
    togglestore.BoostWhiteField = value
end})

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

WebhookSection:textbox({name = "textbox",def = "",placeholder = "https://discord.com/api/v9/webhooks/",callback = function(value)
    cstore.WebhookUrl = value
 end})

WebhookSection:toggle({name = "Convert Honey",def = true,callback = function(value)
    cstore.WebhookConvertHoney = value
end})

WebhookSection:toggle({name = "Collect Pollen",def = true,callback = function(value)
    cstore.WebhookCollectPollen = value
end})

WebhookSection:toggle({name = "Convert Honey",def = true,callback = function(value)
    cstore.WebhookCollectSnowflake = value
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

p = nil
task.spawn(function()
    repeat
        if togglestore.AutoConvert and not togglestore.FarmSnowflakes then
            if functionstore.GetPollen() >= functionstore.GetCapacity() then
                functionstore.ToWebhook("wbh_convert")
                repeat
                    if cstore.ConvertMethod == "Teleport" then
                        Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(functionstore.GetHivePosition())
                        cstore.Converting = true
                        task.wait(0.5)
                        functionstore.Convert()
                    elseif cstore.ConvertMethod == "Reset" then
                        print("This method is unavailable")
                    elseif cstore.ConvertMethod == "Walk" then
                        if not cstore.Converting then
                            cstore.Converting = true
                            local p = Instance.new("Part")
                            p.Parent = Workspace
                            p.Name = "ckkk67"
                            p.Size = Vector3.new(10000, 5, 10000)
                            p.Position = Players.LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 370, 0)
                            p.CanCollide = true
                            p.Anchored = true
                            p.Transparency = 1
                            Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(p.Position + Vector3.new(0, 9, 0))
                            repeat
                                Players.LocalPlayer.Character.Humanoid:MoveTo(functionstore.GetHivePosition())
                                task.wait(1)
                            until (((functionstore.GetHivePosition() * Vector3.new(1, 0, 1)) - (Players.LocalPlayer.Character.HumanoidRootPart.Position * Vector3.new(1, 0, 1))).magnitude < 15) or not togglestore.AutoConvert
                            p = 0
                            Workspace:FindFirstChild("ckkk67"):Destroy()
                            wait(3)
                            functionstore.Convert()
                        end
                    end
                    if functionstore.IsConverting() == false then
                        functionstore.Convert()
                    end
                    task.wait(0.1)
                until functionstore.GetPollen() == 0 or togglestore.AutoConvert == false
                cstore.Converting = false
                if togglestore.AutoFarm then
                    TweenService:Create(Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(2, Enum.EasingStyle.Linear), {CFrame = CFrame.new(fieldstore[cstore.SelectedField].Position)}):Play()
                end
                if Workspace:FindFirstChild("ckkk67") then
                    Workspace.ckkk67:Destroy()
                end
                cstore.WalkingToField = false
            end
        end
        task.wait(0.05)
    until false
end)

task.spawn(function()
    repeat
        if togglestore.AutoFarm and not cstore.Converting and not togglestore.FarmSnowflakes then
            if not cstore.WalkingToField then
                cstore.WalkingToField = true
                local py = Instance.new("Part")
                py.Parent = Workspace
                py.Name = "ckkk68"
                py.Size = Vector3.new(10000, 5, 10000)
                py.Position = Players.LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 370, 0)
                py.CanCollide = true
                py.Anchored = true
                py.Transparency = 1
                Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(py.Position + Vector3.new(0, 9, 0))
                repeat
                    Players.LocalPlayer.Character.Humanoid:MoveTo(fieldstore[cstore.SelectedField].Position)
                    task.wait(1)
                until (((fieldstore[cstore.SelectedField].Position * Vector3.new(1, 0, 1)) - (Players.LocalPlayer.Character.HumanoidRootPart.Position * Vector3.new(1, 0, 1))).magnitude < 15) or not togglestore.AutoFarm
                if Workspace:FindFirstChild("ckkk68") then
                    Workspace.ckkk68:Destroy()
                end
                functionstore.ToWebhook("wbh_collecting")
            end
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

task.spawn(function()
    repeat
        if togglestore.AutoGlueDispenser then
            eventstore.ToyEvent:FireServer("Glue Dispenser")
        end
        if togglestore.AutoBlueberryDispenser then
            eventstore.ToyEvent:FireServer("Blueberry Dispenser")
        end
        if togglestore.AutoStrawberryDispenser then
            eventstore.ToyEvent:FireServer("Strawberry Dispenser")
        end
        if togglestore.AutoCoconutDispenser then
            eventstore.ToyEvent:FireServer("Coconut Dispenser")
        end
        if togglestore.AutoTreatDispenser then
            eventstore.ToyEvent:FireServer("Treat Dispenser")
        end
        if togglestore.AutoWealthClock then
            eventstore.ToyEvent:FireServer("Wealth Clock")
        end
        if togglestore.BoostBlueField then
            eventstore.ToyEvent:FireServer("Blue Field Booster")
        end
        if togglestore.BoostRedField then
            eventstore.ToyEvent:FireServer("Red Field Booster")
        end
        if togglestore.BoostWhiteField then
            eventstore.ToyEvent:FireServer("Field Booster")
        end
        task.wait(3)
    until false
end)

task.spawn(function()
    repeat
        if togglestore.FarmSnowflakes then
            local selectedsnowflake = functionstore.GetSnowflake()
            local collecttick = tick()
            functionstore.ToWebhook("wbh_gsnowflake")
            repeat task.wait()
                game:GetService("TweenService"):Create(Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(1), {CFrame = selectedsnowflake.CFrame + Vector3.new(0, 15, 0)}):Play()
                Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            until (tick() - collecttick > 4.5)  
        end
        task.wait(6)
    until false
end)

--[[
section1:button({name = "button",callback = function()
   print('hot ui lib')
end})

section1:slider({name = "rate ui lib 1-100",def = 1, max = 100,min = 1,rounding = true,ticking = false,measuring = "",callback = function(value)
   print(value)
end})

section1:dropdown({name = "dropdown",def = "",max = 10,options = {"1","2","3","4","5","6","7","8","9","10"},callback = function(chosen)
   print(chosen)
end})

section1:buttonbox({name = "buttonbox",def = "",max = 4, options = {"yoyoyo","yo2","yo3","yo4"},callback = function(value)
   print(value)
end})


section1:multibox({name = "multibox",def = {}, max = 4,options = {"1","2","3","4"},callback = function(value)
   print(value)
end})

section1:textbox({name = "textbox",def = "default text",placeholder = "Enter WalkSpeed",callback = function(value)
   print(value)
end})

section1:keybind({name = "set ui keybind",def = nil,callback = function(key)
   window.key = key
end})

local picker = section1:colorpicker({name = "color",cpname = nil,def = Color3.fromRGB(255,255,255),callback = function(value)
   color = value
end})--]]
