local module = {}

local Bindable

local t = {}
t.__index = t


function Trow (err_code, opt_msg)
	if opt_msg and type(opt_msg) == "string" then
		warn(err_code, opt_msg)
	else
		warn(err_code)
	end
	
end

function module:New()
	Bindable = Instance.new("BindableEvent")
	Bindable.Name = game:GetService("HttpService"):GenerateGUID(false).." | "..game.JobId
	
	setmetatable(t, {})
	
	t.API = {
		Loaded = "Event"
	}
	
	return t
end

function module:Publish(Event)
	Bindable:Fire({["EventMethod"] = tostring(Event)})
end

function module:Subscribe (Event, Function)

	Bindable.Event:Connect(function(a)
		if not a["EventMethod"] or type(a["EventMethod"]) ~= "string" then return end
		
		local event_String_Table = string.split(a["EventMethod"], ".")
		
		local requested_class = event_String_Table[1]
		local requested_event = event_String_Table[2]
		
		if rawget(t, requested_class) then
			if rawget(t[requested_class], requested_event) then
				Function()
			end
		end
		
	end)
end

return module
