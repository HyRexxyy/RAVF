local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

--new feature and variable
local Players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
if not player or not replicatedStorage then return end

-- Load Rayfield
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua"))()

-- Window
local Window = Rayfield:CreateWindow({
    Name = "Fish It Script",
    LoadingTitle = "Fish It",
    LoadingSubtitle = "by @HyRexxyy",
    Theme = "Amethyst",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "Rexxyy",
        FileName = "FishIt"
    },
    KeySystem = false
})

-- Tabs
local MainTab = Window:CreateTab("Auto Fish", "fish")
local PlayerTab = Window:CreateTab("Player", "users-round")
local IslandsTab = Window:CreateTab("Islands", "map")
local EventTab = Window:CreateTab("Event", "cog")
local Buy_Weather = Window:CreateTab("Buy Weather", "cog")
local SettingsTab = Window:CreateTab("Settings", "cog")
local DevTab = Window:CreateTab("Developer", "airplay")

-- Remotes
local net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
local equipRemote = net:WaitForChild("RE/EquipToolFromHotbar")
local rodRemote = net:WaitForChild("RF/ChargeFishingRod")
local miniGameRemote = net:WaitForChild("RF/RequestFishingMinigameStarted")
local finishRemote = net:WaitForChild("RE/FishingCompleted")

-- State
local AutoSell = false
local autofish = false
local perfectCast = false
local ijump = false
local autoRecastDelay = 0.5
local enchantPos = Vector3.new(3231, -1303, 1402)

local featureState = {
    AutoSell = false,
}

local function NotifySuccess(title, message)
	Rayfield:Notify({ Title = title, Content = message, Duration = 3, Image = "circle-check" })
end

local function NotifyError(title, message)
	Rayfield:Notify({ Title = title, Content = message, Duration = 3, Image = "ban" })
end

-- Developer Info
DevTab:CreateParagraph({
    Title = "HyRexxyy Script",
    Content = "Thanks for using this script!\n\nDont forget to follow me on my social platform:\n- Tiktok: tiktok.com/hyrexxyy\n- Instagram: @hyrexxyy\n- GitHub: github.com/hyrexxyy\n\nKeep supporting!"
})

DevTab:CreateButton({ Name = "Tiktok", Callback = function() setclipboard("https://tiktok.com/hyrexxyy") NotifySuccess("Link Tiktok", "Copied to clipboard!") end })
DevTab:CreateButton({ Name = "Instagram", Callback = function() setclipboard("https://instagram.com/hyrexxyy") NotifySuccess("Link Instagram", "Copied to clipboard!") end })
DevTab:CreateButton({ Name = "GitHub", Callback = function() setclipboard("https://github.com/hyrexxyy") NotifySuccess("Link GitHub", "Copied to clipboard!") end })

-- MainTab (Auto Fish)
MainTab:CreateParagraph({
    Title = "🎣 Auto Fish Settings",
    Content = "Use toggle & slider below to setting auto fishing."
})

MainTab:CreateToggle({
    Name = "🎣 Enable Auto Fishing",
    CurrentValue = false,
    Callback = function(val)
        autofish = val
        if val then
            task.spawn(function()
                while autofish do
                    pcall(function()
                        equipRemote:FireServer(1)
                        task.wait(0.1)

                        local timestamp = perfectCast and 9999999999 or (tick() + math.random())
                        rodRemote:InvokeServer(timestamp)
                        task.wait(0.1)

                        local x = perfectCast and -1.238 or (math.random(-1000, 1000) / 1000)
                        local y = perfectCast and 0.969 or (math.random(0, 1000) / 1000)

                        miniGameRemote:InvokeServer(x, y)
                        task.wait(1.3)
                        finishRemote:FireServer()
                    end)
                    task.wait(autoRecastDelay)
                end
            end)
        end
    end
})

MainTab:CreateToggle({
    Name = "✨ Use Perfect Cast",
    CurrentValue = false,
    Callback = function(val)
        perfectCast = val
    end
})

MainTab:CreateSlider({
    Name = "⏱️ Auto Recast Delay (seconds)",
    Range = {0.5, 5},
    Increment = 0.1,
    CurrentValue = autoRecastDelay,
    Callback = function(val)
        autoRecastDelay = val
    end
})

