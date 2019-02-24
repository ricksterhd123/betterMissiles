--[[
Description: Create better homing missiles!
Author: exilepilot

This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <http://unlicense.org>
]]

--[[
Description: Create a missile just like you would createProjectile in MTA except you don't need weaponType it's 20 by default.
NOTE: if the target is a player and is inside a vehicle then the target should be the vehicle => better sync 
Returns: projectile
--]]
function createMissile(creator, posX, posY, posZ, force, target, rotX, rotY, rotZ, velX, velY, velZ, model)
	if not target then return false end
	local projectile = createProjectile(creator, 20, posX, posY, posZ, force, target, rotX, rotY, rotZ, velX, velZ, model)
	if projectile then
		setElementData(projectile, "target", target)
	end
	return projectile
end

--[[
Get the desired steering force
Params: projectile - The steering force we're calculating for
	target - The target the projectile must steer toward
	maxSpeed - The maximum speed of the projectile.
	decelRadius - Minimum distance before the projectile begins to decelerate.
Returns: steeringForceVelocity as Vector3 
--]]
local function getSteeringForce(projectile, target, maxSpeed, decelRadius)
	assert(isElement(target) and getElementType(projectile) == "projectile")
	maxSpeed = maxSpeed or 1
	decelRadius = decelRadius or 0
 
	local px, py, pz = getElementPosition(projectile)
	local pvx, pvy, pvz = getElementVelocity(projectile)
	local tx, ty, tz = getElementPosition(target)
	local targetPosition = Vector3(tx, ty, tz)
	local projectilePosition = Vector3(px, py, pz)
	local projectileVelocity = Vector3(pvx, pvy, pvz)
	
	local targetOffset = targetPosition - projectilePosition
	targetOffset:normalize()

	local distance = getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz)
	local scaledSpeed = (distance / decelRadius) * maxSpeed
	local desiredSpeed = math.min(scaledSpeed, maxSpeed)
	
	local desiredVelocity = targetOffset * desiredSpeed
	return desiredVelocity - projectileVelocity
end

--[[
Description: Calculate new position for all missiles
--]]
local function projectileNavigation()
	for i, projectile in ipairs(getElementsByType("projectile")) do
		-- Check if it has a target
		local target = getElementData(projectile, "target")
		if target then
			local steeringForce = getSteeringForce(projectile, target)
			local vx, vy, vz = steeringForce:getX(), steeringForce:getY(), steeringForce:getZ()
			local px, py, pz = getElementPosition(projectile)
			setElementPosition(projectile, px + vx, py + vy, pz + vz)
			--setElementVelocity(projectile, vx, vy, vz)
		end
	end
end
addEventHandler("onClientPreRender", getRootElement(), projectileNavigation)
