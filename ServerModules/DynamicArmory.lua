local DynamicArmory = {
	Framework = { -- This is NOT a configuration, do not modify these values
		Player = {
			CurrentPlayer = nil,
			CurrentCharacter =nil,
		},

		Gun = {
			CurrentTool = nil,

			Models = {
				GunModel = nil,
			},

			_Stats = {
				ModConfig = nil,
				Id = "",

				Equipped = false,
				Shooting = false,
				Inspecting = false,
				Bolting = false,
				Aiming = false,

				Ammo = 0,
				Mags = 0,
				MaxMags = 0,

				Shells = 0,
				ReserveShells = 0,
				MaxReserveShells = 0,
			}
		},

	},
}


-----------------------------
----DynamicArmory values-----
-----------------------------

local DynamicArmoryFramework = DynamicArmory.Framework
local DynamicArmoryStorage = game.ReplicatedStorage:WaitForChild("DynamicArmoryStorage")
local Functions = DynamicArmory.Functions

local UpdateServer = DynamicArmoryStorage.Events:WaitForChild("UpdateServer")
local UpdateClient = DynamicArmoryStorage.Events:WaitForChild("UpdateClient")

-----------------------------
-------Libraries-------------
-----------------------------

local SecurityLibrary = require(script.Parent.Libraries.SecurityLibrary)
local MainLibrary = require(script.Parent.Libraries.MainLibrary)
local RemoteControlLibrary = require(script.Parent.Libraries.RemoteControlLibrary)
local DB = require(script.Parent.Extensions.DynamicDBToolkit)
-----------------------------
-------Player values---------
-----------------------------

local Player = DynamicArmoryFramework.Player.CurrentPlayer
local Character = DynamicArmoryFramework.Player.CurrentCharacter

Player = game.Players.PlayerAdded:Wait()
Character = Player.Character or Player.CharacterAppearanceLoaded:Wait()

-----------------------------
-------Gun values------------
-----------------------------

local DynamicArmoryGun = DynamicArmoryFramework.Gun

-----------------------------
---------Gun Tool------------
-----------------------------

local DynamicArmoryCurrentTool = DynamicArmoryGun.CurrentTool

local DynamicArmoryToolDestroyed = false

-----------------------------
--------Gun Models-----------
-----------------------------

local DynamicArmoryCurrentToolModels = DynamicArmoryGun.Models

local DynamicArmoryCurrentGunModel = DynamicArmoryCurrentToolModels.GunModel

-----------------------------
---------Gun Stats-----------
-----------------------------
local DynamicArmoryGunStats = DynamicArmoryGun._Stats
local DynamicArmoryIsGunEquiped = DynamicArmoryGunStats.Equipped
local DynamicArmoryIsGunShooting = DynamicArmoryGunStats.Shooting
local DynamicArmoryIsGunBolting = DynamicArmoryGunStats.Bolting
local DynamicArmoryIsGunAiming = DynamicArmoryGunStats.Aiming

-----------------------------
--------Gun ammo-------------
-----------------------------

local DynamicArmoryGunAmmo = DynamicArmoryGunStats.Ammo
local DynamicArmoryMags = DynamicArmoryGunStats.Mags
local DynamicArmoryMaxMags = DynamicArmoryGunStats.MaxMags

local DynamicArmoryGunShells = DynamicArmoryGunStats.Ammo
local DynamicArmoryGunReserveShells = DynamicArmoryGunStats.ReserveShells
local DynamicArmoryGunMaxReserveShells = DynamicArmoryGunStats.MaxReserveShells

-----------------------------
---------Gun Misc------------
-----------------------------

local DynamicArmoryGunSettings = DynamicArmoryGunStats.ModConfig
local DynamicArmoryGunId = DynamicArmoryGunStats.Id

DynamicArmory.CoreFunctions = {--//PLEASE DON'T USE IT'S FOR DEVS ONLY!
	-----------------------------
	--------(DEV ONLY)-----------
	-----------------------------

	Stat = function (n, v)
		if getfenv(2).script == script then 
			if n or v then
				if DynamicArmoryGunStats[n] ~= nil then
					DynamicArmoryGunStats[n] = v
				else
					warn("DynamicArmoryCore: Invalid Child, Arg n is not a valid member of DynamicArmoryGunStats.")
				end
			else
				if not n then
					warn("DynamicArmoryCore: Arg Missing, Arg = n.")
				end

				if not v then
					warn("DynamicArmoryCore: Arg Missing, Arg = v.")
				end
			end

		else
			warn("DynamicArmoryCore: Tried to call a CoreFunction from an unauthorized script, CoreFunctions are meant to be used by developers only and can cause big security issues if not used properly.")
		end
	end,

	-----------------------------
	--------(DEV ONLY)-----------
	-----------------------------
}

DynamicArmory.Functions = {

	Gun = {
		Shoot = function (Origin, Direction)
			
			-----------------------------
			--------Core stuff-----------
			-----------------------------
			
			DynamicArmory.CoreFunctions.Stat("Shooting", true)
			
			-----------------------------
			----------Values-------------
			-----------------------------
			
			local Params = RaycastParams.new()
			
			-----------------------------
			----------Raycast------------
			-----------------------------
			
			Params.FilterType = Enum.RaycastFilterType.Blacklist
			Params.FilterDescendantsInstances = {Character}
			
			local Result = workspace:Raycast(Origin, Direction * 500, Params)
			
			-----------------------------
			----------Analyze------------
			-----------------------------
			if Result then
				if Result.Instance.Name ~= "Terrain" then
					if Result.Instance:IsA("BasePart") then
						if Result.Instance.Parent:FindFirstChild("Humanoid") then
							Result.Instance.Parent:FindFirstChild("Humanoid"):TakeDamage(50)
						end
					end
				end
			end
			
			
		end,
	}












}

function DynamicArmory.DynamicArmoryWeapon ()

	-----------------------------
	---------Core stuff----------
	-----------------------------

	local Core = DynamicArmory.CoreFunctions
	local UpdateCore = Core.Stat

	-----------------------------
	-------Starter stuff---------
	-----------------------------

	SecurityLibrary.LoadDB()

	-----------------------------
	-----Internal Functions------
	-----------------------------


	local function ChildAdded (Tool)

		-----------------------------
		----Is the tool is a gun?----
		-----------------------------

		if not SecurityLibrary.Authed(Tool) then return end

		-----------------------------
		---Set the equipped status---
		-----------------------------

		UpdateCore("Equipped", true)

		DynamicArmoryGunStats.Equipped = true

		-----------------------------
		------Set current tool-------
		-----------------------------

		DynamicArmoryCurrentTool = Tool

		-----------------------------
		--------Remote Events--------
		-----------------------------

		UpdateServer.OnServerEvent:Connect(function(Plr, Args)


			if SecurityLibrary.CheckRemote(Args, DynamicArmoryGunStats) then 
				if Args["Requested_Method"] == "Shoot" then
					DynamicArmory.Functions.Gun.Shoot(Args.O, Args.D)
				end
			end
			
		end)

	end



	Character.ChildAdded:Connect(function(Tool)
		ChildAdded(Tool)
	end)
end



return DynamicArmory
