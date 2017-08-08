LIBRARY.Name = "Notifications"
LIBRARY.Author = "IZED"

local rpc = import("libs/rpc")
local utils = import("libs/utils")
local event = import("libs/event")
local cfg = import("config/notifications")

local counter = 0
local delayedCounter = 0
local list = {}
local yPos = 0

local function ThrowHint( options )
	if not options then options = {} end
	local color = options.color or Color(255, 255, 255)
	local text = options.text or ""
	local _counter = counter
	if list[_counter] then list[_counter]:Remove() list[_counter] = nil end

	local hint = vgui.Create("DPanel")
	if options.big then
		hint:SetPos( ScrW()*0.5 - utils.TextWidth("SoulMission80", text)*0.5,ScrH() * 0.2 + yPos )
		hint:SetSize(utils.TextWidth("SoulMission80", text), utils.TextHeight("SoulMission80", text))
	else
		hint:SetPos( ScrW() - utils.TextWidth(cfg.Font, text) - 20,ScrH() / 8 * 6 + yPos )
		hint:SetSize(utils.TextWidth(cfg.Font, text), utils.TextHeight(cfg.Font, text))
	end
	hint:SetDrawBackground(false)

	local label = vgui.Create( "ZOutlinedLabel", hint )
	label:SetPos( 0,0 )
	label:SetText( text )
	if big then
		label:SetFont( "SoulMission80" )
	else
		label:SetFont( cfg.Font )
	end
	label:SetColor( color )

	list[_counter] = {
		hint = hint,
		text = text,
		color = color,
		big = options.big
	}

	if options.chat then
		chat.AddText(color, text )
	else
		MsgC(color, text, "\n")
	end

	local th = utils.TextHeight(cfg.Font, "I")
	if options.big then
		th = utils.TextHeight("SoulMission60", "I")
	end

	if yPos == 0 then
		yPos = th
	elseif yPos == th then
		yPos = 2 * th
	elseif yPos == 2 * th then
		yPos = 3 * th
	elseif yPos == 3 * th then
		yPos = 4 * th
	elseif yPos == 4 * th then
		yPos = 5 * th
	else
		yPos = 0
	end

	timer.Create("Notification:".._counter, options.duration or 4, 1, function()
			list[_counter].moveLeft = true
	end)
	counter = _counter

	surface.PlaySound( "ambient/water/drip"..math.random(1, 4)..".wav" )
end

event.Observe("Tick"):subscribe(function()
	for k,v in pairs(list) do
		if v.hint and v.text and v.moveLeft then
			local x,y = v.hint:GetPos()
			v.hint:SetPos(x-5,y)
			if x <= ScrW() - utils.TextWidth(cfg.Font, v.text) - 50 then
				v.moveLeft = false
				v.moveRight = true
			end
		elseif v.hint and v.text and v.moveRight then
			local x,y = v.hint:GetPos()
			if list[k].big then
				v.hint:SetPos(x+80,y)
			else
				v.hint:SetPos(x+50,y)
			end
			if x >= ScrW() then
				list[k].hint:Remove()
				list[k].hint = nil
				list[k] = nil
			end
		end
	end
end)


COMPONENT.Create = function(options)
	utils.PrintTable(options)
	timer.Create( "DelayedHint:" .. delayedCounter, delay or 0, 1, function()
		ThrowHint(options)
	end)
	delayedCounter = delayedCounter + 1
end

rpc.Observe("notifications.Create"):subscribe(COMPONENT.Create)
