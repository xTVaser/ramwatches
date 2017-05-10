package.loaded.utils = nil
local utils = require 'utils'
local subclass = utils.subclass

package.loaded.layouts = nil
local layoutsModule = require 'layouts'
local Layout = layoutsModule.Layout

local margin = 6
local fontSize = 12
local fixedWidthFontName = "Consolas"

local layouts = {}


layouts.Jak2Layout = subclass(Layout)
function layouts.Jak2Layout:init()

self.margin = margin
  self:setUpdatesPerSecond(5)
  self.window:setSize(400, 300)

  

  self:addLabel{fontSize=fontSize, fontName=fixedWidthFontName}
  self:addItem(self.game.xPositionDisplay)
  self:addItem(self.game.zPositionDisplay)
  self:addItem(self.game.horizontalSpeed)
  self:addItem(self.game.checkpointAddr)
  
	self:activateAutoPositioningY()
end


return {
  layouts = layouts,
}