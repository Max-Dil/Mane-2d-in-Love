_G.love = love
function love.distance(x1, y1, x2, y2) local dx = x2 - x1 local dy = y2 - y1 return math.sqrt(dx * dx + dy * dy) end

--[[
MIT License

Copyright (c) 2024 Max-Dil

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

_G.mane = {
    load = function () end,
    images = {},
    fonts = {},
    fps = 1000,
	core = {},
	json = require("mane.lib.json"),
	speed = 0
}

local moduls = {"display","graphics","physics","key","update","click","timer"}
for _, name in ipairs(moduls) do
	require("mane.src.core."..name)
end

function love.load()

local update = require("mane.src.update")
function love.update(dt)
    update(dt)
	mane.core.update.update(dt)
end

local draw = require("mane.src.draw")
function love.draw()
    draw()
end

function love.keypressed(key, scancode, isrepeat)
	mane.core.key.keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key)
	mane.core.key.keyreleased(key)
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

function love.touchreleased(id, x, y, dx, dy, pressure)
	mane.core.click.touchreleased(id, x, y, dx, dy, pressure)
end

function love.touchpressed(id, x, y, dx, dy, pressure)
	mane.core.click.touchpressed(id, x, y, dx, dy, pressure)
end

function love.touchmoved(id, x, y, dx, dy, pressure)
	mane.core.click.touchmoved(id, x, y, dx, dy, pressure)
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