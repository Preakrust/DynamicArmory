local module = {}

local ID = "gWdfUwYCls7oMF3ov6PBYuI76kSQwGYCyoOsVAV"

--Kinda basic but we only need that for client security library--

function module.Authed (Tool)
	if not Tool or not Tool:IsA("Tool") then return end

	if Tool:FindFirstChild(ID) then return true else return false end
end

return module
