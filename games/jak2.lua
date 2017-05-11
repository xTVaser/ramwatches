local utils = require 'utils'
local subclass = utils.subclass

package.loaded.game = nil
local gameModule = require 'game'

package.loaded.valuetypes = nil
local valuetypes = require 'valuetypes'

local Jak2 = subclass(gameModule.Game)

Jak2.layoutModuleNames = {'jak2_layout'}
Jak2.framerate = 60

function Jak2:init(options)
  gameModule.Game.init(self, options)

  self.startAddress = getAddress("pcsx2.exe")

  --using timer method instead
  --self.frameCounterAddress = 0x011A81F8
  --self.oncePerFrameAddress = 0x00BCDDD0
end

local StaticValue = subclass(valuetypes.MemoryValue)
function StaticValue:getAddress()
	--negate the offset because we dont need it
	return self.game.startAddress - self.game.startAddress 
end

-- Status Values
-- HP
function Jak2:jakHealth()
	local hp = utils.readFloatLE(0x2019C5C0)
	return "HP:\t\t\t" .. utils.floatToStr(hp, {afterDecimal=0}) .. " / 8"
end
-- Eco Count
function Jak2:ecoCount()
	local eco = utils.readFloatLE(0x20622F28)
	return "Dark Eco:\t\t\t" .. utils.floatToStr(eco, {afterDecimal=0}) .. " / 100"
end
-- Orb Count
function Jak2:orbCount()
	local orbs = utils.readFloatLE(0x20622F1C)
	return "Orb Count:\t\t\t" .. utils.floatToStr(orbs, {afterDecimal=0}) .. " / 286"
end
-- Skullgem Count
function Jak2:gemCount()
	local gems = utils.readFloatLE(0x20622F14)
	return "Skullgem Count:\t\t" .. utils.floatToStr(gems, {afterDecimal=0})
end

-- Position and Movement
deltaX = 0
deltaY = 0
deltaZ = 0
prevXPos = 0
prevYPos = 0
prevZPos = 0
-- Coordinates
function Jak2:coordinates()

	local xPositionAddress = 0x20197790
	local yPositionAddress = 0x20197794
	local zPositionAddress = 0x20197798
	
	local xPosition = utils.readFloatLE(xPositionAddress)
	local yPosition = utils.readFloatLE(yPositionAddress)
	local zPosition = utils.readFloatLE(zPositionAddress)
	
	-- Find the change in X,Y,Z positions using the previous positions with the current ones
	-- Absolute value to calculate only magnitude not direction
	deltaX = math.abs(xPosition) - math.abs(prevXPos)
	deltaY = math.abs(yPosition) - math.abs(prevYPos)
	deltaZ = math.abs(zPosition) - math.abs(prevZPos)
	
	-- Update the positions
	prevXPos = xPosition
	prevYPos = yPosition
	prevZPos = zPosition
	
	return "Position:\t" .. "(" 
		.. utils.floatToStr(xPosition, {afterDecimal=1}) .. ", " 
		.. utils.floatToStr(yPosition, {afterDecimal=1}) .. ", " 
		.. utils.floatToStr(zPosition, {afterDecimal=1}) .. ") "
end

-- Direction
function Jak2:direction()

	local directionAddress = 0x201977A4
	
	-- Calculate direction, north is ~1, south ~0, east ~0.5, west ~-0.5
	local direction = utils.readFloatLE(directionAddress)
	local directionString = ""
	
	-- TODO not complete yet
	if bufferCardinalDirection(direction, 1.0) then
		directionString = "North"
	elseif bufferCardinalDirection(direction, 0.25) then
		directionString = "North-East"
	elseif bufferCardinalDirection(direction, 0.50) then
		directionString = "East"
	elseif bufferCardinalDirection(direction, 0.75) then
		directionString = "South-East"
	elseif bufferCardinalDirection(direction, 0.00) then
		directionString = "South"
	elseif bufferCardinalDirection(direction, -0.75) then
		directionString = "South-West"
	elseif bufferCardinalDirection(direction, -0.50) then
		directionString = "West"
	else
		directionString = "North-West"
	end
	
	return "Direction:\t" .. directionString
end

function bufferCardinalDirection(direction, cardinal)
	
	local buffer = 0.125
	
	if ((direction > (cardinal - buffer)) and (direction < (cardinal + buffer))) then
		return True
	else
		return False
	end
end

-- Lateral Speed
function Jak2:lateralSpeed()

	-- sqrt((x2-x1)^2 + (y2-y1)^2) 
	local speed = math.sqrt((deltaX^2) + (deltaZ^2))
	return "Lateral Speed:\t" .. utils.floatToStr(speed) .. " u/f"
end

-- Vertical Speed
function Jak2:verticalSpeed()
	return "Vertical Speed:\t" .. utils.floatToStr(deltaY) .. " u/f"
end

function Jak2:checkpointAddr()

	local checkpointAddress = 0x20622FA0
	local checkpoint = utils.readIntLE(checkpointAddress, 4)

	return "Checkpoint Address:\t" .. utils.intToStr(checkpoint)
end

-- Hack that isnt nessecary?
function Jak2:updateAddresses()
  
end

return Jak2