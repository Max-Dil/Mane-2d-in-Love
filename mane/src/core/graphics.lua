local m = {}

m.newArrayImage = function (sprites)
    local images = {}
    for i = 1, #sprites, 1 do
        images[i] = love.graphics.newImage(sprites[i])
    end
    return images
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

mane.graphics = m