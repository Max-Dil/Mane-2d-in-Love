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
local base = require('mane.src.core.methods.base')

function m:newSprite(spriteSheet, x, y)
    local obj = setmetatable({
        spriteSheet = spriteSheet,
        mode = "fill",
        _type = "newSprite",
        color = {1,1,1,1},
        angle = 0,
        xScale = 1,
        yScale = 1,
        x = x or 0,
        y = y or 0,
        frame = 1,
        isVisible = true,
        group = self,
        events = {
            collision = {},
            preCollision = {},
            postCollision = {},
            touch = {},
            key = {},
            update = {}
        }
    },{__index = base})
    function obj.newAnimation(self, name, options)
        self.spriteSheet:newAnimation(name, options)
    end
    function obj.playAnimation(self, name, options)
        if type(name) == 'table' then
            options = name
        end
        options = options or {}
        local time = options.time or self.spriteSheet.animations[name].time
        local rep = options.time or self.spriteSheet.animations[name].rep
        local count = options.count or self.spriteSheet.animations[name].count
        local start = options.start or self.spriteSheet.animations[name].start
        local nameTimer = options.nameTimer or self.spriteSheet.animations[name].nameTimer

        local origStart = start
        local _rep = (count + 1) * rep
        self.spriteSheet.animations[name].timer = mane.timer.new(0, function ()
            self.frame = start
            start = start + 1
            if start > origStart + count then
                start = origStart
            end
            self.spriteSheet.animations[name].timer:setTime(time)
        end, _rep, nameTimer)
    end
    function obj.stopAnimation(self, name, delay)
        local function stop()
            self.spriteSheet.animations[name].timer:cancel()
        end
        if delay then
            mane.timer.new(delay, stop)
        else
            stop()
        end
    end
    table.insert(self.obj, obj)
    return obj
end

function m:newParticle(image, buffer, x, y)
    if not mane.images[image] then
        mane.images[image] = love.graphics.newImage(image)
    end
    local obj = setmetatable({
        buffer = buffer,
        size = 5,
        _type = "newParticle",
        color = {1,1,1,1},
        angle = 0,
        xScale = 1,
        yScale = 1,
        x = x or 0,
        y = y or 0,
        particle = love.graphics.newParticleSystem(mane.images[image], buffer),
        image = mane.images[image],
        setImage = function (self, image)
            if not mane.images[image] then
                mane.images[image] = love.graphics.newImage(image)
            end
            self.particle = love.graphics.newParticleSystem(mane.images[image], self.buffer)
            self.image = mane.images[image]
        end,
        setBuffer = function (self, buffer)
            self.particle = love.graphics.newParticleSystem(self.image, buffer)
            self.buffer = buffer
        end,
        isVisible = true,
        update = false,
        group = self,
        events = {
            collision = {},
            preCollision = {},
            postCollision = {},
            touch = {},
            key = {},
            update = {}
        }
    },{__index = base})
    table.insert(self.obj, obj)
    return obj
end

function m:newContainer(x, y, width, height)
    local obj = setmetatable({
        x = x or 0,
        y = y or 0,
        width = width or 100,
        height = height or 100,
        _type = "newContainer",
        isVisible = true,
        obj = {},
        group = self,
        events = {
            collision = {},
            preCollision = {},
            postCollision = {},
            touch = {},
            key = {},
            update = {}
        }
    },{__index = base})
    obj.insert = function (self, obj)
        obj:moveToGroup(self)
    end
    obj.scale = nil
    obj.rotate = nil
    obj.setColor = nil
    obj.removeBody = nil
    table.insert(self.obj, obj)
    return obj
end

function m:newPrintf(text, font, x, y, limit, align, fontSize)
    if type(font) == "number" then
        x, y, limit, align = font, x, y, limit
    else
        if not mane.fonts[font] then
            mane.fonts[font] = love.graphics.newFont(font, fontSize or 20)
        end
    end
    local obj = setmetatable({
        text = text,
        x = x,
        y = y,
        limit = limit or 200,
        align = align or "left",
        font = type(font) == "string" and mane.fonts[font] or love.graphics.getFont(),
        fontSize = fontSize or 20,
        setFontSize = function (fontSize)
            mane.fonts[self.font] = love.graphics.setNewFont(mane.fonts[self.font], self.fontSize or 20)
            self.fontSize = fontSize
            self.font = mane.fonts[font]
        end,
        mode = "fill",
        _type = "newPrintf",
        color = {1,1,1,1},
        angle = 0,
        xScale = 1,
        yScale = 1,
        isVisible = true,
        group = self,
        events = {
            collision = {},
            preCollision = {},
            postCollision = {},
            touch = {},
            key = {},
            update = {}
        }
    },{__index = base})
    table.insert(self.obj, obj)
    return obj
end

