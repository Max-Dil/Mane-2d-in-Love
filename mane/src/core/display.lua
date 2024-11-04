local m = {}
m.width = love.graphics.getWidth()
m.height = love.graphics.getHeight()
m.centerX = m.width / 2
m.centerY = m.height / 2

m.setBackGroundColor = function (r, g, b, a)
    love.graphics.setBackgroundColor( r or 1, g or 1, b or 1, a or 1 )
end

m.wireframe = false

m.setShear = function (kx, ky)
    love.graphics.shear( kx, ky )
end

m.renderMode = "normal"

mane.display = m
require("mane.src.core.group")