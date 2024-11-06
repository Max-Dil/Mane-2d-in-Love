require("mane")

function mane.load()
    local centerX, centerY = mane.display.centerX, mane.display.centerY
    local group = mane.display.game
    local world = mane.physics.newWorld(0, 500)

    local platform = group:newRect(centerX, centerY+100, 300, 50)
    world:addBody(platform, "static", {shape = "rect", width = 300, height = 50})

    local player = group:newRect(centerX, centerY, 50, 50)
    world:addBody(player, "dynamic", {shape = "rect", width = 50, height = 50})

    world.update = true -- включает обновление мира
end