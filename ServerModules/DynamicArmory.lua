local DynamicArmory = {
	Framework = { -- This is NOT a configuration, do not modify these values
		Player = {
			CurrentPlayer = game.Players.PlayerAdded:Wait(),
			CurrentCharacter = game.Players.PlayerAdded:Wait().Character or game.Players.PlayerAdded:Wait().CharacterAppearanceLoaded:Wait(),
			DeviceType = "",
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

local SecurityLibrary = require(script.Parent.Library.SecurityLibrary)
local MainLibrary = require(script.Parent.Library.MainLibrary)
local RemoteControlLibrary = require(script.Parent.Library.RemoteControlLibrary)

-----------------------------
-------Player values---------
-----------------------------

local Player = DynamicArmoryFramework.Player.CurrentPlayer
local Character = DynamicArmoryFramework.Player.CurrentCharacter

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

local DynamicArmoryIsGunEquiped = DynamicArmoryGun._Stats.Equipped
local DynamicArmoryIsGunShooting = DynamicArmoryGun._Stats.Shooting
local DynamicArmoryIsGunBolting = DynamicArmoryGun._Stats.Bolting
local DynamicArmoryIsGunAiming = DynamicArmoryGun._Stats.Aiming

-----------------------------
--------Gun ammo-------------
-----------------------------

local DynamicArmoryGunAmmo = DynamicArmoryGun._Stats.Ammo
local DynamicArmoryMags = DynamicArmoryGun._Stats.Mags
local DynamicArmoryMaxMags = DynamicArmoryGun._Stats.MaxMags

local DynamicArmoryGunShells = DynamicArmoryGun._Stats.Ammo
local DynamicArmoryGunReserveShells = DynamicArmoryGun._Stats.ReserveShells
local DynamicArmoryGunMaxReserveShells = DynamicArmoryGun._Stats.MaxReserveShells

-----------------------------
---------Gun Misc------------
-----------------------------

local DynamicArmoryGunSettings = DynamicArmoryGun._Stats.ModConfig
local DynamicArmoryGunId = DynamicArmoryGun._Stats.Id

function DynamicArmory.DynamicArmoryWeapon ()
	
end

function DeltaAPI.New()

	Player = game.Players.PlayerAdded:Wait()
	Character = Player.Character or Player.CharacterAppearanceLoaded:Wait()


	--[[Functions]]--


	local function Auth (Tool)
		if not Tool then return end

		if Tool:FindFirstChild(Misc.ID) then return true else return false end
	end

	local function ChildAdded (Child)
		if not Child:IsA("Tool") or not Child then return end

		if not Auth(Child) or not Child:FindFirstChild("ID") then return end

		
		DeltaAPI.Framework.Tool.Tool = Child
		DeltaAPI.Framework.Player.Character = Character

		local EquipStatus, Failed = pcall(function()
			DeltaAPI.Framework.Tool.Config = Modules.MainLibrary.GetConfig(Child)
			DeltaAPI.Framework.Models.Gun.Model = Modules.MainLibrary.EquipGun(Character,tostring(Child:FindFirstChild("ID").Value), DeltaAPI.Framework.Tool.Config)
			
			RobloxSignal = game:GetService("RunService").Stepped:Connect(function()
				Character.Torso["Left Shoulder"].Transform = CFrame.new(0, 0, 0)
				Character.Torso["Right Shoulder"].Transform = CFrame.new(0, 0, 0)
			end)
		end)
		
		if Failed then
			print(Failed)
		end

	end

	local function ChildRemoved (Child)
		if Child == DeltaAPI.Framework.Tool.Tool then
			--RobloxSignal:Disconnect()
			Modules.MainLibrary.UnEquip(Character, DeltaAPI.Framework.Models.Gun.Model, DeltaAPI.Framework.Tool.Config)
		end
	end

	---[[Eqquip and Uneqquiped]]---
	
	Character.ChildAdded:Connect(function(Child)
		ChildAdded(Child)
	end)

	Character.ChildRemoved:Connect(function(Child)
		ChildRemoved(Child)
	end)

end

DynamicArmory.Functions = {
	Player = {
		character = Character
	}
}

return DynamicArmory
