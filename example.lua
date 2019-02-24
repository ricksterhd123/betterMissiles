--[[ 
A51 no fly zone example script
--]]

local a51ColRadius = 100
local a51ColHeight = 100
local SAM_SITES = {{237.57784, 1694.60608, 27.07218}}

function shootSAM(target)
end

function onEnterNoFlyZone(element, matchingDimension)
	if not matchingDimension then return false end

	local vehicle = getPedOccupiedVehicle(localPlayer)
	if element == localPlayer or element == vehicle then
		createMissile(element, SAM_SITES[1][1], SAM_SITES[1][2], SAM_SITES[1][3], 1, element) 		
	end
end

function init()
	local a51ColTube = createColTube(213.53088, 1905.42578, 17.64063, a51ColRadius, a51ColHeight)
	addEventHandler("onClientColShapeHit", a51ColTube, onEnterNoFlyZone)
end
addEventHandler("onClientResourceStart", resourceRoot, init)
