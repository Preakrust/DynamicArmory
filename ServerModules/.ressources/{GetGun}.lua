--!strict

return {
	Get = function (ID: string, Chracter: Model, CurrentTool: BoolValue) 
		if not CurrentTool then
			local Storage = require(script.Parent["{GetStorage}"]):WaitForChild("Models"):WaitForChild("Gun")
			local b = Storage:WaitForChild(ID).BaseGun:FindFirstChild(ID)
			
			if b then
				return b:Clone()
			end
			
		else
			local a = Chracter:FindFirstChild(ID)
			
			if a then
				return a
			end
		end
	end
}

