if SERVER then
	AddCSLuaFile()
	AddCSLuaFile("import_manager.lua")
	AddCSLuaFile("keeper.lua")
end
include("keeper.lua")

_G.Z = {}  
Z.Debug = true
 
print("")
print("----------------------------------------------")
print("--------- Z++  Dependencies for GMod! --------")
print("----------------------------------------------") 

function Z.compose(fn, ...)
	local a = {...}
	local c = table.maxn(a)
	return function(...)
		local d = {}
		local b = {...}
		for i = 1, table.maxn(a) do
			d[i] = a[i]
		end
		for i = 1, table.maxn(b) do
			d[c + i] = b[i]
		end
		return fn(unpack(d))
	end  
end 

function Z.extract(fn, ...)
	if type(fn) == "function" then
		return fn(...)
	else
		return fn
	end
end

function Z.cout(...) 
	MsgC(Color(200,200,100), "[Z++] ") 
	local args = ""
	for k,v in pairs({...}) do
		args = args .. tostring(v) .. "   "
	end
	MsgC(Color(200,200,200), args, "\n")
end

function Z.err(tag, ...)
	MsgC(Color(200,100,100), "["..tag.."] ") 
	local args = ""
	for k,v in pairs({...}) do
		args = args .. tostring(v) .. "   "
	end
	MsgC(Color(200,200,200), args, "\n") 
	return "Error"
end

function Z.dbg(tag, ...)
	if not Z.Debug then return end
	MsgC(Color(100,200,100), "["..tag.."] ")  
	local args = ""
	local a = {...}
	for i = 1, table.maxn(a) do
		args = args .. tostring(a[i]) .. i .. "   "
	end
	MsgC(Color(200,200,200), args, "\n")
end

local asyncs = {}
function Z.async(fn, ...)
	table.insert(asyncs, {fn = fn, args = {...}})
end
local function callAsyncs(justone)
	for i,async in ipairs(asyncs) do
		table.remove(asyncs, i)
		async.fn(unpack(async.args))
		if justone then return end
	end	
end

hook.Add("Tick", "ASYNCLOOP", Z.compose(callAsyncs, true))

if SERVER then
	hook.Add("DependenciesReady", "DEPENDENCIES_READY", function()
		local _, modules = file.Find("modules/*", "LUA") 
		for _, dir in pairs(modules, false) do
			if dir == "." or dir == ".." then continue end
			import("modules/"..dir, nil, true)
		end
		callAsyncs(false)
	end)
else
	hook.Add("DependenciesReady", "DEPENDENCIES_READY", function()
		local _, modules = file.Find("modules/*", "LUA") 
		for _, dir in pairs(modules, false) do
			if dir == "." or dir == ".." then continue end
			import("modules/"..dir, nil, true)
		end
		callAsyncs(false)
	end)
end

include("import_manager.lua") 

hook.Run("Z++Ready")

print("")