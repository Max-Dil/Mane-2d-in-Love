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

local m = {}
local running = {}

local timer = {}

function timer:cancel()
    for i = 1, #running, 1 do
        if running[i] == self then
            table.remove(running, i)
            break
        end
    end
end

function timer:pause()
    self.on = false
end

function timer:resume()
    self.on = true
end

function timer:setTime(time)
    self._time = time
end

m.new = function (time, listener, rep)
    if type(listener) == "number" then
        listener, rep = rep, listener
    end
    local obj = setmetatable({
        time = time,
        rep = rep or 1,
        listener = listener,
        _time = time,
        on = true
    }
    , {__index = timer})
    table.insert(running, obj)
    return obj
end

m.cancel = function(timer)
    timer:cancel()
end

m.pause = function(timer)
    timer.on = false
end

m.resume = function(timer)
    timer.on = true
end

function m.update(dt)
    for i = 1, #running, 1 do
        if running[i].on then
            running[i].time = running[i].time - (dt * 1000)
            if running[i].time <= 0 then
                running[i].listener()
                if running[i].rep == 1 then
                    running[i]:cancel()
                else
                    running[i].rep = running[i].rep - 1
                    running[i].time = running[i]._time
                end
            end
        end
    end
end

return m