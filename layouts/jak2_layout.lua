package.loaded.utils = nil
local utils = require 'utils'
local subclass = utils.subclass

package.loaded.layouts = nil
local layoutsModule = require 'layouts'
local Layout = layoutsModule.Layout

local margin = 15
local fontSize = 10
local fontSizeHeader = 12
local contentFontName = "Consolas"
local headerFontName = "Arial Black"
local headerFontColor = 0x000000

local layouts = {}

layouts.Jak2Layout = subclass(Layout)
function layouts.Jak2Layout:init()

	self.margin = margin
	self:setUpdatesPerSecond(5)
	self.window:setSize(400, 800)
	self.window.setColor(0xFF00DD)

	self:addLabel{fontSize=fontSizeHeader, fontName=headerFontName, fontColor=headerFontColor}
	self:addItem("Jak Status")
	self:addLabel{fontSize=fontSize, fontName=contentFontName}
	self:addItem(self.game.jakHealth)
	self:addItem(self.game.ecoCount)
	self:addItem(self.game.orbCount)
	self:addItem(self.game.gemCount)
	
	self:addLabel{fontSize=fontSizeHeader, fontName=headerFontName, fontColor=headerFontColor}
	self:addItem("Position and Movement")
	self:addLabel{fontSize=fontSize, fontName=contentFontName}
	self:addItem(self.game.coordinates)
	self:addItem(self.game.lateralSpeed)
	self:addItem(self.game.verticalSpeed)
	self:addItem(self.game.checkpointAddr)
	
	self:addLabel{fontSize=fontSizeHeader, fontName=headerFontName, fontColor=headerFontColor}
	self:addItem("Inventory")
	self:addLabel{fontSize=fontSize, fontName=contentFontName}
	self:addItem(self.game.ammoCount)
	self:addItem(self.game.currentSelectedGun)
	self:addItem(self.game.unlockedAbilities)
	self:addItem(self.game.unlockedClearance)
	self:addItem(self.game.unlockedUpgrades)
	self:addItem(self.game.unlockedDarkJak)
	
	self:addLabel{fontSize=fontSizeHeader, fontName=headerFontName, fontColor=headerFontColor}
	self:addItem("Game Info")
	
	
	
	self:addLabel{fontSize=fontSizeHeader, fontName=headerFontName, fontColor=headerFontColor}
	self:addItem("Objectives")
	
	self:addLabel{fontSize=fontSizeHeader, fontName=headerFontName, fontColor=headerFontColor}
	self:addItem("Boss Information")
	
	self:addLabel{fontSize=fontSizeHeader, fontName=headerFontName, fontColor=headerFontColor}
	self:addItem("Secrets")

	self:addLabel{fontSize=fontSize, fontName=contentFontName}
	

	self:activateAutoPositioningY()
end

return {
	layouts = layouts,
}