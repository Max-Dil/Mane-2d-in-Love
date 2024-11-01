local m = {}

m.newPrintf = function (obj)
    local color = obj.color or {1,1,1,1}
    love.graphics.setColor(color[1] or 1, color[2] or 1, color[3] or 1, color[4] or 1)
    if obj.font then
        if type(obj.text) == "table" then
            love.graphics.printf(obj.text, obj.font, obj.x, obj.y, obj.limit, obj.align, (obj.angle / 180) * math.pi, obj.xScale, obj.yScale)
        else
            local textWidth = obj.font:getWidth(obj.text)
            local textHeight = obj.font:getHeight(obj.text)
            love.graphics.printf(obj.text, obj.font, obj.x, obj.y, obj.limit, obj.align,  (obj.angle / 180) * math.pi, obj.xScale, obj.yScale, textWidth/2, textHeight/2)
        end
    else
        if type(obj.text) == "table" then
            love.graphics.printf(obj.text, obj.x, obj.y, obj.limit, obj.align,  (obj.angle / 180) * math.pi, obj.xScale, obj.yScale)
        else
            local font = love.graphics.getFont()
            local textWidth = font:getWidth(obj.text)
            local textHeight = font:getHeight(obj.text)
            love.graphics.printf(obj.text, obj.x, obj.y, obj.limit, obj.align,  (obj.angle / 180) * math.pi, obj.xScale, obj.yScale, textWidth/2, textHeight/2)
        end
    end
end

m.newPrint = function (obj)
    local color = obj.color or {1,1,1,1}
    love.graphics.setColor(color[1] or 1, color[2] or 1, color[3] or 1, color[4] or 1)
    if obj.font then
        if type(obj.text) == "table" then
            love.graphics.print(obj.text, obj.font, obj.x, obj.y, (obj.angle / 180) * math.pi, obj.xScale, obj.yScale)
        else
            local textWidth = obj.font:getWidth(obj.text)
            local textHeight = obj.font:getHeight(obj.text)
            love.graphics.print(obj.text, obj.font, obj.x, obj.y, (obj.angle / 180) * math.pi, obj.xScale, obj.yScale, textWidth/2, textHeight/2)
        end
    else
        if type(obj.text) == "table" then
            love.graphics.print(obj.text, obj.x, obj.y, (obj.angle / 180) * math.pi, obj.xScale, obj.yScale)
        else
            local font = love.graphics.getFont()
            local textWidth = font:getWidth(obj.text)
            local textHeight = font:getHeight(obj.text)
            love.graphics.print(obj.text, obj.x, obj.y, (obj.angle / 180) * math.pi, obj.xScale, obj.yScale, textWidth/2, textHeight/2)
        end
    end
end

m.newPolygon = function (obj)
    local color = obj.color or {1,1,1,1}
    love.graphics.setColor(color[1] or 1, color[2] or 1, color[3] or 1, color[4] or 1)
    love.graphics.rotate((obj.angle / 180) * math.pi)
    love.graphics.scale(obj.xScale, obj.yScale)
    love.graphics.polygon(obj.mode, obj.vertices)
end

m.newPoint = function (obj)
    local color = obj.color or {1,1,1,1}
    love.graphics.setColor(color[1] or 1, color[2] or 1, color[3] or 1, color[4] or 1)
    love.graphics.rotate((obj.angle / 180) * math.pi)
    love.graphics.scale(obj.xScale, obj.yScale)
    love.graphics.setPointSize(obj.size)
    love.graphics.points(obj.points)
end

m.newLine = function (obj)
    local color = obj.color or {1,1,1,1}
    love.graphics.setColor(color[1] or 1, color[2] or 1, color[3] or 1, color[4] or 1)
    love.graphics.rotate((obj.angle / 180) * math.pi)
    love.graphics.scale(obj.xScale, obj.yScale)
    love.graphics.setLineWidth( obj.width)
    love.graphics.setLineStyle( obj.style )
    love.graphics.setLineJoin( obj.join )
    love.graphics.line(obj.points)
