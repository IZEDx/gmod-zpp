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
print("--------- Z++  Make Lua Great Again! ---------")
print("----------------------------------------------") 

function Z.curry(fn, ...)
	local args = {...}
	return function(...)
		return fn(unpack(args), ...)
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
	for k,v in pairs({...}) do
		args = args .. tostring(v) .. "   "
	end
	MsgC(Color(200,200,200), args, "\n")
end

hook.Add("DependenciesReady", "DEPENDENCIES_READY", function()
	local _, modules = file.Find("modules/*", "LUA") 
	for _, dir in pairs(modules, false) do
		if dir == "." or dir == ".." then continue end
		local n = "modules/"..dir
		import(n)
	end  
end)

include("import_manager.lua") 

hook.Run("Z++Ready")

print("")