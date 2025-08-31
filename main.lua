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
