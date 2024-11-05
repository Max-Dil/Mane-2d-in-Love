local m = {}
m.running = {}

function m.new(obj, listener)
    if #obj.events.key <= 0 then
        table.insert(m.running, obj)
    end
    table.insert(obj.events.key, listener)
end

function m.remove(obj, listener)
    for i = #obj.events.key, 1, -1 do
        if obj.events.key[i] == listener then
            table.remove(obj.events.key, i)
            break
        end
    end
    for i = m.running, 1, -1 do
        if m.running[i] == obj then
            table.remove(m.running, i)
            break
        end
    end
end


m.keypressed = function (key, scancode, isrepeat)
    for i = 1, #m.running, 1 do
        local obj = m.running[i]
        obj.events.key(
            {
                phase = "began",
                scancode = scancode,
                isrepeat = isrepeat,
                key = key
            }
        )
    end
end

m.keyreleased = function (key)
    for i = 1, #m.running, 1 do
        local obj = m.running[i]
        obj.events.key(
            {
                phase = "ended",
                key = key
            }
        )
    end
end

return m