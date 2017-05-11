package.loaded.utils = nil
local utils = require 'utils'
local subclass = utils.subclass

package.loaded.layouts = nil
local layoutsModule = require 'layouts'
local Layout = layoutsModule.Layout

local margin = 6
local fontSize = 10
local fontSizeHeader = 12
local contentFontName = "Consolas"
local headerFontName = "Arial"
local headerFontColor = 0x000000

local layouts = {}

layouts.Jak2Layout = subclass(Layout)
function layouts.Jak2Layout:init()

	self.margin = margin
	self:setUpdatesPerSecond(5)
	self.window:setSize(400, 800)

	self:addLabel{fontSize=fontSizeHeader, fontName=headerFontName, fontColor=headerFontColor}
	self:addItem("Jak Status")
	
	self:addLabel{fontSize=fontSizeHeader, fontName=headerFontName, fontColor=headerFontColor}
	self:addItem("Position and Movement")
	
	self:addLabel{fontSize=fontSizeHeader, fontName=headerFontName, fontColor=headerFontColor}
	self:addItem("Game Info")
	
	self:addLabel{fontSize=fontSizeHeader, fontName=headerFontName, fontColor=headerFontColor}
	self:addItem("Inventory")
	
	self:addLabel{fontSize=fontSizeHeader, fontName=headerFontName, fontColor=headerFontColor}
	self:addItem("Objectives")
	
	self:addLabel{fontSize=fontSizeHeader, fontName=headerFontName, fontColor=headerFontColor}
	self:addItem("Boss Information")
	
	self:addLabel{fontSize=fontSizeHeader, fontName=headerFontName, fontColor=headerFontColor}
	self:addItem("Secrets")

	self:addLabel{fontSize=fontSize, fontName=contentFontName}
	self:addItem(self.game.xPositionDisplay)
	self:addItem(self.game.zPositionDisplay)
	self:addItem(self.game.horizontalSpeed)
	self:addItem(self.game.checkpointAddr)

	self:activateAutoPositioningY()
end

return {
	layouts = layouts,
}