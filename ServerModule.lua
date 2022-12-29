local Delta_API = {}

local Settings = {}

Settings.Table = {
    --[[Settings]]--
    
    --//Movements
    Sliding = true,
    Crouching = true,
    Running = true,
    Leaning = true,
    
    --//Info
    Tool_Identifier = "gWdfUwYCls7oMF3ov6PBYuI76kSQwGYCyoOsVAV",
    Rig_Name = "Rig",
    
}




--//Values
local Selected_Weapon_Model = nil
local Current_Settings = nil
local Animations_Module = nil
--//Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--//Plugins
local Update_Plugins = ReplicatedStorage.DELTA_API_STORAGE.Update_Plugins
--//Main_Storage
local Storage = ReplicatedStorage:WaitForChild("DELTA_API_STORAGE")

--//Storage children

local SendInfoToClient = Storage.Events.Client.Update
local SendInfoToClient2 = Storage.Events.Client.Update2

local Pr

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
            v.CollisionGroup = "Delta_Gun_Engine";
        end
    end
end

function Delta_API:Server() 
    
    Update_Plugins:Fire({ --Updates plugins
        Method = "API_LOADING",
    })
    
    local PhysicsService = game:GetService("PhysicsService")
    
    PhysicsService:RegisterCollisionGroup("DELTA?ACTION='COOLISION'")

    PhysicsService:CollisionGroupSetCollidable("DELTA?ACTION='COOLISION'", "DELTA?ACTION='COOLISION'", false)
    PhysicsService:CollisionGroupSetCollidable("DELTA?ACTION='COOLISION'", "Default", false)

    
    game.Players.PlayerAdded:Connect(function(Player)
        Player.CharacterAppearanceLoaded:Connect(function(character)
            
            Update_Plugins:Fire({ --Updates plugins
                Method = "API_LOADED",
            })
            
            Pr = Player
            
           local Limbs = {
                head = character:WaitForChild("Head"),
                torso = character:WaitForChild("Torso"),
                leftArm = character:WaitForChild("Left Arm"),
                rightArm = character:WaitForChild("Right Arm"),
                rootPart = character:WaitForChild("HumanoidRootPart")
            }
            
            
            
            character.ChildAdded:Connect(function(Added_Instance)
                if Added_Instance:FindFirstChild(Settings.Table.Tool_Identifier) then
                    
                    local function check_for_property (i, p)
                        
                        
                        
                        if i:FindFirstChild(p.Name or p) then
                            return false
                        end
                        
                        local success, err = pcall(function()
                            if i[p] then
                                
                            end
                        end)
                        
                        if success then
                            return true
                        else
                            return false
                        end
                    end
                    
                    
                    local function Innit_Cache (Cache, Settings)
                        for i, v in pairs(Cache:GetChildren()) do
                            if check_for_property(v, "Value") then
                                if v.Value == -1 then
                                    v.Value = Settings.Gun_Values[v.Name]
                                end
                            end
                        end
                    end
                    
                    local function Remove_Weapon ()
                        
                        Animations_Module.Un_Equip_Server(character)
                        Selected_Weapon_Model:Destroy()
                        
                        SendInfoToClient2:FireClient(Player, {
                            Method = "Un_Equip",
                        })
                    end
                    
                    local function Load_Attachement (Gun)
                        for i, v in pairs(Storage.Models.Gun[Added_Instance.ID.Value].BaseAttachement:GetChildren()) do
                            
                            v = v:Clone()
                            
                            v.PrimaryPart = v[v.Name]
                            v.Parent = Gun.Attachement
                            Motor6D_Group(v, v[v.Name], true, v[v.Name])
                            Motor6D(Gun.AttachementNodes[v.Name], v[v.Name], v)
                            v[v.Name].CFrame = Gun.AttachementNodes[v.Name].CFrame
                            
                            Remove_Applied_Forces(v)
                            
                        end
                    end

                    local function Set_Gun (Gun, Setting, anim)
                        
                        Gun.Parent =  character
                        Motor6D_Group(Gun, Gun.Handle, false, Gun.Welds)
                        Motor6D(Limbs.rightArm, Gun.Handle, Gun.Connectors)
                        Remove_Applied_Forces(Gun)
                        
                        Gun.Handle.CFrame = Limbs.rightArm.CFrame
                        
                        anim.Equip_Server(character, Gun)
                        
                        
                        
                        
                        SendInfoToClient:FireClient(Player,{
                            Method = "Equipped",
                            Tool = Added_Instance,
                            Gun_ID = Added_Instance.ID.Value,
                            Gun = Gun,
                            Rig = Storage.Models[Settings.Table.Rig_Name];
                            Gun_Settings = Current_Settings,
                            Gun_Animations = anim
                            
                        })
                        
                    end
                    
                    
                    
                    
                    Selected_Weapon_Model = Storage.Models.Gun[Added_Instance.ID.Value].BaseGun[Added_Instance.ID.Value]:Clone()
                    Current_Settings = require(Added_Instance.ModConfig.Configuration)
                    Animations_Module = require(Added_Instance.ModConfig.Animations)
                    Innit_Cache(Added_Instance:FindFirstChild("Internal_Cache"), Current_Settings)
                    Load_Attachement(Selected_Weapon_Model)
                    Set_Gun(Selected_Weapon_Model, Current_Settings, Animations_Module)
                    
                    
                    
                    
                    Update_Plugins:Fire({ --Updates plugins
                        Method = "Equipped",
                        Gun_ID = Added_Instance.ID.Value,
                        Gun = Selected_Weapon_Model,
                        Gun_Settings = Current_Settings,
                        Gun_Animations = Animations_Module,
                    })
                    
                    
                    
                    
                    
                    
                    
                    character.ChildRemoved:Connect(function(Removed_Child)
                        if Removed_Child == Added_Instance then
                            Remove_Weapon()
                        end
                    end)


                    
                end
            end)
            
            
            
            
        end)
    end)
    
end


function Delta_API.Gun ()
    if not Selected_Weapon_Model then return end
    return Selected_Weapon_Model
end


function Delta_API.Player ()
    if not Pr then return end
    return Pr
end

function Delta_API.Character ()
    if not Pr.Character then Pr.CharacterAppearanceLoaded:Wait() end
    
    
    return Pr.Character
end

function Delta_API.Limbs (character)
    return {
        head = character:WaitForChild("Head"),
        torso = character:WaitForChild("Torso"),
        leftArm = character:WaitForChild("Left Arm"),
        rightArm = character:WaitForChild("Right Arm"),
        rootPart = character:WaitForChild("HumanoidRootPart")
    }
end

return Delta_API
