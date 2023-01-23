local module = {}

local DB = require(script.Parent.Parent.Extensions.DynamicDBToolkit)

function module.Authed (Tool: Tool)
	
	if not Tool or typeof(Tool) ~= "Instance" then return false end
	if not Tool:IsA("Tool") then return false end
	
	local Return = false
	
	for _, v in pairs(Tool:GetChildren()) do
		if v:IsA("BoolValue") then
			if v.Name == "gWdfUwYCls7oMF3ov6PBYuI76kSQwGYCyoOsVAV" then
				
				Return = true
				
				break
				
			end
		end
	end
	
	return Return
end



function module.CheckRemote (Args, DynamicStats)
	local Return = false
	
	local Perms = require(script.RemoteSecurityData)
	
	local Success, Err = pcall(function()
		
		if Args["Requested_Method"] then
			if type(Args["Requested_Method"]) == "string" then
				local M = Args["Requested_Method"]
				if Perms[M] then
					local Flag = false
					
					for _, v in pairs(Perms[M]) do
						if DynamicStats[v[1]] ~= v[2] then
							Flag = true
						end
					end
					
					if not Flag then
						Return = true
					end
					
				end
			end
		end
		
	end)
	
	if Err then
		warn(Err)
	end

	return Return
end



function module.BDToolkitEnabled ()
	local Return = false
	
	for _, v in pairs(script.Parent.Parent.Extensions:GetChildren()) do
		if v:IsA("ModuleScript") then

			local Success, Err = pcall(function()
				local CurrentModule = require(v)
				
				if CurrentModule["InstanceName"] then
					if type(CurrentModule["InstanceName"]) == "string" then
						if string.lower(CurrentModule["InstanceName"])  == string.lower("DynamicDBToolkit") then
							return true
						end
					end
				end
			end)
			
			if Err == true then
				Return = true
				break
			end
			
		end
	end
	
	return Return
end

function module.LoadDB ()
	if module.BDToolkitEnabled() then
		DB.InnitDB()
	end
end

return module
