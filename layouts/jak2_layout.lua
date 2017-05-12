package.loaded.utils = nil
local utils = require 'utils'
local subclass = utils.subclass

package.loaded.layouts = nil
local layoutsModule = require 'layouts'
local Layout = layoutsModule.Layout

local margin = 15
local fontSize = 9
local fontSizeHeader = 12
local contentFontName = "Lucida Console"
local headerFontName = "Arial Black"
local headerFontColor = 0xFFFFFF
local textColor = 0xddf7ff

local layouts = {}

layouts.Jak2Layout = subclass(Layout)
function layouts.Jak2Layout:init()

	self.margin = margin
	self:setUpdatesPerSecond(5)
	self.window:setSize(425, 800)
	self.window.setColor(0x160819)

	self:addLabel{fontSize=fontSizeHeader, fontName=headerFontName, fontColor=headerFontColor}
	self:addItem("Jak Status")
	self:addLabel{fontSize=fontSize, fontName=contentFontName, fontColor=textColor}
	self:addItem(self.game.jakHealth)
	self:addItem(self.game.ecoCount)
	self:addItem(self.game.orbCount)
	self:addItem(self.game.gemCount)
	
	self:addLabel{fontSize=fontSizeHeader, fontName=headerFontName, fontColor=headerFontColor}
	self:addItem("Position and Movement")
	self:addLabel{fontSize=fontSize, fontName=contentFontName, fontColor=textColor}
	self:addItem(self.game.coordinates)
	self:addItem(self.game.lateralSpeed)
	self:addItem(self.game.verticalSpeed)
	self:addItem(self.game.checkpointAddr)
	
	self:addLabel{fontSize=fontSizeHeader, fontName=headerFontName, fontColor=headerFontColor}
	self:addItem("Inventory")
	self:addLabel{fontSize=fontSize, fontName=contentFontName, fontColor=textColor}
	self:addItem(self.game.ammoCount)
	self:addItem(self.game.currentSelectedGun)
	self:addItem(self.game.unlockedAbilities)
	self:addItem(self.game.unlockedClearance)
	self:addItem(self.game.unlockedUpgrades)
	self:addItem(self.game.unlockedDarkJak)
	
	self:addLabel{fontSize=fontSizeHeader, fontName=headerFontName, fontColor=headerFontColor}
	self:addItem("Objectives")
	self:addLabel{fontSize=fontSize, fontName=contentFontName, fontColor=textColor}
	self:addItem(self.game.currentScore)
	self:addItem(self.game.currentObjectiveCount)
	self:addItem(self.game.currentMissionTimer)
	self:addItem(self.game.completedMissions)
	
	self:addLabel{fontSize=fontSizeHeader, fontName=headerFontName, fontColor=headerFontColor}
	self:addItem("Boss Information")
	self:addLabel{fontSize=fontSize, fontName=contentFontName, fontColor=textColor}
	self:addItem(self.game.praxisTwoBombs)
	self:addItem(self.game.krewHealth)
	self:addItem(self.game.krewSpawns)
	self:addItem(self.game.korPhaseOneTwo)
	
	self:addLabel{fontSize=fontSizeHeader, fontName=headerFontName, fontColor=headerFontColor}
	self:addItem("Game Info")
	self:addLabel{fontSize=fontSize, fontName=contentFontName, fontColor=textColor}
	self:addItem(self.game.guardAlert)
	self:addItem(self.game.currentSave)
	self:addItem(self.game.totalAttacks)
	self:addItem(self.game.totalEcoCollected)

	self:activateAutoPositioningY()
end

return {
	layouts = layouts,
}