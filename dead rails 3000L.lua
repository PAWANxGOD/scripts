-- Services
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- Local Player
local LocalPlayer = Players.LocalPlayer

-- Load Fluent UI Library and Addons
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/hungquan99/FluentUI/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/hungquan99/FluentUI/master/Addons/InterfaceManager.lua"))()

-- Custom Keybind for Minimizing UI
local minimizeUI = Enum.KeyCode.RightAlt

-- Connection Cleanup Table
local Connections = {}

-- Welcome Screen and Changelog
Fluent:Notify({
    Title = "Ringta Scripts v2.0",
    Content = "Welcome to the enhanced Dead Rails script!",
    SubContent = "Changelog:\n- Added Auto-Sell Items\n- Added Player ESP\n- Custom Keybinds\n- Anti-Damage Toggle\n- New Purple UI Theme\n- UI Animations & Improvements",
    Duration = 10
})

-- Create Main UI with Customizations
local Window = Fluent:CreateWindow({
    Title = "Ringta Scripts",
    SubTitle = "Enhanced by xAI | " .. os.date("%I:%M %p IST, %A, %B %d, %Y"),
    TabWidth = 160,
    Size = UDim2.fromOffset(500, 400), -- Adjusted size for better usability
    Acrylic = true,
    Theme = "Custom", -- Custom theme for color changes
    MinimizeKey = minimizeUI
})

-- Custom Theme (Purple and Black)
Fluent.Options:SetValue("Theme", {
    AccentColor = Color3.fromRGB(147, 112, 219), -- Medium Purple
    BackgroundColor = Color3.fromRGB(20, 20, 30), -- Darker Black
    TextColor = Color3.fromRGB(220, 220, 220), -- Light Gray
    ButtonColor = Color3.fromRGB(90, 60, 150), -- Darker Purple
    HoverColor = Color3.fromRGB(180, 140, 240), -- Lighter Purple
})

-- Custom Fonts
Fluent.Options:SetValue("Font", Enum.Font.Montserrat)

-- Enable UI Animations (Can be toggled in Settings)
local UIAnimationsEnabled = true
local function ApplyHoverAnimation(element)
    if not UIAnimationsEnabled then return end
    element.MouseEnter:Connect(function()
        TweenService:Create(element, TweenInfo.new(0.2), {BackgroundColor3 = Fluent.Options:GetValue("Theme").HoverColor}):Play()
    end)
    element.MouseLeave:Connect(function()
        TweenService:Create(element, TweenInfo.new(0.2), {BackgroundColor3 = Fluent.Options:GetValue("Theme").ButtonColor}):Play()
    end)
end

-- Tabs
local Tabs = {
    Farm = Window:AddTab({ Title = "Farm", Icon = "rbxassetid://121302760641013" }),
    Main = Window:AddTab({ Title = "Main", Icon = "rbxassetid://121302760641013" }),
    Items = Window:AddTab({ Title = "Items", Icon = "rbxassetid://121302760641013" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "rbxassetid://121302760641013" }),
    Player = Window:AddTab({ Title = "Player", Icon = "rbxassetid://121302760641013" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "rbxassetid://121302760641013" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "rbxassetid://121302760641013" }),
}

-- Load External Modules with Error Handling
local function SafeLoadstring(url, moduleName)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if not success then
        Fluent:Notify({
            Title = "Ringta Scripts",
            Content = "Failed to load " .. moduleName .. ": " .. tostring(result),
            Duration = 5
        })
        return nil
    end
    return result
end

local baseUrl = "https://raw.githubusercontent.com/Shade-vex/Hutao-hub-code-pro-mode/refs/heads/main/"
local Config = SafeLoadstring(baseUrl .. "Config.lua.txt", "Config")
local Utilities = SafeLoadstring(baseUrl .. "Util.lua.txt", "Utilities")
local ESP = SafeLoadstring(baseUrl .. "ESP.lua.txt", "ESP") and SafeLoadstring(baseUrl .. "ESP.lua.txt")()(Config, Utilities)
local MiddleClick = SafeLoadstring(baseUrl .. "MiddleClick.lua.txt", "MiddleClick")
local Aimbot = SafeLoadstring(baseUrl .. "Aimbot.lua.txt", "Aimbot")

