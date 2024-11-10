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
m.running = {}
m.focus = {}

local function distancePointLine(x, y, x1, y1, x2, y2)
    local lineLength = math.sqrt(math.pow(x2 - x1, 2) + math.pow(y2 - y1, 2))
    if lineLength == 0 then
        return math.sqrt(math.pow(x - x1, 2) + math.pow(y - y1, 2))
    end
    local t = ((x - x1) * (x2 - x1) + (y - y1) * (y2 - y1)) / math.pow(lineLength, 2)
    if t < 0 then
        return math.sqrt(math.pow(x - x1, 2) + math.pow(y - y1, 2))
    elseif t > 1 then
        return math.sqrt(math.pow(x - x2, 2) + math.pow(y - y2, 2))
    else
        local closestX = x1 + t * (x2 - x1)
        local closestY = y1 + t * (y2 - y1)
        return math.sqrt(math.pow(x - closestX, 2) + math.pow(y - closestY, 2))
    end
end
local clickCheck = {
    arc = function (obj, x, y)
        local x1 = x - obj.x
        local y1 = y - obj.y
        local angle = math.rad(obj.angle)
        local x2 = x1 * math.cos(angle) + y1 * math.sin(angle)
        local y2 = -x1 * math.sin(angle) + y1 * math.cos(angle)
        local theta = math.atan2(y2, x2)
        if theta < 0 then
        theta = theta + 2 * math.pi
        end
        local angle1 = (obj.angle1 / 180) * math.pi
        local angle2 = (obj.angle2 / 180) * math.pi
        if angle1 > angle2 then
        angle1, angle2 = angle2, angle1
        end
        if (theta >= angle1 and theta <= angle2) then
        local r = math.sqrt(x2 * x2 + y2 * y2)
        if r <= obj.radius then
        return true
        end
        end
        return false
    end,
    isPointOnLine = function(obj, x, y)
        for i = 1, #obj.points - 2, 2 do
            local width, height = mane.graphics.getLineWidthHeight(obj.points)
            width, height = width*1.5, height*1.5
            local ox = obj.x - width
            local oy = obj.y - height
            local x1 = ox + obj.points[i]
            local y1 = oy + obj.points[i + 1]
            local x2 = ox + obj.points[i + 2]
            local y2 = oy + obj.points[i + 3]
            if distancePointLine(x, y, x1, y1, x2, y2) <= obj.width / 2 then
                return true
            end
        end
        return false
    end,
    rect = function (obj, x, y)
        if x > (obj.x - obj.width / 2) and x < (obj.x + obj.width / 2) and
        y > (obj.y - obj.height / 2) and y < (obj.y + obj.height / 2) then
        local distance_to_center_x = math.abs(x - obj.x)
        local distance_to_center_y = math.abs(y - obj.y)
        if distance_to_center_x > obj.width / 2 - obj.rx then
            if distance_to_center_y > obj.height / 2 - obj.ry then
            if (distance_to_center_x - obj.width / 2 + obj.rx)^2 + (distance_to_center_y - obj.height / 2 + obj.ry)^2 > obj.rx^2 then
            return false
            end
        else
            if distance_to_center_x - obj.width / 2 + obj.rx > obj.rx then
            return false
            end
        end
        else
        if distance_to_center_y > obj.height / 2 - obj.ry then
            if distance_to_center_y - obj.height / 2 + obj.ry > obj.ry then
            return false
            end
        end
        end
        return true
        end
        return false
    end
}

function m.new(obj, listener)
    if #obj.events.touch <= 0 then
        table.insert(m.running, obj)
    end
    table.insert(obj.events.touch, listener)
end

function m.remove(obj, listener)
    for i = #obj.events.touch, 1, -1 do
        if obj.events.touch[i] == listener then
            table.remove(obj.events.touch, i)
            break
        end
    end
end

