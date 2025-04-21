--[[
MIT License

Copyright (c) 2025 Max-Dil

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

local m = {}

m.newTextField = function(obj)
    if not obj.isVisible then return end
    local color = obj.color or {1, 1, 1, 1}
    love.graphics.push()
    love.graphics.translate(obj.x, obj.y)
    love.graphics.rotate(math.rad(obj.angle or 0))
    love.graphics.scale(obj.xScale or 1, obj.yScale or 1)

    love.graphics.setFont(obj.font)

    love.graphics.setColor(0, 0, 1, 0.5)
    for _, x, y, w, h in obj.inputField:eachSelection() do
        love.graphics.rectangle("fill", x - obj.width / 2, y - obj.height / 2, w, h)
    end

    love.graphics.setColor(color[1], color[2], color[3], color[4])
    for _, text, x, y in obj.inputField:eachVisibleLine() do
        love.graphics.print(text, x, y, 0, 1, 1, obj.width/2, obj.height / 2)
    end

    if mane.core.inputFieldFocus == obj then
        local x, y, h = obj.inputField:getCursorLayout()
        love.graphics.setColor(1, 1, 1, math.abs(math.cos(obj.inputField:getBlinkPhase() * math.pi)))
        love.graphics.rectangle("fill", x - obj.width / 2, y - obj.height / 2, 1, h)
    end

    love.graphics.pop()
end
m.newBoxField = m.newTextField

m.newSprite = function (obj)
    local color = obj.color or {1,1,1,1}
    love.graphics.setColor(color[1] or 1, color[2] or 1, color[3] or 1, color[4] or 1)
    love.graphics.draw(
        obj.spriteSheet.image,
        obj.spriteSheet.sprites[obj.frame],
        obj.x,
        obj.y,
        math.rad(obj.angle or 0),
        obj.xScale or 1,
        obj.yScale or 1,
        obj.spriteSheet.frameWidth / 2,
        obj.spriteSheet.frameHeight / 2
    )
end

m.newParticle = function (obj)
    local color = obj.color or {1,1,1,1}
    love.graphics.setColor(color[1] or 1, color[2] or 1, color[3] or 1, color[4] or 1)
    love.graphics.translate(obj.x, obj.y)
    love.graphics.rotate(math.rad(obj.angle or 0))
    love.graphics.scale(obj.xScale or 1, obj.yScale or 1)
    love.graphics.draw(obj.particle, 0, 0)
end

m.newContainer = function (container)
    if not container.isVisible then return true end
    love.graphics.setScissor(
        container.x - container.width/2,
        container.y - container.height/2,
        container.width,
        container.height
    )
    love.graphics.translate(container.x - container.width/2, container.y - container.height/2)
    local len = #container.obj
    for i = 1, len, 1 do
        local obj = container.obj[i]
        if obj.isVisible then
            love.graphics.push()
            m[obj._type](obj)
            love.graphics.pop()
        end
    end
    love.graphics.setScissor()
end

m.newPrintf = function (obj)
    local color = obj.color or {1,1,1,1}
    love.graphics.setColor(color[1] or 1, color[2] or 1, color[3] or 1, color[4] or 1)
    love.graphics.setFont(obj.font)
    if type(obj.text) == "table" then
        love.graphics.printf(obj.text, obj.x, obj.y, obj.limit, obj.align, math.rad(obj.angle or 0), obj.xScale or 1, obj.yScale or 1)
    else
        if obj.align == "left" then
            local textHeight = obj.font:getHeight(obj.text)
            love.graphics.printf(obj.text, obj.x, obj.y, obj.limit, obj.align, math.rad(obj.angle or 0), obj.xScale or 1, obj.yScale or 1, nil, textHeight/2)
        else
            local textWidth = obj.font:getWidth(obj.text)
            local textHeight = obj.font:getHeight(obj.text)
            love.graphics.printf(obj.text, obj.x, obj.y, obj.limit, obj.align, math.rad(obj.angle or 0), obj.xScale or 1, obj.yScale or 1, textWidth/2, textHeight/2)
        end
    end
end

m.newPrint = function (obj)
    local color = obj.color or {1,1,1,1}
    love.graphics.setColor(color[1] or 1, color[2] or 1, color[3] or 1, color[4] or 1)
    love.graphics.setFont(obj.font)
    if type(obj.text) == "table" then
        love.graphics.print(obj.text, obj.x, obj.y, math.rad(obj.angle or 0), obj.xScale or 1, obj.yScale or 1)
    else
        local textWidth = obj.font:getWidth(obj.text)
        local textHeight = obj.font:getHeight(obj.text)
        love.graphics.print(obj.text, obj.x, obj.y, math.rad(obj.angle or 0), obj.xScale or 1, obj.yScale or 1, textWidth/2, textHeight/2)
    end
end

m.newPolygon = function (obj)
    local color = obj.color or {1,1,1,1}
    love.graphics.setColor(color[1] or 1, color[2] or 1, color[3] or 1, color[4] or 1)
    local width, height = mane.graphics.getPolygonDimensions(obj.vertices)
    width, height = width*1.5, height*1.5
    love.graphics.translate(obj.x - width, obj.y - height)
    love.graphics.rotate(math.rad(obj.angle or 0))
    love.graphics.scale(obj.xScale or 1, obj.yScale or 1)
    love.graphics.polygon(obj.mode or "fill", obj.vertices)
end

m.newPoints = function (obj)
    local color = obj.color or {1,1,1,1}
    love.graphics.setColor(color[1] or 1, color[2] or 1, color[3] or 1, color[4] or 1)
    local width, height = mane.graphics.getPointsDimensions(obj.points)
    width, height = width*1.5, height*1.5
    love.graphics.translate(obj.x - width, obj.y - height)
    love.graphics.rotate(math.rad(obj.angle or 0))
    love.graphics.scale(obj.xScale or 1, obj.yScale or 1)
    love.graphics.setPointSize(obj.size or 5)
    love.graphics.points(obj.points)
end

m.newLine = function (obj)
    local color = obj.color or {1,1,1,1}
    love.graphics.setColor(color[1] or 1, color[2] or 1, color[3] or 1, color[4] or 1)
    local width, height = mane.graphics.getLineWidthHeight(obj.points)
    width, height = width*1.5, height*1.5
    love.graphics.translate(obj.x - width, obj.y - height)
    love.graphics.rotate(math.rad(obj.angle or 0))
    love.graphics.scale(obj.xScale or 1, obj.yScale or 1)
    love.graphics.setLineWidth( obj.width or 3)
    love.graphics.setLineStyle( obj.style or "smooth")
    love.graphics.setLineJoin( obj.join or "none")
    love.graphics.line(obj.points)
end

m.newEllipse = function (obj)
    local color = obj.color or {1,1,1,1}
    love.graphics.setColor(color[1] or 1, color[2] or 1, color[3] or 1, color[4] or 1)
    love.graphics.translate(obj.x, obj.y)
    love.graphics.rotate(math.rad(obj.angle or 0))
    love.graphics.scale(obj.xScale or 1, obj.yScale or 1)
    love.graphics.ellipse(obj.mode or "fill", 0, 0, obj.radiusx, obj.radiusy, obj.segments)
end

m.newLayerImage = function (obj)
    local color = obj.color or {1,1,1,1}
    love.graphics.setColor(color[1] or 1, color[2] or 1, color[3] or 1, color[4] or 1)
    local image = obj.image[obj.layerindex]
    if obj.quad then
        love.graphics.draw(image, obj.quad, obj.x, obj.y, math.rad(obj.angle or 0), obj.xScale or 1, obj.yScale or 1, (obj.ox or image:getWidth())/2, (obj.oy or image:getHeight())/2)
    else
        love.graphics.draw(image, obj.x, obj.y, math.rad(obj.angle or 0), obj.xScale or 1, obj.yScale or 1, (obj.ox or image:getWidth())/2, (obj.oy or image:getHeight())/2)
    end
end

m.newImage = function (obj)
    local color = obj.color or {1,1,1,1}
    love.graphics.setColor(color[1] or 1, color[2] or 1, color[3] or 1, color[4] or 1)
    if obj.quad then
        love.graphics.draw(obj.image, obj.quad, obj.x, obj.y, math.rad(obj.angle or 0), obj.xScale or 1, obj.yScale or 1, (obj.ox or obj.image:getWidth())/2, (obj.oy or obj.image:getHeight())/2)
    else
        love.graphics.draw(obj.image, obj.x, obj.y, math.rad(obj.angle or 0), obj.xScale or 1, obj.yScale or 1, (obj.ox or obj.image:getWidth())/2, (obj.oy or obj.image:getHeight())/2)
    end
end

m.newArc = function (obj)
    local color = obj.color or {1,1,1,1}
    love.graphics.setColor(color[1] or 1, color[2] or 1, color[3] or 1, color[4] or 1)
    love.graphics.translate(obj.x, obj.y)
    love.graphics.rotate(math.rad(obj.angle or 0))
    love.graphics.scale(obj.xScale or 1, obj.yScale or 1)
    love.graphics.arc(obj.mode or "fill", obj.arctype or "pie", 0, 0, obj.radius, (obj.angle1 / 180) * math.pi, (obj.angle2 / 180) * math.pi, obj.segments)
end

m.newCircle = function (obj)
    local color = obj.color or {1,1,1,1}
    love.graphics.setColor(color[1] or 1, color[2] or 1, color[3] or 1, color[4] or 1)
    love.graphics.translate(obj.x, obj.y)
    love.graphics.rotate(math.rad(obj.angle or 0))
    love.graphics.scale(obj.xScale or 1, obj.yScale or 1)
    love.graphics.circle(obj.mode or "fill", 0, 0, obj.radius, obj.segments)
end

m.newRect = function (obj)
    local color = obj.color or {1,1,1,1}
    love.graphics.setColor(color[1] or 1, color[2] or 1, color[3] or 1, color[4] or 1)
    love.graphics.translate(obj.x, obj.y)
    love.graphics.rotate(math.rad(obj.angle or 0))
    love.graphics.scale(obj.xScale or 1, obj.yScale or 1)
    love.graphics.rectangle(obj.mode or "fill", -obj.width/2, -obj.height/2, obj.width, obj.height, obj.rx, obj.ry, obj.segments)
end

local offsetX, offsetY = 0, 0
m.newHitboxs = function (group)
    offsetX, offsetY = offsetX + group.x, offsetY + group.y
    for i = 1, #group.obj, 1 do
        local obj = group.obj[i]
        if obj.isVisible then
            if obj._type == 'newGroup' or obj._type == 'newContainer' then
                love.graphics.push()
                m.newHitboxs(obj)
                love.graphics.pop()
            end
            if obj.body and obj.shape then
                local bx, by = obj.body:getPosition()
                local bAngle = obj.body:getAngle()

                local gAngle = math.rad(group.angle)
                local transformedAngle = bAngle - gAngle

                love.graphics.push()
                love.graphics.translate(bx + offsetX, by + offsetY)
                love.graphics.rotate(transformedAngle)

                if obj.body:getType() == "static" then
                    love.graphics.setColor(1,0,0,1)
                else
                    if obj.body:isActive() then
                        love.graphics.setColor(0,1,0,1)
                    else
                        love.graphics.setColor(0.5,0.5,0.5,1)
                    end
                end
                if obj.bodyOptions.shape == "rect" then
                    love.graphics.rectangle("line", 0 - obj.bodyOptions.width/2, 0 - obj.bodyOptions.height/2, obj.bodyOptions.width, obj.bodyOptions.height)
                elseif obj.bodyOptions.shape == "circle" then
                    love.graphics.circle('line', 0, 0, obj.bodyOptions.radius)
                elseif obj.bodyOptions.shape == "chain" then
                    local points = obj.bodyOptions.points
                    love.graphics.line(points)
                elseif obj.bodyOptions.shape == "edge" then
                    local x1, y1 = obj.bodyOptions.x1, obj.bodyOptions.y1
                    local x2, y2 = obj.bodyOptions.x2, obj.bodyOptions.y2
                    love.graphics.line(x1, y1, x2, y2)
                elseif obj.bodyOptions.shape == "polygon" then
                    local points = obj.bodyOptions.vertices
                    love.graphics.polygon("line", points)
                end
                love.graphics.pop()
            end
        end
    end
end

m.newGroup = function(group)
    love.graphics.push()
    love.graphics.rotate(math.rad(group.angle or 0))
    love.graphics.translate(group.x, group.y)
    love.graphics.scale(group.xScale or 1, group.yScale or 1)

    local len = #group.obj
    for i = 1, len, 1 do
        local obj = group.obj[i]
        if obj.isVisible then
            love.graphics.push()
            love.graphics.setShader(obj.shader or nil)
            m[obj._type](obj)
            love.graphics.pop()
        end
    end
    love.graphics.pop()
end

mane.display.draw = function(obj)
    if obj.isVisible then
        love.graphics.push()
        if obj.group then
            love.graphics.rotate(math.rad(obj.group.angle or 0))
            love.graphics.translate(obj.group.x, obj.group.y)
            love.graphics.scale(obj.group.xScale or 1, obj.group.yScale or 1)
        end
        love.graphics.setShader(obj.shader or nil)
        m[obj._type](obj)
        love.graphics.pop()
    end
end

return function ()
    if mane.display.game.isVisible then
        love.graphics.setWireframe( mane.display.wireframe )
        m.newGroup(mane.display.game)
        if mane.display.renderMode == "hybrid" then
            offsetX, offsetY = 0, 0
            m.newHitboxs(mane.display.game)
        end
    end
end