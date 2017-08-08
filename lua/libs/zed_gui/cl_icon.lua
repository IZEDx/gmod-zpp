local PANEL = {}

local function TextSize(font, text)
  surface.SetFont(font)
  return surface.GetTextSize(text)
end

function PANEL:Init()
	self:SetMouseInputEnabled( false )
	self:SetKeyboardInputEnabled( false )
end

function PANEL:PerformLayout()
end

function PANEL:PaintOver()
end

vgui.Register("ZIcon",PANEL,"ModelImage");

  
