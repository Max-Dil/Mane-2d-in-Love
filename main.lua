require("mane")

function mane.load()
    local centerX, centerY = mane.display.centerX, mane.display.centerY
    local group = mane.display.game
    local world = mane.physics.newWorld(0, 500)

    local platform = group:newRect(centerX, centerY+100, 300, 50)
    platform.name = "platform"
    world:addBody(platform, "static", {shape = "rect", width = 300, height = 50})

    local player = group:newRect(centerX, centerY, 50, 50)
    player.name = "player"
    world:addBody(player, "dynamic", {shape = "rect", width = 50, height = 50})

    world.update = true -- включает обновление мира

    player:addEvent("collision", function (e)
        if e.phase == "began" then
            player.body:setLinearVelocity(0, -500)
        end
    end, world)
end