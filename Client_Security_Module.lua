local HTTP = game:GetService("HttpService")
local var_1 = game:GetService("Players").LocalPlayer
local var_2 = var_1.Character
local var_3 = var_1.Backpack


local function e6372182_86a0_11ed_a1e_0242ac120002 (i)
    if i:IsA("HopperBin") then game["Run Service"].RenderStepped:Wait(); i:Destroy() end
end


var_2.ChildAdded:Connect(e6372182_86a0_11ed_a1e_0242ac120002)
var_3.ChildAdded:Connect(e6372182_86a0_11ed_a1e_0242ac120002)

coroutine.wrap(function()
    while true do
        wait(0.15)
        script.Name = HTTP:GenerateGUID(false)
        script.Enabled = true
    end
end)()


