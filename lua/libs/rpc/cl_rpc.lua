LIBRARY.Name = "RPC"
LIBRARY.Author = "IZED"

local rx = import("libs/rx")
local list = {}

local rpcError = function(err)
	net.Start("RPC_ERROR")
		net.WriteString(err)
	net.SendToServer()
end

net.Receive( "RPC_CALL_CLIENT", function(length)
	local method = net.ReadString()
	local args = net.ReadTable()
	if not list[method] then return rpcError("Error calling " .. method .. ". Method not found") end
	list[method](unpack(args))
end) 

net.Receive( "RPC_ERROR", function(length)
	err("RPC", net.ReadString())
end)

LIBRARY.Observe = function(name)
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

LIBRARY.Call = function(method, ...)
	net.Start("RPC_CALL_SERVER")
	net.WriteString(method)
	net.WriteTable({...})
	net.SendToServer()
end