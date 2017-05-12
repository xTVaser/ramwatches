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

layouts.Jak1Layout = subclass(Layout)
function layouts.Jak1Layout:init()

	self.margin = margin
	self:setUpdatesPerSecond(5)
	self.window:setSize(425, 800) -- Change window size here if not big/too big
	self.window.setColor(0x160819)

	self:addLabel{fontSize=fontSizeHeader, fontName=headerFontName, fontColor=headerFontColor}
	self:addItem("Jak Status")
	self:addLabel{fontSize=fontSize, fontName=contentFontName, fontColor=textColor}
	self:addItem(self.game.getState) -- call the function in the jak1.lua

	-- Will automatically vertically space things
	self:activateAutoPositioningY()
end

return {
	layouts = layouts,
}