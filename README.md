# RAMwatch Display
Displays for ramwatch CheatEngine plugin https://github.com/yoshifan/ram-watch-cheat-engine

# Installation
Requires Cheat Engine 6.6 for Lua 5.3 features.  
Clone the repository and point the Cheat Table lua script to the directory.
In cheat engine go to Table > Show Cheat Table Lua Script  
```lua
RWCEMainDirectory = [[E:\Emulator\ramwatches]]

RWCEOptions = {
  gameModuleName = 'jak2',
  gameVersion = 'na_0_00',
  layoutName = 'Jak2Layout',
  windowPosition = {0, 0},
}

local loaderFile, errorMessage = loadfile(RWCEMainDirectory .. '/loader.lua')
if errorMessage then error(errorMessage) end
loaderFile()
```
Also rename to the respective layout and game module name.

# Screenshot
Jak 2 RAMwatch
![alt text](http://i.imgur.com/AZTq9UA.png "Jak 2 Display")
