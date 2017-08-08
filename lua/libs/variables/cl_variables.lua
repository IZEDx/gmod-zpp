LIBRARY.Name = "Variables"
LIBRARY.Author = "IZED"

local rpc = import("libs/rpc")
local event = import("libs/event")

rpc.Observe("SetNetworkedVariable"):subscribe(function(name, value)
	_G[name] = value
	event.Call("SetNetworkedVariable", name, value)
	dbg("Set variable", name, "to value", tostring(value))
end)

rpc.Observe("RemoveNetworkedVariable"):subscribe(function(name)
	_G[name] = nil
	event.Call("RemoveNetworkedVariable", name)
	dbg("Removed variable", name)
end)