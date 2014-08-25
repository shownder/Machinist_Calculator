-- Project: Trades Math Calculator
-- Description: Mobile version of Harry Powell's Trades Math Calculator
-- Developed By: Stephen Powell
-- Corona Version: 1.0
-- Managed with http://OutlawGameTools.com
--
-- Copyright 2013 . All Rights Reserved.
---- cpmgen main.lua

-- cpmgen main.lua
local physicalW = math.round( (display.contentWidth  - display.screenOriginX*2) / display.contentScaleX)
local physicalH = math.round( (display.contentHeight - display.screenOriginY*2) / display.contentScaleY)

--Require
local loadsave = require("loadsave")
local device = require("device")
local licensing = require( "licensing" )
local composer = require( "composer" )

if not device.isApple then

licensing.init( "google" )

local function alertListener ( event )
  if "clicked" == event.action then

    local i = event.index    
    if i == 1 then
      native.requestExit()
    end        
  end
end

local function licensingListener( event )

   local verified = event.isVerified
   if not event.isVerified then
      --failed verify app from the play store, we print a message
      native.showAlert ( "Could Not Authorize", "There was a problem contacting the Google licensing servers. Please check internet connection and try again.", { "Close" }, alertListener)
    else
      composer.gotoScene( "menu")
   end
end

licensing.verify( licensingListener )
end

local timesOpen2 = loadsave.loadTable("timesOpen2.json")
local menuOpened = loadsave.loadTable("menuOpen.json")
--timesOpen2.opened = 4

if (menuOpened == nil) then
    menuOpened = {}
    menuOpened.opened = false
    loadsave.saveTable(menuOpened, "menuOpen.json")
end
  
  if (timesOpen2 == nil) then
    timesOpen2 = {}
    timesOpen2.opened = 0
    loadsave.saveTable(timesOpen2, "timesOpen2.json")
  elseif timesOpen2.opened ~= "never" then
    --timesOpen2.opened = 0
    if timesOpen2.opened < 7 then
      timesOpen2.opened = timesOpen2.opened + 1
      loadsave.saveTable(timesOpen2, "timesOpen2.json")
    end
  end
 
print(system.getInfo("model") .. " " .. system.getInfo("platformVersion"))
if device.isApple then
  composer.gotoScene( "menu")
end





