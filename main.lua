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
local analytics = require( "analytics" )

if ( system.getInfo( "platformName" ) == "Android" ) then

analytics.init( "FRSV5MBZK5MNNRY92PVP" )

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

if device.isApple then
  analytics.init( "C52V5WBYR3QV8Q8XXKZZ" )
end

local timesOpen3 = loadsave.loadTable("timesOpen3.json")
local menuOpened = loadsave.loadTable("menuOpen.json")
--timesOpen3.opened = 4

if (menuOpened == nil) then
    menuOpened = {}
    menuOpened.opened = false
    loadsave.saveTable(menuOpened, "menuOpen.json")
end
  
  if (timesOpen3 == nil) then
    timesOpen3 = {}
    timesOpen3.opened = 0
    loadsave.saveTable(timesOpen3, "timesOpen3.json")
  elseif timesOpen3.opened ~= "never" then
    --timesOpen3.opened = 0
    if timesOpen3.opened < 7 then
      timesOpen3.opened = timesOpen3.opened + 1
      loadsave.saveTable(timesOpen3, "timesOpen3.json")
    end
  end
 
print(system.getInfo("model") .. " " .. system.getInfo("platformVersion"))
if device.isApple or device.isSimulator then
  composer.gotoScene( "menu")
end





