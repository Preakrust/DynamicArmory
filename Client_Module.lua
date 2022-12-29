local  Delta_API = {}

local RBXsignal

--//Values 
local stop_back_and_forth = false
local first_person = false
local third_person = false

local RenderViewModel = false

local Shooting = false 
local Inspecting = false
local Bolting = false

local ViewModel = nil

--//Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local run = game:GetService("RunService")

----------[Keybinds]----------
local Key = require(script.key_binds)

----------[Main storage]----------
local Storage = ReplicatedStorage:WaitForChild("DELTA_API_STORAGE")

----------[Events]----------
local ServerEvent = Storage.Events.Client.Update
local ServerEvent2 = Storage.Events.Client.Update2

local UpdatePlugins = ReplicatedStorage.DELTA_API_STORAGE.Update_Plugins

----------[Local functions]----------

local function Motor6D_Group (G, P, Attachement, parent)
    for i, v in pairs(G:GetDescendants()) do
        if v:IsA("BasePart") and v ~= P then
            if Attachement == false then
                if not v.Parent:FindFirstAncestor("Attachement") then
                    local m = Instance.new("Motor6D");

                    m.Name = v.Name;
                    m.Part0 = P;
                    m.Part1 = v;
                    m.C0 = m.Part0.CFrame:Inverse() * m.Part1.CFrame;
                    m.Parent = parent;


                end
            else

                local m = Instance.new("Motor6D");

                m.Name = v.Name;
                m.Part0 = P;
                m.Part1 = v;
                m.C0 = m.Part0.CFrame:Inverse() * m.Part1.CFrame;
                m.Parent = parent;

            end

        end
    end
end

local function Motor6D (a, b, p)
    local m = Instance.new("Motor6D");
    m.Name = b.Name;
    m.Part0 = a;
    m.Part1 = b;
    m.Parent = p;
end

