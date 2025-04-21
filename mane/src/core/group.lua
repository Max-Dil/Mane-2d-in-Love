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
local base = require(mane.path .. '.src.core.methods.base')

function m:newTextField(x, y, width, height, options)
    local libInput = require(mane.path .. ".lib.InputField")
    options = options or {}
    local inputType = options.password and "password" or "normal"
    local initialText = options.text or ""
    local font = options.font
    local fontSize = options.fontSize or 20
    local align = options.align or "left"

    local fontKey
    if type(font) == "string" then
        fontKey = font .. "_" .. fontSize
        if not mane.fonts[fontKey] then
            mane.fonts[fontKey] = love.graphics.newFont(font, fontSize)
        end
    else
        fontKey = "default_" .. fontSize
        if not mane.fonts[fontKey] then
            mane.fonts[fontKey] = love.graphics.newFont(fontSize)
        end
    end

    local inputField = libInput(initialText, inputType)
    inputField:setFont(mane.fonts[fontKey])
    inputField:setDimensions(width, height)
    inputField:setAlignment(align)
    inputField:setEditable(options.editable ~= false)
    if options.filter then
        inputField:setFilter(options.filter)
    end

    local obj = setmetatable({
        x = x or 0,
        y = y or 0,
        width = width or 200,
        height = height or mane.fonts[fontKey]:getHeight(),
        _type = "newTextField",
        color = options.color or {1, 1, 1, 1},
        color2 = options.color or {1, 1, 1, 1},
        angle = 0,
        xScale = 1,
        yScale = 1,
        isVisible = true,
        group = self,
        inputField = inputField,
        font = mane.fonts[fontKey],
        fontKey = fontKey,
        fontPath = type(font) == "string" and font or nil,
        fontSize = fontSize,
        align = align,
        setFontSize = function(self, newFontSize)
            if self.fontPath then
                local newFontKey = self.fontPath .. "_" .. newFontSize
                if not mane.fonts[newFontKey] then
                    mane.fonts[newFontKey] = love.graphics.newFont(self.fontPath, newFontSize)
                end
                self.fontKey = newFontKey
                self.font = mane.fonts[newFontKey]
            else
                local newFontKey = "default_" .. newFontSize
                if not mane.fonts[newFontKey] then
                    mane.fonts[newFontKey] = love.graphics.newFont(newFontSize)
                end
                self.fontKey = newFontKey
                self.font = mane.fonts[newFontKey]
            end
            self.fontSize = newFontSize
            self.inputField:setFont(self.font)
        end,
        getText = function(self)
            return self.inputField:getText()
        end,
        setText = function(self, text)
            self.inputField:setText(text)
        end,
        getSelectedText = function(self)
            return self.inputField:getSelectedText()
        end,
        setEditable = function(self, editable)
            self.inputField:setEditable(editable)
        end,
        events = {
            collision = {},
            preCollision = {},
            postCollision = {},
            touch = {},
            key = {},
            update = {},
        }
    }, {__index = base})


    obj.stroke = self:newRect(obj.x, obj.y, obj.width, obj.height)
    obj.stroke.mode = "line"
    obj:addEvent("update", function(e)
        obj.inputField:update(e.dt)
        obj.stroke.x, obj.stroke.y, obj.stroke.width, obj.stroke.height = obj.x, obj.y, obj.width, obj.height
    end)


    obj:addEvent("touch", function(e)
        if e.phase == "began" then
            if mane.core.inputFieldFocus and mane.core.inputFieldFocus ~= obj then
                mane.core.inputFieldFocus.inputField:setEditable(false)
                mane.core.inputFieldFocus.stroke.color = {1,1,1,1}
                mane.core.inputFieldFocus.inputField:setEditable(true)
            end
            mane.core.inputFieldFocus = obj
            obj.inputField:setEditable(true)
            obj.stroke.color = {0,1,0,1}
        end
    end)

    local origRemove = obj.remove
    function obj:remove()
        for i = #mane.core.inputField, 1, -1 do
            if mane.core.inputField[i] == obj then
                table.remove(mane.core.inputField, i)
                break
            end
        end
        if mane.core.inputFieldFocus == obj then
            mane.core.inputFieldFocus = nil
        end
        obj.stroke:remove()
        origRemove(obj)
    end

    local origMoveGroup = obj.moveToGroup
    function obj:moveToGroup(group)
        obj.stroke:moveToGroup(group)
        origMoveGroup(obj, group)
    end

    table.insert(mane.core.inputField, obj)

    table.insert(self.obj, obj)
    return obj
end

