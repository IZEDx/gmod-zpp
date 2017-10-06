LIBRARY.Name = "Variables"
LIBRARY.Author = "IZED"

local utils 	= import("libs/utils")
local rpc 		= import("libs/rpc")
local event 	= import("libs/event")
local sql 		= import("libs/sql")

local variables = keeper:Get("variables", {})
local counter = 0

local data = sql.Default("zpp_data")
local pdata = sql.Default("zpp_pdata")

local VARIABLE = {}
function LIBRARY.Create(name, value, options)
	if not is(name).str() then
		return nil
	end

	counter = counter + 1
	local this = {
		id = counter,
		name = name,
		value = nil,
		player = is(options):with("player") and options.player or nil,
		private = is(options):with("private") and options.private or false,
		store = is(options):with("store") and options.store or false
	}

	setmetatable(this, VARIABLE)
	this:set(value)
	return this
end

function VARIABLE:set(value)

end

function VARIABLE:remove()

end

function VARIABLE:load(cb)
	if not self.store then
		return self.value
	end
	if is(self.player):ply() then
		data.getData(self.player:SteamID()..";"..tostring(self.name), function(result)
			cb(result)
		end)
	else
		data.getData(self.name, function(result)
			cb(result)
		end)
	end
	return self.value
end

function VARIABLE:get(storeCb)
	if is(storeCb):fn() and self.store then
		self:load(storeCb)
	end
	return self.value
end



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