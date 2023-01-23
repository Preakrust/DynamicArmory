local module = {InstanceName = 'DynamicDBToolkit'} --DO NOT REMOVE

local ErrorsCore = {
	"DynamicDBToolkit: Trying to access a protected function from an unautharized mean, Current Security ID = %s, Required Secuirity ID = %s, Please only use call functions using securityLibrary (check our docs if you don't know) -- DDBT Debuger."
}

local Errors = {
	LackingPerms = function (CurrentID, WantedID, Warn)
		local Final = string.format(ErrorsCore[1], tostring(CurrentID), tostring(WantedID))

		if Warn then
			warn(Final)
		end

		return Final
	end
}



function module:InnitDB()
	if getfenv(2).script == script.Parent.Parent.Library.SecurityLibrary then
		return true
	else
		Errors.LackingPerms(1, 2, true)
		return false
	end
end

return module

