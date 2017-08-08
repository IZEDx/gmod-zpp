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