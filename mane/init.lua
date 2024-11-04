_G.love = love
function love.distance(x1, y1, x2, y2) local dx = x2 - x1 local dy = y2 - y1 return math.sqrt(dx * dx + dy * dy) end

_G.mane = {
    load = function () end,
    images = {},
    fonts = {},
    fps = 1000,
	core = {}
}
require("mane.src.core.display")
require("mane.src.core.graphics")
require("mane.src.core.physics")
mane.core.click = require("mane.src.core.click")
function love.load()
mane.timer = require("mane.src.core.timer")

local update = require("mane.src.update")
function love.update(dt)
    update(dt)
end

local draw = require("mane.src.draw")
function love.draw()
    draw()
end

function love.mousereleased(x, y, button, isTouch)
	mane.core.click.mousereleased(x, y, button, isTouch)
end

function love.mousepressed( x, y, button, isTouch)
	mane.core.click.mousepressed(x, y, button, isTouch)
end

function love.mousemoved(x, y, dx, dy)
	mane.core.click.mousemoved(x, y, dx, dy)
end

function love.run()
    love.load(love.arg.parseGameArguments(arg), arg)
	love.timer.step()

	local dt = 0
	return function()
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end

		dt = love.timer.step()

		love.update(dt)

		love.graphics.origin()
		love.graphics.clear(love.graphics.getBackgroundColor())

		love.draw()

		love.graphics.present()

		love.timer.sleep(1/mane.fps)
	end
end

mane.load()
end