end

m.newEllipse = function (obj)
    local color = obj.color or {1,1,1,1}
    love.graphics.setColor(color[1] or 1, color[2] or 1, color[3] or 1, color[4] or 1)
    love.graphics.rotate((obj.angle / 180) * math.pi)
    love.graphics.scale(obj.xScale, obj.yScale)
    love.graphics.ellipse(obj.mode, obj.x, obj.y, obj.radiusx, obj.radiusy, obj.segments)
end

m.newLayerImage = function (obj)
    local color = obj.color or {1,1,1,1}
    love.graphics.setColor(color[1] or 1, color[2] or 1, color[3] or 1, color[4] or 1)
    local image = obj.image[obj.layerindex]
    if obj.quad then
        love.graphics.draw(image, obj.quad, obj.x, obj.y, (obj.angle / 180) * math.pi, obj.xScale, obj.yScale, (obj.ox or image:getWidth())/2, (obj.oy or image:getHeight())/2)
    else
        love.graphics.draw(image, obj.x, obj.y, (obj.angle / 180) * math.pi, obj.xScale, obj.yScale, (obj.ox or image:getWidth())/2, (obj.oy or image:getHeight())/2)
    end
end

m.newImage = function (obj)
    local color = obj.color or {1,1,1,1}
    love.graphics.setColor(color[1] or 1, color[2] or 1, color[3] or 1, color[4] or 1)
    if obj.quad then
        love.graphics.draw(obj.image, obj.quad, obj.x, obj.y, (obj.angle / 180) * math.pi, obj.xScale, obj.yScale, (obj.ox or obj.image:getWidth())/2, (obj.oy or obj.image:getHeight())/2)
    else
        love.graphics.draw(obj.image, obj.x, obj.y, (obj.angle / 180) * math.pi, obj.xScale, obj.yScale, (obj.ox or obj.image:getWidth())/2, (obj.oy or obj.image:getHeight())/2)
    end
end

m.newArc = function (obj)
    local color = obj.color or {1,1,1,1}
    love.graphics.setColor(color[1] or 1, color[2] or 1, color[3] or 1, color[4] or 1)
    love.graphics.rotate((obj.angle / 180) * math.pi)
    love.graphics.scale(obj.xScale, obj.yScale)
    love.graphics.arc(obj.mode, obj.arctype, obj.x, obj.y, obj.radius, (obj.angle1 / 180) * math.pi, (obj.angle2 / 180) * math.pi, obj.segments)
end

m.newCircle = function (obj)
    local color = obj.color or {1,1,1,1}
    love.graphics.setColor(color[1] or 1, color[2] or 1, color[3] or 1, color[4] or 1)
    love.graphics.rotate((obj.angle / 180) * math.pi)
    love.graphics.scale(obj.xScale, obj.yScale)
    love.graphics.circle(obj.mode, obj.x, obj.y, obj.radius, obj.segments)
end

m.newRect = function (obj)
    local color = obj.color or {1,1,1,1}
    love.graphics.setColor(color[1] or 1, color[2] or 1, color[3] or 1, color[4] or 1)
    love.graphics.rotate((obj.angle / 180) * math.pi)
    love.graphics.scale(obj.xScale, obj.yScale)
    love.graphics.rectangle(obj.mode, obj.x - obj.width/2, obj.y - obj.height/2, obj.width, obj.height, obj.rx, obj.ry, obj.segments)
end

m.newGroup = function(group)
    love.graphics.setWireframe( mane.display.wireframe )
    love.graphics.push()
    love.graphics.translate(group.x, group.y)
    love.graphics.scale(group.xScale, group.yScale)
    love.graphics.rotate((group.angle / 180) * math.pi)
    for i = 1, #group.obj, 1 do
        if group.obj[i].isVisible then
            love.graphics.push()
            m[group.obj[i]._type](group.obj[i])
            love.graphics.pop()
        end
    end
    love.graphics.pop()
end

return function ()
    local group = mane.display.game
    if group.isVisible then
        m.newGroup(group)
    end
end