-- Buy Weather
Buy_Weather:CreateParagraph({
    Title = "🌤️ Purchase Weather Events",
    Content = "Select a weather event to trigger."
})
local autoBuyWeather = false

Buy_Weather:CreateToggle({
    Name = "🌀 Auto Buy All Weather",
    CurrentValue = false,
    Flag = "AutoBuyWeatherToggle",
    Callback = function(Value)
        autoBuyWeather = Value
        if Value then
            Rayfield:Notify({
                Title = "Auto Weather",
                Content = "Started Auto Buying Weather",
                Duration = 3
            })

            task.spawn(function()
                while autoBuyWeather do
                    for _, w in ipairs(weathers) do
                        pcall(function()
                            replicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseWeatherEvent"]:InvokeServer(w.Name)
                            
                        end)
                        task.wait(1.5) -- jeda antar pembelian
                    end
                    task.wait(10) -- tunggu sebelum mengulang pembelian
                end
            end)
        else
            Rayfield:Notify({
                Title = "Auto Weather",
                Content = "Stopped Auto Buying",
                Duration = 2
            })
        end
    end
})
local weathers = {
    { Name = "Wind", Price = "10k Coins", Desc = "Increases Rod Speed" },
    { Name = "Snow", Price = "15k Coins", Desc = "Adds Frozen Mutations" },
    { Name = "Cloudy", Price = "20k Coins", Desc = "Increases Luck" },
    { Name = "Storm", Price = "35k Coins", Desc = "Increase Rod Speed And Luck" },
    { Name = "Shark Hunt", Price = "300k Coins", Desc = "Shark Hunt" }
}

for _, w in ipairs(weathers) do
    Buy_Weather:CreateButton({
        Name = w.Name .. " (" .. w.Price .. ")",
        Callback = function()
            pcall(function()
                replicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseWeatherEvent"]:InvokeServer(w.Name)
                Rayfield:Notify({
                    Title = "⛅ Weather Event",
                    Content = "Triggering " .. w.Name,
                    Duration = 3
                })
            end)
        end
    })
end

local AutoSellToggle = MainTab:CreateToggle({
    Name = "🛒 Auto Sell (Teleport ke Alex)",
    CurrentValue = false,
    Flag = "AutoSell",
    Callback = function(value)
        featureState.AutoSell = value
        if value then
            task.spawn(function()
                while featureState.AutoSell and player do
                    pcall(function()
                        if not (player.Character and player.Character:FindFirstChild("HumanoidRootPart")) then return end

                        local npcContainer = replicatedStorage:FindFirstChild("NPC")
                        local alexNpc = npcContainer and npcContainer:FindFirstChild("Alex")

                        if not alexNpc then
                            Rayfield:Notify({
                                Title = "❌ Error",
                                Content = "NPC 'Alex' tidak ditemukan!",
                                Duration = 5,
                                Image = 4483362458
                            })
                            featureState.AutoSell = false
                            AutoSellToggle:Set(false)
                            return
                        end

                        local originalCFrame = player.Character.HumanoidRootPart.CFrame
                        local npcPosition = alexNpc.WorldPivot.Position

                        player.Character.HumanoidRootPart.CFrame = CFrame.new(npcPosition)
                        task.wait(1)

                        replicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/SellAllItems"]:InvokeServer()
                        task.wait(1)

                        player.Character.HumanoidRootPart.CFrame = originalCFrame
                    end)
                    task.wait(20)
                end
            end)
        end
    end
})

-- Toggle logic
local blockUpdateOxygen = false

PlayerTab:CreateToggle({
    Name = "Unlimited Oxygen",
    CurrentValue = false,
    Flag = "BlockUpdateOxygen",
    Callback = function(value)
        blockUpdateOxygen = value
        Rayfield:Notify({
            Title = "Update Oxygen Block",
            Content = value and "Remote blocked!" or "Remote allowed!",
            Duration = 3,
        })
    end,
})