function m:newBoxField(x, y, width, height, options)
    local libInput = require(mane.path .. ".lib.InputField")
    options = options or {}
    local inputType = options.nowrap and "multinowrap" or "multiwrap"
    local initialText = options.text or ""
    local font = options.font
    local fontSize = options.fontSize or 20
    local align = options.align or "left"

    local fontKey
    if type(font) == "string" then
        fontKey = font .. "_" .. fontSize
        if not mane.fonts[fontKey] then
            mane.fonts[fontKey] = love.graphics.newFont(font, fontSize)
        end
    else
        fontKey = "default_" .. fontSize
        if not mane.fonts[fontKey] then
            mane.fonts[fontKey] = love.graphics.newFont(fontSize)
        end
    end

    local inputField = libInput(initialText, inputType)
    inputField:setFont(mane.fonts[fontKey])
    inputField:setDimensions(width, height)
    inputField:setAlignment(align)
    inputField:setEditable(options.editable ~= false)
    if options.filter then
        inputField:setFilter(options.filter)
    end

    local obj = setmetatable({
        x = x or 0,
        y = y or 0,
        width = width or 200,
        height = height or 100,
        _type = "newBoxField",
        color = options.color or {1, 1, 1, 1},
        color2 = options.color or {1, 1, 1, 1},
        angle = 0,
        xScale = 1,
        yScale = 1,
        isVisible = true,
        group = self,
        inputField = inputField,
        font = mane.fonts[fontKey],
        fontKey = fontKey,
        fontPath = type(font) == "string" and font or nil,
        fontSize = fontSize,
        align = align,
        setFontSize = function(self, newFontSize)
            if self.fontPath then
                local newFontKey = self.fontPath .. "_" .. newFontSize
                if not mane.fonts[newFontKey] then
                    mane.fonts[newFontKey] = love.graphics.newFont(self.fontPath, newFontSize)
                end
                self.fontKey = newFontKey
                self.font = mane.fonts[newFontKey]
            else
                local newFontKey = "default_" .. newFontSize
                if not mane.fonts[newFontKey] then
                    mane.fonts[newFontKey] = love.graphics.newFont(newFontSize)
                end
                self.fontKey = newFontKey
                self.font = mane.fonts[newFontKey]
            end
            self.fontSize = newFontSize
            self.inputField:setFont(self.font)
        end,
        getText = function(self)
            return self.inputField:getText()
        end,
        setText = function(self, text)
            self.inputField:setText(text)
        end,
        getSelectedText = function(self)
            return self.inputField:getSelectedText()
        end,
        setEditable = function(self, editable)
            self.inputField:setEditable(editable)
        end,
        events = {
            collision = {},
            preCollision = {},
            postCollision = {},
            touch = {},
            key = {},
            update = {},
        }
    }, {__index = base})

    obj.stroke = self:newRect(obj.x, obj.y, obj.width, obj.height)
    obj.stroke.mode = "line"
    obj:addEvent("update", function(e)
        obj.inputField:update(e.dt)
        obj.stroke.x, obj.stroke.y, obj.stroke.width, obj.stroke.height = obj.x, obj.y, obj.width, obj.height
    end)

    obj:addEvent("touch", function(e)
        if e.phase == "began" then
            if mane.core.inputFieldFocus and mane.core.inputFieldFocus ~= obj then
                mane.core.inputFieldFocus.inputField:setEditable(false)
                mane.core.inputFieldFocus.stroke.color = {1,1,1,1}
                mane.core.inputFieldFocus.inputField:setEditable(true)
            end
            mane.core.inputFieldFocus = obj
            obj.inputField:setEditable(true)
            obj.stroke.color = {0,1,0,1}
        end
    end)

    local origRemove = obj.remove
    function obj:remove()
        for i = #mane.core.inputField, 1, -1 do
            if mane.core.inputField[i] == obj then
                table.remove(mane.core.inputField, i)
                break
            end
        end
        
        if mane.core.inputFieldFocus == obj then
            mane.core.inputFieldFocus = nil
        end
        obj.stroke:remove()
        origRemove(obj)
    end

    local origMoveGroup = obj.moveToGroup
    function obj:moveToGroup(group)
        obj.stroke:moveToGroup(group)
        origMoveGroup(obj, group)
    end

    table.insert(mane.core.inputField, obj)

    table.insert(self.obj, obj)
    return obj
