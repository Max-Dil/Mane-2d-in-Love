local m = {}

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

mane.graphics = m