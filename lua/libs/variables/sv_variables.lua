LIBRARY.Name = "Variables"
LIBRARY.Author = "IZED"

local utils = import("libs/utils")
local rpc = import("libs/rpc")
local event = import("libs/event")

local variables = {}
local counter = 0

LIBRARY.Create = function(name, value, ply)
	counter = counter + 1
	local this = {
		id = counter,
		name = name,
		value = nil,
		ply = ply,
		set = function(self, newValue)
			self.value = utils.SanitizeTable(newValue)
			if ply and ply:IsValid() then
				ply:CallRPC("SetNetworkedVariable", self.name, self.value)
			else
				rpc.Call("SetNetworkedVariable", self.name, self.value)
			end
			event.Call("SetNetworkedVariable", self.name, self.value)
			variables[self.id] = self
		end,
		remove = function(self)
			if ply and ply:IsValid() then
				ply:callRPC("RemoveNetworkedVariable", self.name)
			else
				rpc.Call("RemoveNetworkedVariable", self.name)
			end
			event.Call("RemoveNetworkedVariable", self.name)
			variables[self.id] = nil
			self = nil
		end,
		get = function(self)
			return self.value
		end
	}
	this:set(value)
	return this
end

event.Observe("PlayerInitialSpawn"):subscribe(function(ply)
	for k,v in pairs(variables) do
		ply:callRPC("SetNetworkedVariable", v.name, v.value)
	end
end)