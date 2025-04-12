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

local base = {}

function base:removeBody()
    -- Уничтожаем физические объекты, если они существуют
    if self.fixture then
        self.fixture:destroy()
        self.fixture = nil
    end
    if self.body then
        self.body:destroy()
        self.body = nil
    end
    self.shape = nil

    if self.world then
        if self.events and self.events.collision and #self.events.collision > 0 then
            for i = #self.world.events.collision, 1, -1 do
                if self.world.events.collision[i] == self then
                    table.remove(self.world.events.collision, i)
                    break
                end
            end
            self.events.collision = {}
        end

        if self.events and self.events.preCollision and #self.events.preCollision > 0 then
            for i = #self.world.events.preCollision, 1, -1 do
                if self.world.events.preCollision[i] == self then
                    table.remove(self.world.events.preCollision, i)
                    break
                end
            end
            self.events.preCollision = {}
        end

        if self.events and self.events.postCollision and #self.events.postCollision > 0 then
            for i = #self.world.events.postCollision, 1, -1 do
                if self.world.events.postCollision[i] == self then
                    table.remove(self.world.events.postCollision, i)
                    break
                end
            end
            self.events.postCollision = {}
        end
    end

    for key, value in pairs(base) do
        self[key] = nil
    end
end

function base:setMask(mask)
    mane.physics.setCategory(self, mask)
end

base["setСategory"] = function (self, category)
    mane.physics.setCategory(self, category)
end

function base:setType(bodyType)
    self.body:setType(bodyType)
end

function base:setSleepingAllowed(allowed)
    self.body:setSleepingAllowed(allowed)
end

function base:setDensity(density)
    self.fixture:setDensity(density)
end

function base:setRestitution(restruction)
    self.fixture:setRestitution(restruction)
end

function base:setFriction(friction)
    self.fixture:setFriction(friction)
end

function base:setMassData(x, y, mass, inertia)
    self.body:setMassData(x, y, mass, inertia)
end

function base:setMass(mass)
    self.body:setMass(mass)
end

function base:setLinearVelocity(x, y)
    self.body:setLinearVelocity(x, y)
end

function base:setLinearDamping(ld)
    self.body:setLinearDamping(ld)
end

function base:setInertia(inertia)
    self.body:setInertia(inertia)
end

function base:setGravityScale(scale)
    self.body:setGravityScale(scale)
end

function base:setFixedRotation(isFixed)
    self.body:setFixedRotation(isFixed)
end

function base:setBullet(status)
    self.body:setBullet(status)
end

function base:setAwake( awake )
    self.body:setAwake( awake )
end

function base:setAngularVelocity( w )
    self.body:setAngularVelocity( w )
end

function base:setAngularDamping( damping )
    self.body:setAngularDamping( damping )
end

function base:setActive( active )
    self.body:setActive( active )
end

function base:resetMassData( )
    self.body:resetMassData( )
end

function base:isTouching( object )
    if object.body then
        return self.body:isTouching( object.body )
    else
        return false
    end
end

function base:isSleepingAllowed( )
    return self.body:isSleepingAllowed( )
end

function base:isBullet( )
    return self.body:isBullet( )
end

function base:isAwake( )
    return self.body:isAwake( )
end

function base:isActive( )
    return self.body:isActive( )
end

function base:getType( )
    return self.body:getType( )
end

function base:getMassData( )
    return self.body:getMassData( )
end

function base:getMass( )
    return self.body:getMass( )
end

function base:getLinearVelocity( )
    return self.body:getLinearVelocity( )
end

function base:getLinearDamping( )
    return self.body:getLinearDamping( )
end

function base:getInertia( )
    return self.body:getInertia( )
end

function base:getGravityScale( )
    return self.body:getGravityScale( )
end

function base:getAngularVelocity() 
    return self.body:getAngularVelocity( )
end

function base:getAngularDamping( )
    return self.body:getAngularDamping( )
end

function base:getAngle( )
    return self.body:getAngle( )
end

function base:applyTorque( torque )
    return self.body:applyTorque( torque )
end

function base:applyLinearImpulse( ix, iy )
    self.body:applyLinearImpulse( ix, iy )
end

function base:applyForce( fx, fy )
    self.body:applyForce( fx, fy )
end

function base:applyAngularImpulse( impulse )
    self.body:applyAngularImpulse( impulse )
end

return base