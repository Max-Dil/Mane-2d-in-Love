require("mane")
mane.fps = 120

function mane.load()
    local centerX, centerY = mane.display.centerX, mane.display.centerY
    local group = mane.display.game -- default group
    local world = mane.physics.newWorld(0, 500)

    local platform = group:newRect(centerX, centerY+100, 300, 50)
    world:addBody(platform, "static")

    local player = group:newRect(centerX, centerY, 50, 50)
    world:addBody(player, "dynamic")

    mane.display.renderMode = 'hybrid'
    world.update = true

    local c = group:newPrint('lox', 200, 200, 70)
end


-- скролл
--[[
require("mane")
mane.fps = 120

function mane.load()
    local centerX, centerY = mane.display.centerX, mane.display.centerY
    local group = mane.display.game

    local container = group:newContainer(centerX, centerY, 200, 300)
    container.group = group:newGroup()
    container:insert(container.group)

    for i = 1, 10 do
        local rect = container.group:newRect(0, (i - 1) * 60, 150, 50)
        rect:setColor(math.random(), math.random(), math.random(), 1)
    end

    local startY = 0
    local isScrolling = false

    container:addEvent("touch", function(e)
        if e.phase == "began" then
            startY = e.y
            isScrolling = true
        elseif e.phase == "moved" and isScrolling then
            local deltaY = e.y - startY
            container.group:translate(0, deltaY)
            startY = e.y
        elseif e.phase == "ended" or e.phase == "cancelled" then
            isScrolling = false
        end
    end)
end
]]