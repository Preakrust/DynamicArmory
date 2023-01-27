--!strict

return function ()
	
	--Player Loader--
	
	local Player = require(script.Parent.Parent[".ressources"]["{GetPlayer}"])
	local Character = Player.Character or Player.CharacterAppearanceLoaded:Wait()
	
	--Open Library--
	
	local OpenLibrary = script.Parent.Parent.OpenLibrary
	local PackageManager = require(OpenLibrary["{PackageManager}"])
	
	--Package--
	local PackageArgs = PackageManager.NewVirtualPackageArgs.New("DAP", "45875852", "Omega Software", "0.0.0.2")
	local DAP = PackageManager.NewVirtualPackage(PackageArgs)
	
	
	--Add libraries inside the package--
	
	
	for _, v in pairs(script.Parent.Parent[".ressources"][".PackagesRessources"]:GetChildren()) do
		if v:IsA("ModuleScript") then
			PackageManager.ImportModuleToPackage(DAP, v, v.Name)
		end
	end
	
	
	--Start the code stuff idk--
	
	
	DAP["{ServerManager}"]()
	
	
end