if ESP then ESP.Initialize() end
if MiddleClick then MiddleClick.Initialize() end
if Aimbot then Aimbot.Initialize() end

-- Farm Tab
do
    Tabs.Farm:AddParagraph({
        Title = "Note",
        Content = "• Toggles can be used with configs.\n• Disabling does not stop the feature.\n• Set up configs in the Settings tab."
    })

    Tabs.Farm:AddSection("➳ Bonds")

    local AfBToggle = Tabs.Farm:AddToggle("AfBToggle", {Title = "Auto Farm Bonds", Description = "Normal version of farm bonds.", Default = false })
    AfBToggle:OnChanged(function(Value)
        if Value then
            getgenv().DeadRails = {
                ["Farm"] = {
                    ["Enabled"] = true,
                    ["Mode"] = "Normal",
                },
            }
            local AutoBondsURL = baseUrl .. "AutoBondsINF"
            local success, err = pcall(function()
                loadstring(game:HttpGet(AutoBondsURL))()
            end)
            if not success then
                Fluent:Notify({
                    Title = "Ringta Scripts",
                    Content = "Failed to start Auto Farm Bonds: " .. tostring(err),
                    Duration = 5
                })
            else
                Fluent:Notify({
                    Title = "Ringta Scripts",
                    Content = "Auto Farm Bonds enabled!",
                    Duration = 5
                })
            end
        else
            Fluent:Notify({
                Title = "Ringta Scripts",
                Content = "Auto Farm Bonds disabled.",
                Duration = 5
            })
        end
    end)

    local AfBToggle1 = Tabs.Farm:AddToggle("AfBToggle1", {Title = "Ultimate Auto Farm Bonds", Description = "70+ bonds per run, recommended.", Default = false })
    AfBToggle1:OnChanged(function(Value)
        if Value then
            local AutoBondsURL = baseUrl .. "AutoBonds2.lua.txt"
            local success, err = pcall(function()
                loadstring(game:HttpGet(AutoBondsURL))()
            end)
            if not success then
                Fluent:Notify({
                    Title = "Ringta Scripts",
                    Content = "Failed to start Ultimate Auto Farm Bonds: " .. tostring(err),
                    Duration = 5
                })
            else
                Fluent:Notify({
                    Title = "Ringta Scripts",
                    Content = "Ultimate Auto Farm Bonds enabled!",
                    Duration = 5
                })
            end
        else
            Fluent:Notify({
                Title = "Ringta Scripts",
                Content = "Ultimate Auto Farm Bonds disabled.",
                Duration = 5
            })
        end
    end)

    Tabs.Farm:AddSection("➳ Win")

    local AfBToggle12 = Tabs.Farm:AddToggle("AfBToggle12", {Title = "Auto Farm Bonds & Win", Description = "AI farm bonds & win. Recommended to use Cowboy class.", Default = false })
    AfBToggle12:OnChanged(function(Value)
        if Value then
            local AutoBondsURL = baseUrl .. "AutoBonds3.lua.txt"
            local success, err = pcall(function()
                loadstring(game:HttpGet(AutoBondsURL))()
            end)
            if not success then
                Fluent:Notify({
                    Title = "Ringta Scripts",
                    Content = "Failed to start Auto Farm Bonds & Win: " .. tostring(err),
                    Duration = 5
                })
            else
                Fluent:Notify({
                    Title = "Ringta Scripts",
                    Content = "Auto Farm Bonds & Win enabled!",
                    Duration = 5
                })
            end
        else
            Fluent:Notify({
                Title = "Ringta Scripts",
                Content = "Auto Farm Bonds & Win disabled.",
                Duration = 5
            })
        end
    end)
end

