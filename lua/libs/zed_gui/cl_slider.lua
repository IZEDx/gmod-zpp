local PANEL = {}

local function TextSize(font, text)
  surface.SetFont(font)
  return surface.GetTextSize(text)
end

function PANEL:Init()
  local Panel = self

  self.Font = "ZEDFont40"
  self.TextColor = Color(210,210,210,255)
  self.SliderFGColor = Color(210,210,210,255)
  self.SliderBGColor = Color(100, 100, 100, 255)
  self.Decimals = true

  local w,h = TextSize(self.Font, "Slider")
  self.Label = vgui.Create( "ZLabel", self )
  self.Label:SetPos( 0, 0 )
  self.Label:SetText( "Slider" )
  self.Label:SetColor(self.TextColor)
  self.Label:SetFont( self.Font )

  w = w + 30

  self.Slider = vgui.Create( "DSlider", self )
  self.Slider:SetPos( w, self:GetTall() * 0.1 )
  self.Slider:SetSize( self:GetWide() - w, self:GetTall() * 0.8 )

  self.Slider.Min = 0
  self.Slider.Max = 100
  self.Slider.Value = 50

  self.Slider.SlideX = (self.Slider.Value / (self.Slider.Max - self.Slider.Min)) * self.Slider:GetWide()
  self.Slider.Paint = function()
      surface.SetDrawColor( self.SliderBGColor )
      surface.DrawRect( 0, 0, self.Slider:GetWide(), self.Slider:GetTall() )

      surface.SetDrawColor( self.SliderFGColor )
      surface.DrawRect( (self.Slider.SlideX or 0) - 5, 0, 10, self.Slider:GetTall() )
  end

  self.Slider.Knob:SetVisible(false)

  self.Slider.TranslateValues = function( slider, x, y )
    Panel.Slider.Value = Panel.Slider.Min + (Panel.Slider.Max - Panel.Slider.Min) * x
    if Panel.Decimals then
      Panel.Slider.Value = math.floor(Panel.Slider.Value + 0.5)
    end

    Panel.Slider.SlideX = (Panel.Slider.Value / (Panel.Slider.Max - Panel.Slider.Min)) * Panel.Slider:GetWide()

    if Panel.ValueChanged then
      Panel:ValueChanged(Panel.Slider.Value)
    end

    return -1,-1
  end
end


function PANEL:SetTitle(s)
  self.Label:SetText(tostring(s))

  local w,h = TextSize(self.Font, self:GetTitle())
  w = w + 20

  self.Slider:SetPos( w, self:GetTall() * 0.1 )
  self.Slider:SetSize( self:GetWide() - w, self:GetTall() * 0.8 )

  self.Label:SetPos(0, self:GetTall() * 0.5 - h * 0.5)
end
function PANEL:GetTitle()
  return self.Label:GetText()
end


function PANEL:SetFont(s)
  self.Label:SetFont(tostring(s))
end
function PANEL:GetFont()
  return self.Label:GetFont()
end


function PANEL:SetMin(v)
  self.Slider.Min = tonumber(v) or 0
  self.Slider.SlideX = (self.Slider.Value / (self.Slider.Max - self.Slider.Min)) * self.Slider:GetWide()
end
function PANEL:GetMin(v)
  return self.Slider.Min or 0
end


function PANEL:SetValue(v)
  self.Slider.Value = tonumber(v) or 50
  self.Slider.SlideX = (self.Slider.Value / (self.Slider.Max - self.Slider.Min)) * self.Slider:GetWide()
end
function PANEL:GetValue(v)
  return self.Slider.Value or 50
end


function PANEL:SetMax(v)
  self.Slider.Max = tonumber(v) or 100
  self.Slider.SlideX = (self.Slider.Value / (self.Slider.Max - self.Slider.Min)) * self.Slider:GetWide()
end
function PANEL:GetMax(v)
  return self.Slider.Max or 100
end


function PANEL:SetSize(w,h)
  self.BaseClass.SetSize(self, w, h)

  local w,h = TextSize(self.Font, self:GetTitle())
  w = w + 20

  self.Slider:SetPos( w, self:GetTall() * 0.1 )
  self.Slider:SetSize( self:GetWide() - w, self:GetTall() * 0.8 )

  self.Label:SetPos(0, self:GetTall() * 0.5 - h * 0.5)
end

function PANEL:SetPos(x,y)
  self.BaseClass.SetPos(self, x, y)

  local w,h = TextSize(self.Font, self:GetTitle())
  w = w + 20

  self.Slider:SetPos( w, self:GetTall() * 0.1 )
  self.Slider:SetSize( self:GetWide() - w, self:GetTall() * 0.8 )

  self.Label:SetPos(0, self:GetTall() * 0.5 - h * 0.5)
end



function PANEL:Paint()
end



function PANEL:PerformLayout()
	self.BaseClass.PerformLayout(self)

  local w,h = TextSize(self.Font, self:GetTitle())
  w = w + 20

  self.Slider:SetPos( w, self:GetTall() * 0.1 )
  self.Slider:SetSize( self:GetWide() - w, self:GetTall() * 0.8 )

  self.Label:SetPos(0, self:GetTall() * 0.5 - h * 0.5)
end



vgui.Register("ZSlider",PANEL,"DPanel");
