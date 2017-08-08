_G._KEEPERSTORE = _G._KEEPERSTORE or {}
_G.keeper = {}
local KEEPER = {}
local store = _KEEPERSTORE

keeper.Create = function(namespace)
	local this = {
		namespace = namespace,

		Get = function(self, name, default)
			if not store[self.namespace][name] then
				store[self.namespace][name] = default
			end
			return store[self.namespace][name]
		end,

		Set = function(self, name, value)
			store[self.namespace][name] = value
		end
	}

	if not store[namespace] then
		store[namespace] = {}
	end

	return this
end
