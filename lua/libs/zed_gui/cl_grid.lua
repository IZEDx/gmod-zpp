local PANEL = {}

function PANEL:Init()
  self:SetPos(0,0)
  self:SetSize(500,500)
  self:SetSpaceX(2)
  self:SetSpaceY(2)
  self:SetBorder(0,0)
end

vgui.Register("ZGrid",PANEL,"DIconLayout");

 
