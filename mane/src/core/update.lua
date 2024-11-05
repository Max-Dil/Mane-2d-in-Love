local m = {}
m.running = {}

function m.new(obj, listener)
    if #obj.events.update <= 0 then
        table.insert(m.running, obj)
    end
    table.insert(obj.events.update, listener)
end

function m.remove(obj, listener)
    for i = #obj.events.update, 1, -1 do
        if obj.events.update[i] == listener then
            table.remove(obj.events.update, i)
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

m.update = function (dt)
    for i = 1, #m.running, 1 do
        local obj = m.running[i]
        obj.events.update[i](
            {
                dt = dt
            }
        )
    end
end

return m