function m.mousepressed(x, y, button, isTouch)
    local function call_func(obj)
        if not obj.isTouch then
            table.insert(m.focus, obj)
        end
        obj.isTouch = true
        for i2 = 1, #obj.events.touch, 1 do
            local result = obj.events.touch[i2]({
                phase = "began",
                target = obj,
                x = x,
                y = y,
                button = button,
                isTouch = isTouch
            })
            if result then
                return true
            end
        end
    end
    for i = 1, #m.running, 1 do
        local obj = m.running[i]
        if obj._type == "newRect" then
            if clickCheck.rect(obj, x, y) then
                local result = call_func(obj)
                if result then
                    break
                end
            end
        elseif obj._type == "newCircle" then
            if love.distance(x, y, obj.x, obj.y) < obj.radius then
                local result = call_func(obj)
                if result then
                    break
                end
            end
        elseif obj._type == "newArc" then
            if clickCheck.arc(obj, x, y) then
                local result = call_func(obj)
                if result then
                    break
                end
            end
        elseif  obj._type == "newImage" or obj._type == "newLayerImage" then
            local image = obj._type == "newImage" and obj.image or obj.image[obj.layerindex]
            local imageWidth, imageHeight = obj.image:getDimensions()
            local x1 = obj.x - imageWidth * obj.xScale / 2
            local y1 = obj.y - imageHeight * obj.yScale / 2
            local x2 = obj.x + imageWidth * obj.xScale / 2
            local y2 = obj.y + imageHeight * obj.yScale / 2
            if x >= x1 and x <= x2 and y >= y1 and y <= y2 then
                local result = call_func(obj)
                if result then
                    break
                end
            end
        elseif obj._type == "newEllipse" then
            if math.pow((x - obj.x) / obj.radiusx, 2) + math.pow((y - obj.y) / obj.radiusy, 2) <= 1 then
                local result = call_func(obj)
                if result then
                    break
                end
            end
        elseif obj._type == "newLine" then
            if clickCheck.isPointOnLine(obj, x, y) then
                local result = call_func(obj)
                if result then
                    break
                end
            end
        elseif obj._type == "newPoints" then
            for j = 1, #obj.points, 2 do
                local width, height = mane.graphics.getPointsDimensions(obj.points)
                width, height = width*1.5, height*1.5
                local pointX = (obj.x - width) + obj.points[j]
                local pointY = (obj.y - height) + obj.points[j + 1]
                if love.distance(x, y, pointX, pointY) <= obj.size / 2 then
                    local result = call_func(obj)
                    if result then
                        return true
                    end
                    break
                end
            end
        elseif obj._type == "newPolygon" then
            if mane.graphics.pointInPolygon(obj.vertices, x, y, obj) then
                local result = call_func(obj)
                if result then
                    break
                end
            end
        elseif obj._type == "newPrint" or obj._type == "newPrintf" then
            local currentY = obj.y
            local text = obj.text
            if type(obj.text) == "table" then
                text = ""
                for _, line in ipairs(obj.text) do
                    text = text .. line.text
                end
            end
            local textWidth, textHeight = obj.font:getWidth(text), obj.font:getHeight(text)
            local x1 = obj.x - textWidth / 2
            local y1 = obj.y - textHeight / 2
            local x2 = obj.x + textWidth / 2
            local y2 = obj.y + textHeight / 2
            if x >= x1 and x <= x2 and y >= y1 and y <= y2 then
                local result = call_func(obj)
                if result then
                    break
                end
            end
        elseif obj._type == "newContainer" then
            if x > (obj.x - obj.width / 2) and x < (obj.x + obj.width / 2) and
               y > (obj.y - obj.height / 2) and y < (obj.y + obj.height / 2) then
                local result = call_func(obj)
                if result then
                    break
                end
            end
        end
    end
end

function m.mousereleased(x, y, button, isTouch)
    for i = #m.focus, 1, -1 do
        local obj = m.focus[i]
        if obj.isTouch then
            obj.isTouch = false
            local result
            for i2 = 1, #obj.events.touch, 1 do
                local result2 = obj.events.touch[i2]({
                    phase = "ended",
                    target = obj,
                    x = x,
                    y = y,
                    button = button,
                    isTouch = isTouch
                })
                if result2 then
                    result = true
                    break
                end
            end
            table.remove(m.focus, i)
            if result then
                return true
            end
        end
    end
end

function m.mousemoved(x, y, dx, dy)
    for i = #m.focus, 1, -1 do
        local obj = m.focus[i]
        if obj.isTouch then
            local result
            for i2 = 1, #obj.events.touch, 1 do
                local result2 = obj.events.touch[i2]({
                    phase = "moved",
                    target = obj,
                    x = x,
                    y = y,
                    dx = dx,
                    dy = dy,
                    button = 0
                })
                if result2 then
                    result = true
                    break
                end
            end
            if result then
                return true
            end
        end
    end
end

mane.core.click = m