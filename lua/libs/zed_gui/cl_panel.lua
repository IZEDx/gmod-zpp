local PANEL = {}

local blur = Material("pp/blurscreen")
local function DrawBlur(panel, amount)
	local x, y = panel:LocalToScreen(0, 0)
	local scrW, scrH = ScrW(), ScrH()
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(blur)
	for i = 1, 3 do
		blur:SetFloat("$blur", (i / 3) * (amount or 6))
		blur:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
	end
end

function PANEL:Init()
	self:SetBackgroundColor(Color(0, 0, 0, 200))
	self:SetOutlineColor(Color(255, 255, 255, 20))
end

function PANEL:Paint(c)
	DrawBlur(self, 6)
	surface.SetDrawColor(self:GetOutlineColor())
	surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
	surface.SetDrawColor(self:GetBackgroundColor())
	surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
end

function PANEL:SetOutlineColor(color)
	self.outlineColor = color
end

function PANEL:GetOutlineColor()
	return self.outlineColor
end

vgui.Register("ZPanel",PANEL,"DPanel");
