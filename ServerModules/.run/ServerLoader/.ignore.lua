return {
	ServerLoaderFunction = function ()
		local JSON = require(script.Parent.Parent.Parent.OpenLibrary["{JSON-Library}"])
		
		local Env = script.Parent.Parent.Parent[".env"]
		
		local CurrentEnv = Env[".info"][".CurrentEnv"]
		
		
		CurrentEnv.Value = JSON.Encode({
			GameID = game.GameId,
			JobId = game.JobId,
			
			CreatorID = game.CreatorId,
			GameName = game.Name,
		})
		
	end,
}
