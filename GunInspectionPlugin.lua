game.ReplicatedStorage.DELTA_API_STORAGE.Update_Plugins.Event:Connect(function(data)
    local Inpsecting = false
    if data.Method == "Gun_Inspecting_Started" then
        -- Update your gun engine plugins here, using the Gun_ID passed in the data argument
        print(data.Tool.Internal_Cache.Ammo.Value)
        Inpsecting = true
    elseif data.Method == "Gun_Inspecting_Stoped" then
        
        print("Gun stoped inspecting")
        Inpsecting = false
    
    end
end)