-- Main Tab
do
    Tabs.Main:AddSection("➳ Class")

    local HorseClassButton = Tabs.Main:AddButton({
        Title = "Get Horse Class",
        Callback = function()
            if getgenv().HorseCl then return end
            getgenv().HorseCl = true
            local args = { [1] = "Horse" }
            local success, err = pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("RemotePromise"):WaitForChild("Remotes"):WaitForChild("C_BuyClass"):FireServer(unpack(args))
                task.wait(1)
                game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("RemotePromise"):WaitForChild("Remotes"):WaitForChild("C_EquipClass"):FireServer(unpack(args))
            end)
            if not success then
                Fluent:Notify({
                    Title = "Ringta Scripts",
                    Content = "Failed to get Horse class: " .. tostring(err),
                    Duration = 5
                })
            else
                Fluent:Notify({
                    Title = "Ringta Scripts",
                    Content = "Horse class acquired and equipped successfully!",
                    Duration = 5
                })
            end
        end
    })
    ApplyHoverAnimation(HorseClassButton)

    local CowboyClassButton = Tabs.Main:AddButton({
        Title = "Get Cowboy Class",
        Callback = function()
            if getgenv().CowboyCl then return end
            getgenv().CowboyCl = true
            local args = { [1] = "Cowboy" }
            local success, err = pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("RemotePromise"):WaitForChild("Remotes"):WaitForChild("C_BuyClass"):FireServer(unpack(args))
                task.wait(1)
                game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("RemotePromise"):WaitForChild("Remotes"):WaitForChild("C_EquipClass"):FireServer(unpack(args))
            end)
            if not success then
                Fluent:Notify({
                    Title = "Ringta Scripts",
                    Content = "Failed to get Cowboy class: " .. tostring(err),
                    Duration = 5
                })
            else
                Fluent:Notify({
                    Title = "Ringta Scripts",
                    Content = "Cowboy class acquired and equipped successfully!",
                    Duration = 5
                })
            end
        end
    })
    ApplyHoverAnimation(CowboyClassButton)

    Tabs.Main:AddSection("➳ Aimbot")

    local AimbotV1Toggle = Tabs.Main:AddToggle("AimbotV1Toggle", {Title = "Aimbot V1", Default = false })
    AimbotV1Toggle:OnChanged(function(Value)
        if Aimbot then
            Aimbot.AimbotEnabled = Value
            Fluent:Notify({
                Title = "Ringta Scripts",
                Content = "Aimbot V1 " .. (Value and "enabled" or "disabled") .. "!",
                Duration = 5
            })
        else
            Fluent:Notify({
                Title = "Ringta Scripts",
                Content = "Aimbot module not loaded!",
                Duration = 5
            })
        end
    end)

    local AimbotKeybind = Enum.KeyCode.Q
    Tabs.Main:AddDropdown("AimbotKeybindDropdown", {
        Title = "Aimbot Keybind",
        Values = {"Q", "E", "F", "G"},
        Multi = false,
        Default = "Q",
        Callback = function(Value)
            AimbotKeybind = Enum.KeyCode[Value]
            Fluent:Notify({
                Title = "Ringta Scripts",
                Content = "Aimbot keybind set to " .. Value,
                Duration = 5
            })
        end
    })

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == AimbotKeybind then
            AimbotV1Toggle:SetValue(not AimbotV1Toggle.Value)
        end
    end)

    Tabs.Main:AddSection("➳ Player ESP")

    local PlayerEspToggle = Tabs.Main:AddToggle("PlayerEspToggle", {Title = "Player ESP", Description = "Highlights other players in the game.", Default = false })
    local PlayerEspConnections = {}
    PlayerEspToggle:OnChanged(function(Value)
        if Value then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "PlayerESP"
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                    highlight.Parent = player.Character
                    table.insert(PlayerEspConnections, highlight)
                end
            end
            local conn = Players.PlayerAdded:Connect(function(player)
                player.CharacterAdded:Connect(function(character)
                    if PlayerEspToggle.Value then
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "PlayerESP"
                        highlight.FillColor = Color3.fromRGB(255, 0, 0)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.FillTransparency = 0.5
                        highlight.OutlineTransparency = 0
                        highlight.Parent = character
                        table.insert(PlayerEspConnections, highlight)
                    end
                end)
            end)
            table.insert(PlayerEspConnections, conn)
            Fluent:Notify({
                Title = "Ringta Scripts",
                Content = "Player ESP enabled!",
                Duration = 5
            })
        else
            for _, conn in pairs(PlayerEspConnections) do
                if typeof(conn) == "Instance" then
                    conn:Destroy()
                else
                    conn:Disconnect()
                end
            end
            PlayerEspConnections = {}
            Fluent:Notify({
                Title = "Ringta Scripts",
                Content = "Player ESP disabled.",
                Duration = 5
            })
        end
    end)

    Tabs.Main:AddSection("➳ Anti-Damage")

    local AntiDamageToggle = Tabs.Main:AddToggle("AntiDamageToggle", {Title = "Anti-Damage", Description = "Prevents health loss (if supported).", Default = false })
    local antiDamageConnection
    AntiDamageToggle:OnChanged(function(Value)
        if Value then
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                antiDamageConnection = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                    if humanoid.Health < humanoid.MaxHealth then
                        humanoid.Health = humanoid.MaxHealth
                    end
                end)
                table.insert(Connections, antiDamageConnection)
                Fluent:Notify({
                    Title = "Ringta Scripts",
                    Content = "Anti-Damage enabled! Health loss prevented.",
                    Duration = 5
                })
            else
                Fluent:Notify({
                    Title = "Ringta Scripts",
                    Content = "Character or Humanoid not found!",
                    Duration = 5
                })
                AntiDamageToggle:SetValue(false)
            end
        else
            if antiDamageConnection then
                antiDamageConnection:Disconnect()
                antiDamageConnection = nil
            end
            Fluent:Notify({
                Title = "Ringta Scripts",
                Content = "Anti-Damage disabled.",
                Duration = 5
            })
        end
    end)
