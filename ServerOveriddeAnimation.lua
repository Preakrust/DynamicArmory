local event = game.ReplicatedStorage.DELTA_API_STORAGE.Events.Server.Update
local API = script.Parent.Parent.Parent.ModuleScript
local Required_API = require(API)

local RBX_SIGNAL 

local c 
local L 


game.ReplicatedStorage.Update_Plugins.Event:Connect(function(data)
    local Inpsecting = false
    
    if data.Method == "Equipped" then
        
        c = Required_API.Character()
        L = Required_API.Limbs(c)
        
        RBX_SIGNAL = game["Run Service"].Stepped:Connect(function()
            L.torso["Left Shoulder"].Transform = L.torso["Left Shoulder"].Transform:Lerp(CFrame.new(0, 0, 0), 1)
            L.torso["Right Shoulder"].Transform = L.torso["Right Shoulder"].Transform:Lerp(CFrame.new(0, 0, 0), 1)
        end)
        
        
    elseif data.Method == "Un_Eqquiped" then
        RBX_SIGNAL:Disconnect()
    end
end)


