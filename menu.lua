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

local rightButt, rightlabel
local obliqueButt, obliqueLabel
local sineButt, sineLabel
local boltButt, boltLabel
local speedButt, speedLabel
local counterButt, counterLabel
local chartButt, chartLabel
local timesOpen
local back
local logo, facebookButt
local topBar, botBar, menuScroll
local scrollComplete

local function sceneSelect ( event )
	local phase = event.phase 

   if "ended" == phase then
   	if event.target.num == 1 then
		composer.gotoScene( "rightAngle", { effect="fromTop", time=800} )
		elseif event.target.num == 2 then
		composer.gotoScene( "oblique", { effect="fromTop", time=800} )
		elseif event.target.num == 3 then
		composer.gotoScene( "sineBar", { effect="fromTop", time=800} )
		elseif event.target.num == 4 then
		composer.gotoScene( "speedFeed", { effect="fromTop", time=800} )
		elseif event.target.num == 5 then
		composer.gotoScene( "bolt", { effect="fromTop", time=800} )
    elseif event.target.num == 6 then
		composer.gotoScene( "counter", { effect="fromTop", time=800} )
    elseif event.target.num == 7 then
		composer.gotoScene( "charts", { effect="fromTop", time=800, params = {isOverlay = false},} )
   	end
   end
end

local function goToFacebook ( event )
	local phase = event.phase 

    if (not system.openURL("fb://profile/187552938002070")) then
      system.openURL("http://www.facebook.com/pages/Machinists-Calculator/187552938002070")
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

local function moveItems()
  
  transition.to(rightButt, {y=back.contentHeight - 50, time=500})
  transition.to(obliqueButt, {y=back.contentHeight - 50, time=600})
  transition.to(sineButt, {y=back.contentHeight - 50, time=700})
  transition.to(speedButt, {y=back.contentHeight - 50, time=800})
  transition.to(boltButt, {y=back.contentHeight - 50, time=900})
  transition.to(counterButt, {y=back.contentHeight - 50, time=1000})
  transition.to(chartButt, {y=back.contentHeight - 50, time=1100})
  
  transition.fadeIn(rightLabel, {time=500})
  transition.fadeIn(obliqueLabel, {time=600})
  transition.fadeIn(sineLabel, {time=700})
  transition.fadeIn(speedLabel, {time=800})
  transition.fadeIn(boltLabel, {time=900})
  transition.fadeIn(counterLabel, {time=1000})
  transition.fadeIn(chartLabel, {time=1100})
  
  --menuScroll:scrollToPosition( {x=-110, time=1900, onComplete = scrollComplete})  
  
end

local function moveItems2()
  
  transition.to(rightButt, {y=back.contentHeight - 50})
  transition.to(obliqueButt, {y=back.contentHeight - 50})
  transition.to(sineButt, {y=back.contentHeight - 50})
  transition.to(speedButt, {y=back.contentHeight - 50})
  transition.to(boltButt, {y=back.contentHeight - 50})
  transition.to(counterButt, {y=back.contentHeight - 50})
  transition.to(chartButt, {y=back.contentHeight - 50})
  
  rightLabel.alpha = 1
  obliqueLabel.alpha = 1
  sineLabel.alpha = 1
  speedLabel.alpha = 1
  boltLabel.alpha = 1
  counterLabel.alpha = 1
  chartLabel.alpha = 1
  
end

scrollComplete = function()
  
  menuScroll:scrollToPosition( {x=0, time=1000})  