end

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
        font = nil
    end
    fontSize = fontSize or 20
    local fontKey
    if type(font) == "string" then
        fontKey = font .. "_" .. fontSize
        if not mane.fonts[fontKey] then
            mane.fonts[fontKey] = love.graphics.newFont(font, fontSize)
        end
    else
        fontKey = "default_" .. fontSize
        if not mane.fonts[fontKey] then
            mane.fonts[fontKey] = love.graphics.newFont(fontSize)
        end
    end
    local obj = setmetatable({
        text = text,
        x = x,
        y = y,
        limit = limit or 200,
        align = align or "left",
        fontPath = type(font) == "string" and font or nil,
        fontKey = fontKey,
        font = mane.fonts[fontKey],
        fontSize = fontSize,
        setFontSize = function(self, newFontSize)
            if self.fontPath then
                local newFontKey = self.fontPath .. "_" .. newFontSize
                if not mane.fonts[newFontKey] then
                    mane.fonts[newFontKey] = love.graphics.newFont(self.fontPath, newFontSize)
                end
                self.fontKey = newFontKey
                self.font = mane.fonts[newFontKey]
            else
                local newFontKey = "default_" .. newFontSize
                if not mane.fonts[newFontKey] then
                    mane.fonts[newFontKey] = love.graphics.newFont(newFontSize)
                end
                self.fontKey = newFontKey
                self.font = mane.fonts[newFontKey]
            end
            self.fontSize = newFontSize
        end,
        getWidth = function (self, text)
            return self.font:getWidth(text or self.text)
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
    }, {__index = base})
    table.insert(self.obj, obj)
    return obj
end

function m:newPrint(text, font, x, y, fontSize)
    if type(font) == "number" then
        x, y, fontSize = font, x, y
        font = nil
    end
    fontSize = fontSize or 20
    local fontKey
    if type(font) == "string" then
        fontKey = font .. "_" .. fontSize
        if not mane.fonts[fontKey] then
            mane.fonts[fontKey] = love.graphics.newFont(font, fontSize)
        end
    else
        fontKey = "default_" .. fontSize
        if not mane.fonts[fontKey] then
            mane.fonts[fontKey] = love.graphics.newFont(fontSize)
        end
    end
    local obj = setmetatable({
        text = text,
        x = x,
        y = y,
        fontPath = type(font) == "string" and font or nil,
        fontKey = fontKey,
        font = mane.fonts[fontKey],
        fontSize = fontSize,
        setFontSize = function(self, newFontSize)
            if self.fontPath then
                local newFontKey = self.fontPath .. "_" .. newFontSize
                if not mane.fonts[newFontKey] then
                    mane.fonts[newFontKey] = love.graphics.newFont(self.fontPath, newFontSize)
                end
                self.fontKey = newFontKey
                self.font = mane.fonts[newFontKey]
            else
                local newFontKey = "default_" .. newFontSize
                if not mane.fonts[newFontKey] then
                    mane.fonts[newFontKey] = love.graphics.newFont(newFontSize)
                end
                self.fontKey = newFontKey
                self.font = mane.fonts[newFontKey]
            end
            self.fontSize = newFontSize
        end,
        getWidth = function (self, text)
            return self.font:getWidth(text or self.text)
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
    }, {__index = base})
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
        __x = 0,
        __y = 0,
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
        if nameEvent == "key" then
            mane.core.key.remove(self, listener)
        elseif nameEvent == "update" then
            mane.core.update.remove(self, listener)
        end
    end
    function group.addEvent(self, nameEvent, listener, ...)
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
            if self.obj[i] then
                self.obj[i]:remove()
                self.obj[i] = nil
            end
        end
        self.obj = {}
    end
    function group:moveToGroup(newGroup)
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
    function group:translate(x, y)
        self.x, self.y = self.x + x, self.y + y
    end
    function group:rotate(angle)
        self.angle = self.angle + angle
        self.angle = self.angle % 360
    end
    function group:scale(x, y)
        self.xScale = self.xScale+x
        self.yScale = self.yScale+y
    end
    table.insert(self.obj, group)
    return group
end

mane.display.game =
setmetatable(
    {
        group = {}, obj = {}, x = 0, y = 0, angle = 0, xScale = 1, yScale = 1, isVisible = true,
        __x = 0, __y = 0,
        events = {
            key = {},
            update = {}
        }
},
    {__index = m}
)
function mane.display.game.removeEvent(self, nameEvent, listener, ...)
    if nameEvent == "key" then
        mane.core.key.remove(self, listener)
    elseif nameEvent == "update" then
        mane.core.update.remove(self, listener)
    end
end
function mane.display.game.addEvent(self, nameEvent, listener, ...)
    if nameEvent == "key" then
        mane.core.key.new(self, listener)
    elseif nameEvent == "update" then
        mane.core.update.new(self, listener)
    end
end
function mane.display.game.removeObjects(self)
    for i = #self.obj, 1, -1 do
        if self.obj[i] then
            self.obj[i]:remove()
            self.obj[i] = nil
        end
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
function mane.display.game.translate(self, x, y)
    self.x, self.y = self.x + x, self.y + y
end

function mane.display.game.rotate(self, angle)
    self.angle = self.angle + angle
    self.angle = self.angle % 360
end
function mane.display.game.scale(self, x, y)
    self.xScale = self.xScale+x
    self.yScale = self.yScale+y
end
