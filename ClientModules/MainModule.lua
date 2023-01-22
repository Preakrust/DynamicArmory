local DynamicArmory = {
	Framework = { -- This is NOT a configuration, do not modify these values
		Player = {
			CurrentPlayer = game.Players.LocalPlayer,
			CurrentCharacter = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAppearanceLoaded:Wait(),
			DeviceType = "",
		},

		Gun = {
			RenderStepped = true,

			CurrentTool = nil,

			Models = {
				ViewModel = nil,
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

		Cars = {

		}
	},

	Cache = {
		CL = {"Head", "Torso", "Left Arm", "Right Arm", "Right Leg", "Left Leg"}
	}
}


-----------------------------
----DynamicArmory values-----
-----------------------------

local DynamicArmoryFramework = DynamicArmory.Framework
local DynamicArmoryStorage = game.ReplicatedStorage:WaitForChild("DynamicArmoryStorage")
local Functions = DynamicArmory.Functions

-----------------------------
-------Libraries-------------
-----------------------------

local MainLibrary = require(script.Parent.Library.MainLibrary)
local OSLibrary = require(script.Parent.Library.OSlibrary)
local SecurityLibrary = require(script.Parent.Library.SecurityLibrary)
local RenderingLibrary = require(script.Parent.Library.RenderingLibrary)
local Utilities = require(DynamicArmoryStorage.modules.Utilities)

-----------------------------
-------Player values---------
-----------------------------

local Player = DynamicArmoryFramework.Player.CurrentPlayer
local Character = DynamicArmoryFramework.Player.CurrentCharacter

-----------------------------
----Device values------------
-----------------------------

local UserDeviceType = DynamicArmoryFramework.Player.DeviceType

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
local DynamicArmoryCurrentViewModel = DynamicArmoryCurrentToolModels.ViewModel

-----------------------------
---------Gun Stats-----------
-----------------------------

local DynamicArmoryIsGunEquiped = DynamicArmoryGun._Stats.Equipped
local DynamicArmoryIsGunShooting = DynamicArmoryGun._Stats.Shooting
local DynamicArmoryIsGunBolting = DynamicArmoryGun._Stats.Bolting
local DynamicArmoryIsGunAiming = DynamicArmoryGun._Stats.Aiming
local DynamicArmoryGunRenderStepped = DynamicArmoryGun.RenderStepped

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

-----------------------------
-----Built in functions------
-----------------------------

DynamicArmory.Functions = {

	Gun = {
		IsEquipped = function ()
			return DynamicArmoryIsGunEquiped
		end,

		SetViewModelCFrame = function (cf)
			if not cf then return end

			if DynamicArmoryCurrentViewModel and DynamicArmoryIsGunEquiped then
				DynamicArmoryCurrentViewModel.HRP.CFrame = cf
			end

		end,

		GetViewModel = function ()
			if DynamicArmoryCurrentViewModel and DynamicArmoryIsGunEquiped then
				return DynamicArmoryCurrentViewModel
			end
		end,
	},

	Character = {
		GetLimbFromName = function (Limb)
			if not Limb or not table.find(DynamicArmory.Cache.CL, Limb) then return end

			return DynamicArmory.Framework.Player.CurrentCharacter:FindFirstChild("Limb")
		end,

		GetLimbs = function ()
			local t = {}

			for _, v in pairs(DynamicArmory.Framework.Player.CurrentCharacter:GetChildren()) do
				if table.find(DynamicArmory.Cache.CL, v.Name) then
					t[v.Name] = v
				end
			end

			return t
		end,

		GetLimbsMotor6D = function ()
			local t = {}

			for _, v in pairs(DynamicArmory.Framework.Player.CurrentCharacter:GetChildren()) do
				if table.find(DynamicArmory.Cache.CL, v.Name) then
					t[v.Name] = v
				end
			end

			return t
		end,
	}


}

-----------------------------
-------Main functions--------
-----------------------------



function DynamicArmory.DynamicArmoryWeapon()

	-----------------------------
	-------Render Values---------
	-----------------------------

	local DynamicArmoryRender
	local DynamicArmoryRenderStepped

	-----------------------------
	-----Internal Functions------
	-----------------------------

	local function ChildAdded (Child)

		-----------------------------
		----Is the tool is a gun?----
		-----------------------------

		if not SecurityLibrary.Authed(Child) then return end

		-----------------------------
		---Set the equipped status---
		-----------------------------

		DynamicArmoryIsGunEquiped = true
		
		-----------------------------
		------Set current tool-------
		-----------------------------

		DynamicArmoryCurrentTool = Child

		-----------------------------
		-------Get device type-------
		-----------------------------

		UserDeviceType = OSLibrary.GetGeneralType(OSLibrary.GetPlatformType())

		-----------------------------
		-----Set IDs and stuff-------
		-----------------------------

		DynamicArmoryGunSettings = MainLibrary.GetConfig(Child)
		DynamicArmoryGunId = Child:FindFirstChild("ID").Value

		-----------------------------
		-----Equip the gun duh-------
		-----------------------------

		DynamicArmoryCurrentViewModel = MainLibrary.EqupViewModel(UserDeviceType, DynamicArmoryGunSettings)
		DynamicArmoryCurrentGunModel = MainLibrary.EquipGun(DynamicArmoryCurrentViewModel, DynamicArmoryGunId, DynamicArmoryGunSettings)

		-----------------------------
		--Require the gun settings---
		-----------------------------

		local UsableDynamicArmoryGunSettings = require(DynamicArmoryGunSettings)
		
		-----------------------------
		-----Get render settings-----
		-----------------------------
		
		local DynamicArmoryGunSettingsRenderShirt = UsableDynamicArmoryGunSettings.ClientRenderParameters.RenderShirt
		local DynamicArmoryGunSettingsRenderSkinTone = UsableDynamicArmoryGunSettings.ClientRenderParameters.RenderShirt
		
		-----------------------------
		--------Render the gun-------
		-----------------------------
		
		DynamicArmoryRender = game:GetService("RunService").Stepped:Connect(function()
			-----------------------------
			---Overide roblox animation--
			-----------------------------
			
			Utilities.OverideArmsAnimation(Character)
		end)

		DynamicArmoryRenderStepped = game:GetService("RunService").RenderStepped:Connect(function(dt)
			-----------------------------
			--Render the gun (for real)--
			-----------------------------
			
			if DynamicArmoryGunRenderStepped then
				DynamicArmory.Functions.Gun.SetViewModelCFrame(workspace.CurrentCamera.CFrame)
			end
			
			-----------------------------
			----Aestethic Stuff (yeah)---
			-----------------------------
			
			RenderingLibrary.RenderViewModelAestethic(DynamicArmoryCurrentViewModel, DynamicArmoryGunSettingsRenderShirt, DynamicArmoryGunSettingsRenderShirt)

		end)
		
		-----------------------------
		----Unequip and stuff--------
		-----------------------------
		
		DynamicArmoryCurrentTool.Destroying:Connect(function()
			DynamicArmoryToolDestroyed = true --//This has really no use for client but for ServerModule it would but huh
		end)
		
		Character.ChildRemoved:Connect(function(Child)
			if not DynamicArmoryToolDestroyed then
				MainLibrary.UnEquip(DynamicArmoryGunSettings, DynamicArmoryCurrentViewModel)
			else
				MainLibrary.UnEquip(DynamicArmoryGunSettings, DynamicArmoryCurrentViewModel)
			end
		end)
		
		workspace.CurrentCamera.ChildRemoved:Connect(function()
			if not workspace.CurrentCamera:FindFirstChild("DynamicArmoryViewModelRig") then
				if DynamicArmoryToolDestroyed then
					DynamicArmoryToolDestroyed = false
				end
			end
		end)

	end

	-----------------------------
	-----Do some stuff------
	-----------------------------

	Character.ChildAdded:Connect(function(Child)
		ChildAdded(Child)
	end)

end

return DynamicArmory
