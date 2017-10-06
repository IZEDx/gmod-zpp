local lib = LIBRARY
lib.Name = "MySQL"
lib.Author = "IZED"

local rx 			= import("libs/rx")
local utils 		= import("libs/utils")
local is 			= utils.is
local cfg 			= import("config/mysql")
local connections 	= keeper:Get("connections", {})

local function _queryError(results)
	if results[1] and not results[1].status then
		err("[sql]", "Error running query:", results[1].error)
		return true
	elseif not results[1] or #results == 0 then
		err("[sql]", "Error running query: Nothing returned!")
		return true
	end
	return false
end

local function _marshallTable(t)
	if type(t) ~= "table" then return end
	local tbl = table.Copy(t)
	for k,v in pairs(tbl) do
		if type(k) == "function" or type(k) == "userdata" or type(v) == "function" or type(v) == "userdata" then
			tbl[k] = nil
			continue
		end
		if type(v) == "table" then
			tbl[k] = ZDB.MarshallTable(v)
		end
	end
	return tbl
end

local CONNECTION = {}
function Connection(connectionHash)
	local this = {
		hash = connectionHash,
		usingMySQL = false,
		db = nil,
		tableName = "",
		data = {} 
	}
	setmetatable(this, CONNECTION)
	return this
end

function CONNECTION:initializeTables()
	self.tableName = self:escape(self.tableName)
	self:query([[CREATE TABLE if not exists `]]..self.tableName..[[` (`key` TEXT, `value` TEXT)]])
end

function CONNECTION:escape(s)
	if self.usingMySQL then
		return self.db:Escape(s)
	else
		return sql.SQLStr(s, true)
	end
end

function CONNECTION:query(query, callback, optionalArg)
	callback = type(callback) == "function" and callback or function() end
	if self.usingMySQL then
		self.db:Query(query, function(results)
			if _queryError(results) then return end
			if not results[1].data then
				return err("[sql]", "Error running SQLite query (Nothing returned): ", query)
			end
			callback(results[1].data, optionalArg)			
		end)
	else
		local results = sql.Query(query)
		if results and #results > 0 then
			callback(results, optionalArg)
		else
			callback({}, optionalArg)
		end
	end
end

function CONNECTION:getData(key, callback)
	if type(key) ~= "string" then return end
	if type(callback) ~= "function" then return end

	key = self:escape(key)
	self:query("SELECT `value` FROM `"..self.tableName.."` WHERE `key` = '"..key.."'", function(results)
		callback(#results > 0 and results[1].value)
	end)
end

function CONNECTION:setData(key, value)
	if type(key) ~= "string" then return end
	if type(value) == "function" or type(value) == "userdata" then return end

	if type(value) == "table" then
		value = util.TableToJSON(_marshallTable(value))
	end

	local _key, _value = self:escape(key), self:escape(tostring(value))

	self:getData(key, function(result)
		local query = "UPDATE `"..self.tableName.."` SET `value`='".._value.."' WHERE `key`='".._key.."'"
		if not result then
			query = "INSERT INTO `"..self.tableName.."` VALUES ( '" .. _key .. "', '".._value.."' )"
		end
		self:query(query)
	end)
end



function lib.Init(hostOrTbl, port, database, username, password, tbl)
	local connectionHash = util.CRC(tostring(hostOrTbl)..":"..tostring(port)..":"..tostring(database)..":"..tostring(tbl))
	if connections[connectionHash] then
		return connections[connectionHash]
	end

	local this = Connection(connectionHash)

	if not port or not database or not username or not password then
		this.tableName = hostOrTbl or "zpp_data"
	else
		require('tmysql4')

		this.tableName = tbl or "zpp_data"

		local conn, err = tmysql.initialize(hostOrTbl, username, password, database, port)
		this.db = conn
		if err then
			err("[sql]", "Error connecting to Database:", err)
			return
		end

		this.usingMySQL = true 
	end

	this:InitializeTables(this.tableName)

	connections[connectionHash] = this
	return this
end

function lib.Default(tbl)
	if not is(tbl).str() then
		tbl = "zpp_data"
	end
	if not cfg.UseMySQL then
		return lib.Init(tbl)
	end

	return lib.Init(cfg.Host, cfg.Port, cfg.Database, cfg.User, cfg.Password, tbl)
end