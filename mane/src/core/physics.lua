local m = {}

m.newWorld = function (gx, gy, sleep)
    local world = love.physics.newWorld( gx or 0, gy or 0, sleep == nil and false or sleep)
    function world:addBody(obj, bodyType, options)
        if options then
            if options.shape == "rect" then
                obj.shape = love.physics.newRectangleShape(options.width, options.height)
            elseif options.shape == "circle" then
                obj.shape = love.physics.newCircleShape(options.radius)
            end
        end
        obj.body = love.physics.newBody(self, obj.x, obj.y, bodyType)
        obj.fixture = love.physics.newFixture(obj.body, obj.shape)
        obj.fixture:setUserData(obj)
    end
    return world
end

m.setCategory = function (obj, category)
    obj.fixture:setCategory(category)
end

m.setMask = function (obj, mask)
    obj.fixture:setMask(mask)
end

mane.physics = m