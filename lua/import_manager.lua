
local list = {}
local cl_files = {}
local CompileString = _G.CompileString
local _import

local dependencyNotFound = function(caller, dependency)
	return Z.err("DEPENDENCY", "Can't find dependency:", dependency, "(Required by " .. caller .. ")")
end 
 
--------------------------------------------------------------------------------

local createFileRunner = function(path, prestr)
	if not path then return end
	if type(prestr) ~= "function" then prestr = function(...) return ... end end
	local code = ""
	if SERVER then
		if not file.Exists(path, "LUA") then return "File not found:" .. tostring(path), "DEPENDENCY" end
		code = file.Read(path, "LUA")
	else
		code = cl_files[path]
	end
	return CompileString(prestr(tostring(code)), path, false)
end


local runInComponentContext = function(file, compHandler) 
	local oldComp = _G.COMPONENT
	local oldCompHandler = _G[compHandler]
	local comp = {}
	_G.COMPONENT = comp
	_G.import = function(dep)
		local imp = _import(dep, file)
		if imp == "Error" then 
			comp.DependencyNotFound = true
			if type(comp.OnDependencyNotFound) == "function" then
				comp.OnDependencyNotFound(dep)
			end
		end
		return imp
	end 

	local runner, errtype = createFileRunner(file, function(code)
		code = string.gsub(code, "(%s*)export%s+(%w+)", "%1COMPONENT.%2")
		code = string.gsub(code, [[import\\(([\\"\\'].+[\\"\\'])\\)]], [[import(%1) if DNF then return "Error" end]])
		code = [[local COMPONENT = _G.COMPONENT local ]]..compHandler..[[ = COMPONENT local keeper = keeper.Create("]]..file..[[") local import = _G.import local DNF = COMPONENT.DependencyNotFound ]] .. code
		return code
	end)
	if type(runner) ~= "function" then
		Z.err(errtype or "LUA", runner)
	else
		local newComp = runner()
		if newComp ~= nil then
			if type(newComp) == "table" then
				for k,v in pairs(newComp) do
					comp[k] = v
				end
			else
				comp._return = newComp
			end
		end
	end 

	_G.COMPONENT = oldComp
	_G.import = _import
	return comp
end

local getComponentType = function(dep)
	if dep:sub(0, 8) == "modules/" then
		return "module"
	elseif dep:sub(0, 5) == "libs/" then
		return "library"
	elseif dep:sub(0, 5) == "tests/" then
		return "test"
	elseif dep:sub(0, 7) == "config/" then
		return "config"
	else
		return "file"
	end
end

local findFiles = function(dep)
	local parts = dep:Split("/")
	local _file = parts[#parts]
	table.remove(parts)
	local dir = table.concat(parts, "/").."/"
	local result = {}
	local found = false

	if _file:sub(0,3) == "sv_" or _file:sub(0,3) == "cl_" then
		_file = _file:sub(4)
	end

	if _file:sub(-4) == ".lua" then
		_file = _file:sub(0,-5)
	end


	if SERVER then
		local serverFiles,_ = file.Find(dir.."sv_".._file..".lua", "LUA")
		for k,v in pairs(serverFiles) do
			found = true
			table.insert(result, {path = dir.."sv_".._file..".lua", client = false, server = true})
		end
	end

	local clientFiles,_ = file.Find(dir.."cl_".._file..".lua", "LUA")
	for k,v in pairs(clientFiles) do
		found = true
		table.insert(result, {path = dir.."cl_".._file..".lua", client = true, server = false})
	end

	local noPrefixFiles,_ = file.Find(dir.._file..".lua", "LUA")
	for k,v in pairs(noPrefixFiles) do
		found = true
		table.insert(result, {path = dir.._file..".lua", client = true, server = true})
	end

	return found and result
end

local findDirs = function(dep)
	local path = dep .. "/"
	local files,_ = file.Find(path .. "*.lua", "LUA")
	local result = {}
	local found = false

	for k,v in pairs(files) do
		local prefix = v:sub(0,3)
		local client = prefix ~= "sv_"
		local server = prefix ~= "cl_"
		if 	client or (server and SERVER) or (client and server) then 
			table.insert(result, {path = path..v, client = client, server = server})
			found = true
		end
	end

	return found and result
end

--------------------------------------------------------------------------------


function import(dep, caller)
	if list[dep] then
		return list[dep]
	end
	if type(caller) ~= "string" then caller = dep end

	local compType = getComponentType(dep)
	local find = (compType == "module" or compType == "library") and findDirs or findFiles
	local files = find(dep)
	DEPENDENCY_NOT_FOUND = nil
	if not files then
		DEPENDENCY_NOT_FOUND = true
		return dependencyNotFound(caller, dep) 
	end
	list[dep] = {
		Dependency = dep
	}

	Z.dbg("DEPENDENCY", "Loading " .. compType .. ": ", dep, "(Required by " .. caller .. ")")

	for k,v in pairs(files) do
		if (v.client and CLIENT) or (v.server and SERVER) then
			local comp = runInComponentContext(v.path, compType:upper())
			for k,v in pairs(comp) do 
				if not list[dep][k] then
					list[dep][k] = v
				end
			end
		end
		if v.client and SERVER then
			AddCSLuaFile(v.path)
			cl_files[v.path] = file.Read(v.path, "LUA")
			if string.len(cl_files[v.path]) > 65400 then
				Z.err("FILE SIZE", v.path .. " is dangerously big. This may result in a cut off when sending to the client and cause unwanted behaviour and Lua Errors. Consider minifying it or splitting it up into multiple files.")
			end
		end
	end
	
	if list[dep]._return then
		return list[dep]._return
	end
	return list[dep] 
end


_import = import

if SERVER then
	util.AddNetworkString( "LOAD_DEPENDENCY" )

	hook.Run("DependenciesReady")

	local _sendFilesToPlayer = function(ply)
		local id = 0
		local max = 0
		for k,v in pairs(cl_files) do 
			max = max + 1
		end
		for k,v in pairs(cl_files) do
			id = id + 1
			net.Start("LOAD_DEPENDENCY")
			net.WriteInt(id, 32)
			net.WriteInt(max, 32)
			net.WriteString(k)
			net.WriteString(v)
			net.Send(ply)
		end
	end

	hook.Add("PlayerInitialSpawn", "DEPENDENCY_INIT", _sendFilesToPlayer)

	for k,v in pairs(player.GetAll()) do
		_sendFilesToPlayer(v)
	end
else
	net.Receive("LOAD_DEPENDENCY", function(len) 
		local id = net.ReadInt(32)
		local max = net.ReadInt(32)
		local file = net.ReadString()
		local code = net.ReadString()
		cl_files[file] = code

		--Z.dbg("FILE", "Received file:", file, id)

		if id >= max then
			hook.Run("DependenciesReady")
		end
	end)
end