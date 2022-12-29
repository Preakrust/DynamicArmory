----------[API viewModel visual effect (e.g bobbing and swaying, easy to modify and stuff)]----------
local API = require(script.Parent.Parent.Parent.ClientModule)

----------[Events]----------
local UPDATE_PLUGINS_EVENT = game.ReplicatedStorage.Update_Plugins

----------[Connections]----------
local RBX_SIGNAL 

----------[Player variables]----------

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAppearanceLoaded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local currentCamera = workspace.CurrentCamera

----------[Values]----------
local RENDER_VIEW_MODEL = false
local EQUIPPED = false
local ViewModel = nil
local prevOscillatingForce = 0
local prevBreathOscillatingForce = 0

UPDATE_PLUGINS_EVENT.Event:Connect(function(data)
    if data.Method == "Equipped" then
        EQUIPPED = true
        RBX_SIGNAL = game:GetService("RunService").RenderStepped:Connect(function(dt)
            if EQUIPPED and RENDER_VIEW_MODEL then
                ViewModel = API.ViewModel()
                
                local startPosition = ViewModel.PrimaryPart.Position
                
                local function Bobbing(Viewmodel, setting)
                    local w = false
                    
                    humanoid.Changed:Connect(function()
                        if humanoid.MoveDirection.magnitude > 0 then
                            if not w then
                                w = true
                                game.TweenService:Create(script.Alpha, TweenInfo.new(0.1), {Value = 1}):Play()
                            end
                        else
                            if w then
                                w = false
                                game.TweenService:Create(script.Alpha, TweenInfo.new(1), {Value = 0}):Play()
                            end
                        end
                    end)
                    
                    
                    local oscillatingForce =  math.sin(tick() * 5)  -- calculate the oscillating force value
                    ViewModel.PrimaryPart.CFrame = ViewModel.PrimaryPart.CFrame:Lerp(
                        ViewModel.PrimaryPart.CFrame * CFrame.new(0, oscillatingForce / 10, 0) * CFrame.Angles(math.rad(oscillatingForce * 10), math.rad(-oscillatingForce * 10), 0),
                        script.Alpha.Value
                    )
                end
                
                
                local function Breath (Viewmodel, setting)

                    local oscillatingForce =  math.sin(tick() * 3) * 0.5 * 0.5 
                    local smoothedOscillatingForce = (oscillatingForce - prevBreathOscillatingForce) / dt

                    ViewModel.PrimaryPart.CFrame *= CFrame.new(0, oscillatingForce / 17, 0)
                end
                
                if ViewModel then

                    for i, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                        if v:IsA("Shirt") then
                            local Template, Color = v.ShirtTemplate, v.Color3
                            local Shirt = ViewModel.Shirt
                            Shirt.ShirtTemplate = Template
                            Shirt.Color3 = Color
                        end
                    end

                    Bobbing(ViewModel)
                    Breath(ViewModel)
                end
            end
        end)
      
    elseif data.Method == "Un_Equip" then
        EQUIPPED = false
        RBX_SIGNAL:Disconnect()
    elseif data.Method == "Render.Changed" then
        RENDER_VIEW_MODEL = data.RenderViewModel
    end
end)

