local PANEL = {}

local function TextSize(font, text)
  surface.SetFont(font)
  return surface.GetTextSize(text)
end

function PANEL:Init()
  local Frame = self

  self:SetTitle( "" )
  self:SetVisible(true)
  self:SetDraggable(false)
  self:SetBackgroundBlur(true)
  self:ShowCloseButton(false)
  self.Font = "ZEDFont40"
  self.BackgroundColor = Color(40, 40, 40, 255)

  local w,h = TextSize(self.Font, "X")
  self.CloseButton = vgui.Create( "ZButton", self )
  self.CloseButton:SetPos( 0, 0 )
  self.CloseButton:SetText( "X" )
  self.CloseButton:SetFont( self.Font )
  self.CloseButton:SetSize(w,h)
  self.CloseButton.DoClick = function()
    Frame:Close()
    if type(Frame.onClose) == "function" then
      Frame:onClose()
    end
  end
end


function PANEL:SetFont(c)
  self.CloseButton:SetFont(c)
end
function PANEL:GetFont()
  return self.CloseButton:GetFont()
end


function PANEL:SetBackgroundColor(c)
  self.BackgroundColor = c
end
function PANEL:GetBackgroundColor()
  return self.BackgroundColor
end


function PANEL:Paint()
    surface.SetDrawColor( self:GetBackgroundColor() )
    surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
end

function PANEL:PerformLayout()
	self.BaseClass.PerformLayout(self);

  w,h = TextSize(self.CloseButton:GetFont(), "X")
  self.CloseButton:SetPos( self:GetWide() - w*1.2, 0 )
  self.CloseButton:SetFont( "ZEDFont40" )
  self.CloseButton:SetSize(w,h)
end

vgui.Register("ZFrame",PANEL,"DFrame");
