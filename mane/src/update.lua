local m = {}
m.groupUpdate = function(group)
    for i = 1, #group.obj, 1 do
        local obj = group.obj[i]
        if obj._type == "newGroup" then
            m.groupUpdate(obj)
        else
            if obj.body and obj.body:getType() == "dynamic" then
                if obj.x ~= obj.oldBodyX then
                    obj.body:setX(obj.body:getX() + ( obj.x - obj.oldBodyX))
                end
                if obj.y ~= obj.oldBodyY then
                    obj.body:setY(obj.body:getY() + ( obj.y - obj.oldBodyY))
                end
                if obj.angle ~= obj.oldBodyAngle then
                    obj.body:setAngle(obj.body:getAngle() + math.rad( obj.angle - obj.oldBodyAngle))
                end
                obj.x = obj.body:getX()
                obj.y = obj.body:getY()
                obj.angle = (obj.body:getAngle()/math.pi) * 180
                obj.oldBodyX = obj.x
                obj.oldBodyY = obj.y
                obj.oldBodyAngle = obj.angle
            elseif obj.body and obj.body:getType() == "static" then
                obj.body:setX(obj.x)
                obj.body:setY(obj.y)
            end
        end
    end
end

return function (dt)
    mane.timer.update(dt)

    mane.physics.update(dt)
    if mane.display.game.isVisible then
        m.groupUpdate(mane.display.game)
    end
end