local function Remove_Applied_Forces (G)
    for i, v in pairs(G:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Anchored = false;
            v.CanCollide = false;
            v.CanTouch = true;
            v.CollisionGroup = "DELTA?ACTION='COOLISION'";
        end
    end
end

local swayOffset = CFrame.new()
local lastCameraCF = workspace.CurrentCamera.CFrame

function Delta_API:Client()
    
    ----------[Player variables]----------
    
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAppearanceLoaded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local currentCamera = workspace.CurrentCamera

    local limbs = {
        head = character:WaitForChild("Head"),
        torso = character:WaitForChild("Torso"),
        leftArm = character:WaitForChild("Left Arm"),
        rightArm = character:WaitForChild("Right Arm"),
        rootPart = character:WaitForChild("HumanoidRootPart")
    }
    
    ----------[Plugins]----------
    
    UpdatePlugins:Fire({
        Method = "Loaded",
    })

    ServerEvent.OnClientEvent:Connect(function(data)
        
        ----------[Gun variables]----------
        
        data.Gun_Animations = require(data.Tool.ModConfig.Animations)
        data.Gun_Settings = require(data.Tool.ModConfig.Configuration)
        data.Gun = data.Gun:Clone()
        data.Rig = data.Rig:Clone()
        
        ViewModel = data.Rig
        
        ----------[Local functions]----------
        
        local function ChangeCameraPerson(person, Rig)
            
            ----------[ViewModel render]----------
            
            if person == "1" then
                if Rig and not stop_back_and_forth then
                    Rig.Parent = workspace.CurrentCamera
                    RenderViewModel = true
                    first_person = true
                    third_person = false
                end
            else
                if Rig and not stop_back_and_forth then
                    Rig.Parent = ReplicatedStorage
                    RenderViewModel = false
                    first_person = false
                    third_person = true
                end
            end
            
            ----------[Plugins]----------
            
            UpdatePlugins:Fire({
                Method = "Render.Changed",
                RenderViewModel = RenderViewModel
            })
            
        end
        
        ----------[Camera]----------
        
        local function InitCamera()
            if limbs.head.LocalTransparencyModifier == 1 then
                ChangeCameraPerson("1", data.Rig)
            else
                ChangeCameraPerson("2", data.Rig)
            end
        end
         
        ----------[Main function]----------
        
        local function set_up_gun (Gun, Rig, Gun_Animations, config)
            
            ----------[Reset values]----------
            
            first_person = false
            third_person = false
            
            stop_back_and_forth = false
            RenderViewModel = false
            
            Bolting = false
            Inspecting = false
            
            ----------[Parent the viewmodel to the camera]----------
            Rig.Parent = currentCamera
            
            Gun.Parent = Rig
            Gun.PrimaryPart = Gun.Handle
            
            Gun.Connectors:FindFirstChildWhichIsA("Motor6D"):Destroy()
            
            Motor6D(Rig["Right Arm"], Gun.PrimaryPart, Rig["Right Arm"])
            Gun.PrimaryPart.CFrame = Rig["Right Arm"].CFrame
            
            --//Aestethic
            Rig["Right Arm"].Size = config.R_Size
            Rig["Left Arm"].Size = config.L_Size
            
            --//Animation
            Gun_Animations.Equip_Client(data.Rig)
            
            --//Images filtering
            for i, v in pairs(character[data.Gun.Name]:GetDescendants()) do
                if v.Name == "RED_DOT" then
                    if v.Transparency and not v.ImageTransparency then
                        v.Transparency = 1
                    elseif v.ImageTransparency and v.Transparency then
                        v.ImageTransparency = 1
                        v.Transparency = 1
                    end
                end
            end
            
            --//Remove an anoying glitch
            Remove_Applied_Forces(data.Rig)
            
            UpdatePlugins:Fire({ --Update plugins once the function is completed
                Method = "Equipped",
                Tool = data.Tool,
                Gun_ID = data.Tool.ID.Value,
                Gun = Gun,
            })
            
            InitCamera()
            
            if RenderViewModel then
                if data.Tool.Internal_Cache.Needs_Bolt.Value == 1 then
                    coroutine.wrap(function()
                        Bolting = true
                        wait(data.Gun_Animations.Bolt_Client(data.Rig, data.Gun))
                        Bolting = false

                        data.Tool.Internal_Cache.Needs_Bolt.Value = 0
                    end)()
                end
            end
        end
        
        -----------[Equip the gun]----------
        set_up_gun(data.Gun, data.Rig, data.Gun_Animations, data.Gun_Settings)
        
        
        ----------[Render the view model]----------
        RBXsignal = run.RenderStepped:Connect(function(dt)
            if RenderViewModel then
                data.Rig.PrimaryPart.CFrame = workspace.CurrentCamera.CFrame
            end
        end)
        
        ----------[start actions depending on input]----------
        UserInputService.InputBegan:Connect(function(InputObject, gameProccessedEvent)
            if InputObject.KeyCode == Key.inspect and RenderViewModel then

                if not Inspecting and not Shooting and not Bolting then
                    Inspecting = true

                    coroutine.wrap(function()
                        
                        UpdatePlugins:Fire({ --Update plugins once the function is completed
                            Method = "Gun_Inspecting_Started",
                            Tool = data.Tool,
                            Gun = data.Gun,
                        })
                        
                        local inpsect = wait(data.Gun_Animations.Inspect_Ammo_Client(data.Rig, data.Gun))
                        
                        UpdatePlugins:Fire({ --Update plugins once the function is completed
                            Method = "Gun_Inspecting_Stoped",
                            Tool = data.Tool,
                            Gun = data.Gun,
                        })
                        
                        Inspecting = false
                        
                    end)()

                end

            end
        end)

        player:GetMouse().Button1Down:Connect(function()
            
            player:GetMouse().Button1Up:Connect(function()
                
            end)
            
        end)
        
        
        limbs.head:GetPropertyChangedSignal('LocalTransparencyModifier'):Connect(function()
            if limbs.head.LocalTransparencyModifier == 1 then
                if not first_person then
                    if not RenderViewModel then
                        ChangeCameraPerson("1", data.Rig)
                    end
                end
            else
                if not third_person then
                    if RenderViewModel then
                        ChangeCameraPerson("2", data.Rig)
                    end
                end
            end
        end)
        
        ServerEvent2.OnClientEvent:Connect(function()
            UpdatePlugins:Fire({
                Method = "Un_Equip",
            })
            
            stop_back_and_forth = true
            RBXsignal:Disconnect()
            data.Rig:Destroy()
            
            
        end)
        
        
    end) 
end

function Delta_API.ViewModel ()
    return ViewModel
end

return Delta_API
