require("mane")

function mane.load()
    local centerX, centerY = mane.display.centerX, mane.display.centerY
    local group = mane.display.game:newGroup()

    local worldGame = mane.physics.newWorld(0, 500)
    local rect = group:newRect(centerX, centerY, 50, 50)
    rect.name = "one rect"
    worldGame:addBody(rect, "dynamic", {shape = "rect", width = 50, height = 50})

    local rect2 = group:newRect(centerX, centerY+100, 400, 50)
    rect2.name = "platform"
    worldGame:addBody(rect2, "static", {shape = "rect", width = 400, height = 50})
    rect2:addClick(function (e)
        if e.phase == "began" then
        elseif e.phase == "moved" then
            rect2.x, rect2.y = e.x, e.y
        elseif e.phase == "ended" then
        end
        return true
    end)

    local arc = group:newArc(100, 100, 50, 10, 360, 2)
    arc:addClick(function (e)
        if e.phase == "began" then
        elseif e.phase == "moved" then
            arc.x, arc.y = e.x, e.y
        elseif e.phase == "ended" or e.phase == "cancelled" then
        end
        return true
    end)


    -- local collision = function (ob1, ob2)
    --     print(ob1.name)
    --     print(ob2.name)
    -- end
    -- rect:addCollision(worldGame, collision)

    local text = group:newPrint("Hello World!", 300, 300)
    worldGame:addBody(text, "static", {shape = "edge", x1 = 0, y1 = 0, x2 = 100, y2 = 100})
    text:addClick(function (e)
        if e.phase == "began" then
        elseif e.phase == "moved" then
            text.x, text.y = e.x, e.y
        elseif e.phase == "ended" or e.phase == "cancelled" then
        end
        return true
    end)
    function mane.physics.globalCollision(a, b)
        print(a.name)
    end
    mane.display.renderMode = "hybrid"
    function love.keypressed(key)
        if key == "a" then
            worldGame.update = true
            mane.timer.new(1000, function ()
            end)
        end
    end
end