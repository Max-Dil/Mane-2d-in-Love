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
local running = {}

local timer = {}

function timer:cancel()
    for i = #running, 1, -1 do
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

m.new = function (time, listener, rep, name)
    if type(listener) == "number" then
        listener, rep = rep, listener
    end
    local obj = setmetatable({
        time = time,
        rep = rep or 1,
        listener = listener,
        _time = time,
        on = true,
        name = name
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

m.resumeAll = function(name)
    for i = #running, 1, -1 do
        if running[i] then
            if name then
                if name == running[i].name then
                    running[i].on = true
                end
            else
                running[i].on = true
            end
        end
    end
end

m.pauseAll = function(name)
    for i = #running, 1, -1 do
        if running[i] then
            if name then
                if name == running[i].name then
                    running[i].on = false
                end
            else
                running[i].on = false
            end
        end
    end
end

m.cancelAll = function(name)
    for i = #running, 1, -1 do
        if running[i] then
            if name then
                if name == running[i].name then
                    running[i]:cancel()
                end
            else
                running[i]:cancel()
            end
        end
    end
    if not name then
        running = {}
    end
end

function m.update(dt)
    for i = #running, 1, -1 do
        local toRemove = false
        if running[i].on then
            running[i].time = running[i].time - (dt * 1000)
            if running[i].time <= 0 then
                running[i].listener(dt)
                if running[i] then
                    if running[i].rep == 1 then
                        toRemove = true
                    else
                        running[i].rep = running[i].rep - 1
                        running[i].time = running[i]._time
                    end
                end
            end
        end
        if toRemove then
            table.remove(running, i)
        end
    end
end

mane.timer = m