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

local base = {}

function base:setColor(r, g, b, a)
    self.color = {r or 1, g or 1, b or 1, a or 1}
end

function base:translate(x, y)
    self.x, self.y = self.x + x, self.y + y
end

function base:rotate(angle)
    self.angle = self.angle + angle
    self.angle = self.angle % 360
end

function base:scale(x, y)
    self.xScale = self.xScale+x
    self.yScale = self.yScale+y
end

function base:moveToGroup(newGroup)
    local group = self.group
    for i = #group.obj, 1, -1 do
        if group.obj[i] == self then
            table.remove(group.obj, i)
            break
        end
    end
    self.group = newGroup
    table.insert(newGroup.obj, self)
end

function base:remove()
    local group = self.group

    mane.transition.cancelObject(self)

    if self.removeBody then
        self:removeBody()
    end
    if #self.events.touch >= 1 then
        for i = #mane.core.click.running, 1, -1 do
            if mane.core.click.running[i] == self then
                table.remove(mane.core.click.running, i)
                break
            end
        end
        for i = #mane.core.click.focus, 1, -1 do
            if mane.core.click.focus[i] == self then
                table.remove(mane.core.click.focus, i)
                break
            end
        end
    end
    if #self.events.key >= 1 then
        for i = #mane.core.key.running, 1, -1 do
            if mane.core.key.running[i] == self then
                table.remove(mane.core.key.running, i)
                break
            end
        end
    end
    if #self.events.update >= 1 then
        for i = #mane.core.update.running, 1, -1 do
            if mane.core.update.running[i] == self then
                table.remove(mane.core.update.running, i)
                break
            end
        end
    end
    for i = #group.obj, 1, -1 do
        if group.obj[i] == self then
            table.remove(group.obj, i)
            break
        end
    end
end

function base:removeEvent(nameEvent, listener, ...)
    local table2 = {...}
    if nameEvent == "key" then
        mane.core.key.remove(self, listener)
    elseif nameEvent == "touch" then
        mane.core.click.remove(self, listener)
    elseif nameEvent == "collision" then
        for i = #self.events.collision, 1, -1 do
            if self.events.collision[i] == listener then
                table.remove(self.events.collision, i)
                break
            end
        end
        if #self.events.collision == 0 then
            for i = #self.world.events.collision, 1, -1 do
                if self.world.events.collision[i] == self then
                    table.remove(self.world.events.collision, i)
                    break
                end
            end
        end
    elseif nameEvent == "update" then
        mane.core.update.remove(self, listener)
    elseif nameEvent == "postCollision" then
        table2[1]:removePostCollision(self, listener)
    elseif nameEvent == "preCollision" then
        table2[1]:removePreCollision(self, listener)
    end
end

function base:addEvent(nameEvent, listener, ...)
    local table = {...}
    if nameEvent == "key" then
        mane.core.key.new(self, listener)
    elseif nameEvent == "touch" then
        mane.core.click.new(self, listener)
    elseif nameEvent == "collision" then
        if #table < 1 then
            self.world:addCollision(self, listener)
        else
            table[1]:addCollision(self, listener)
        end
    elseif nameEvent == "update" then
        mane.core.update.new(self, listener)
    elseif nameEvent == "postCollision" then
        if #table < 1 then
            self.world:addPostCollision(self, listener)
        else
            table[1]:addPostCollision(self, listener)
        end
    elseif nameEvent == "preCollision" then
        if #table < 1 then
            self.world:addPreCollision(self, listener)
        else
            table[1]:addPreCollision(self, listener)
        end
    end
end

function base:toBack()
    local group = self.group
    for i = #group.obj, 1, -1 do
        if group.obj[i] == self then
            table.remove(group.obj, i)
            break
        end
    end
    table.insert(group.obj, 1, self)
end

function base:toFront()
    local group = self.group
    for i = #group.obj, 1, -1 do
        if group.obj[i] == self then
            table.remove(group.obj, i)
            break
        end
    end
    table.insert(group.obj, self)
end

return base