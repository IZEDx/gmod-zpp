local PANEL = {}

function PANEL:Init()
  self:SetPos( 0, 0 )
  self:SetDrawBackground(false)

  self.label1 = vgui.Create("ZLabel", self)
  self.label1:SetPos(0,0)
  self.label1:SetColor(Color(0,0,0,200))

  self.label2 = vgui.Create("ZLabel", self)
  self.label2:SetPos(2,0)
  self.label2:SetColor(Color(0,0,0,200))

  self.label3 = vgui.Create("ZLabel", self)
  self.label3:SetPos(0,2)
  self.label3:SetColor(Color(0,0,0,200))

  self.label4 = vgui.Create("ZLabel", self)
  self.label4:SetPos(2,2)
  self.label4:SetColor(Color(0,0,0,200))

  self.label5 = vgui.Create("ZLabel", self)
  self.label5:SetPos(1,1)
end

function PANEL:SetFont(f)
  self.label1:SetFont(f)
  self.label2:SetFont(f)
  self.label3:SetFont(f)
  self.label4:SetFont(f)
  self.label5:SetFont(f)
  self:SetSize(self.label5:GetWide() + 4, self.label5:GetTall() + 4)
end

function PANEL:SetColor(f)
  self.label5:SetColor(f)
end

function PANEL:Remove()
  self.label1:Remove()
  self.label2:Remove()
  self.label3:Remove()
  self.label4:Remove()
  self.label5:Remove()
end

function PANEL:SetText(f)
  self.label1:SetText(f)
  self.label2:SetText(f)
  self.label3:SetText(f)
  self.label4:SetText(f)
  self.label5:SetText(f)
  self:SetSize(self.label5:GetWide() + 4, self.label5:GetTall() + 4)
end

vgui.Register("ZOutlinedLabel",PANEL,"DPanel");