-- Hook FireServer
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if method == "FireServer" and tostring(self) == "URE/UpdateOxygen" and blockUpdateOxygen then
        warn("Tahan Napas Bang")
        return nil -- prevent call
    end

    return oldNamecall(self, unpack(args))
end))

-- Player Tab
PlayerTab:CreateToggle({
    Name = "Infinity Jump",
    CurrentValue = false,
    Callback = function(val)
        ijump = val
    end
})



UserInputService.JumpRequest:Connect(function()
    if ijump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

 PlayerTab:CreateButton({
        Name = "Weather Machine",
        Callback = function()
            local weather = workspace:FindFirstChild("!!!! ISLAND LOCATIONS !!!!"):FindFirstChild("Weather Machine")
            local char = game:GetService("Players").LocalPlayer.Character
            if weather and char and char:FindFirstChild("HumanoidRootPart") then
                char:PivotTo(CFrame.new(weather.Position))
                Rayfield:Notify({
                    Title = "Teleported",
                    Content = "To Weather Machine",
                    Duration = 3,
                    Image = 4483362458
                })
            else
                Rayfield:Notify({
                    Title = "Error",
                    Content = "Weather Machine or Character not found.",
                    Duration = 3,
                    Image = 4483362458
                })
            end
        end,
    })
end

PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 150},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(val)
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = val end
    end
})

PlayerTab:CreateSlider({
    Name = "Jump Power",
    Range = {50, 500},
    Increment = 10,
    CurrentValue = 35,
    Callback = function(val)
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.UseJumpPower = true
            hum.JumpPower = val
        end
    end
})

-- Islands Tab
local islandCoords = {
    ["01"] = { name = "Weather Machine", position = Vector3.new(-1471, -3, 1929) },
    ["02"] = { name = "Esoteric Depths", position = Vector3.new(3157, -1303, 1439) },
    ["03"] = { name = "Tropical Grove", position = Vector3.new(-2038, 3, 3650) },
    ["04"] = { name = "Stingray Shores", position = Vector3.new(-32, 4, 2773) },
    ["05"] = { name = "Kohana Volcano", position = Vector3.new(-519, 24, 189) },
    ["06"] = { name = "Coral Reefs", position = Vector3.new(-3095, 1, 2177) },
    ["07"] = { name = "Crater Island", position = Vector3.new(968, 1, 4854) },
    ["08"] = { name = "Kohana", position = Vector3.new(-658, 3, 719) },
    ["09"] = { name = "Winter Fest", position = Vector3.new(1611, 4, 3280) },
    ["10"] = { name = "Isoteric Island", position = Vector3.new(1987, 4, 1400) },
["11"] = { name = "Lost Isle", position = Vector3.new(-3670.30078125, -113.00000762939453, -1128.0589599609375)},
["12"] = { name = "Lost Isle [Lost Shore]", position = Vector3.new(-3697, 97, -932)},
["13"] = { name = "Lost Isle [Sisyphus]", position = Vector3.new(-3719.850830078125, -113.00000762939453, -958.6303100585938)},

["14"] = { name = "Lost Isle [Treasure Hall]", position = Vector3.new(-3652, -298.25, -1469)},
["15"] = { name = "Lost Isle [Treasure Room]", position = Vector3.new(-3652, -283.5, -1651.5)}
}

for _, data in pairs(islandCoords) do
    IslandsTab:CreateButton({
        Name = data.name,
        Callback = function()
            local char = Workspace.Characters:FindFirstChild(LocalPlayer.Name)
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(data.position + Vector3.new(0, 5, 0))
                NotifySuccess("Teleported!", "You are now at " .. data.name)
            else
                NotifyError("Teleport Failed", "Character or HRP not found!")
            end
        end
    })
