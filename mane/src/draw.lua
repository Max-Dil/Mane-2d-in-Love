--[[
MIT License

Copyright (c) 2024 Max-Dil

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

m.newSprite = function (obj)
    local color = obj.color or {1,1,1,1}
    love.graphics.setColor(color[1] or 1, color[2] or 1, color[3] or 1, color[4] or 1)
    love.graphics.draw(obj.spriteSheet.image, obj.spriteSheet.sprites[obj.frame], obj.x, obj.y, math.rad(obj.angle), obj.xScale, obj.yScale)
end

m.newParticle = function (obj)
    local color = obj.color or {1,1,1,1}
    love.graphics.setColor(color[1] or 1, color[2] or 1, color[3] or 1, color[4] or 1)
    love.graphics.translate(obj.x, obj.y)
    love.graphics.rotate(math.rad(obj.angle))
    love.graphics.scale(obj.xScale, obj.yScale)
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
    for i = 1, #container.obj, 1 do
        local obj = container.obj[i]
        if obj.isVisible then
            love.graphics.push()
            m[obj._type](obj)
            love.graphics.pop()
            if mane.display.renderMode == "hybrid" and obj.body and obj.shape then
                local x, y = obj.body:getPosition()
                local angle = obj.body:getAngle()

                love.graphics.push()
                love.graphics.translate(x, y)
                love.graphics.rotate(angle)

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
    love.graphics.setScissor()
end

m.newPrintf = function (obj)
    local color = obj.color or {1,1,1,1}
    love.graphics.setColor(color[1] or 1, color[2] or 1, color[3] or 1, color[4] or 1)
    if type(obj.text) == "table" then
        love.graphics.printf(obj.text, obj.font, obj.x, obj.y, obj.limit, obj.align, math.rad(obj.angle), obj.xScale, obj.yScale)
    else
        local textWidth = obj.font:getWidth(obj.text)
        local textHeight = obj.font:getHeight(obj.text)
        love.graphics.printf(obj.text, obj.font, obj.x, obj.y, obj.limit, obj.align,  math.rad(obj.angle), obj.xScale, obj.yScale, textWidth/2, textHeight/2)
    end
end

m.newPrint = function (obj)
    local color = obj.color or {1,1,1,1}
    love.graphics.setColor(color[1] or 1, color[2] or 1, color[3] or 1, color[4] or 1)
    if type(obj.text) == "table" then
        love.graphics.print(obj.text, obj.font, obj.x, obj.y, math.rad(obj.angle), obj.xScale, obj.yScale)
    else
        local textWidth = obj.font:getWidth(obj.text)
        local textHeight = obj.font:getHeight(obj.text)
        love.graphics.print(obj.text, obj.font, obj.x, obj.y, math.rad(obj.angle), obj.xScale, obj.yScale, textWidth/2, textHeight/2)
    end
end

m.newPolygon = function (obj)
    local color = obj.color or {1,1,1,1}
    love.graphics.setColor(color[1] or 1, color[2] or 1, color[3] or 1, color[4] or 1)
    local width, height = mane.graphics.getPolygonDimensions(obj.vertices)
    width, height = width*1.5, height*1.5
    love.graphics.translate(obj.x - width, obj.y - height)
    love.graphics.rotate(math.rad(obj.angle))
    love.graphics.scale(obj.xScale, obj.yScale)
    love.graphics.polygon(obj.mode, obj.vertices)
end

m.newPoints = function (obj)
    local color = obj.color or {1,1,1,1}
    love.graphics.setColor(color[1] or 1, color[2] or 1, color[3] or 1, color[4] or 1)
    local width, height = mane.graphics.getPointsDimensions(obj.points)
    width, height = width*1.5, height*1.5
    love.graphics.translate(obj.x - width, obj.y - height)
    love.graphics.rotate(math.rad(obj.angle))
    love.graphics.scale(obj.xScale, obj.yScale)
    love.graphics.setPointSize(obj.size)
    love.graphics.points(obj.points)
end

m.newLine = function (obj)
    local color = obj.color or {1,1,1,1}
    love.graphics.setColor(color[1] or 1, color[2] or 1, color[3] or 1, color[4] or 1)
    local width, height = mane.graphics.getLineWidthHeight(obj.points)
    width, height = width*1.5, height*1.5
    love.graphics.translate(obj.x - width, obj.y - height)
    love.graphics.rotate(math.rad(obj.angle))
    love.graphics.scale(obj.xScale, obj.yScale)
    love.graphics.setLineWidth( obj.width)
    love.graphics.setLineStyle( obj.style )
    love.graphics.setLineJoin( obj.join )
    love.graphics.line(obj.points)
end

m.newEllipse = function (obj)
    local color = obj.color or {1,1,1,1}
    love.graphics.setColor(color[1] or 1, color[2] or 1, color[3] or 1, color[4] or 1)
    love.graphics.translate(obj.x, obj.y)
    love.graphics.rotate(math.rad(obj.angle))
    love.graphics.scale(obj.xScale, obj.yScale)
    love.graphics.ellipse(obj.mode, 0, 0, obj.radiusx, obj.radiusy, obj.segments)
end

m.newLayerImage = function (obj)
    local color = obj.color or {1,1,1,1}
    love.graphics.setColor(color[1] or 1, color[2] or 1, color[3] or 1, color[4] or 1)
    local image = obj.image[obj.layerindex]
    if obj.quad then
        love.graphics.draw(image, obj.quad, obj.x, obj.y, math.rad(obj.angle), obj.xScale, obj.yScale, (obj.ox or image:getWidth())/2, (obj.oy or image:getHeight())/2)
    else
        love.graphics.draw(image, obj.x, obj.y, math.rad(obj.angle), obj.xScale, obj.yScale, (obj.ox or image:getWidth())/2, (obj.oy or image:getHeight())/2)
    end
end

m.newImage = function (obj)
    local color = obj.color or {1,1,1,1}
    love.graphics.setColor(color[1] or 1, color[2] or 1, color[3] or 1, color[4] or 1)
    if obj.quad then
        love.graphics.draw(obj.image, obj.quad, obj.x, obj.y, math.rad(obj.angle), obj.xScale, obj.yScale, (obj.ox or obj.image:getWidth())/2, (obj.oy or obj.image:getHeight())/2)
    else
        love.graphics.draw(obj.image, obj.x, obj.y, math.rad(obj.angle), obj.xScale, obj.yScale, (obj.ox or obj.image:getWidth())/2, (obj.oy or obj.image:getHeight())/2)
    end
end

m.newArc = function (obj)
    local color = obj.color or {1,1,1,1}
    love.graphics.setColor(color[1] or 1, color[2] or 1, color[3] or 1, color[4] or 1)
    love.graphics.translate(obj.x, obj.y)
    love.graphics.rotate(math.rad(obj.angle))
    love.graphics.scale(obj.xScale, obj.yScale)
    love.graphics.arc(obj.mode, obj.arctype, 0, 0, obj.radius, (obj.angle1 / 180) * math.pi, (obj.angle2 / 180) * math.pi, obj.segments)
end

m.newCircle = function (obj)
    local color = obj.color or {1,1,1,1}
    love.graphics.setColor(color[1] or 1, color[2] or 1, color[3] or 1, color[4] or 1)
    love.graphics.translate(obj.x, obj.y)
    love.graphics.rotate(math.rad(obj.angle))
    love.graphics.scale(obj.xScale, obj.yScale)
    love.graphics.circle(obj.mode, 0, 0, obj.radius, obj.segments)
end

m.newRect = function (obj)
    local color = obj.color or {1,1,1,1}
    love.graphics.setColor(color[1] or 1, color[2] or 1, color[3] or 1, color[4] or 1)
    love.graphics.translate(obj.x, obj.y)
    love.graphics.rotate(math.rad(obj.angle))
    love.graphics.scale(obj.xScale, obj.yScale)
    love.graphics.rectangle(obj.mode, - obj.width/2,  -obj.height/2, obj.width, obj.height, obj.rx, obj.ry, obj.segments)
end

m.newGroup = function(group)
    love.graphics.push()
    love.graphics.translate(group.x, group.y)
    love.graphics.rotate(math.rad(group.angle))
    love.graphics.scale(group.xScale, group.yScale)
    for i = 1, #group.obj, 1 do
        local obj = group.obj[i]
        if obj.isVisible then
            love.graphics.push()
            m[obj._type](obj)
            love.graphics.pop()
            if mane.display.renderMode == "hybrid" and obj.body and obj.shape then
                local x, y = obj.body:getPosition()
                local angle = obj.body:getAngle()

                love.graphics.push()
                love.graphics.translate(x, y)
                love.graphics.rotate(angle)

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
    love.graphics.pop()
end

return function ()
    if mane.display.game.isVisible then
        love.graphics.setWireframe( mane.display.wireframe )
        m.newGroup(mane.display.game)
    end
end