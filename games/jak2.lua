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
	return "Dark Eco:\t\t" .. utils.floatToStr(eco, {afterDecimal=0}) .. " / 100"
end
-- Orb Count
function Jak2:orbCount()
	local orbs = utils.readFloatLE(0x20622F1C)
	return "Orb Count:\t\t" .. utils.floatToStr(orbs, {afterDecimal=0}) .. " / 286"
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
	
	return "Position:\t\t" .. "(" 
		.. utils.floatToStr(xPosition, {afterDecimal=1}) .. ", " 
		.. utils.floatToStr(yPosition, {afterDecimal=1}) .. ", " 
		.. utils.floatToStr(zPosition, {afterDecimal=1}) .. ") "
end

-- Lateral Speed
function Jak2:lateralSpeed()

	-- sqrt((x2-x1)^2 + (y2-y1)^2) 
	local speed = math.sqrt((deltaX^2) + (deltaZ^2))
	return "Lateral Speed:\t\t" .. utils.floatToStr(speed) .. " u/f"
end

-- Vertical Speed
function Jak2:verticalSpeed()
	return "Vertical Speed:\t\t" .. utils.floatToStr(deltaY) .. " u/f"
end

-- Checkpoint
dofile (RWCEMainDirectory .. '\\jak2_checkpoints.lua')
function Jak2:checkpointAddr()

	local checkpointAddress = 0x20622FA0
	local checkpointValue = utils.readIntLE(checkpointAddress, 4)
	local checkpoint = checkpoints[checkpointValue]
	
	if checkpoint ~= nil then
		return "Checkpoint:\t\t" .. checkpoint
	else
		return "Checkpoint:\t\t" .. "Unknown (" .. utils.intToStr(checkpointValue) .. ")"
	end
end

-- Inventory
-- Ammo Counts
function Jak2:ammoCount()

	local scatterAddress = 0x20622F58
	local blasterAddress = 0x20622F54
	local vulcanAddress = 0x20622F5C
	local peacemakerAddress = 0x20622F60
	
	local scatterAmmo = utils.readFloatLE(scatterAddress)
	local blasterAmmo = utils.readFloatLE(blasterAddress)
	local vulcanAmmo = utils.readFloatLE(vulcanAddress)
	local peacemakerAmmo = utils.readFloatLE(peacemakerAddress)
	
	local ammoUpgraded = utils.readIntLE(0x20622F31, 1) & 0x80 -- 8th bit set?
	
	local scatterFlag = utils.readIntLE(0x20622F30, 1) & 0x80 -- 8th bit set?
	local blasterFlag = utils.readIntLE(0x20622F30, 1) & 0x40 -- 7th bit set?
	local vulcanFlag = utils.readIntLE(0x20622F31, 1) & 0x01 -- 1st bit set?
	local peacemakerFlag = utils.readIntLE(0x20622F31, 1) & 0x02 -- 2nd bit set?
	
	return "\t\t\t\t" .. utils.floatToStr(scatterAmmo, {afterDecimal=0}) .. (ammoUpgraded == 128 and " / 100" or (scatterFlag == 0 and " / 50" or " -- / --")) ..
		"\nAmmo Counts:\t\t" .. utils.floatToStr(vulcanAmmo, {afterDecimal=0}) .. (ammoUpgraded == 128 and " / 200" or (blasterFlag == 0 and " / 100" or " -- / --")) .. 
		"\t\t" .. utils.floatToStr(peacemakerAmmo, {afterDecimal=0}) .. (ammoUpgraded == 128 and " / 10" or (vulcanFlag == 0 and " / 5" or " -- / --")) ..
		"\n\t\t\t\t" .. utils.floatToStr(blasterAmmo, {afterDecimal=0}) .. (ammoUpgraded == 128 and " / 200" or (peacemakerFlag == 0 and " / 100" or " -- / --"))
end

-- Currently selected gun
function Jak2:currentSelectedGun()
	
	local selectedGunAddress = 0x20622F50
	
	local gunIndex = utils.readIntLE(selectedGunAddress, 4)
	
	if gunIndex == 1 then
		return "Current Selected Gun:\tBlaster Rifle"
	elseif gunIndex == 2 then
		return "Current Selected Gun:\tScatter Gun"
	elseif gunIndex == 3 then
		return "Current Selected Gun:\tVulcan Fury"
	elseif gunIndex == 4 then
		return "Current Selected Gun:\tPeacemaker"
	else
		return "Current Selected Gun:\t---"
	end
end

