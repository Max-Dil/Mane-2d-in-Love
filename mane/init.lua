_G.love = love

_G.mane = {
    load = function () end,
    images = {},
    fonts = {},
    fps = 1000
}
function love.load()
require("mane.src.core.display")
require("mane.src.core.graphics")

mane.timer = require("mane.src.core.timer")

local update = require("mane.src.update")
function love.update(dt)
    update(dt)
end

local draw = require("mane.src.draw")
function love.draw()
    draw()
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