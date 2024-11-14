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
    for i = 1, #group.obj, 1 do
        local obj = group.obj[i]
        if obj._type == 'newGroup' then
            m.groupUpdate(obj)
        elseif obj._type == 'newParticle' then
            if obj.update then
                obj.particle:update(dt)
            end
        else
            if obj.body then
                if obj.body:getType() == 'dynamic' then

                    if obj.x ~= obj.oldBodyX then
                        obj.body:setX(obj.body:getX() + (obj.x - obj.oldBodyX))
                    end

                    if obj.y ~= obj.oldBodyY then
                        obj.body:setY(obj.body:getY() + (obj.y - obj.oldBodyY))
                    end

                    if obj.angle ~= obj.oldBodyAngle then
                        obj.body:setAngle(obj.body:getAngle() + math.rad(obj.angle - obj.oldBodyAngle))
                    end

                    obj.x = obj.body:getX()
                    obj.y = obj.body:getY()
                    obj.angle = (obj.body:getAngle() / math.pi) * 180

                    obj.oldBodyX = obj.x
                    obj.oldBodyY = obj.y
                    obj.oldBodyAngle = obj.angle
                else
                    obj.body:setX(obj.x)
                    obj.body:setY(obj.y)
                    obj.body:setAngle(math.rad(obj.angle))
                end
            end
        end
    end
end

return function (dt)
    dt = dt + mane.speed
    mane.timer.update(dt)

    mane.physics.update(dt)
    if mane.display.game.isVisible then
        m.groupUpdate(mane.display.game, dt)
    end
end