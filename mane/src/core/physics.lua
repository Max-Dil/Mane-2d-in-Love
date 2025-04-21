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
m.worlds = {}

local worldClass = {}
local physicsMethods = require(mane.path .. '.src.core.methods.physics')

function worldClass:addBody(obj, bodyType, options)
    for key, value in pairs(physicsMethods) do
        obj[key] = value
    end

    if self.fixture then
        self.fixture:destroy()
    end

    if options then
        options.offsetX = options.offsetX or 0
        options.offsetY = options.offsetY or 0
        if options.shape == "rect" then
            if not (options.width or options.height) then
                error("addBody no width or height is options", 2)
            end
            obj.shape = love.physics.newRectangleShape(options.width, options.height)
        elseif options.shape == "circle" then
            if not options.radius then
                error("addBody no radius is options", 2)
            end
            obj.shape = love.physics.newCircleShape(options.radius)
        elseif options.shape == "chain" then
            if not options.points then
                error("addBody no points is options", 2)
            end
            obj.shape = love.physics.newChainShape(options.loop or false, options.points)
        elseif options.shape == "edge" then
            if not (options.x1 or options.y1 or options.x2 or options.y2) then
                error("addBody no x1 or x2 or y1 or y2 is options", 2)
            end
            obj.shape = love.physics.newEdgeShape(options.x1, options.y1, options.x2, options.y2)
        elseif options.shape == "polygon" then
            if not options.vertices then
                error("addBody no vertices is options", 2)
            end
            obj.shape = love.physics.newPolygonShape(obj.vertices)
        end
    else
        options = {offsetX = 0, offsetY = 0}
        if obj._type == "newRect" or obj._type == "newContainer" then
            obj.shape = love.physics.newRectangleShape(obj.width, obj.height)
            options.width, options.height = obj.width, obj.height
            options.shape = "rect"
        elseif obj._type == "newCircle" then
            obj.shape = love.physics.newCircleShape(obj.radius)
            options.radius = obj.radius
            options.shape = "circle"
        elseif obj._type == "newPolygon" then
            obj.shape = love.physics.newPolygonShape(obj.vertices)
            options.vertices = obj.vertices
            options.shape = "polygon"
        elseif obj._type == "newPoints" then
            obj.shape = love.physics.newChainShape(false, obj.points)
            options.shape = "chain"
            options.points = obj.points
        end
    end
    obj.bodyOptions = options or {offsetX = 0, offsetY = 0}

    obj.body = love.physics.newBody(self.world, obj.x, obj.y, bodyType or "dynamic")
    obj.oldBodyX, obj.oldBodyY = obj.x, obj.y
    obj.oldBodyAngle = obj.angle

    obj.fixture = love.physics.newFixture(obj.body, obj.shape)
    obj.fixture:setUserData(obj)

    obj.world = self
end

function worldClass:addCollision(obj, listener)
    if #obj.events.collision <= 0 then
        table.insert(self.events.collision, obj)
    end
    table.insert(obj.events.collision, listener)
end

function worldClass:addPreCollision(obj, listener)
    if #obj.events.preCollision <= 0 then
        table.insert(self.events.preCollision, obj)
    end
    table.insert(obj.events.preCollision, listener)
end

function worldClass:removePreCollision(obj, listener)
    for i = #obj.events.preCollision, 1, -1 do
        if obj.events.preCollision[i] == listener then
            table.remove(obj.events.preCollision, i)
            break
        end
    end
    if #obj.events.preCollision == 0 then
        for i = #self.events.preCollision, 1, -1 do
            if self.events.preCollision[i] == obj then
                table.remove(self.events.preCollision, i)
                break
            end
        end
    end
end

function worldClass:addPostCollision(obj, listener)
    if #obj.events.postCollision <= 0 then
        table.insert(self.events.postCollision, obj)
    end
    table.insert(obj.events.postCollision, listener)
end

function worldClass:removePostCollision(obj, listener)
    for i = #obj.events.postCollision, 1, -1 do
        if obj.events.postCollision[i] == listener then
            table.remove(obj.events.postCollision, i)
            break
        end
    end
    if #obj.events.postCollision == 0 then
        for i = #self.events.postCollision, 1, -1 do
            if self.events.postCollision[i] == obj then
                table.remove(self.events.postCollision, i)
                break
            end
        end
    end
end

function worldClass:remove()
    for i = 1, #m.worlds do
        if m.worlds[i] == self then
            table.remove(m.worlds, i)
            break
        end
    end
    if self.world then
        self.world:destroy()
        self.events = {
            collision = {},
            preCollision = {},
            postCollision = {}
        }
    end
end

