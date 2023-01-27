--!strict

return {
	Authed = function (tool: Tool)
		if not tool or typeof(tool) ~= "Instance" then return false end
		if not tool:IsA("Tool") then return false end

		local Return = false

		for _, v in pairs(tool:GetChildren()) do
			if v:IsA("BoolValue") then
				if v.Name == "gWdfUwYCls7oMF3ov6PBYuI76kSQwGYCyoOsVAV" then
					Return = true 
					break
				end
			end
		end

		return Return
	end
} 
