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
local tween = require(mane.path .. ".lib.tween")

local m = {}
m.transitions = {}

local easingTypes = {
    "linear",
    "inQuad", "outQuad", "inOutQuad", "outInQuad",
    "inCubic", "outCubic", "inOutCubic", "outInCubic",
    "inQuart", "outQuart", "inOutQuart", "outInQuart",
    "inQuint", "outQuint", "inOutQuint", "outInQuint",
    "inSine", "outSine", "inOutSine", "outInSine",
    "inExpo", "outExpo", "inOutExpo", "outInExpo",
    "inCirc", "outCirc", "inOutCirc", "outInCirc",
    "inElastic", "outElastic", "inOutElastic", "outInElastic",
    "inBack", "outBack", "inOutBack", "outInBack",
    "inBounce", "outBounce", "inOutBounce", "outInBounce"
}

local function isValidEasing(easing)
    for _, v in ipairs(easingTypes) do
        if v == easing then return true end
    end
    return false
end

local function createTransition(object, params, isFrom)
    if not object or type(object) ~= "table" then
        error("Object must be a table")
    end
    if not params or type(params) ~= "table" then
        error("Params must be a table")
    end

    local time = (params.time or 1000)/1000
    local delay = params.delay or 0
    local easing = params.transition or "linear"
    local onComplete = params.onComplete
    local target = {}

    if not isValidEasing(easing) then
        easing = "linear"
    end

    for k, v in pairs(params) do
        if k ~= "time" and k ~= "delay" and k ~= "transition" and k ~= "onComplete" then
            target[k] = v
        end
    end

    if isFrom then
        local temp = {}
        for k, v in pairs(target) do
            temp[k] = object[k] or 0
            object[k] = v
        end
        target = temp
    end

    local t = tween.new(time, object, target, easing)

    local elapsed = 0
    local delayed = delay > 0
    local paused = false

    local transition
    transition = {
        tween = t,
        object = object,
        delay = delay,
        elapsed = elapsed,
        delayed = delayed,
        paused = paused,
        onComplete = onComplete,
        update = function(self, dt)
            if transition.paused or transition.delayed then
                if transition.delayed then
                    transition.elapsed = transition.elapsed + dt
                    if transition.elapsed >= transition.delay then
                        transition.delayed = false
                    end
                end
                return false
            else
                local completed = transition.tween:update(dt)
                if completed and transition.onComplete then
                    transition.onComplete()
                    transition.onComplete = nil
                end
                return completed
            end
        end,
        pause = function(self)
            transition.paused = true
        end,
        resume = function(self)
            transition.paused = false
        end
    }

    table.insert(m.transitions, transition)
    return transition
end

function m.to(object, params)
    return createTransition(object, params, false)
end

function m.from(object, params)
    return createTransition(object, params, true)
end

function m.pause(transition)
    for _, t in ipairs(m.transitions) do
        if t == transition then
            t:pause()
            return true
        end
    end
    return false
end

function m.resume(transition)
    for _, t in ipairs(m.transitions) do
        if t == transition then
            t:resume()
            return true
        end
    end
    return false
end

function m.pauseObject(object)
    for _, t in ipairs(m.transitions) do
        if t.object == object then
            t:pause()
        end
    end
end

function m.resumeObject(object)
    for _, t in ipairs(m.transitions) do
        if t.object == object then
            t:resume()
        end
    end
end

function m.cancel(transition)
    for i, t in ipairs(m.transitions) do
        if t == transition then
            table.remove(m.transitions, i)
            return true
        end
    end
    return false
end

function m.cancelObject(object)
    for i = #m.transitions, 1, -1 do
        if m.transitions[i].object == object then
            table.remove(m.transitions, i)
        end
    end
end

function m.cancelAll()
    m.transitions = {}
end

function m.pauseAll()
    for _, t in ipairs(m.transitions) do
        t:pause()
    end
end

function m.resumeAll()
    for _, t in ipairs(m.transitions) do
        t:resume()
    end
end

function m.update(dt)
    for i = #m.transitions, 1, -1 do
        local completed = m.transitions[i]:update(dt)
        if completed then
            table.remove(m.transitions, i)
        end
    end
end

return m