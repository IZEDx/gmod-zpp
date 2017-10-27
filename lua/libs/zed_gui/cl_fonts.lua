local utils = import("libs/utils")
local is = utils.Is

local fonts = keeper:get("fonts", {})

export Font = function(size)
  if not is(size):int() then 
    return fonts[1] 
  end

  local fontname = "ZEDFont"..size
  if fonts[fontname] == fontname then 
    return fontname 
  end

  surface.CreateFont (fontname, {
    size = size / 1680 * ScrW(),
    weight = 400,
    antialias = true,
    shadow = false,
    font = "Montserrat"
  })

  fonts[fontname] = fontname

  return fontname
end

export WorldFont = function(size)
  if not is(size):int() then 
    return fonts[1] 
  end

  local fontname = "ZEDFont"..size.."World"
  if fonts[fontname] == fontname then 
    return fontname 
  end

  surface.CreateFont (fontname, {
    size = size,
    weight = 400,
    antialias = true,
    shadow = false,
    font = "Montserrat"
  })

  fonts[fontname] = fontname

  return fontname
end

for i = 25, 60, 5 do
  exports.Font(i)
  exports.WorldFont(i)
end