function m:newPrint(text, font, x, y, fontSize)
    if type(font) == "number" then
        x, y, fontSize = font, x, y
    else
        if not mane.fonts[font] then
            mane.fonts[font] = love.graphics.newFont(font, fontSize or 20)
        end
    end
    local obj = setmetatable({
        text = text,
        x = x,
        y = y,
        font = type(font) == "string" and mane.fonts[font] or love.graphics.getFont(),
        fontSize = fontSize or 20,
        setFontSize = function (fontSize)
            mane.fonts[self.font] = love.graphics.setNewFont(mane.fonts[self.font], self.fontSize or 20)
            self.fontSize = fontSize
            self.font = mane.fonts[font]
        end,
        mode = "fill",
        _type = "newPrint",
        color = {1,1,1,1},
        angle = 0,
        xScale = 1,
        yScale = 1,
        isVisible = true,
        group = self,
        events = {
            collision = {},
            preCollision = {},
            postCollision = {},
            touch = {},
            key = {},
            update = {}
        }
    },{__index = base})
    table.insert(self.obj, obj)
    return obj
end

function m:newPolygon(vertices, x, y)
    local obj = setmetatable({
        vertices = vertices,
        mode = "fill",
        _type = "newPolygon",
        color = {1,1,1,1},
        angle = 0,
        xScale = 1,
        yScale = 1,
        x = x or 0,
        y = y or 0,
        isVisible = true,
        group = self,
        events = {
            collision = {},
            preCollision = {},
            postCollision = {},
            touch = {},
            key = {},
            update = {}
        }
    },{__index = base})
    table.insert(self.obj, obj)
    return obj
end

function m:newPoints(points, x, y)
    local obj = setmetatable({
        points = points,
        size = 5,
        _type = "newPoints",
        color = {1,1,1,1},
        angle = 0,
        xScale = 1,
        yScale = 1,
        x = x or 0,
        y = y or 0,
        isVisible = true,
        group = self,
        events = {
            collision = {},
            preCollision = {},
            postCollision = {},
            touch = {},
            key = {},
            update = {}
        }
    },{__index = base})
    table.insert(self.obj, obj)
    return obj
end

function m:newLine(points, x, y)
    local obj = setmetatable({
        points = points,
        _type = "newLine",
        color = {1,1,1,1},
        angle = 0,
        xScale = 1,
        yScale = 1,
        x = x or 0,
        y = y or 0,
        isVisible = true,
        group = self,
        width = 3,
        style = "smooth",
        join = "none",
        events = {
            collision = {},
            preCollision = {},
            postCollision = {},
            touch = {},
            key = {},
            update = {}
        }
    },{__index = base})
    table.insert(self.obj, obj)
    return obj
end

function m:newEllipse(x, y, radiusx, radiusy, segments)
    local obj = setmetatable({
        x = x,
        y = y,
        radiusx = radiusx,
        radiusy = radiusy,
        mode = "fill",
        _type = "newEllipse",
        color = {1,1,1,1},
        angle = 0,
        xScale = 1,
        yScale = 1,
        segments = segments or 100,
        isVisible = true,
        group = self,
        events = {
            collision = {},
            preCollision = {},
            postCollision = {},
            touch = {},
            key = {},
            update = {}
        }
    },{__index = base})
    table.insert(self.obj, obj)
    return obj
end

function m:newLayerImage(imageArray, layerindex, x, y, xScale, yScale, ox, oy)
    local obj = setmetatable({
        x = x,
        y = y,
        image = imageArray,
        layerindex = layerindex or 0,
        xScale = xScale or 1,
        yScale = yScale or 1,
        ox = ox or nil,
        oy = oy or nil,
        quad = nil,
        _type = "newLayerImage",
        color = {1,1,1,1},
        angle = 0,
        isVisible = true,
        group = self,
        events = {
            collision = {},
            preCollision = {},
            postCollision = {},
            touch = {},
            key = {},
            update = {}
        }
    },{__index = base})
    table.insert(self.obj, obj)
    return obj
end

function m:newImage(image, x, y, xScale, yScale, ox, oy)
    if not mane.images[image] then
        mane.images[image] = love.graphics.newImage(image)
    end
    local obj = setmetatable({
        x = x,
        y = y,
        image = mane.images[image],
        ox = ox or nil,
        oy = oy or nil,
        quad = nil,
        _type = "newImage",
        color = {1,1,1,1},
        angle = 0,
        xScale = xScale or 1,
        yScale = yScale or 1,
        isVisible = true,
        group = self,
        events = {
            collision = {},
            preCollision = {},
            postCollision = {},
            touch = {},
            key = {},
            update = {}
        }
    },{__index = base})
    table.insert(self.obj, obj)
    return obj
end

