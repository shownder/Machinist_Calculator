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
local storyboard = require( "storyboard" )
local loadsave = require("loadsave")
local licensing = require( "licensing" )
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
      native.showAlert ( "Not Authorized", "The app was not purchased from Google Play.", { "Close" }, alertListener)
   end
end

licensing.verify( licensingListener )

local timesOpen = loadsave.loadTable("timesOpen.json")
--timesOpen.opened = 0
  
  if (loadsave.loadTable("timesOpen.json") == nil) then
    timesOpen = {}
    timesOpen.opened = 0
    loadsave.saveTable(timesOpen, "timesOpen.json")
  elseif timesOpen.opened ~= "never" then
    --timesOpen.opened = 0
    if timesOpen.opened < 7 then
      timesOpen.opened = timesOpen.opened + 1
      loadsave.saveTable(timesOpen, "timesOpen.json")
    end
  end
 

storyboard.gotoScene( "menu", "fade", 800 )