end

-- Items Tab
do
    Tabs.Items:AddSection("➳ Auto-Sell Items")

    local AutoSellToggle = Tabs.Items:AddToggle("AutoSellToggle", {Title = "Auto-Sell Items", Description = "Automatically sells collected items for currency.", Default = false })
    local AutoSellConnection
    AutoSellToggle:OnChanged(function(Value)
        if Value then
            AutoSellConnection = RunService.Heartbeat:Connect(function()
                local backpack = LocalPlayer.Backpack
                for _, item in pairs(backpack:GetChildren()) do
                    if item:IsA("Tool") and (item.Name:match("Gold") or item.Name:match("Silver")) then
                        local success, err = pcall(function()
                            ReplicatedStorage.Remotes.SellItem:FireServer(item)
                        end)
                        if not success then
                            Fluent:Notify({
                                Title = "Ringta Scripts",
                                Content = "Failed to sell item " .. item.Name .. ": " .. tostring(err),
                                Duration = 5
                            })
                        end
                    end
                end
            end)
            table.insert(Connections, AutoSellConnection)
            Fluent:Notify({
                Title = "Ringta Scripts",
                Content = "Auto-Sell Items enabled!",
                Duration = 5
            })
        else
            if AutoSellConnection then
                AutoSellConnection:Disconnect()
                AutoSellConnection = nil
            end
            Fluent:Notify({
                Title = "Ringta Scripts",
                Content = "Auto-Sell Items disabled.",
                Duration = 5
            })
        end
    end)

    Tabs.Items:AddSection("➳ Tesla")

    local AutoSpawnTeslaButton = Tabs.Items:AddButton({
        Title = "Auto Spawn Tesla",
        Callback = function()
            local success, err = pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/Shade-vex/bruh/refs/heads/main/Auto-Tesla-Boss.lua"))()
            end)
            if not success then
                Fluent:Notify({
                    Title = "Ringta Scripts",
                    Content = "Failed to spawn Tesla: " .. tostring(err),
                    Duration = 5
                })
            else
                Fluent:Notify({
                    Title = "Ringta Scripts",
                    Content = "Tesla spawned successfully!",
                    Duration = 5
                })
            end
        end
    })
    ApplyHoverAnimation(AutoSpawnTeslaButton)

    local AutoKillTeslaButton = Tabs.Items:AddButton({
        Title = "Auto Kill Tesla",
        Callback = function()
            local success, err = pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/Shade-vex/bruh/refs/heads/main/Kill-Tesla-Boss.lua"))()
            end)
            if not success then
                Fluent:Notify({
                    Title = "Ringta Scripts",
                    Content = "Failed to kill Tesla: " .. tostring(err),
                    Duration = 5
                })
            else
                Fluent:Notify({
                    Title = "Ringta Scripts",
                    Content = "Tesla killed successfully!",
                    Duration = 5
                })
            end
        end
    })
    ApplyHoverAnimation(AutoKillTeslaButton)