end
---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )

  local sceneGroup = self.view
   
  timesOpen = loadsave.loadTable("timesOpen.json")
  
  if timesOpen.opened == 5 then
    native.showAlert ( "Rate Us? We appreciate your feedback!", "Help Us Improve by leaving a review.", { "Never", "Later", "OK" }, alertListener )
  end
    
  print("Times Opened "..timesOpen.opened)
  
  back = display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
  
  backEdgeX = back.contentBounds.xMin
	backEdgeY = back.contentBounds.yMin
  
  Runtime:addEventListener( "key", onKeyEvent )
  
  logo = display.newImageRect(sceneGroup, "Images/title.png", 175, 100)
  logo:rotate(-90)
  logo.x = backEdgeX + 95
  logo.y = back.contentHeight - 111
  
  topBar = display.newRect( sceneGroup, 0, display.contentCenterY, 30, display.contentHeight )
  topBar:setFillColor(0.15, 0.4, 0.729, 0.75)
  topBar.anchorX = 0
  topBar.anchorY = 0.5
  
  facebookButt = display.newImageRect(sceneGroup, "Images/facebook.png", 56, 56)
  facebookButt:rotate(-90)
  facebookButt.x = backEdgeX + 75
  facebookButt.y = backEdgeY + 50
  facebookButt:addEventListener ( "touch", goToFacebook )
  
  rightButt = widget.newButton
	{
		width = 56,
    height = 56,
    left = 0,
		top = 0,
		id = "rightAngle",
    defaultFile = "Images/rightMenu.png",
		onRelease = sceneSelect,		
		}
	rightButt.num = 1
	sceneGroup:insert(rightButt)
	--rightButt.x = backEdgeX + 190
  rightButt.x = 50
  rightButt.y = display.contentHeight + 100
  rightButt:rotate(-90)
  rightButt.alpha = 0.75
  
  rightLabel = display.newText( { parent = sceneGroup, text = "Right Angle", 0, 0, font = "BerlinSansFB-Reg", fontSize = 20, width = 100})
  rightLabel:rotate(-90)
  --rightLabel.x = backEdgeX + 190
  rightLabel.x = 50
  rightLabel.y = back.contentHeight - 140
  rightLabel:setFillColor(0.15, 0.4, 0.729, 0.90)
  rightLabel.num = 1
  rightLabel:addEventListener ( "touch", sceneSelect )
  rightLabel.alpha = 0
  
  obliqueButt = widget.newButton
	{
		width = 56,
    height = 56,
    left = 0,
		top = 0,
		id = "obliqueButt",
    defaultFile = "Images/obliqueMenu.png",
		onRelease = sceneSelect,		
		}
	obliqueButt.num = 2
	sceneGroup:insert(obliqueButt)
	--obliqueButt.x = backEdgeX + 260
  obliqueButt.x = 120
	obliqueButt.y = display.contentHeight + 100
  obliqueButt:rotate(-90)
  obliqueButt.alpha = 0.75
  
  obliqueLabel = display.newText( { parent = sceneGroup, text = "Oblique Triangle", 0, 0, font = "BerlinSansFB-Reg", fontSize = 20, width = 100})
  obliqueLabel:rotate(-90)
  --obliqueLabel.x = backEdgeX + 260
  obliqueLabel.x = 120
  obliqueLabel.y = back.contentHeight - 140
  obliqueLabel:setFillColor(0.15, 0.4, 0.729, 0.90)
  obliqueLabel.num = 2
  obliqueLabel:addEventListener ( "touch", sceneSelect )
  obliqueLabel.alpha = 0
  
  sineButt = widget.newButton
	{
		width = 56,
    height = 56,
    left = 0,
		top = 0,
		id = "sineButt",
    defaultFile = "Images/sineMenu.png",
		onRelease = sceneSelect,		
		}
	sineButt.num = 3
	sceneGroup:insert(sineButt)
	--sineButt.x = backEdgeX + 330
  sineButt.x = 190
	sineButt.y = display.contentHeight + 100
  sineButt:rotate(-90)
  sineButt.alpha = 0.75
  
  sineLabel = display.newText( { parent = sceneGroup, text = "Sine Bar", 0, 0, font = "BerlinSansFB-Reg", fontSize = 20, width = 100})
  sineLabel:rotate(-90)
  --sineLabel.x = backEdgeX + 330
  sineLabel.x = 190
  sineLabel.y = back.contentHeight - 140
  sineLabel:setFillColor(0.15, 0.4, 0.729, 0.90)
  sineLabel.num = 3
  sineLabel:addEventListener ( "touch", sceneSelect )
  sineLabel.alpha = 0
  
  speedButt = widget.newButton
	{
		width = 56,
    height = 56,
    left = 0,
		top = 0,
		id = "speedButt",
    defaultFile = "Images/speedMenu.png",
		onRelease = sceneSelect,		
		}
	speedButt.num = 4
	sceneGroup:insert(speedButt)
	--speedButt.x = backEdgeX + 400
  speedButt.x = 260
	speedButt.y = display.contentHeight + 100
  speedButt:rotate(-90)
  speedButt.alpha = 0.75
  
  speedLabel = display.newText( { parent = sceneGroup, text = "Speeds & Feeds", 0, 0, font = "BerlinSansFB-Reg", fontSize = 20, width = 100})
  speedLabel:rotate(-90)
  --speedLabel.x = backEdgeX + 400
  speedLabel.x = 260
  speedLabel.y = back.contentHeight - 140
  speedLabel:setFillColor(0.15, 0.4, 0.729, 0.90)
  speedLabel.num = 4
  speedLabel:addEventListener ( "touch", sceneSelect )
  speedLabel.alpha = 0
  
  boltButt = widget.newButton
	{
		width = 56,
    height = 56,
    left = 0,
		top = 0,
		id = "boltButt",
    defaultFile = "Images/boltMenu.png",
		onRelease = sceneSelect,		
		}
	boltButt.num = 5
	sceneGroup:insert(boltButt)
	--boltButt.x = backEdgeX + 470
  boltButt.x = 330
	boltButt.y = display.contentHeight + 100
  boltButt:rotate(-90)
  boltButt.alpha = 0.75
  
  boltLabel = display.newText( { parent = sceneGroup, text = "Bolt Circle", 0, 0, font = "BerlinSansFB-Reg", fontSize = 20, width = 100})
  boltLabel:rotate(-90)
  --boltLabel.x = backEdgeX + 470
  boltLabel.x = 330
  boltLabel.y = back.contentHeight - 140
  boltLabel:setFillColor(0.15, 0.4, 0.729, 0.90)
  boltLabel.num = 5
  boltLabel:addEventListener ( "touch", sceneSelect )
  boltLabel.alpha = 0
  
  counterButt = widget.newButton
	{
		width = 56,
    height = 56,
    left = 0,
		top = 0,
		id = "boltButt",
    defaultFile = "Images/counterButt.png",
		onRelease = sceneSelect,		
		}
	counterButt.num = 6
	sceneGroup:insert(counterButt)
	--counterButt.x = backEdgeX + 470
  counterButt.x = 400
	counterButt.y = display.contentHeight + 100
  counterButt:rotate(-90)
  counterButt.alpha = 0.75
  
  counterLabel = display.newText( { parent = sceneGroup, text = "C'Sink & Drill Point", 0, 0, font = "BerlinSansFB-Reg", fontSize = 20, width = 100})
  counterLabel:rotate(-90)
  --counterLabel.x = backEdgeX + 470
  counterLabel.x = 400
  counterLabel.y = back.contentHeight - 140
  counterLabel:setFillColor(0.15, 0.4, 0.729, 0.90)
  counterLabel.num = 6
  counterLabel:addEventListener ( "touch", sceneSelect )
  counterLabel.alpha = 0
  
  chartButt = widget.newButton
	{
		width = 56,
    height = 56,
    left = 0,
		top = 0,
		id = "boltButt",
    defaultFile = "Images/chartMenu.png",
		onRelease = sceneSelect,		
		}
	chartButt.num = 7
	sceneGroup:insert(chartButt)
	--counterButt.x = backEdgeX + 470
  chartButt.x = 470
	chartButt.y = display.contentHeight + 100
  chartButt:rotate(-90)
  chartButt.alpha = 0.75
  
  chartLabel = display.newText( { parent = sceneGroup, text = "Drill Charts", 0, 0, font = "BerlinSansFB-Reg", fontSize = 20, width = 100})
  chartLabel:rotate(-90)
  --counterLabel.x = backEdgeX + 470
  chartLabel.x = 470
  chartLabel.y = back.contentHeight - 140
  chartLabel:setFillColor(0.15, 0.4, 0.729, 0.90)
  chartLabel.num = 7
  chartLabel:addEventListener ( "touch", sceneSelect )
  chartLabel.alpha = 0
  
  
  menuScroll = widget.newScrollView
  {
    left = 150,
    top = 0,
    width = back.contentWidth - 150,
    height = back.contentHeight,
    scrollWidth = 1000,
    scrollHeight = 500,
    verticalScrollDisabled = true,
    hideBackground = true,
    --isBounceEnabled = false,
    rightPadding = 50,
  }
  sceneGroup:insert(menuScroll)
  
  menuScroll:insert(rightButt)
  menuScroll:insert(obliqueButt)
  menuScroll:insert(sineButt)
  menuScroll:insert(speedButt)
  menuScroll:insert(boltButt)
  menuScroll:insert(counterButt)
  menuScroll:insert(chartButt)
  
  menuScroll:insert(rightLabel)
  menuScroll:insert(obliqueLabel)
  menuScroll:insert(sineLabel)
  menuScroll:insert(speedLabel)
  menuScroll:insert(boltLabel)
  menuScroll:insert(counterLabel)
  menuScroll:insert(chartLabel)
  
  moveItems2()

--  if not composer.getSceneName( "previous" ) then
--    timer.performWithDelay(1000, moveItems)
--  else
--    moveItems2()
--  end
  
    

   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
     print(display.contentWidth)  
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
      -- Called immediately after scene goes off screen.
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