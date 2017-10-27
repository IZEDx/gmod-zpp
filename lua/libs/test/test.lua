export Name = "Test"
export Author = "IZED"

local lust = import("libs/lust")
local _print = keeper:get("print", print)
local path = {}

local function capture(t,s)
	if string.find(s, "PASS") then 
		t.passes = t.passes + 1
		t.total = t.total + 1
		t.lastfail = false
		return
	end
	if string.find(s, "FAIL") then
		t.total = t.total + 1
		t.lastfail = true
		table.insert(t.fails, string.match(s, "%s+(.+)"))
		return
	end
	if string.find(s, "%s+.+") and t.lastfail then
		t.fails[#t.fails] = t.fails[#t.fails] .. "\n\t" .. string.match(s, "%s+(.+)")
		return
	end
end

local function printResults(v)
		Z.dbg("TEST", v.name .. " passes: " .. v.passes .. "/" .. v.total)
		for _,fail in pairs(v.fails) do
			Z.err("TEST", fail)
		end
end

export describe = function(name, fn)
	table.insert(path, name)
	local t = {
		fails = {},
		lastfail = false,
		passes = 0,
		total = 0,
		name = table.concat(path, ".")
	}
	print = Z.compose(capture, t)
	lust.describe(name, function()

		fn()
	end)
	print = _print
	if t.total > 0 then
		printResults(t)
	end
	table.remove(path, #path)
end

export it = lust.it
export expect = lust.expect
export before = lust.before