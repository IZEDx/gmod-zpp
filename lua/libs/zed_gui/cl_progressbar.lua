local PANEL = {}
function PANEL:Init()
  self.BackgroundColor = Color(110, 110, 110, 255)
  self.ProgressColor = Color(110, 150, 110, 255)

  self.Progress = 0

  self:SetBackgroundColor(self.BackgroundColor)

  self.ProgressBar = vgui.Create( "DPanel", self )
  self.ProgressBar:SetPos( 0, 0 )
  self.ProgressBar:SetBackgroundColor(self.ProgressColor)
  self.ProgressBar:SetSize( 0, 0 )
end


function PANEL:SetProgressColor(c)
  self.ProgressBar:SetBackgroundColor(c)
end
function PANEL:GetProgressColor()
  return self.ProgressBar:GetBackgroundColor()
end

function PANEL:SetProgress(c)
  c = tonumber(c)
  if not c then return end
  if c > 1 then
    self.Progress = 1
  elseif c < 0 then
    self.Progress = 0
  else
    self.Progress = c
  end
  self.ProgressBar:SetSize(self:GetWide() * self.Progress, self:GetTall())
end
function PANEL:GetProgress(c)
  return self.Progress
end

function PANEL:PerformLayout()
	self.BaseClass.PerformLayout(self);

  self.ProgressBar:SetSize(self:GetWide() * self.Progress, self:GetTall())
end

vgui.Register("ZProgressbar",PANEL,"DPanel");