-- Unlocked Abilities
function Jak2:unlockedAbilities()

	local gunFlag = utils.readIntLE(0x20622F30, 1) & 0x20 -- 6th bit set?
	local jetboardFlag = utils.readIntLE(0x20622F31, 1) & 0x04 -- 3rd bit set?
	local jetboardFlagMission = utils.readIntLE(0x20622F33, 1) & 0x04 -- 3rd bit set?
	local darkJakFlag = utils.readIntLE(0x20622F31, 1) & 0x20 -- 6th bit set?
	
	local finalString = "Unlocked Abilities:\t"
	
	local firstEntry = true
	
	if gunFlag ~= 0 then
		if firstEntry == false then 
			finalString = finalString .. "\t\t"
		end
		finalString = finalString .. "Can use Guns\n" 
		firstEntry = false
	end
	if darkJakFlag ~= 0 then
		if firstEntry == false then 
			finalString = finalString .. "\t\t\t"
		end
		finalString = finalString .. "Can use Dark Jak\n" 
		firstEntry = false
	end
	if jetboardFlag ~= 0 then
		if firstEntry == false then 
			finalString = finalString .. "\t\t\t"
		end
		finalString = finalString .. "Can use Jetboard\n" 
		firstEntry = false
	end
	if jetboardFlagMission ~= 0 then
		if firstEntry == false then 
			finalString = finalString .. "\t\t\t"
		end
		finalString = finalString .. "Can use Jetboard on Mission\n" 
		firstEntry = false
	end
	if firstEntry == true then
		finalString = finalString .. "---" end
	
	return finalString
end

-- Unlocked Clearances
function Jak2:unlockedClearance() 
	
	local redFlag = utils.readIntLE(0x20622F32, 1) & 0x04 -- 3rd bit set?
	local greenFlag = utils.readIntLE(0x20622F32, 1) & 0x08 -- 4th bit set?
	local yellowFlag = utils.readIntLE(0x20622F32, 1) & 0x10 -- 5th bit set?
	
	local finalString = "Unlocked Clearances:\t"
	
	if redFlag ~= 0 then
		finalString = finalString .. "Red  " end
	if greenFlag ~= 0 then
		finalString = finalString .. "Green  " end
	if yellowFlag ~= 0 then
		finalString = finalString .. "Yellow  " end
	if redFlag == 0 and greenFlag == 0 and yellowFlag == 0 then
		finalString = finalString .. "---" end
		
	return finalString
end
		
-- Unlocked Upgrades
function Jak2:unlockedUpgrades()

	local scatterROFFlag = utils.readIntLE(0x20622F31, 1) & 0x40 -- 7th bit set?
	local capacityFlag = utils.readIntLE(0x20622F31, 1) & 0x80 -- 8th bit set?
	local damageFlag = utils.readIntLE(0x20622F32, 1) & 0x01 -- 1st bit set?
	
	local finalString = "Unlocked Upgrades:\t"
	
	local firstEntry = true
	
	if scatterROFFlag ~= 0 then
		if firstEntry == false then 
			finalString = finalString .. "\t\t\t"
		end
		finalString = finalString .. "Increased Scatter Gun ROF\n" 
		firstEntry = false
	end
	if capacityFlag ~= 0 then
		if firstEntry == false then 
			finalString = finalString .. "\t\t\t"
		end
		finalString = finalString .. "Weapon Capacity Increased\n" 
		firstEntry = false
	end
	if damageFlag ~= 0 then
		if firstEntry == false then 
			finalString = finalString .. "\t\t\t"
		end
		finalString = finalString .. "Weapon Damage Increased\n" 
		firstEntry = false
	end
	if firstEntry == true then
		finalString = finalString .. "---" end
	
	return finalString
end

-- Dark Jak Upgrades
function Jak2:unlockedDarkJak()

	local bombFlag = utils.readIntLE(0x20622F32, 1) & 0x40 -- 7th bit set?
	local blastFlag = utils.readIntLE(0x20622F32, 1) & 0x80 -- 8th bit set?
	local invulnFlag = utils.readIntLE(0x20622F33, 1) & 0x01 -- 1st bit set?
	local giantFlag = utils.readIntLE(0x20622F33, 1) & 0x02 -- 2nd bit set?
	
	local finalString = "Dark Jak Powers:\t"
	
	local firstEntry = true
	
	if bombFlag ~= 0 then
		if firstEntry == false then 
			finalString = finalString .. "\t\t\t"
		end
		finalString = finalString .. "Dark Bomb\n" 
		firstEntry = false
	end
	if blastFlag ~= 0 then
		if firstEntry == false then 
			finalString = finalString .. "\t\t\t"
		end
		finalString = finalString .. "Dark Blast\n" 
		firstEntry = false
	end
	if invulnFlag ~= 0 then
		if firstEntry == false then 
			finalString = finalString .. "\t\t\t"
		end
		finalString = finalString .. "Dark Invulnerability\n" 
		firstEntry = false
	end
	if giantFlag ~= 0 then
		if firstEntry == false then 
			finalString = finalString .. "\t\t\t"
		end
		finalString = finalString .. "Dark Giant\n" 
		firstEntry = false
	end
	if firstEntry == true then
		finalString = finalString .. "---" end
	
	return finalString
