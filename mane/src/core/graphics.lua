local m = {}

m.newArrayImage = function (sprites)
    local images = {}
    for i = 1, #sprites, 1 do
        images[i] = love.graphics.newImage(sprites[i])
    end
    return images
end

mane.graphics = m