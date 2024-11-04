local m = {}
m.worlds = {}

local worldClass = {}

function worldClass:addBody(obj, bodyType, options)
    if options then
        if options.shape == "rect" then
            if not (options.width or options.height) then
                error("addBody no width or height is options",2)
            end
            obj.shape = love.physics.newRectangleShape(options.width, options.height)
        elseif options.shape == "circle" then
            if not options.radius then
                error("addBody no radius is options",2)
            end
            obj.shape = love.physics.newCircleShape(options.radius)
        elseif options.shape == "chain" then
            if not options.points then
                error("addBody no points is options",2)
            end
            obj.shape = love.physics.newChainShape( options.loop or false, obj.points )
        elseif options.shape == "edge" then
            if not (options.x1 or options.y1 or options.x2 or options.y2) then
                error("addBody no x1 or x2 or y1 or y2 is options",2)
            end
            obj.shape = love.physics.newEdgeShape( options.x1, options.y1, options.x2, options.y2 )
        elseif options.shape == "polygon" then
            if not options.vertices then
                error("addBody no vertices is options",2)
            end
            obj.shape = love.physics.newPolygonShape( obj.vertices )
        end
    end
    obj.bodyOptions = options or {}
    obj.body = love.physics.newBody(self.world, obj.x, obj.y, bodyType or "dynamic")
    obj.oldBodyX, obj.oldBodyY = obj.x, obj.y
    obj.oldBodyAngle = obj.angle
    obj.fixture = love.physics.newFixture(obj.body, obj.shape)
    obj.fixture:setUserData(obj)
    obj.world = self.world
end

m.newWorld = function (gx, gy, sleep)
    local world = setmetatable({
        world = love.physics.newWorld( gx or 0, gy or 0, sleep and sleep or false),
        update = false
    }, {__index = worldClass})
    world.events = {
        collision = {},
        endCollision = {},
        preCollision = {},
        postCollision = {}
    }
    world.world:setCallbacks(
    function (a, b) -- коллизи
        for i = 1, #world.events.collision, 1 do
            for i2 = 1, #world.events.collision[i].events.collision, 1 do
                local obj1 = a:getUserData() or {}
                local obj2 = b:getUserData() or {}
                if world.events.collision[i] == obj1 then
                    world.events.collision[i].events.collision[i2](obj1, obj2)
                end
            end
        end
        if mane.physics.globalCollision then
            local obj1 = a:getUserData() or {}
            local obj2 = b:getUserData() or {}
            mane.physics.globalCollision(obj1, obj2)
        end
    end,
    function (a, b) -- после коллизии
        for i = 1, #world.events.endCollision, 1 do
            for i2 = 1, #world.events.endCollision[i].events.endCollision, 1 do
                local obj1 = a:getUserData() or {}
                local obj2 = b:getUserData() or {}
                if world.events.endCollision[i] == obj1 then
                    world.events.endCollision[i].events.endCollision[i2](obj1, obj2)
                end
            end
        end
        if mane.physics.endGlobalCollision then
            local obj1 = a:getUserData() or {}
            local obj2 = b:getUserData() or {}
            mane.physics.endGlobalCollision(obj1, obj2)
        end
    end,
    function (a, b) -- предикт до коллизии
        for i = 1, #world.events.preCollision, 1 do
            for i2 = 1, #world.events.preCollision[i].events.preCollision, 1 do
                local obj1 = a:getUserData() or {}
                local obj2 = b:getUserData() or {}
                if world.events.preCollision[i] == obj1 then
                    world.events.preCollision[i].events.preCollision[i2](obj1, obj2)
                end
            end
        end
        if mane.physics.preGlobalCollision then
            local obj1 = a:getUserData() or {}
            local obj2 = b:getUserData() or {}
            mane.physics.preGlobalCollision(obj1, obj2)
        end
    end,
    function (a, b) -- предиет после коллизии
        for i = 1, #world.events.postCollision, 1 do
            for i2 = 1, #world.events.postCollision[i].events.postCollision, 1 do
                local obj1 = a:getUserData() or {}
                local obj2 = b:getUserData() or {}
                if world.events.postCollision[i] == obj1 then
                    world.events.postCollision[i].events.postCollision[i2](obj1, obj2)
                end
            end
        end
        if mane.physics.postGlobalCollision then
            local obj1 = a:getUserData() or {}
            local obj2 = b:getUserData() or {}
            mane.physics.postGlobalCollision(obj1, obj2)
        end
    end)
    table.insert(m.worlds, world)
    return world
end

m.setCategory = function (obj, category)
    obj.fixture:setCategory(category)
end

m.setMask = function (obj, mask)
    obj.fixture:setMask(mask)
end

m.update = function (dt)
    for i = 1, #m.worlds, 1 do
        if m.worlds[i].update then
            m.worlds[i].world:update(dt)
        end
    end
end

mane.physics = m