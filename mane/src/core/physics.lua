local m = {}
m.worlds = {}

local worldClass = {}

function worldClass:addBody(obj, bodyType, options)
    if options then
        if options.shape == "rect" then
            obj.shape = love.physics.newRectangleShape(options.width, options.height)
        elseif options.shape == "circle" then
            obj.shape = love.physics.newCircleShape(options.radius)
        end
    end
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
        mane.physics.globalCollision(a, b)
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
        mane.physics.endGlobalCollision(a, b)
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
        mane.physics.preGlobalCollision(a, b)
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
        mane.physics.postGlobalCollision(a, b)
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
mane.physics.globalCollision = function (a, b)end
mane.physics.endGlobalCollision = function (a, b)end
mane.physics.preGlobalCollision = function (a, b)end
mane.physics.postGlobalCollision = function (a, b)end