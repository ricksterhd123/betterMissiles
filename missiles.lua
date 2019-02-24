--[[
Description: Create a missile just like you would createProjectile()
Params:

Returns:
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
Get the steering force velocity the projectile should follow
--]]
function getSteeringForce(projectile, target, maxSpeed, decelRadius)
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
Description: Shabby proportional navigation on missiles with element data 'target'
--]]
function proportionalNavigation()
	for i, projectile in ipairs(getElementsByType("projectile")) do
		-- Check if it has a target
		local target = getElementData(projectile, "target")
		if target then
			local steeringForce = getSteeringForce(projectile, target, 5, 1)
			local vx, vy, vz = steeringForce:getX(), steeringForce:getY(), steeringForce:getZ()
			local px, py, pz = getElementPosition(projectile)
			setElementPosition(projectile, px + vx, py + vy, pz + vz)
			--setElementVelocity(projectile, vx, vy, vz)
		end
	end
end
addEventHandler("onClientPreRender", getRootElement(), 
proportionalNavigation)




