local m = {}

function m.getWidth()
    return love.graphics.getWidth()
end

function m.getHeight()
    return love.graphics.getHeight()
end

function m.setTitle(title)
    love.window.setTitle(title)
end

function m.getTitle()
    return love.window.getTitle()
end

m.setFullscreen = function(screen)
    love.window.setFullscreen(screen)

    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    mane.display.width = w
	mane.display.height = h
	mane.display.centerX = mane.display.width / 2
	mane.display.centerY = mane.display.height / 2
    return true
end

function m.isFullscreen()
    return love.window.isFullscreen()
end

function m.setSize(w, h)
    local success, err = love.window.setMode(w, h, love.window.getFullscreen())

    if not success then
        return false, err
    end

    mane.display.width = w
	mane.display.height = h
	mane.display.centerX = mane.display.width / 2
	mane.display.centerY = mane.display.height / 2
    return true
end

function m.setPosition(x, y)
    love.window.setPosition(x, y)
end

function m.getPosition()
    return love.window.getPosition()
end

function m.setMouseVisible(visible)
    love.mouse.setVisible(visible)
end

function m.isMouseVisible()
    return love.mouse.isVisible()
end

function m.setMouseGrabbed(grabbed)
    love.mouse.setGrabbed(grabbed)
end

function m.isMouseGrabbed()
    return love.mouse.isGrabbed()
end

function m.setSizableLimits(minwidth, minheight, maxwidth, maxheight)
    love.window.setMode(love.graphics.getWidth(), love.graphics:getHeight(), {
        minwidth = minwidth,
        minheight = minheight,
        maxwidth = maxwidth,
        maxheight = maxheight,
        resizable = true
    })
end


return m