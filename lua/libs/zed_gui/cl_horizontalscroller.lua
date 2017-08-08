--[[   _
    ( )
   _| |   __   _ __   ___ ___     _ _
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_)
	DHorizontalScroller

	Made to scroll the tabson PropertySheet, but may have other uses.

--]]

local PANEL = {}

AccessorFunc( PANEL, "m_iOverlap", 					"Overlap" )

--[[---------------------------------------------------------
-----------------------------------------------------------]]
function PANEL:Init()

	self.Panels = {}
	self.OffsetX = 0
	self.FrameTime = 0

  self.pnlCanvas 	= vgui.Create( "Panel", self )
  self.pnlIndic 	= vgui.Create( "ZSlider", self )
  self.pnlIndic:SetTitle("")

  self.pnlIndic:SetMin(0)
  self.pnlIndic:SetMax(100)
  self.pnlIndic:SetValue(0)

  self.pnlIndic.SliderFGColor = Color(110,190,110)

  self.pnlIndic.ValueChanged = function(t, v)
    self.OffsetX = v / (100 / (self.pnlCanvas:GetWide() - self:GetWide()))
    self:InvalidateLayout( true )
  end

	self:SetOverlap( 0 )
end


function PANEL:AddPanel( pnl )

	table.insert( self.Panels, pnl )

	pnl:SetParent( self.pnlCanvas )
	self:InvalidateLayout(true)

end


function PANEL:OnMouseWheeled( dlta )

	self.OffsetX = self.OffsetX + dlta * -50
	self:InvalidateLayout( true )

	return true

end


function PANEL:PerformLayout()

	local w, h = self:GetSize()


	self.pnlCanvas:SetTall( h )

  self.pnlIndic:SetSize(self:GetWide(), self.pnlIndic:GetTall())
  self.pnlIndic:SetPos(-10, self:GetTall() - self.pnlIndic:GetTall())

	local x = 0

	for k, v in pairs( self.Panels ) do

		v:SetPos( x, 0 )
		v:SetTall( h )
		v:ApplySchemeSettings()

		x = x + v:GetWide() - self.m_iOverlap

	end

	self.pnlCanvas:SetWide( x + self.m_iOverlap )

	if ( w < self.pnlCanvas:GetWide() ) then
		self.OffsetX = math.Clamp( self.OffsetX, 0, self.pnlCanvas:GetWide() - self:GetWide() )
	else
		self.OffsetX = 0
	end
  self.pnlIndic:SetValue((100 / (self.pnlCanvas:GetWide() - self:GetWide())) * self.OffsetX)
  --self.pnlIndic:SetPos(((1 / (self.pnlCanvas:GetWide() - self:GetWide())) * self.OffsetX) * (self:GetWide() - self.pnlIndic:GetWide()), self:GetTall() - self.pnlIndic:GetTall())
	self.pnlCanvas.x = self.OffsetX * -1
end

derma.DefineControl( "ZHorizontalScroller", "", PANEL, "Panel" )
