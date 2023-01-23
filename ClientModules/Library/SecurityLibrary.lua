--!strict

local module = {}

--Kinda basic but we only need that for client security library--

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

return module
