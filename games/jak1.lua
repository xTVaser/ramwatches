local utils = require 'utils'
local subclass = utils.subclass

package.loaded.game = nil
local gameModule = require 'game'

package.loaded.valuetypes = nil
local valuetypes = require 'valuetypes'

local Jak1 = subclass(gameModule.Game)

Jak1.layoutModuleNames = {'jak1_layout'}
Jak1.framerate = 60

function Jak1:init(options)
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
function Jak1:getState()
	
	-- read in one byte and bitwise AND with 0000 0010, if the result is not 0, the flag is set
	local attackFlag = utils.readIntLE(0x2017A3B4, 1) & 2
	-- separated goggle flag, you could keep it as 4 bytes and AND with 512 instead though
	local goggleFlag = utils.readIntLE(0x2017A3B5, 1) & 2
	
	local finalOutput = "State:\n"
	
	-- ~= is not equal in Lua
	-- .. is combine strings
	if attackFlag ~= 0 then
		finalOutput = finalOutput .. "Attacking"
	end
	if goggleFlag ~= 0 then
		finalOutput = finalOutput .. "Goggles On"
	end
	
	return finalOutput
end
		
return Jak1