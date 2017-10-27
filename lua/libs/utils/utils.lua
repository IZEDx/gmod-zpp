LIBRARY.Name = "Utils"
LIBRARY.Author = "IZED"

function LIBRARY.FindPlayer(name)
	for k,v in pairs(player.GetAll()) do
		if string.find(string.lower(v:GetName()), string.lower(name)) then
			return v
		end
	end
	return false
end

function LIBRARY.FindPlayerByID(steamid)
	for k,v in pairs(player.GetAll()) do
		if string.find(string.lower(v:SteamID()), string.lower(steamid)) then
			return v
		end
	end
	return false
end


function LIBRARY.CallMapEntities(name, func, ...)
	for k,v in pairs(ents.GetAll()) do
		if v.keyValues and v.keyValues.targetname and v.keyValues.targetname == name then
			v[func](v, ...)
		end
	end
end

function LIBRARY.GetMapEntities(name)
	local tbl = {}
	for k,v in pairs(ents.GetAll()) do
		if v.keyValues and v.keyValues.targetname and v.keyValues.targetname == name then
			table.insert(tbl, v)
		end
	end
	return tbl
end


function LIBRARY.SanitizeTable(tbl)
	if type(tbl) == "table" then
		local ret = {}
		for k,v in pairs(tbl) do
			if type(v) == "table" then
				ret[k] = serializeTable(v)
			elseif type(v) == "number" or type(v) == "boolean" or type(v) == "string" then
				ret[k] = v
			end
		end
		return ret
	elseif type(v) == "number" or type(v) == "boolean" or type(v) == "string" then
		return tbl
	else
		return nil
	end
end



local function _printTable(tbl, spaces, func)
	for k,v in pairs(tbl) do
		if type(v) ~= "table" then
			func(spaces .. tostring(k) .. ": " .. tostring(v))
		else
			func(spaces .. tostring(k) .. ": {")
			_printTable(v, spaces .. "  ", func)
			func(spaces .. "}")
		end
	end
end
function LIBRARY.PrintTable(tbl, func)
	if not func then func = print end
	func("{")
	_printTable(tbl, "  ", func)
	func("}")
end

local IS = {}
local IS_mt = {__index = IS}
function LIBRARY.Is(v)
	local this = {
		value = v
	}

	setmetatable(this, IS_mt)

	return this
end


local function _ofType(t, v)
	return type(v) == t
end
local _types = {}
_types = {
	str		= Z.compose(_ofType, "string"),
	num		= Z.compose(_ofType, "number"),
	bool	= Z.compose(_ofType, "boolean"),
	fn		= Z.compose(_ofType, "function"),
	tbl		= Z.compose(_ofType, "table"),
	ud		= Z.compose(_ofType, "userdata"),

	valid	= function(v)
		return IsValid(v)
	end,

	int 	= function(v)
		if not _types.num(v) then return false end
		local _,f = math.modf(v)
		return f == 0
	end,

	float	= function(v)
		if not _types.num(v) then return false end
		local _,f = math.modf(v)
		return f ~= 0
	end,

	size = function(v, size)
		if not _types.num(size) then return false end
		if _types.str(v) or _types.tbl(v) then
			return #v == size
		end
		return false
	end,

	range	= function(v, min, max)
		if not _types.num(min) then return false end
		if not _types.num(max) then
			max = min
			min = 0
		end

		if _types.num(v) then
			return v >= min and v <= max
		end

		if _types.str(v) or _types.tbl(v) then
			return #v >= min and #v <= max
		end

		return false
	end,

	with	= function(v, ...)
		local options = {...}
		if #options == 1 and _types.tbl(options[1]) then
			options = options[1]
		end
		if not _types.tbl(v) then
			return false
		end
		for k,v in pairs(options) do
			local key = k
			if _types.str(v) and not _types.str(k) then
				key = v
			end
			if _types.str(key) then
				if options[key] then
					return false
				end
			end
		end
		return true
	end
}

for k,v in pairs(_types) do
	IS[k] = function(self, ...)
		return v(self.value, ...)
	end
end

if Z.Debug then
	Z.async(import, "tests/utils")
end