end

-- Teleport Tab
do
    Tabs.Teleport:AddSection("➳ Locations")

    local TeleportDropdown = Tabs.Teleport:AddDropdown("TeleportDropdown", {
        Title = "Select Location",
        Values = {"Spawn", "Safe Zone", "Arena", "Secret Base"},
        Multi = false,
        Default = "Spawn",
    })

    local TeleportButton = Tabs.Teleport:AddButton({
        Title = "Teleport",
        Callback = function()
            local location = TeleportDropdown.Value
            local positions = {
                Spawn = Vector3.new(0, 5, 0),
                ["Safe Zone"] = Vector3.new(100, 5, 100),
                Arena = Vector3.new(-50, 5, -50),
                ["Secret Base"] = Vector3.new(200, 5, -200)
            }
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.CFrame = CFrame.new(positions[location])
                Fluent:Notify({
                    Title = "Ringta Scripts",
                    Content = "Teleported to " .. location .. "!",
                    Duration = 5
                })
            else
                Fluent:Notify({
                    Title = "Ringta Scripts",
                    Content = "Character not found!",
                    Duration = 5
                })
            end
        end
    })
    ApplyHoverAnimation(TeleportButton)
end

-- Player Tab
do
    Tabs.Player:AddSection("➳ Custom Keybinds")

    local NoclipKeybind = Enum.KeyCode.E
    Tabs.Player:AddDropdown("NoclipKeybindDropdown", {
        Title = "Noclip Keybind",
        Values = {"E", "Q", "F", "G"},
        Multi = false,
        Default = "E",
        Callback = function(Value)
            NoclipKeybind = Enum.KeyCode[Value]
            Fluent:Notify({
                Title = "Ringta Scripts",
                Content = "Noclip keybind set to " .. Value,
                Duration = 5
            })
        end
    })

    local NcToggle = Tabs.Player:AddToggle("NcToggle", {Title = "Noclip (Keybind)", Default = false })
    local noClipLoop
    NcToggle:OnChanged(function(Value)
        if Value then
            noClipLoop = RunService.Stepped:Connect(function()
                local character = LocalPlayer.Character
                if character then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        local isDead = humanoid.Health <= 0
                        for _, v in pairs(character:GetDescendants()) do
                            if v:IsA("MeshPart") or v:IsA("Part") then
                                v.CanCollide = isDead
                            end
                        end
                        local rootPart = character:FindFirstChild("HumanoidRootPart")
                        if rootPart and rootPart.Position.Y < -5 then
                            rootPart.CFrame = CFrame.new(rootPart.Position.X, 5, rootPart.Position.Z)
                        end
                    end
                end
            end)
            table.insert(Connections, noClipLoop)
            Fluent:Notify({
                Title = "Ringta Scripts",
                Content = "Noclip enabled! Use keybind to toggle.",
                Duration = 5
            })
        else
            if noClipLoop then
                noClipLoop:Disconnect()
                noClipLoop = nil
            end
            local character = LocalPlayer.Character
            if character then
                for _, v in pairs(character:GetDescendants()) do
                    if v:IsA("MeshPart") or v:IsA("Part") then
                        v.CanCollide = true
                    end
                end
            end
            Fluent:Notify({
                Title = "Ringta Scripts",
                Content = "Noclip disabled.",
                Duration = 5
            })
        end
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == NoclipKeybind then
            NcToggle:SetValue(not NcToggle.Value)
        end
    end)

    Tabs.Player:AddSection("➳ Movement")

    local FlyToggle = Tabs.Player:AddToggle("FlyToggle", {Title = "Fly", Default = false })
    local flyConnection
    FlyToggle:OnChanged(function(Value)
        if Value then
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.Parent = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            
            flyConnection = RunService.RenderStepped:Connect(function()
                local character = LocalPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    local rootPart = character.HumanoidRootPart
                    local moveDirection = humanoid.MoveDirection * 30
                    bodyVelocity.Velocity = Vector3.new(moveDirection.X, 0, moveDirection.Z)
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        bodyVelocity.Velocity = bodyVelocity.Velocity + Vector3.new(0, 30, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        bodyVelocity.Velocity = bodyVelocity.Velocity + Vector3.new(0, -30, 0)
                    end
                end
            end)
            table.insert(Connections, flyConnection)
            Fluent:Notify({
                Title = "Ringta Scripts",
                Content = "Fly enabled! Use Space to ascend, Shift to descend.",
                Duration = 5
            })
        else
            if flyConnection then
                flyConnection:Disconnect()
                flyConnection = nil
            end
            local rootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local bodyVelocity = rootPart:FindFirstChildOfClass("BodyVelocity")
                if bodyVelocity then
                    bodyVelocity:Destroy()
                end
            end
            Fluent:Notify({
                Title = "Ringta Scripts",
                Content = "Fly disabled.",
                Duration = 5
            })
        end
    end)

    local WalkSpeedToggle = Tabs.Player:AddToggle("WalkSpeedToggle", {Title = "WalkSpeed", Default = false })
    local speedLoop
    WalkSpeedToggle:OnChanged(function(Value)
        if Value then
            speedLoop = RunService.Heartbeat:Connect(function()
                local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = 50
                end
            end)
            table.insert(Connections, speedLoop)
            Fluent:Notify({
                Title = "Ringta Scripts",
                Content = "WalkSpeed enabled! Speed set to 50.",
                Duration = 5
            })
        else
            if speedLoop then
                speedLoop:Disconnect()
                speedLoop = nil
            end
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
            end
            Fluent:Notify({
                Title = "Ringta Scripts",
                Content = "WalkSpeed disabled. Speed reset to 16.",
                Duration = 5
            })
        end
    end)

    local JumpHeightToggle = Tabs.Player:AddToggle("JumpHeightToggle", {Title = "JumpHeight", Default = false })
    local jumpConnection
    JumpHeightToggle:OnChanged(function(Value)
        if Value then
            jumpConnection = RunService.Heartbeat:Connect(function()
                local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.JumpPower = 75
                end
            end)
            table.insert(Connections, jumpConnection)
            Fluent:Notify({
                Title = "Ringta Scripts",
                Content = "JumpHeight enabled! Jump power set to 75.",
                Duration = 5
            })
        else
            if jumpConnection then
                jumpConnection:Disconnect()
                jumpConnection = nil
            end
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.JumpPower = 50
            end
            Fluent:Notify({
                Title = "Ringta Scripts",
                Content = "JumpHeight disabled. Jump power reset to 50.",
                Duration = 5
            })
        end
    end)
end

-- Misc Tab
do
    Tabs.Misc:AddSection("➳ Utilities")

    local AntiAfkToggle = Tabs.Misc:AddToggle("AntiAfkToggle", {Title = "Anti AFK", Default = false })
    local afkConnection
    AntiAfkToggle:OnChanged(function(Value)
        if Value then
            afkConnection = LocalPlayer.Idled:Connect(function()
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
                task.wait(0.1)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
            end)
            table.insert(Connections, afkConnection)
            Fluent:Notify({
                Title = "Ringta Scripts",
                Content = "Anti AFK enabled!",
                Duration = 5
            })
        else
            if afkConnection then
                afkConnection:Disconnect()
                afkConnection = nil
            end
            Fluent:Notify({
                Title = "Ringta Scripts",
                Content = "Anti AFK disabled.",
                Duration = 5
            })
        end
    end)

    local FpsBoostButton = Tabs.Misc:AddButton({
        Title = "FPS Boost",
        Callback = function()
            local success, err = pcall(function()
                for _, v in pairs(Workspace:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.Material = Enum.Material.SmoothPlastic
                    elseif v:IsA("Decal") then
                        v:Destroy()
                    end
                end
                Lighting.GlobalShadows = false
                Lighting.FogEnd = 9e9
            end)
            if not success then
                Fluent:Notify({
                    Title = "Ringta Scripts",
                    Content = "Failed to apply FPS Boost: " .. tostring(err),
                    Duration = 5
                })
            else
                Fluent:Notify({
                    Title = "Ringta Scripts",
                    Content = "FPS Boost applied successfully!",
                    Duration = 5
                })
            end
        end
    })
    ApplyHoverAnimation(FpsBoostButton)

    Tabs.Misc:AddSection("➳ Weapon Mods")

    local BypassDelaysToggle = Tabs.Misc:AddToggle("BypassDelaysToggle", {Title = "Bypass Delays", Default = false })
    local bypassConnection
    BypassDelaysToggle:OnChanged(function(Value)
        if Value then
            bypassConnection = RunService.Heartbeat:Connect(function()
                local weaponConfig = ReplicatedStorage:FindFirstChild("WeaponConfiguration")
                if weaponConfig then
                    for _, config in pairs(weaponConfig:GetChildren()) do
                        config:SetAttribute("FireDelay", 0)
                        config:SetAttribute("ReloadTime", 0)
                    end
                end
            end)
            table.insert(Connections, bypassConnection)
            Fluent:Notify({
                Title = "Ringta Scripts",
                Content = "Bypass Delays enabled! Fire and reload delays set to 0.",
                Duration = 5
            })
        else
            if bypassConnection then
                bypassConnection:Disconnect()
                bypassConnection = nil
            end
            Fluent:Notify({
                Title = "Ringta Scripts",
                Content = "Bypass Delays disabled.",
                Duration = 5
            })
        end
    end)
end

-- Settings Tab
do
    Tabs.Settings:AddSection("➳ UI Settings")

    local UIAnimationToggle = Tabs.Settings:AddToggle("UIAnimationToggle", {Title = "Enable UI Animations", Description = "Toggle UI animations for better performance.", Default = true })
    UIAnimationToggle:OnChanged(function(Value)
        UIAnimationsEnabled = Value
        Fluent:Notify({
            Title = "Ringta Scripts",
            Content = "UI Animations " .. (Value and "enabled" or "disabled") .. "!",
            Duration = 5
        })
    end)

    Tabs.Settings:AddSection("➳ Script Settings")

    local AexecToggle = Tabs.Settings:AddToggle("AexecToggle", {Title = "Auto Execute", Default = false })
    AexecToggle:OnChanged(function(Value)
        if Value then
            task.spawn(function()
                pcall(function()
                    if queue_on_teleport then
                        local SkullHubScript1 = [[
                            task.wait(3)
                            loadstring(game:HttpGet('https://raw.githubusercontent.com/hungquan99/SkullHub/main/loader.lua'))()
                        ]]
                        queue_on_teleport(SkullHubScript1)
                    end
                end)
            end)
            Fluent:Notify({
                Title = "Ringta Scripts",
                Content = "Auto execute enabled!",
                Duration = 5
            })
        else
            Fluent:Notify({
                Title = "Ringta Scripts",
                Content = "Auto execute disabled!",
                Duration = 5
            })
        end
    end)

    SaveManager:SetLibrary(Fluent)
    InterfaceManager:SetLibrary(Fluent)
    SaveManager:IgnoreThemeSettings()
    SaveManager:SetIgnoreIndexes({})
    InterfaceManager:SetFolder("Ringta Scripts")
    SaveManager:SetFolder("Ringta X Enhanced/Dead Rails")
    InterfaceManager:BuildInterfaceSection(Tabs.Settings)
    SaveManager:BuildConfigSection(Tabs.Settings)
end

-- Select First Tab
Window:SelectTab(1)
Fluent:Notify({ Title = "Ringta Scripts", Content = "Enhanced Dead Rails script loaded successfully!", Duration = 5 })
SaveManager:LoadAutoloadConfig()

-- Enhanced Draggable UI Button with Gradient and Glow
local ExistingUI = CoreGui:FindFirstChild("SkullHubMinimizeUI")
if ExistingUI then ExistingUI:Destroy() end

local DragUI = Instance.new("ScreenGui")
DragUI.Name = "SkullHubMinimizeUI"
DragUI.ResetOnSpawn = false
DragUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
DragUI.Parent = CoreGui

local Button = Instance.new("ImageButton")
Button.Parent = DragUI
Button.Size = UDim2.new(0, 60, 0, 60)
Button.Position = UDim2.new(0, 10, 1, -85)
Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Button.BackgroundTransparency = 0.2
Button.BorderSizePixel = 0
Button.ClipsDescendants = true
Button.Image = "rbxassetid://90508203972003"
Button.ScaleType = Enum.ScaleType.Fit
Button.Active = true
Button.ZIndex = 1000

-- Add Gradient
local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(147, 112, 219)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 60, 150))
})
UIGradient.Parent = Button

