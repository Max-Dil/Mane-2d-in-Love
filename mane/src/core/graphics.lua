--[[
MIT License

Copyright (c) 2025 Max-Dil

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

local m = {}

m.newShader = function (code)
    return love.graphics.newShader(code)
end

m.newArrayImage = function (sprites)
    local images = {}
    for i = 1, #sprites, 1 do
        images[i] = love.graphics.newImage(sprites[i])
    end
    return images
end

function m.getPointsDimensions(points)
    local minX = math.huge
    local minY = math.huge
    local maxX = -math.huge
    local maxY = -math.huge

    for i = 1, #points, 2 do
        local x = points[i]
        local y = points[i + 1]

        if x < minX then
            minX = x
        end

        if x > maxX then
            maxX = x
        end

        if y < minY then
            minY = y
        end

        if y > maxY then
            maxY = y
        end
    end

    local width = maxX - minX
    local height = maxY - minY

    return width, height
end

m.getLineWidthHeight = function(points)
    local minX, maxX, minY, maxY = math.huge, -math.huge, math.huge, -math.huge

    for i = 1, #points - 2, 2 do
    minX = math.min(minX, points[i], points[i + 2])
    maxX = math.max(maxX, points[i], points[i + 2])
    minY = math.min(minY, points[i + 1], points[i + 3])
    maxY = math.max(maxY, points[i + 1], points[i + 3])
    end

    return maxX - minX, maxY - minY
end

function m.getPolygonDimensions(points)
    local minX, minY = math.huge, math.huge
    local maxX, maxY = -math.huge, -math.huge

    for i = 1, #points, 2 do
        local x = points[i]
        local y = points[i + 1]

        if x < minX then minX = x end
        if x > maxX then maxX = x end
        if y < minY then minY = y end
        if y > maxY then maxY = y end
    end

    return maxX - minX, maxY - minY
end

function m.pointInPolygon(pgon, tx, ty, obj)
    obj = obj or {x = 0, y = 0}
	if (#pgon < 6) then
		return false
	end

    local width, height = m.getPolygonDimensions(pgon)
    width, height = width*1.5, height*1.5
	local x1 = (obj.x - width) + pgon[#pgon - 1]
	local y1 = (obj.y - height) + pgon[#pgon]
	local cur_quad = m.getQuad(tx,ty,x1,y1)
	local next_quad
	local total = 0
	local i

	for i = 1,#pgon,2 do
		local x2 = (obj.x - width) + pgon[i]
		local y2 = (obj.y - height) + pgon[i+1]
		next_quad = m.getQuad(tx,ty,x2,y2)
		local diff = next_quad - cur_quad

		if (diff == 2) or (diff == -2) then
			if (x2 - (((y2 - ty) * (x1 - x2)) / (y1 - y2))) < tx then
				diff = -diff
			end
		elseif diff == 3 then
			diff = -1
		elseif diff == -3 then
			diff = 1
		end

		total = total + diff
		cur_quad = next_quad
		x1 = x2
		y1 = y2
	end

	return (math.abs(total)==4)
end

function m.getQuad(axis_x,axis_y,vert_x,vert_y)
	if vert_x < axis_x then
		if vert_y < axis_y then
			return 1
		else
			return 4
		end
	else
		if vert_y < axis_y then
			return 2
		else
			return 3
		end
	end
end

m.newSpriteSheet = function (image, frameWidth, frameHeight, numFrames, framesPerLine)
    if not mane.images[image] then
        mane.images[image] = love.graphics.newImage(image)
    end
    image = mane.images[image]
    local sprites = {}
    for i = 1, numFrames do
        local x = (i - 1) % framesPerLine * frameWidth
        local y = math.floor((i - 1) / framesPerLine) * frameHeight
        local quad = love.graphics.newQuad(x, y, frameWidth, frameHeight, image:getWidth(), image:getHeight())
        sprites[i] = quad
    end

    local base = {}

    function base:newAnimation(name, options)
        local frameStart, frameCount, time, rep = options.start, options.count, options.time, options.rep
        self.animations[name] = {
            start = frameStart or 1,
            count = frameCount or 1,
            time = time or 0,
            rep = rep or 1,
            nameTimer = options.nameTimer
        }
    end

    local obj = setmetatable(
        {
            frameWidth = frameWidth,
            frameHeight = frameHeight,
            numFrames = numFrames,
            framesPerLine = framesPerLine,
            animations = {},
            image = image,
            sprites = sprites
        },
    {__index = base})
    obj.animations['default'] = {
        frameStart = 1,
        frameCount = #sprites - 1,
        time = 500,
        rep = 1
    }

    return obj
end

mane.graphics = m