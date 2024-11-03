local m = {}
m.running = {}
m.focus = {}

local function checkArcClick(obj, x, y)
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
end
local function distancePointToLineSegment(x, y, x1, y1, x2, y2)
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
local function isPointOnLine(x, y, obj)
    for i = 1, #obj.points - 2, 2 do
        local width, height = mane.graphics.getLineWidthHeight(obj.points)
        local ox = obj.x - width
        local oy = obj.y - height
        local x1 = ox + obj.points[i]
        local y1 = oy + obj.points[i + 1]
        local x2 = ox + obj.points[i + 2]
        local y2 = oy + obj.points[i + 3]
        if distancePointToLineSegment(x, y, x1, y1, x2, y2) <= obj.width / 2 then
            return true
        end
    end
    return false
end

function m.new(obj, listener)
    table.insert(obj.events.touch, listener)
    table.insert(m.running, obj)
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
                button = button
            })
            if result then
                return true
            end
        end
    end
    for i = 1, #m.running, 1 do
        local obj = m.running[i]
        if obj._type == "newRect" then
            if x > (obj.x - obj.width / 2) and x < (obj.x + obj.width / 2) and
               y > (obj.y - obj.height / 2) and y < (obj.y + obj.height / 2) then
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
            if checkArcClick(obj, x, y) then
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
            if isPointOnLine(x, y, obj) then
                local result = call_func(obj)
                if result then
                    break
                end
            end
        elseif obj._type == "newPoints" then
            for j = 1, #obj.points, 2 do
                local pointX = obj.points[j]
                local pointY = obj.points[j + 1]
                if love.distance(x, y, pointX, pointY) <= obj.size / 2 then
                    local result = call_func(obj)
                    if result then
                        return true
                    end
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
                    button = button
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

return m