-- Add Glow Effect (UIStroke)
local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(180, 140, 240)
UIStroke.Transparency = 0.5
UIStroke.Parent = Button

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = Button

local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function SimulateKeyPress()
    VirtualInputManager:SendKeyEvent(true, minimizeUI, false, game)
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(false, minimizeUI, false, game)
end

local isDragging = false
local dragThreshold = 10

Button.MouseButton1Click:Connect(function()
    if isDragging then return end
    TweenService:Create(Button, tweenInfo, {BackgroundTransparency = 0.5, Size = UDim2.new(0, 55, 0, 55), Rotation = 5}):Play()
    task.wait(0.1)
    TweenService:Create(Button, tweenInfo, {BackgroundTransparency = 0.2, Size = UDim2.new(0, 60, 0, 60), Rotation = 0}):Play()
    SimulateKeyPress()
end)

Button.MouseEnter:Connect(function()
    TweenService:Create(Button, tweenInfo, {Size = UDim2.new(0, 65, 0, 65), UIStroke.Transparency = 0}):Play()
end)

Button.MouseLeave:Connect(function()
    TweenService:Create(Button, tweenInfo, {Size = UDim2.new(0, 60, 0, 60), UIStroke.Transparency = 0.5}):Play()
end)

local dragging, dragStart, startPos

local function StartDrag(input)
    isDragging = false
    dragging = true
    dragStart = input.Position
    startPos = Button.Position

    input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
            dragging = false
        end
    end)
end

local function OnDrag(input)
    if dragging then
        local delta = (input.Position - dragStart).Magnitude
        if delta > dragThreshold then
            isDragging = true
        end
        local newX = startPos.X.Offset + (input.Position.X - dragStart.X)
        local newY = startPos.Y.Offset + (input.Position.Y - dragStart.Y)
        local screenSize = UserInputService:GetScreenResolution()
        newX = math.clamp(newX, 0, screenSize.X - Button.Size.X.Offset)
        newY = math.clamp(newY, 0, screenSize.Y - Button.Size.Y.Offset)
        Button.Position = UDim2.new(0, newX, 0, newY)
    end
end

Button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        StartDrag(input)
    end
end)

Button.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        OnDrag(input)
    end
end)

-- Cleanup on Script End
game:BindToClose(function()
    for _, conn in pairs(Connections) do
        if conn then
            conn:Disconnect()
        end
    end
    Connections = {}
end)