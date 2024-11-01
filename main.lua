require("mane")

function mane.load()
    local centerX, centerY = mane.display.centerX, mane.display.centerY
    local group = mane.display.game:newGroup()
    local group2 = group:newGroup()

    local circle = group:newCircle(centerX, centerY, 50)
    circle.segments = 5

    local image = group:newImage("icon.png", centerX, centerY)
    image.xScale = 0.5
    image.yScale = 0.5
    image.angle = 45
    local line = group:newLine({400, 400, 300, 300})

    local rect = group:newRect(centerX, centerY-200, 50, 50, 10, 10)
    rect:setColor(1,0,1)
    rect.mode = "line"

    local arc = group:newArc(100, 100, 50, 180/6, 360 - 180/6)

    local text = group:newPrint({{1,1,0,1},"Fon",{0,1,1,1},"Dom"}, centerX, centerY-100)
    text.angle = 45

    local text2 = group:newPrintf({{1,1,0,1},"Fon",{0,1,1,1},"Dom"}, centerX, centerY-200, 500, "right")
    text2.angle = 45

    local timer = mane.timer.new(500, function ()
        rect:translate(0, 5)
    end, 5)
    function love.keypressed()

    end
end