----------[Override arm animations, set A to false if you use animations made in the roblox animation editor or Moon]----------

local RBX_SIGNAL
local A = true

game.ReplicatedStorage.Update_Plugins.Event:Connect(function(data)
    local Inpsecting = false
    if data.Method == "Equipped" then
        
        RBX_SIGNAL = game:GetService("RunService").Stepped:Connect(function()
           
            local c = game.Players.LocalPlayer.Character 
            
            if A then
                c.Torso["Left Shoulder"].Transform = c.Torso["Left Shoulder"].Transform:Lerp(CFrame.new(0, 0, 0), 1)
                c.Torso["Right Shoulder"].Transform = c.Torso["Right Shoulder"].Transform:Lerp(CFrame.new(0, 0, 0), 1)
            end
            
        end)
        
    elseif data.Method == "Un_Equip" then
        RBX_SIGNAL:Disconnect()
    end
end)
