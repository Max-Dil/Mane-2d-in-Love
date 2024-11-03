local m = {}
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
    table.insert(newGroup.obj, self)
end

function base:remove()
    local group = self.group
    base:removeFocus()
    if #self.events.touch >= 1 then
        for i = #mane.core.click.running, 1, -1 do
            if mane.core.click.running[i] == self then
                table.remove(mane.core.click.running, i)
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

function base:addCollision(world, listener)
    table.insert(self.events.collision, listener)
    table.insert(world.events.collision, self)
end
function base:removeCollision(listener)
    for i = #self.events.collision, 1, -1 do
        if self.events.collision[i] == listener then
            table.remove(self.events.collision, i)
            break
        end
    end
end
function base:addEndCollision(world, listener)
    table.insert(self.events.endCollision, listener)
    table.insert(world.events.endCollision, self)
end
function base:removeEndCollision(listener)
    for i = #self.events.endCollision, 1, -1 do
        if self.events.endCollision[i] == listener then
            table.remove(self.events.endCollision, i)
            break
        end
    end
end
function base:addPreCollision(world, listener)
    table.insert(self.events.preCollision, listener)
    table.insert(world.events.preCollision, self)
end
function base:removePreCollision(listener)
    for i = #self.events.preCollision, 1, -1 do
        if self.events.preCollision[i] == listener then
            table.remove(self.events.preCollision, i)
            break
        end
    end
end
function base:addPostCollision(world, listener)
    table.insert(self.events.postCollision, listener)
    table.insert(world.events.postCollision, self)
end
function base:removePostCollision(listener)
    for i = #self.events.postCollision, 1, -1 do
        if self.events.postCollision[i] == listener then
            table.remove(self.events.postCollision, i)
            break
        end
    end
end
function base:addClick(listener)
    mane.core.click.new(self, listener)
end
-- function base:addFocus()
--     table.insert(mane.core.click.focus, self)
-- end
-- function base:removeFocus()
--     for i = 1, #mane.core.click.focus, 1 do
--         if mane.core.click.focus[i][1] == self then
--             table.remove(mane.core.click.focus, i)
--             break
--         end
--     end
-- end

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
        font = type(font) == "string" and mane.fonts[font] or nil,
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
            endCollision = {},
            preCollision = {},
            postCollision = {},
            touch = {}
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
        font = type(font) == "string" and mane.fonts[font] or nil,
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
            endCollision = {},
            preCollision = {},
            postCollision = {},
            touch = {}
        }
    },{__index = base})
    table.insert(self.obj, obj)
    return obj
end

function m:newPolygon(vertices)
    local obj = setmetatable({
        vertices = vertices,
        mode = "fill",
        _type = "newPolygon",
        color = {1,1,1,1},
        angle = 0,
        xScale = 1,
        yScale = 1,
        isVisible = true,
        group = self,
        events = {
            collision = {},
            endCollision = {},
            preCollision = {},
            postCollision = {},
            touch = {}
        }
    },{__index = base})
    table.insert(self.obj, obj)
    return obj
end

function m:newPoints(points)
    local obj = setmetatable({
        points = points,
        size = 5,
        _type = "newPoint",
        color = {1,1,1,1},
        angle = 0,
        xScale = 1,
        yScale = 1,
        isVisible = true,
        group = self,
        events = {
            collision = {},
            endCollision = {},
            preCollision = {},
            postCollision = {},
            touch = {}
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
            endCollision = {},
            preCollision = {},
            postCollision = {},
            touch = {}
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
            endCollision = {},
            preCollision = {},
            postCollision = {},
            touch = {}
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
            endCollision = {},
            preCollision = {},
            postCollision = {},
            touch = {}
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
            endCollision = {},
            preCollision = {},
            postCollision = {},
            touch = {}
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
            endCollision = {},
            preCollision = {},
            postCollision = {},
            touch = {}
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
            endCollision = {},
            preCollision = {},
            postCollision = {},
            touch = {}
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
            endCollision = {},
            preCollision = {},
            postCollision = {},
            touch = {}
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
        isVisible = true
    }, {__index = m})
    table.insert(self.obj, group)
    return group
end

mane.display.newGroup = m.newGroup
mane.display.newRect = m.newRect

mane.display.game = setmetatable({group = {}, obj = {}, x = 0, y = 0, angle = 0, xScale = 1, yScale = 1, isVisible = true}, {__index = m})