end

-- Objectives
-- Current Score
function Jak2:currentScore()
	
	local currentScoreAddress = 0x20622F68
	local currentScoreValue = utils.readFloatLE(currentScoreAddress)
	
	return "Score:\t\t\t" .. utils.floatToStr(currentScoreValue, {afterDecimal=0})
end

-- Current Objective Count
function Jak2:currentObjectiveCount()

	local currentObjectiveCountAddress = 0x20622F8C
	local countValue = utils.readFloatLE(currentObjectiveCountAddress)
	
	return "Objective Count:\t" .. utils.floatToStr(countValue, {afterDecimal=0})
end

-- Current Mission Timer
function Jak2:currentMissionTimer()

	local currentTimerAddress = 0x20622F78
	local currentTime = utils.readIntLE(currentTimerAddress, 4)
	
	-- 300 units per second
	local currentTime = currentTime / 300.0
	
	return "Objective Timer:\t" .. utils.floatToStr(currentTime, {afterDecimal=2}) .. "s"
end

-- Completed Missions
function Jak2:completedMissions()

	local completedMissionsAddress = 0x20622F10
	local completedMissions = utils.readFloatLE(completedMissionsAddress)

	return "Completed Objectives:\t" .. utils.floatToStr(completedMissions, {afterDecimal=0})
end

-- Boss Information
-- Praxis Bomb Count
function Jak2:praxisTwoBombs()
	
	local praxisBombAddress = 0x201B5858
	local bombCount = utils.readIntLE(praxisBombAddress, 4)
	
	-- praxis 2 reasonable values 0-12
	if bombCount >= 0 and bombCount <= 12 then
		return "Praxis II Bombs:\t" .. bombCount
	else
		return "Praxis II Bombs:\t---"
	end
end

-- Krew HP
function Jak2:krewHealth()
	
	local krewHPAddress = 0x201B442C
	local krewHP = utils.readIntLE(krewHPAddress, 4)
	
	-- krew hp 0-100
	if krewHP >= 0 and krewHP <= 100 then
		return "Krew Health:\t\t" .. krewHP
	else
		return "Krew Health:\t\t---"
	end
end

-- Krew Spawn Tracker
function Jak2:krewSpawns()
	
	local krewSpawnAddress = 0x201B4620
	local krewSpawns = utils.readIntLE(krewSpawnAddress, 4)
	
	-- krew spawns < 100
	if krewSpawns >= 0 and krewSpawns <= 100 then
		return "Krew Spawns:\t\t" .. krewSpawns
	else
		return "Krew Spawns:\t\t---"
	end
end

-- Praxis Bomb Count
function Jak2:korPhaseOneTwo()
	
	local korHPAddress = 0x201B5118
	local korHP = utils.readFloatLE(korHPAddress)
	
	-- kor phase 1 and 2 0->1.0
	if korHP >= 0.0 and korHP <= 1.0 then
		return "Kor Phase 1/2 HP:\t" .. utils.floatToStr(korHP, {afterDecimal=3})
	else
		return "Kor Phase 1/2 HP:\t---"
	end
end

-- Game Information
-- guard Alert
function Jak2:guardAlert()
	
	local guardAddress = 0x217350C1
	local guardAlert = utils.readIntLE(guardAddress, 1)
	
	if guardAlert == 1 then
		return "Guard Alert:\t\tLow Alert"
	elseif guardAlert == 2 then
		return "Guard Alert:\t\tHigh Alert"
	else
		return "Guard Alert:\t\tNo Alert"
	end
end

-- current save
function Jak2:currentSave()
	
	local slotAddress = 0x20128A18
	local progressAddress = 0x205A4F5C
	local slot = utils.readIntLE(slotAddress, 4)
	local progress = utils.readFloatLE(progressAddress)
	
	return "Save Slot " .. slot .. "\t\t" .. utils.floatToStr(progress, {afterDecimal=2}) .. "%"
end

-- total attacks
function Jak2:totalAttacks()

	local attackAddress = 0x20622F94
	local attacks = utils.readIntLE(attackAddress, 4)
	
	return "Total No. of Attacks:\t" .. attacks
end

-- total eco collected
function Jak2:totalEcoCollected()

	local ecoAddress = 0x20622F2C
	local eco = utils.readFloatLE(ecoAddress)
	
	return "Total Eco Collected:\t" .. eco
end

return Jak2