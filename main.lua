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
end