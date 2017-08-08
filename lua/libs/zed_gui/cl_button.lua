local PANEL = {}

local function TextSize(font, text)
  surface.SetFont(font)
  return surface.GetTextSize(text)
end

function PANEL:Init()
  self:SetPos( 0, 0 )
  self:SetText( "Button" )
  self:SetFont( "ZEDFont40" )
  self:SetSize(TextSize(self:GetFont(), self:GetText()))
  self:SetColor(Color(150,150,150,255))
  self:SetDrawBackground(false) 

  self.HoverColor = Color(110,150,110,50)
  self.SelectedColor = Color(110,150,110)
  self.IndicatorEnabled = false
  self.ButtonSelected = false
end

function PANEL:PerformLayout()
  self:SetSize(TextSize(self:GetFont(), self:GetText()))
end

function PANEL:Indicator(b)
  self.IndicatorEnabled = b
end
function PANEL:Selected(b)
  self.ButtonSelected = b
end
function PANEL:HoverColor(c)
  if c then self.HoverColor = c else return self.HoverColor end
end
function PANEL:SelectedColor(c)
  if c then self.SelectedColor = c else return self.SelectedColor end
end

function PANEL:Paint()
  if self.IndicatorEnabled then
    local mx,my = gui.MouseX(), gui.MouseY()
    local x,y = self:GetPos()
    local p = self
    while p:GetParent() do
      p = p:GetParent()
      if p then
        local _x, _y = p:GetPos()
        x = x + _x
        y = y + _y
      else
        break
      end
    end


    local w,h = self:GetWide(), self:GetTall()
    if mx >= x and mx < x + w and my > y and my < y + h then
      surface.SetDrawColor(self.HoverColor)
      surface.DrawRect( 0, self:GetTall() - 5, self:GetWide(), 5 )
    elseif self.ButtonSelected then
      surface.SetDrawColor(self.SelectedColor)
      surface.DrawRect( 0, self:GetTall() - 5, self:GetWide(), 5 )
    end
  end
end

vgui.Register("ZButton",PANEL,"DButton");