end
-- Settings Tab
SettingsTab:CreateButton({ Name = "Rejoin Server", Callback = function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end })
SettingsTab:CreateButton({ Name = "Server Hop (New Server)", Callback = function()
    local placeId = game.PlaceId
    local servers, cursor = {}, ""
    repeat
        local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100" .. (cursor ~= "" and "&cursor=" .. cursor or "")
        local success, result = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(url))
        end)
        if success and result and result.data then
            for _, server in pairs(result.data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    table.insert(servers, server.id)
                end
            end
            cursor = result.nextPageCursor or ""
        else
            break
        end
    until not cursor or #servers > 0

    if #servers > 0 then
        local targetServer = servers[math.random(1, #servers)]
        TeleportService:TeleportToPlaceInstance(placeId, targetServer, LocalPlayer)
    else
        NotifyError("Server Hop Failed", "No available servers found!")
    end
end })
SettingsTab:CreateButton({ Name = "Unload Script", Callback = function()
    Rayfield:Notify({ Title = "Script Unloaded", Content = "The script will now unload.", Duration = 3, Image = "circle-check" })
    wait(3)
    game:GetService("CoreGui").Rayfield:Destroy()
end })

-- 🔄 Ambil semua anak dari workspace.Props dan filter hanya yang berupa Model atau BasePart

local function createEventButtons()
    EventTab.Flags = {} -- Bersihkan flags lama agar tidak dobel
    local props = Workspace:FindFirstChild("Props")
    if props then
        for _, child in pairs(props:GetChildren()) do
            if child:IsA("Model") or child:IsA("BasePart") then
                local eventName = child.Name

                EventTab:CreateButton({
                    Name = "Teleport to: " .. eventName,
                    Callback = function()
                        local character = Workspace.Characters:FindFirstChild(LocalPlayer.Name)
                        local hrp = character and character:FindFirstChild("HumanoidRootPart")
                        local pos = nil

                        if child:IsA("Model") then
                            if child.PrimaryPart then
                                pos = child.PrimaryPart.Position
                            else
                                local part = child:FindFirstChildWhichIsA("BasePart")
                                if part then
                                    pos = part.Position
                                end
                            end
                        elseif child:IsA("BasePart") then
                            pos = child.Position
                        end

                        if pos and hrp then
                            hrp.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0)) -- Naik dikit biar gak stuck
                            Rayfield:Notify({
                                Title = "✅ Teleported",
                                Content = "You have been teleported to: " .. eventName,
                                Duration = 4
                            })
                        else
                            Rayfield:Notify({
                                Title = "❌ Teleport Failed",
                                Content = "Failed to locate valid part for: " .. eventName,
                                Duration = 4
                            })
                        end
                    end
                })
            end
        end
    end
end

-- Tombol untuk refresh list event
EventTab:CreateButton({
    Name = "🔄 Refresh Event List",
    Callback = function()
        createEventButtons()
        Rayfield:Notify({
            Title = "✅ Refreshed",
            Content = "Event list has been refreshed.",
            Duration = 3
        })
    end
})

-- Panggil pertama kali saat tab dibuka
createEventButtons()

local props = Workspace:FindFirstChild("Props")
if props then
    for _, child in pairs(props:GetChildren()) do
        if child:IsA("Model") or child:IsA("BasePart") then
            local eventName = child.Name

            EventTab:CreateButton({
                Name = "Teleport to: " .. eventName,
                Callback = function()
                    local character = Workspace.Characters:FindFirstChild(LocalPlayer.Name)
                    local hrp = character and character:FindFirstChild("HumanoidRootPart")
                    local pos = nil

                    if child:IsA("Model") then
                        if child.PrimaryPart then
                            pos = child.PrimaryPart.Position
                        else
                            local part = child:FindFirstChildWhichIsA("BasePart")
                            if part then
                                pos = part.Position
                            end
                        end
                    elseif child:IsA("BasePart") then
                        pos = child.Position
                    end

                    if pos and hrp then
                        hrp.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0)) -- Naik dikit biar gak stuck
                        Rayfield:Notify({
                            Title = "✅ Teleported",
                            Content = "You have been teleported to: " .. eventName,
                            Duration = 4
                        })
                    else
                        Rayfield:Notify({
                            Title = "❌ Teleport Failed",
                            Content = "Failed to locate valid part for: " .. eventName,
                            Duration = 4
                        })
                    end
                end
            })
        end
    end
else
    Rayfield:Notify({
        Title = "Reloading Props Event",
        Content = "workspace.Props tidak ditemukan!",
        Duration = 1
    })
end
