require("mane")

function mane.load()
    local centerX, centerY = mane.display.centerX, mane.display.centerY
    local group = mane.display.game
    local world = mane.physics.newWorld(0, 500)

    local player = group:newRect(centerX, centerY, 50, 50, 20, 20)
    world:addBody(player, "dynamic", {shape = "rect", width = 50, height = 50})

    local platform = group:newRect(centerX, centerY+100, 300, 40)
    world:addBody(platform, "static", {shape = "rect", width =  300, height = 40})

    mane.display.renderMode = "hybrid"
    world.update = true

    player:addEvent("update", function (dt)
        if love.keyboard.isDown("left") then
            player:translate(-5, 0)
        elseif love.keyboard.isDown("right") then
            player:translate(5, 0)
        end
        group.x, group.y = -player.x + centerX, -player.y + centerY
    end)
    player:addEvent("key", function (e)
        if e.phase == "began" and e.key == "up" then
            local vx, vy = player.body:getLinearVelocity()
            if vy > -3 and vy < 3 then
                player.body:setLinearVelocity(0, -400)
            end
        end
    end)
end