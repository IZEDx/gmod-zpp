LIBRARY.Name = "Utils"
LIBRARY.Author = "IZED"

function LIBRARY.TextSize(font, text)
  surface.SetFont(font)
  return surface.GetTextSize(text)
end


function LIBRARY.TextWidth(font, text)
  local w, h = LIBRARY.TextSize(font, text)
  return w
end

function LIBRARY.TextHeight(font, text)
  local w, h = LIBRARY.TextSize(font, text)
  return h
end