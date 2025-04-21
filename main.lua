require("mane")
mane.fps = 120

function mane.load()
    local centerX, centerY = mane.display.centerX, mane.display.centerY
    local group = mane.display.game
    local world = mane.physics.newWorld(0, 500)

    local platform = group:newRect(centerX, centerY + 100, 300, 50)
    world:addBody(platform, "static")

    local player = group:newRect(centerX, centerY, 50, 50)
    world:addBody(player, "dynamic")

    player:addEvent("collision", function(event)
        if event.phase == "began" then
            print("Collision began: Player (" .. event.target.x .. ", " .. event.target.y .. ") with " ..
                  event.other._type .. " at (" .. event.other.x .. ", " .. event.other.y .. ")")
        elseif event.phase == "ended" then
            print("Collision ended: Player (" .. event.target.x .. ", " .. event.target.y .. ") with " ..
                  event.other._type .. " at (" .. event.other.x .. ", " .. event.other.y .. ")")
        end
    end)

    mane.display.renderMode = 'hybrid'

    world.update = true

    local c = group:newPrint('Text', 200, 200, 70)
    local textTransition = mane.transition.to(c, {
        x = 400,
        time = 2000,
        transition = "outQuad",
    })
    local colorTransition = mane.transition.to(c.color, {
        [4] = 0,
        time = 2000
    })

    local textField = group:newTextField(100, 50, 200, 20, {
        text = "Single line",
        fontSize = 16,
        align = "center",
        password = false
    })

    local boxField = group:newBoxField(100, 200, 200, 100, {
        text = "Multi-line text\nLine 2",
        fontSize = 14,
        align = "left",
        nowrap = false,
        editable = true
    })
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