--[[
MIT License

Copyright (c) 2024 Max-Dil

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the 'Software'), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

local m = {}
m.groupUpdate = function(group, dt)
    for i = #group.obj, 1, -1 do
        local obj = group.obj[i]
        if obj._type == 'newGroup' then
            obj.__x = obj.x
            obj.__y = obj.y
            m.groupUpdate(obj)
        elseif obj.body then
            if obj.body:getType() == 'dynamic' then
                local bodyX, bodyY, bodyAngle = obj.body:getX(), obj.body:getY(), obj.body:getAngle()
                if obj.x ~= obj.oldBodyX then
                    bodyX = bodyX + (obj.x - obj.oldBodyX)
                    obj.body:setX(bodyX)
                end
                if obj.y ~= obj.oldBodyY then
                    bodyY = bodyY + (obj.y - obj.oldBodyY)
                    obj.body:setY(bodyY)
                end
                if obj.angle ~= obj.oldBodyAngle then
                    bodyAngle = bodyAngle + math.rad(obj.angle - obj.oldBodyAngle)
                    obj.body:setAngle(bodyAngle)
                end
                obj.x = bodyX - obj.bodyOptions.offsetX
                obj.y = bodyY - obj.bodyOptions.offsetY
                obj.angle = (bodyAngle / math.pi) * 180
                obj.oldBodyX, obj.oldBodyY,  obj.oldBodyAngle = obj.x, obj.y, obj.angle
            else
                obj.body:setX(obj.x + obj.bodyOptions.offsetX + obj.group.__x)
                obj.body:setY(obj.y + obj.bodyOptions.offsetY + obj.group.__y)
                obj.body:setAngle(math.rad(obj.angle) + obj.group.angle)
            end
        elseif obj._type == 'newContainer' then
            obj.__x = obj.x - obj.width/2
            obj.__y = obj.y - obj.height/2
            m.groupUpdate(obj)
        elseif obj._type == 'newParticle' then
            if obj.update then
                obj.particle:update(dt)
            end
        end
    end
end

return function (dt)
    dt = dt * mane.speed
    mane.timer.update(dt)

    mane.physics.update(dt)
    mane.transition.update(dt)
    if mane.display.game.isVisible then
        m.groupUpdate(mane.display.game, dt)
    end
end