Mane - lua simple framework for love 2d. groups, drawing objects for you, timer module. objects also have events:
touch - pressed, released, while pressed
key - pressed, released the keyboard
update - update cycle
collision - start, end of collision

code example:

require("mane")

function mane.load()
local centerx, centery = mane.display.centerx, mane.display.centery
local group = mane.display.game
local world = mane.physics.newworld(0, 500)

local platform = group:newrect(centerx, centery+100, 300, 50)
world:addbody(platform, "static", {shape = "rect", width = 300, height = 50})

local player = group:newrect(centerx, centery, 50, 50)
world:addbody(player, "dynamic", {shape = "rect", width = 50, height = 50})

world.update = true -- enables world update
end

want to change something?
request branch change
