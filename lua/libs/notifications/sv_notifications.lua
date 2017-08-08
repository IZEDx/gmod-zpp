LIBRARY.Name = "Notifications"
LIBRARY.Author = "IZED"

local rpc = import("libs/rpc")

local createNotification = function(ply, options)
	options.color = options.color or Color(255,255,255)
	options.text = options.text or "Sample Text"
	options.delay = options.delay or 0
	options.duration = options.duration or 4
	options.chat = options.chat or false
	options.big = big or false
	rpc.Call(ply, "notifications.Create", options)
end

local PLAYER = FindMetaTable("Player")

function PLAYER:Hint(text, options)
	if type(options) ~= "table" then options = {} end
	options.text = text
	createNotification(self, options)
end


LIBRARY.Broadcast = function(options)
	for _,ply in pairs(player.GetAll()) do
		createNotification(ply, options)
	end
end