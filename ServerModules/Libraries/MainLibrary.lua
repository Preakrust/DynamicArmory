local module = {}

function module.EquipGun (Character, ToolId, Config)
	-----------------------------
	----DynamicArmory values-----
	-----------------------------

	local DynamicArmoryStorage = game.ReplicatedStorage:WaitForChild("DynamicArmoryStorage")

	-----------------------------
	---------Modules-------------
	-----------------------------

	local Utilities = require(DynamicArmoryStorage:WaitForChild("modules"):WaitForChild("Utilities"))

	-----------------------------
	--------Libraires------------
	-----------------------------

	local Animations = require(script.Parent.AnimationLibrary)

	-----------------------------
	--------Functions------------
	-----------------------------

	local function GetGun(ID)
		if not ID then return end

		-----------------------------
		-------Get the gun-----------
		-----------------------------

		local Gun = DynamicArmoryStorage:WaitForChild("Models"):WaitForChild("Gun"):WaitForChild(ID).BaseGun:WaitForChild(ID):Clone()

		-----------------------------
		-----------------------------
		-----------------------------

		Utilities.Remove_Forces(Gun)

		-----------------------------
		-----------------------------
		-----------------------------

		return Gun
	end


	local function WeldGun(Gun)
		if not Gun or not Character["Right Arm"] then return end

		-----------------------------
		-----Parenting and stuff-----
		-----------------------------

		Gun.Parent = Character
		Gun.PrimaryPart = Gun.Handle

		-----------------------------
		-------Weld the gun----------
		-----------------------------

		Utilities.Weld_Group(Gun, Gun.PrimaryPart, false, Gun.Welds)

		-----------------------------
		---Weld the gun to the arm---
		-----------------------------

		local WeldGunToArm = Utilities.Weld(Character["Right Arm"], Gun.PrimaryPart, Gun.Connectors)

		-----------------------------
		----------ToolGrip-----------
		-----------------------------

		Animations.SetToolGrip(WeldGunToArm, Config)

		-----------------------------
		-------Play some anims-------
		-----------------------------

		Animations.SetArms(Config,Character.Torso["Left Shoulder"], Character.Torso["Right Shoulder"])

	end

	-----------------------------
	-----------------------------
	-----------------------------

	local CurrentGun = GetGun(ToolId)

	-----------------------------
	-----------------------------
	-----------------------------

	WeldGun(CurrentGun)

	-----------------------------
	-----------------------------
	-----------------------------

	return CurrentGun
end

function module.Holster (Gun)

end

function module.UnEquip (Character, Gun, Config)
	local function Destroy ()
		local Utilities = require(game:GetService("ReplicatedStorage"):WaitForChild("DynamicArmoryStorage"):WaitForChild("modules"):WaitForChild("Utilities"))
		local Animations = require(script.Parent.AnimationLibrary)

		Animations.UnSetArms(Config, Gun ,Character.Torso["Left Shoulder"], Character.Torso["Right Shoulder"])
		module.Holster()
	end

	Destroy()
end

function module.GetConfig (Tool)
	return Tool.ModConfig
end

function module.NewBullet ()

end

return module
