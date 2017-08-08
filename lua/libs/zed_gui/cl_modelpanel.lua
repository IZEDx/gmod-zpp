local PANEL = {}

local function TextSize(font, text)
  surface.SetFont(font)
  return surface.GetTextSize(text)
end

function PANEL:Init()
  self:SetDirectionalLight( BOX_RIGHT, Color( 255, 160, 80, 255 ) )
  self:SetDirectionalLight( BOX_LEFT, Color( 80, 160, 255, 255 ) )
  self:SetAmbientLight( Vector( -64, -64, -64 ) )
  self:SetAnimated( true )
  self.Angles = Angle( 0, 0, 0 )
end

function PANEL:DragMousePress()
  self.PressX, self.PressY = gui.MousePos()
  self.Pressed = true
  if self.onMouseDown then
    self:onMouseDown()
  end
end

function PANEL:DragMouseRelease()
  self.Pressed = false
end

function PANEL:LayoutEntity( Entity )
  if ( self.bAnimated ) then self:RunAnimation() end

  if ( self.Pressed ) then
    local mx, my = gui.MousePos()
    self.Angles = self.Angles - Angle( 0, ( self.PressX or mx ) - mx, 0 )

    self.PressX,self.PressY = gui.MousePos()
  end

  Entity:SetAngles( self.Angles )
end

vgui.Register("ZModelPanel",PANEL,"DModelPanel");
