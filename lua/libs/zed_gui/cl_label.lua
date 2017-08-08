local PANEL = {}

function PANEL:Init()
  self:SetPos( 0, 0 )

  self:SetText("Label")

  self:SetFont("ZEDFont40")
  self:SetColor(Color(210,210,210,255))

  self:SizeToContents()
end

function PANEL:SetFont(f)
  self.BaseClass.SetFont(self, f)
  self:SizeToContents()
end

function PANEL:SetText(f)
  self.BaseClass.SetText(self, f)
  self:SizeToContents()
end
 
function PANEL:PerformLayout()
  self:SizeToContents()
end

vgui.Register("ZLabel",PANEL,"DLabel");
