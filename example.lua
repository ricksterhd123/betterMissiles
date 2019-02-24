--[[ 
A51 no fly zone example script
--]]

local a51ColRadius = 100
local a51ColHeight = 100
local SAM = { pos = {{237.57784, 1694.60608, 27.07218}} }

function SAM:shoot(target)
	createMissile(target, self.pos[1][1], self.pos[1][2], self.pos[1][3], 1, target) 		
end

function onEnterNoFlyZone(element, matchingDimension)
	if not matchingDimension then return false end

	local vehicle = getPedOccupiedVehicle(localPlayer)
	if element == localPlayer or element == vehicle then
		SAM:shoot(element)
	end
end

function init()
	local a51ColTube = createColTube(213.53088, 1905.42578, 17.64063, a51ColRadius, a51ColHeight)
	addEventHandler("onClientColShapeHit", a51ColTube, onEnterNoFlyZone)
end
addEventHandler("onClientResourceStart", resourceRoot, init)
