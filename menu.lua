--
-- Project: main.lua
-- Description: 
--
-- Version: 1.0
-- Managed with http://CoronaProjectManager.com
--
-- Copyright 2013 . All Rights Reserved.
-- 

--Require

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local widget = require ( "widget" )
widget.setTheme("widget_theme_ios")
local loadsave = require("loadsave")


display.setStatusBar(display.HiddenStatusBar)

--Local forward references

local backEdgeX, backEdgeY

local rightButt
local obliqueButt
local sineButt
local boltButt
local speedButt
local timesOpen

local back


--Listeners

local function sceneSelect ( event )
	local phase = event.phase 

   if "ended" == phase then
   	if event.target.num == 1 then
		storyboard.gotoScene( "rightAngle", { effect="slideLeft", time=800} )
		elseif event.target.num == 2 then
		storyboard.gotoScene( "oblique", { effect="slideLeft", time=800} )
		elseif event.target.num == 3 then
		storyboard.gotoScene( "sineBar", { effect="slideLeft", time=800} )
		elseif event.target.num == 4 then
		storyboard.gotoScene( "speedFeed", { effect="slideLeft", time=800} )
		elseif event.target.num == 5 then
		storyboard.gotoScene( "bolt", { effect="slideLeft", time=800} )
   	end
   end
end

local function onKeyEvent( event )

   local phase = event.phase
   local keyName = event.keyName
   print( event.phase, event.keyName )

   if ( "back" == keyName and phase == "up" ) then
      native.requestExit()
   end
   return true
end

local function alertListener ( event )
	if "clicked" == event.action then

		local i = event.index
    
    if i == 3 then
      local options =
      {
        iOSAppId = "687225532",
        nookAppEAN = "0987654321",
        supportedAndroidStores = { "google", "samsung", "amazon", "nook" },
      }
      native.showPopup("rateApp", options)
    elseif i == 2 then
      timesOpen.opened = -4
      loadsave.saveTable(timesOpen, "timesOpen.json")
    elseif i == 1 then
      timesOpen.opened = "never"
      loadsave.saveTable(timesOpen, "timesOpen.json")
    end
        
	end
end


--Called when the scene view doesn't exist

function scene:createScene( event )
	local screenGroup = self.view

  timesOpen = loadsave.loadTable("timesOpen.json")
  
  if timesOpen.opened == 5 then
    native.showAlert ( "Rate Us? We appreciate your feedback!", "Help Us Improve by leaving a review.", { "Never", "Later", "OK" }, alertListener )
  end
    
  print("Times Opened "..timesOpen.opened)
  print("this is a \n new line")
  	
	back = display.newImageRect ( screenGroup, "backgrounds/menuBack.png",  570, 360 )
	back.x = display.contentCenterX
	back.y = display.contentCenterY		
	backEdgeX = back.contentBounds.xMin
	backEdgeY = back.contentBounds.yMin
  
  Runtime:addEventListener( "key", onKeyEvent )
		
	--Create Button Widgets
  
  rightButt = widget.newButton
	{
		left = 0,
		top = 0,
		width = 180,
		height = 50,
    --font = "BadBlocksTT",
    fontSize = 16,
		id = "rightAngle",
		label = "RIGHT ANGLE",
		onRelease = sceneSelect,		
		}
	rightButt.num = 1
	screenGroup:insert(rightButt)
	rightButt.x = backEdgeX + 430
	rightButt.y = backEdgeY + 60
	
	obliqueButt = widget.newButton
	{
		left = 0,
		top = 0,
		width = 180,
		height = 50,
    --font = "BadBlocksTT",
    fontSize = 16,
		id = "obliqueButt",
		label = "OBLIQUE TRIANGLE",
		onRelease = sceneSelect,		
		}
	obliqueButt.num = 2
	screenGroup:insert(obliqueButt)
	obliqueButt.x = backEdgeX + 430
	obliqueButt.y = backEdgeY + 120
	
	 sineButt = widget.newButton
	{
		left = 0,
		top = 0,
		width = 180,
		height = 50,
    --font = "BadBlocksTT",
    fontSize = 16,
		id = "sineButt",
		label = "SINE BAR",
		onRelease = sceneSelect,		
		}
	sineButt.num = 3
	screenGroup:insert(sineButt)
	sineButt.x = backEdgeX + 430
	sineButt.y = backEdgeY + 180
	
	speedButt = widget.newButton
	{
		left = 0,
		top = 0,
		width = 180,
		height = 50,
    --font = "BadBlocksTT",
    fontSize = 16,
		id = "speedButt",
		label = "SPEEDS & FEEDS",
		onRelease = sceneSelect,		
		}
	speedButt.num = 4
	screenGroup:insert(speedButt)
	speedButt.x = backEdgeX + 430
	speedButt.y = backEdgeY + 240
	
	boltButt = widget.newButton
	{
		left = 0,
		top = 0,
		width = 180,
		height = 50,
    --font = "BadBlocksTT",
    fontSize = 16,
		id = "boltButt",
		label = "BOLT CIRCLE",
		onRelease = sceneSelect,		
		}
	boltButt.num = 5
	screenGroup:insert(boltButt)
	boltButt.x = backEdgeX + 430
	boltButt.y = backEdgeY + 300
		

end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
  local group = self.view
        
    local sceneName = storyboard.getPrevious()
			
			if sceneName ~= nil then
				storyboard.purgeScene( sceneName )
			end
      
      storyboard.number = nil

end

function scene:exitScene( event )
   local group = self.view
   
   Runtime:removeEventListener( "key", onKeyEvent )
	
end

function scene:destroyScene( event )
   local group = self.view
   
   --Runtime:removeEventListener( "key", onKeyEvent )

end

--[[
----------------------------------------------------------------
-- CALLED PRIOR TO THE REMOVAL OF SCENE'S "VIEW" (DISPLAY GROUP)
----------------------------------------------------------------
function Scene:destroyScene( event )
		
	-- REMOVE ALL WIDGETS HERE
	_G.GUI.GetHandle("rightAngleButt"):destroy()
	
end
--]]
scene:addEventListener( "createScene", scene )

scene:addEventListener( "enterScene", scene )

scene:addEventListener( "exitScene", scene )

scene:addEventListener( "destroyScene", scene )


return scene


