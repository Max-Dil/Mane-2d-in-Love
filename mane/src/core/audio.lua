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

local audio = {}

audio.sounds = mane.sounds
audio.masterVolume = 1.0

function audio.loadSound(filename, options)
    options = options or {}
    local soundType = options.stream and "stream" or "static"
    local source = love.audio.newSource(filename, soundType)

    local soundId = filename
    audio.sounds[soundId] = source
    mane.sounds[soundId] = source

    return soundId
end

function audio.play(soundId, options)
    options = options or {}
    local sound = audio.sounds[soundId]
    if not sound then
        print("Error: Sound " .. soundId .. " not found")
        return nil
    end

    if options.loop ~= nil then
        sound:setLooping(options.loop)
    end
    if options.volume then
        sound:setVolume(options.volume * audio.masterVolume)
    end
    if options.pitch then
        sound:setPitch(options.pitch)
    end
    if options.position then
        sound:setPosition(options.position.x or 0, options.position.y or 0, options.position.z or 0)
    end

    local instance = options.clone and sound:clone() or sound
    love.audio.play(instance)

    return instance
end

function audio.stop(soundIdOrInstance)
    local sound = type(soundIdOrInstance) == "string" and audio.sounds[soundIdOrInstance] or soundIdOrInstance
    if sound then
        sound:stop()
    end
end

function audio.pause(soundIdOrInstance)
    local sound = type(soundIdOrInstance) == "string" and audio.sounds[soundIdOrInstance] or soundIdOrInstance
    if sound then
        sound:pause()
    end
end

function audio.resume(soundIdOrInstance)
    local sound = type(soundIdOrInstance) == "string" and audio.sounds[soundIdOrInstance] or soundIdOrInstance
    if sound then
        sound:play()
    end
end

function audio.setVolume(volume)
    audio.masterVolume = math.max(0, math.min(1, volume))
    love.audio.setVolume(audio.masterVolume)
end

function audio.setSoundVolume(soundIdOrInstance, volume)
    local sound = type(soundIdOrInstance) == "string" and audio.sounds[soundIdOrInstance] or soundIdOrInstance
    if sound then
        sound:setVolume(math.max(0, math.min(1, volume)) * audio.masterVolume)
    end
end

function audio.isPlaying(soundIdOrInstance)
    local sound = type(soundIdOrInstance) == "string" and audio.sounds[soundIdOrInstance] or soundIdOrInstance
    return sound and sound:isPlaying() or false
end

function audio.setListenerPosition(x, y, z)
    love.audio.setPosition(x or 0, y or 0, z or 0)
end

function audio.setPitch(soundIdOrInstance, pitch)
    local sound = type(soundIdOrInstance) == "string" and audio.sounds[soundIdOrInstance] or soundIdOrInstance
    if sound then
        sound:setPitch(math.max(0.1, pitch))
    end
end

function audio.dispose(soundId)
    local sound = audio.sounds[soundId]
    if sound then
        sound:stop()
        audio.sounds[soundId] = nil
        mane.sounds[soundId] = nil
    end
end

mane.audio = audio
return audio