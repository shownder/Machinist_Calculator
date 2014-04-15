local composer = require( "composer" )
local scene = composer.newScene()
local widget = require ( "widget" )
widget.setTheme("widget_theme_ios")
local loadsave = require("loadsave")
local myData = require("myData")
display.setStatusBar(display.HiddenStatusBar)
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

local backEdgeX, backEdgeY

local rightButt
local obliqueButt
local sineButt
local boltButt
local speedButt
local timesOpen

local back

local function sceneSelect ( event )
	local phase = event.phase 

   if "ended" == phase then
   	if event.target.num == 1 then
		composer.gotoScene( "rightAngle", { effect="slideLeft", time=800} )
		elseif event.target.num == 2 then
		composer.gotoScene( "oblique", { effect="slideLeft", time=800} )
		elseif event.target.num == 3 then
		composer.gotoScene( "sineBar", { effect="slideLeft", time=800} )
		elseif event.target.num == 4 then
		composer.gotoScene( "speedFeed", { effect="slideLeft", time=800} )
		elseif event.target.num == 5 then
		composer.gotoScene( "bolt", { effect="slideLeft", time=800} )
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

---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )

   local screenGroup = self.view

  timesOpen = loadsave.loadTable("timesOpen.json")
  
  if timesOpen.opened == 5 then
    native.showAlert ( "Rate Us? We appreciate your feedback!", "Help Us Improve by leaving a review.", { "Never", "Later", "OK" }, alertListener )
  end
    
  print("Times Opened "..timesOpen.opened)
  	
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

-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
   elseif ( phase == "did" ) then
    local sceneName = composer.getSceneName( "previous" )
			
			if sceneName ~= nil then
				composer.removeScene( sceneName, true )
			end
      
      myData.number = nil
   end
end

-- "scene:hide()"
function scene:hide( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
    Runtime:removeEventListener( "key", onKeyEvent )
    
   elseif ( phase == "did" ) then
      
   end
end

-- "scene:destroy()"
function scene:destroy( event )

   local sceneGroup = self.view

   -- Called prior to the removal of scene's view ("sceneGroup").
   -- Insert code here to clean up the scene.
   -- Example: remove display objects, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene