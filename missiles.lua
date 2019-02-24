--[[
Description: Create a missile just like you would createProjectile in MTA except you don't need weaponType it's 20 by default.
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
	maxSpeed = 1 or maxSpeed
	decelRadius = 0 or decelRadius
 
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
local function proportionalNavigation()
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
addEventHandler("onClientPreRender", getRootElement(), proportionalNavigation)