m.newWorld = function(gx, gy, sleep)
    local world = setmetatable({
        world = love.physics.newWorld(gx or 0, gy or 0, sleep and sleep or false),
        update = false
    }, {__index = worldClass})
    world.events = {
        collision = {},
        preCollision = {},
        postCollision = {}
    }

    world.world:setCallbacks(
        function(a, b, contact)
            local obj1 = a:getUserData() or {}
            local obj2 = b:getUserData() or {}
            for i = #world.events.collision, 1, -1 do
                local obj = world.events.collision[i]
                if obj then
                    local target, other
                    if obj == obj1 then
                        target, other = obj1, obj2
                    elseif obj == obj2 then
                        target, other = obj2, obj1
                    else
                        goto continue
                    end
                    local x1, y1, x2, y2 = contact:getPositions()
                    local nx, ny = contact:getNormal()
                    local event = {
                        phase = "began",
                        target = target,
                        other = other,
                        contact = {
                            positions = x1 and {{x = x1, y = y1}, x2 and {x = x2, y = y2} or nil} or {},
                            normal = {x = nx, y = ny},
                            isTouching = contact:isTouching(),
                            isEnabled = contact:isEnabled()
                        }
                    }
                    for i2 = #obj.events.collision, 1, -1 do
                        local result = obj.events.collision[i2](event)
                        if result then break end
                    end
                end
                ::continue::
            end
            if mane.physics.globalCollision then
                mane.physics.globalCollision(obj1, obj2)
            end
        end,
        function(a, b, contact)
            local obj1 = a:getUserData() or {}
            local obj2 = b:getUserData() or {}
            for i = #world.events.collision, 1, -1 do
                local obj = world.events.collision[i]
                if obj then
                    local target, other
                    if obj == obj1 then
                        target, other = obj1, obj2
                    elseif obj == obj2 then
                        target, other = obj2, obj1
                    else
                        goto continue
                    end
                    local event = {
                        phase = "ended",
                        target = target,
                        other = other,
                        contact = {
                            isTouching = contact:isTouching(),
                            isEnabled = contact:isEnabled()
                        }
                    }
                    for i2 = #obj.events.collision, 1, -1 do
                        local result = obj.events.collision[i2](event)
                        if result then break end
                    end
                end
                ::continue::
            end
            if mane.physics.endGlobalCollision then
                mane.physics.endGlobalCollision(obj1, obj2)
            end
        end,
        -- PreCollision
        function(a, b, contact)
            local obj1 = a:getUserData() or {}
            local obj2 = b:getUserData() or {}
            for i = #world.events.preCollision, 1, -1 do
                local obj = world.events.preCollision[i]
                if obj then
                    local target, other
                    if obj == obj1 then
                        target, other = obj1, obj2
                    elseif obj == obj2 then
                        target, other = obj2, obj1
                    else
                        goto continue
                    end
                    local x1, y1, x2, y2 = contact:getPositions()
                    local nx, ny = contact:getNormal()
                    local event = {
                        phase = "pre",
                        target = target,
                        other = other,
                        contact = {
                            positions = x1 and {{x = x1, y = y1}, x2 and {x = x2, y = y2} or nil} or {},
                            normal = {x = nx, y = ny},
                            isTouching = contact:isTouching(),
                            isEnabled = contact:isEnabled()
                        }
                    }
                    for i2 = #obj.events.preCollision, 1, -1 do
                        obj.events.preCollision[i2](event)
                    end
                end
                ::continue::
            end
            if mane.physics.preGlobalCollision then
                mane.physics.preGlobalCollision(obj1, obj2)
            end
        end,
        -- PostCollision
        function(a, b, contact)
            local obj1 = a:getUserData() or {}
            local obj2 = b:getUserData() or {}
            for i = #world.events.postCollision, 1, -1 do
                local obj = world.events.postCollision[i]
                if obj then
                    local target, other
                    if obj == obj1 then
                        target, other = obj1, obj2
                    elseif obj == obj2 then
                        target, other = obj2, obj1
                    else
                        goto continue
                    end
                    local x1, y1, x2, y2 = contact:getPositions()
                    local nx, ny = contact:getNormal()
                    local normalImpulse1, normalImpulse2 = contact:getNormalImpulses()
                    local tangentImpulse1, tangentImpulse2 = contact:getTangentImpulses()
                    local event = {
                        phase = "post",
                        target = target,
                        other = other,
                        contact = {
                            positions = x1 and {{x = x1, y = y1}, x2 and {x = x2, y = y2} or nil} or {},
                            normal = {x = nx, y = ny},
                            isTouching = contact:isTouching(),
                            isEnabled = contact:isEnabled(),
                            normalImpulses = normalImpulse1 and {{normal = normalImpulse1, tangent = tangentImpulse1}, normalImpulse2 and {normal = normalImpulse2, tangent = tangentImpulse2} or nil} or {}
                        }
                    }
                    for i2 = #obj.events.postCollision, 1, -1 do
                        local result = obj.events.postCollision[i2](event)
                        if result then break end
                    end
                end
                ::continue::
            end
            if mane.physics.postGlobalCollision then
                mane.physics.postGlobalCollision(obj1, obj2)
            end
        end
    )
    table.insert(m.worlds, world)
    return world
end

m.setCategory = function(obj, category)
    obj.fixture:setCategory(category)
end

m.setMask = function(obj, mask)
    obj.fixture:setMask(mask)
end

m.update = function(dt)
    for i = 1, #m.worlds do
        if m.worlds[i].update then
            m.worlds[i].world:update(dt)
        end
    end
end

mane.physics = m