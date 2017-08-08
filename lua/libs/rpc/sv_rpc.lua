local mod = LIBRARY
mod.Name = "RPC"
mod.Author = "IZED"

local rx = import("libs/rx")
local list = {}

util.AddNetworkString("RPC_CALL_CLIENT")
util.AddNetworkString("RPC_CALL_SERVER")
util.AddNetworkString("RPC_ERROR")

local rpcError = function(client, err)
	net.Start("RPC_ERROR")
		net.WriteString(err)
	net.Send(client)
end

net.Receive( "RPC_CALL_SERVER", function(length, client)
	local method = net.ReadString()
	local args = net.ReadTable()
	if not list[method] then rpcError(client, "Error calling " .. method .. ". Method not found") end
	list[method](client, unpack(args))
end) 

net.Receive( "RPC_ERROR", function(length, client)
	err("RPC", net.ReadString())
end)

mod.Observe = function(name)
	if type(name) ~= "string"then return end 
	return rx.Observable.create(function(observer)
		list[name] = function(...) 
			observer:onNext(...)
		end
		return function()
			list[name] = nil
			observer:onCompleted()
		end
	end)
end 

mod.Call = function(v1, v2, ...)
	net.Start("RPC_CALL_CLIENT")
	if(type(v1) == "string") then
		net.WriteString(v1)
		net.WriteTable({v2, ...})
		net.Broadcast()
	else
		net.WriteString(v2)
		net.WriteTable({...})
		net.Send(v1)
	end
end

local PLAYER = FindMetaTable("Player")

function PLAYER:CallRPC(method, ...)
	mod.Call(self, method, ...)
end