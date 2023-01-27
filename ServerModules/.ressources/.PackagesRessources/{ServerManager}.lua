return {function (player: Player, character: Model)
	--Open Library--

	local OpenLibrary = script.Parent.Parent.Parent.OpenLibrary
	local PackageManager = require(OpenLibrary["{PackageManager}"])
	
	--rsc--
	
	local GetGun = require(script.Parent.Parent["{GetGun}"]).Get
	local SetGunCFrame = require(script.Parent.Parent["{SetModelCFrame}"]).Set
	
	
	--Package--
	local PackageArgs = PackageManager.NewVirtualPackageArgs.New("SecurityPackage", "45875852", "Omega Software", "0.0.0.2")
	local SecurityPackage = PackageManager.NewVirtualPackage(PackageArgs)


	--Add libraries inside the package--


	for _, v in pairs(script.Parent.Parent[".securityPackage"]:GetChildren()) do
		if v:IsA("ModuleScript") then
			PackageManager.ImportModuleToPackage(SecurityPackage, v, v.Name)
		end
	end
	
	
	character.ChildAdded:Connect(function(tool: Tool)
		if SecurityPackage["{Authed}"]["Authed"](tool) then
			local Gun = GetGun(tool.ID.Value, character, false)
			
			Gun.Parent = game.Workspace
			SetGunCFrame(Gun, character.PrimaryPart.CFrame)
		end
	end)
	
	
	
end}