function m:newArc(arctype, x, y, radius, angle1, angle2, segments)
    if type(arctype) == "number" then
        x, y, radius, angle1, angle2, segments = arctype, x, y, radius, angle1, angle2
        arctype = "pie"
    end
    local obj = setmetatable({
        x = x,
        y = y,
        arctype = arctype,
        radius = radius,
        angle1 = angle1 or 0,
        angle2 = angle2 or 0,
        mode = "fill",
        _type = "newArc",
        color = {1,1,1,1},
        angle = 0,
        xScale = 1,
        yScale = 1,
        segments = segments or 12,
        isVisible = true,
        group = self,
        events = {
            collision = {},
            preCollision = {},
            postCollision = {},
            touch = {},
            key = {},
            update = {}
        }
    },{__index = base})
    table.insert(self.obj, obj)
    return obj
end

function m:newCircle(x, y, radius)
    local obj = setmetatable({
        x = x,
        y = y,
        radius = radius,
        mode = "fill",
        _type = "newCircle",
        color = {1,1,1,1},
        angle = 0,
        xScale = 1,
        yScale = 1,
        segments = 100,
        isVisible = true,
        group = self,
        events = {
            collision = {},
            preCollision = {},
            postCollision = {},
            touch = {},
            key = {},
            update = {}
        }
    },{__index = base})
    table.insert(self.obj, obj)
    return obj
end

function m:newRect(x, y, width, height, rx, ry, segments)
    local obj = setmetatable({
        x = x,
        y = y,
        rx = rx or 0,
        ry = ry or 0,
        segments = segments or 100,
        width = width,
        height = height,
        mode = "fill",
        _type = "newRect",
        color = {1,1,1,1},
        angle = 0,
        xScale = 1,
        yScale = 1,
        isVisible = true,
        group = self,
        events = {
            collision = {},
            preCollision = {},
            postCollision = {},
            touch = {},
            key = {},
            update = {}
        }
    },{__index = base})
    table.insert(self.obj, obj)
    return obj
end

function m:newGroup()
    local group = setmetatable({
        group = self,
        obj = {},
        x = 0,
        y = 0,
        _type = "newGroup",
        angle = 0,
        xScale = 1,
        yScale = 1,
        isVisible = true,
        events = {
            key = {},
            update = {}
        }
    }, {__index = m})
    function group.removeEvent(self, nameEvent, listener, ...)
        local table = {...}
        if nameEvent == "key" then
            mane.core.key.remove(self, listener)
        elseif nameEvent == "update" then
            mane.core.update.remove(self, listener)
        end
    end
    function group.addEvent(self, nameEvent, listener, ...)
        local table = {...}
        if nameEvent == "key" then
            mane.core.key.new(self, listener)
        elseif nameEvent == "update" then
            mane.core.update.new(self, listener)
        end
    end
    function group.remove(self)
        for i = #self.obj, 1, -1 do
            self.obj[i]:remove()
        end
        self.obj = {}
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
        for i = #self.group.obj, 1, -1 do
            if self.group.obj[i] == self then
                table.remove(self.group.obj, i)
                break
            end
        end
    end
    function group.removeObjects(self)
        for i = #self.obj, 1, -1 do
            pcall(function ()
                self.obj[i]:remove()
                self.obj[i] = nil
            end)
        end
        self.obj = {}
    end 
    function group:toBack(self)
        local group = self.group
        for i = #group.obj, 1, -1 do
            if group.obj[i] == self then
                table.remove(group.obj, i)
                break
            end
        end
        table.insert(group.obj, 1, self)
    end

    function group:toFront(self)
        local group = self.group
        for i = #group.obj, 1, -1 do
            if group.obj[i] == self then
                table.remove(group.obj, i)
                break
            end
        end
        table.insert(group.obj, self)
    end
    table.insert(self.obj, group)
    return group
end

mane.display.game =
setmetatable(
    {
        group = {}, obj = {}, x = 0, y = 0, angle = 0, xScale = 1, yScale = 1, isVisible = true,
        events = {
            key = {},
            update = {}
        }
},
    {__index = m}
)
function mane.display.game.removeEvent(self, nameEvent, listener, ...)
    local table = {...}
    if nameEvent == "key" then
        mane.core.key.remove(self, listener)
    elseif nameEvent == "update" then
        mane.core.update.remove(self, listener)
    end
end
function mane.display.game.addEvent(self, nameEvent, listener, ...)
    local table = {...}
    if nameEvent == "key" then
        mane.core.key.new(self, listener)
    elseif nameEvent == "update" then
        mane.core.update.new(self, listener)
    end
end
function mane.display.game.removeObjects(self)
    for i = #self.obj, 1, -1 do
        pcall(function ()
            self.obj[i]:remove()
            self.obj[i] = nil
        end)
    end
    self.obj = {}
end
function mane.display.game.remove(self)
    for i = #self.obj, 1, -1 do
        self.obj[i]:remove()
        self.obj[i] = nil
    end
    self.obj = {}
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
end