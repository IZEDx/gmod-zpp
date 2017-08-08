local PANEL = {}

local function TextSize(font, text)
  surface.SetFont(font)
  return surface.GetTextSize(text)
end

function PANEL:Init()
  self.HoverColor = Color(110,150,110)
  self.Color = Color(110,110,110)
  self:SetText("")
  self.Title = ""
  self.Tooltip = {}

  local w,h = TextSize("ZEDFont30", self.Title)
  self.Label = vgui.Create("ZLabel", self)
  self.Label:SetFont("ZEDFont30")
  self.Label:SetPos((self:GetWide() - w)*0.5, self:GetTall()  - h)
  self.Label:SetText(self.Title)

  self.Label2 = vgui.Create("ZLabel", self)
  self.Label2:SetFont("ZEDFont25")
  self.Label2:SetPos((self:GetWide() - w)*0.5, self:GetTall() / 2  - h / 2)
  self.Label2:SetText(self.Title)
end

function PANEL:SetTitle(c)
  self.Label:SetText(c)
  self.Label:SetPos((self:GetWide() - self.Label:GetWide())*0.5, self:GetTall() - self.Label:GetTall())
end
function PANEL:GetTitle()
  return self.Label:GetText()
end

function PANEL:SetMidTitle(c)
  self.Label2:SetText(c)
  self.Label2:SetPos((self:GetWide() - self.Label2:GetWide())*0.5, self:GetTall() / 2 - self.Label2:GetTall() / 2)
end
function PANEL:GetMidTitle()
  return self.Label2:GetText()
end

function PANEL:SetTooltip(c)
  if type(c) == "table" then
    self.Tooltip = c or {}
  elseif type(c) == "string" then
    local s = string.Split(c, '\n')
    self.Tooltip = s or {}
  end
end
function PANEL:GetTooltip()
  return self.Tooltip
end

function PANEL:SetColor(c)
  self.Color = c
end
function PANEL:GetColor()
  return self.Color
end

function PANEL:SetHoverColor(c)
  self.HoverColor = c
end
function PANEL:GetHoverColor()
  return self.HoverColor
end

function PANEL:SetFont(c)
  self.Label:SetFont(c)
  self.Label:SetPos((self:GetWide() - self.Label:GetWide())*0.5, self:GetTall() - self.Label:GetTall())

  self.Label2:SetFont(c)
  self.Label2:SetPos((self:GetWide() - self.Label2:GetWide())*0.5, self:GetTall()/2 - self.Label2:GetTall()/2)
end
function PANEL:GetFont()
  return self.Label:GetFont()
end

function PANEL:PerformLayout()
  self.Label:SetPos((self:GetWide() - self.Label:GetWide())*0.5, self:GetTall() - self.Label:GetTall())
  self.Label2:SetPos((self:GetWide() - self.Label2:GetWide())*0.5, self:GetTall()/2 - self.Label:GetTall()/2)
end

function PANEL:Paint()
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
    surface.DrawRect(0,0,self:GetWide(), self:GetTall())

    surface.SetFont( "ZEDFont25" )
    surface.SetTextColor(self.Label:GetColor())
    local y = 0
    local w,h = surface.GetTextSize("T")
    for k,v in pairs(self.Tooltip or {}) do
      surface.SetTextPos(2,y)
      surface.DrawText(v or "")
      y = y + h + 2
    end
  else
    surface.SetDrawColor(self.Color)
    surface.DrawRect(0,0,self:GetWide(), self:GetTall())
  end

end

vgui.Register("ZTile",PANEL,"DButton");
