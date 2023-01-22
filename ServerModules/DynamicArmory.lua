local DeltaAPI = {
	Framework = { -- This is NOT a configuration, do not modify these values
		Player = {
			Character = nil,
		},

		Tool = {
			Config = nil,
			Equipped = false,
			Tool = nil,
			_Stats = {
				Ammo = nil,
				Shooting = false,
				Inspecting = false,
				Bolting = false,
				Aiming = false,
			}
		},

		Models = {
			Gun = {
				Model = nil,
			},
		},
	},

}

--[[Long story]]
local FunctionToRender = {}

local Player
local Character

--[[ Services ]]--
local Services = {
	ReplicatedStorage = game:GetService("ReplicatedStorage"),
	UserInputService = game:GetService("UserInputService"),
	RunService = game:GetService("RunService"),
}

--[[ Storage ]]--
local APIStorage = Services.ReplicatedStorage:WaitForChild("DynamicArmoryStorage")

local Storage = {
	Events = APIStorage:WaitForChild("Events"),
	Models = APIStorage:WaitForChild("Models"),
}

local Modules = {
	MainLibrary = require(script.Parent.Library.MainLibrary)
}

local Misc = {
	ID = "gWdfUwYCls7oMF3ov6PBYuI76kSQwGYCyoOsVAV",
}

local function ServerCheck ()

end

local RobloxSignal



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

DeltaAPI.Functions = {
	Player = {
		character = Character
	}
}

return DeltaAPI
