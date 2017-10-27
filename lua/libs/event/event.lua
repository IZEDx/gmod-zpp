local lib = LIBRARY
lib.Name = "Event"
lib.Author = "IZED"

local rx = import("libs/rx")

local counts = keeper:get("counts", {})

for k,v in pairs(counts) do
	hook.Remove(k, "Event:"..k..":"..v)
	counts[k] = 1
end

lib.Observe = function(h)
	if type(h) ~= "string" then 
		return 
	end

	local count = counts[h] or 1
	counts[h] = count + 1
	local hookName = "Event:"..h..":"..count

	return rx.Observable.create(function(observer)
		hook.Add(h, hookName, function(...)
			if not observer.stopped then
				return observer._onNext(...)
			end
		end)
		return function()
			hook.Remove(h, hookName)
			observer:onCompleted()
		end
	end)
end

lib.Call = hook.Run