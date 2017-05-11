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
	return "HP: \t\t\t" .. utils.floatToStr(hp, {afterDecimal=0}) .. " / 8"
end
-- Eco Count
function Jak2:ecoCount()
	local eco = utils.readFloatLE(0x20622F28)
	return "Dark Eco: \t\t\t" .. utils.floatToStr(eco, {afterDecimal=0}) .. " / 100"
end
-- Orb Count
function Jak2:orbCount()
	local orbs = utils.readFloatLE(0x20622F1C)
	return "Orb Count: \t\t\t" .. utils.floatToStr(orbs, {afterDecimal=0}) .. " / 286"
end
-- Skullgem Count
function Jak2:gemCount()
	local gems = utils.readFloatLE(0x20622F14)
	return "Skullgem Count: \t\t" .. utils.floatToStr(gems, {afterDecimal=0})
end

-- Position.
function Jak2:xPositionDisplay()
	local xPositionAddress = 0x20197790
	local xPosition = utils.readFloatLE(xPositionAddress)
	-- Find the change in X position using the previous position with the current one
	-- Absolute value to calculate only magnitude not direction
	deltaX = math.abs(xPosition) - math.abs(prevXPos)
	-- Update the position
	prevXPos = xPosition
	return "X position:\t\t" .. utils.floatToStr(xPosition) .. " u/f"
end

function Jak2:zPositionDisplay()
	local zPositionAddress = 0x20197798
	local zPosition = utils.readFloatLE(zPositionAddress)
	-- Find the change in X position using the previous position with the current one
	-- Absolute value to calculate only magnitude not direction
	deltaZ = math.abs(zPosition) - math.abs(prevZPos)
	-- Update the position
	prevZPos = zPosition
	return "Z position:\t\t" .. utils.floatToStr(zPosition) .. " u/f"
end

deltaX = 0
deltaZ = 0
prevXPos = 0
prevZPos = 0

function Jak2:horizontalSpeed()

	-- sqrt((x2-x1)^2 + (y2-y1)^2) 
	speed = math.sqrt((deltaX^2) + (deltaZ^2))
  
	return "Horizontal Speed:\t" .. utils.floatToStr(speed) .. " u/f"
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