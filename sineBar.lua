local composer = require( "composer" )
local scene = composer.newScene()
local widget = require ( "widget" )
local stepperDataFile = require("Images.stepSheet_stepSheet")
display.setStatusBar(display.HiddenStatusBar)
local myData = require("myData")

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

local optionsGroup, backGroup
local back, menuBack, backEdgeX, backEdgeY, rightDisplay

local sineText
local decStep, menu, reset, measure
local places, decLabel, decPlaces, measureLabel

local sineSize, sineSizeTap, stackSize, angle1, angle2, stackSizeTap, angle1Tap, angle2Tap
local whatTap, tapCount, tapTable, aniTable

local options, continue
local stepSheet, buttSheet, tapSheet

local addListeners, removeListeners, toMill, toInch, goBack2


---Listeners

local function onKeyEvent( event )

   local phase = event.phase
   local keyName = event.keyName
   print( event.phase, event.keyName )
   
   if ( "back" == keyName and phase == "up" ) then
       
       timer.performWithDelay(100,goBack2,1)
   end
   return true
end

local function optionsMove(event)
	local phase = event.phase
  if "ended" == phase then
		
    if not options then
      options = true
      transition.to ( optionsBack, { time = 200, x = -50 } )
      transition.to ( optionsBack, { time = 200, y = 0 } )
			transition.to ( optionsGroup, { time = 500, alpha = 1} )
      transition.to ( backGroup, { time = 200, x=160 } )
      transition.to (decLabel, { time = 200, x = 70, y = backEdgeY + 110} )
      decLabel:setFillColor(0.15, 0.4, 0.729)
		elseif options then 
			transition.to ( optionsGroup, { time = 100, alpha = 0} )
      transition.to ( backGroup, { time = 200, x=0 } )
      transition.to ( optionsBack, { time = 200, x = -170 } )
      transition.to ( optionsBack, { time = 200, y = -335 } )
      transition.to (decLabel, { time = 200, x = backEdgeX + 210, y = backEdgeY + 85} )
      decLabel:setFillColor(1)
			options = false
    end
  end
end

local function resetCalc(event)
	local phase = event.phase
		
		transition.to(angle1, {time = 300, alpha = 0})
		transition.to(angle2, {time = 300, alpha = 0})
    transition.to(stackSize, {time = 300, alpha = 0})
		transition.to(sineSize, {time = 300, alpha = 0})
		transition.to(sineSizeTap, {time = 300, alpha = 1})
    transition.to(angle1Tap, {time = 300, alpha = 0})
		transition.to(angle2Tap, {time = 300, alpha = 0})
    transition.to(stackSizeTap, {time = 300, alpha = 0})
    
    angle1.text = "Tap Me"
    angle2.text = "Tap Me"
    stackSize.text = "Tap Me"
    sineSize.text = "Tap Me"
    
		continue = false
    
    timer.performWithDelay( 10, addListeners )
    
    if options then
			transition.to ( optionsGroup, { time = 100, alpha = 0} )
      transition.to ( backGroup, { time = 200, x=0 } )
      transition.to ( optionsBack, { time = 200, x = -170 } )
      transition.to ( optionsBack, { time = 200, y = -335 } )
      transition.to (decLabel, { time = 200, x = backEdgeX + 210, y = backEdgeY + 85} )
      decLabel:setFillColor(1)
			options = false
		end		
end

local function goBack(event)
	
	transition.to ( optionsGroup, { time = 100, alpha = 0} )
    transition.to ( backGroup, { time = 100, alpha = 0 } )
    transition.to ( optionsBack, { time = 500, x = -170 } )
    transition.to ( optionsBack, { time = 500, y = -335 } )
	options = false
	composer.gotoScene( "menu", { effect="fromBottom", time=800})
	return true
end

local function calcTouch( event )
	if event.phase == "ended" then
		
		whatTap = event.target.tap
    
    local isDegree
    
    if options then
			transition.to ( optionsGroup, { time = 100, alpha = 0} )
      transition.to ( backGroup, { time = 200, x=0 } )
      transition.to ( optionsBack, { time = 200, x = -170 } )
      transition.to ( optionsBack, { time = 200, y = -335 } )
      transition.to (decLabel, { time = 200, x = backEdgeX + 210, y = backEdgeY + 85} )
      decLabel:setFillColor(1)
			options = false
		end
		
    if whatTap == 3 or whatTap == 4 or whatTap == 13 or whatTap == 14 then isDegree = true else isDegree = false end
		
    if isDegree then
      composer.showOverlay( "calculator", { effect="fromRight", time=200, params = { negTrue = false, needDec = true, isDegree = true }, isModal = true }  )
    else
      composer.showOverlay( "calculator", { effect="fromRight", time=200, params = { negTrue = false, needDec = true, isDegree = false }, isModal = true }  )
    end
		
		return true
	end
end

local function measureChange( event )
	local phase = event.phase
	
	if "ended" == phase then	
		if measure:getLabel() == "TO METRIC" then
			measure:setLabel("TO IMPERIAL")
			measureLabel:setText("Metric")
			for i = 1, 2, 1 do
				if tapTable[i].text ~= "Tap Me" then
					tapTable[i].text = math.round(toMill(tapTable[i].text) * math.pow(10, places)) / math.pow(10, places)

				end
			end
		else
			measure:setLabel("TO METRIC")
			measureLabel:setText("Imperial")
			for i = 1, 2, 1 do
				if tapTable[i].text ~= "Tap Me" then
					tapTable[i].text = math.round(toInch(tapTable[i].text) * math.pow(10, places)) / math.pow(10, places)
				end
			end
		end
    if options then
			transition.to ( optionsGroup, { time = 100, alpha = 0} )
      transition.to ( backGroup, { time = 200, x=0 } )
      transition.to ( optionsBack, { time = 200, x = -170 } )
      transition.to ( optionsBack, { time = 200, y = -335 } )
      transition.to (decLabel, { time = 200, x = backEdgeX + 210, y = backEdgeY + 85} )
      decLabel:setFillColor(1)
			options = false
		end
	end	
end

local function stepPress( event )
	local phase = event.phase
	
	if "increment" == phase then
		places = places + 1
		decLabel.text = places
	elseif "decrement" == phase then
		places = places - 1
		decLabel.text = places
	end
end

local function sineBarSize( event )
	local values = sizePicker:getValues()
	sineSize.text = values[1].value
end

local function alertListener ( event )
	if "clicked" == event.action then
		stackSize.text = "Tap Me"
		tapCount = 0
	end
end

local function alertListener2 ( event )
	if "clicked" == event.action then
		angle1.text = "Tap Me"
		angle2.text = "Tap Me"
		tapCount = 0
	end
end

--Local Functions

toMill = function(num)

	return num * 25.4	

end

toInch = function(num)
	
	return num / 25.4
	
end

addListeners = function()
  
  sineSize:addEventListener ( "touch", calcTouch )
  
end

removeListeners = function()
  
  sineSize:removeEventListener ( "touch", calcTouch )
  
end

goBack2 = function()
	
  if (myData.isOverlay) then
    myData.number = "Tap Me"
    composer.hideOverlay("slideRight", 500)
  else
		if options then
			transition.to ( optionsGroup, { time = 100, alpha = 0} )
      transition.to ( backGroup, { time = 200, x=0 } )
      transition.to ( optionsBack, { time = 200, x = -170 } )
      transition.to ( optionsBack, { time = 200, y = -335 } )
      transition.to (decLabel, { time = 200, x = backEdgeX + 177, y = backEdgeY + 115} )
      decLabel:setFillColor(1)
			options = false
		end
		composer.gotoScene( "menu", { effect="fromBottom", time=800})
  end
		
end

function scene:calculate()
  local screenGroup = self.view
  
      myData.isOverlay = false
    
    if myData.number ~= "Tap Me" then
    
    if whatTap == 11 then
      sineSize.alpha = 1
      sineSizeTap.alpha = 0
      tapTable[1].text = myData.number
      stackSizeTap.alpha = 1
			angle1Tap.alpha = 1
			angle2Tap.alpha = 1
    elseif whatTap > 11 then
      tapTable[whatTap - 10].text = myData.number
      aniTable[whatTap - 10].alpha = 0
      tapTable[whatTap -10].alpha = 1
    else
      tapTable[whatTap].text = myData.number
    end
		
		if whatTap == 2 or whatTap == 12 then
			if tonumber(stackSize.text) >= tonumber(sineSize.text) then
				continue = false
        for i = 2, 4, 1 do
          aniTable[i].alpha = 1
          tapTable[i].alpha = 0
        end
				native.showAlert ( "Error", "Stack size cannot be greater than Sine Bar length!", { "OK" }, alertListener )
			else
				continue = true
			end
		end

		if (whatTap == 3) or (whatTap == 4) then
			if tonumber(myData.number) >= 90 then
				continue = false
        for i = 2, 4, 1 do
          aniTable[i].alpha = 1
          tapTable[i].alpha = 0
        end
				native.showAlert ( "Error", "Stack size cannot be greater than Sine Bar length!", { "OK" }, alertListener2 )
			else
				continue = true
			end
		end
    
    if (whatTap == 13) or (whatTap == 14) then
			if tonumber(myData.number) >= 90 then
				continue = false
        for i = 2, 4, 1 do
          aniTable[i].alpha = 1
          tapTable[i].alpha = 0
        end
				native.showAlert ( "Error", "Stack size cannot be greater than Sine Bar length!", { "OK" }, alertListener2 )
			else
				continue = true
			end
		end
    
    if continue then
			if (stackSize.text ~= "Tap Me") and (whatTap == 2 or whatTap == 12) then
				angle1.text = math.deg(math.asin( stackSize.text / sineSize.text ))
				angle2.text = 90 - angle1.text
			elseif (angle1.text ~= "Tap Me") and (whatTap == 3 or whatTap == 13) then
				angle2.text = 90 - angle1.text
				stackSize.text = math.sin(math.rad(angle1.text)) * sineSize.text
			elseif (angle2.text ~= "Tap Me") and (whatTap == 4 or whatTap == 14) then
				angle1.text = 90 - angle2.text
				stackSize.text = math.sin(math.rad(angle1.text)) * sineSize.text
			end
		end
    
    if continue and whatTap == 1 then
      angle1.text = math.deg(math.asin( stackSize.text / sineSize.text ))
			angle2.text = 90 - angle1.text
    end
    
		if continue then
			for i =2, 4, 1 do
				tapTable[i].text = math.round(tapTable[i].text * math.pow(10, places)) / math.pow(10, places)
			end
		end
    
    if continue then
      for i = 2, 4, 1 do
        aniTable[i].alpha = 0
        tapTable[i].alpha = 1
      end
    end
    
    if continue then
      timer.performWithDelay( 10, removeListeners, 2 )
    end
    
    end

end

---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )

   local screenGroup = self.view

		tapCount = 0
		tapTable = {}
    aniTable = {}
    optionsGroup = display.newGroup ( )
    backGroup = display.newGroup ( )
		continue = false
    local textOptionsR = {text="Tap Me", x=0, y=0, width=100, align="right", font="BerlinSansFB-Reg", fontSize=24}
    local textOptionsC = {text="Tap Me", x=0, y=0, width=100, align="center", font="BerlinSansFB-Reg", fontSize=24}
    local textOptionsL = {text="Tap Me", x=0, y=0, width=100, align="left", font="BerlinSansFB-Reg", fontSize=24} 
    
    Runtime:addEventListener( "key", onKeyEvent )
    
    stepSheet = graphics.newImageSheet("Images/stepSheet_stepSheet.png", stepperDataFile.getSpriteSheetData() )
	
		back = display.newImageRect( screenGroup, "backgrounds/background.png", 570, 360 )
		back.x = display.contentCenterX
		back.y = display.contentCenterY		
    
		backEdgeX = back.contentBounds.xMin
		backEdgeY = back.contentBounds.yMin
    
    rightDisplay = display.newImageRect(backGroup, "backgrounds/sinebar.png", 570, 360)
    rightDisplay.x = display.contentCenterX
    rightDisplay.y = display.contentCenterY
		
		decStep = widget.newStepper
	{
		
		left = 0,
		top = 0,
		initialValue = 4,
		minimumValue = 2,
		maximumValue = 5,
		sheet = stepSheet,
		defaultFrame = 1,
		noMinusFrame = 2,
		noPlusFrame = 3,
		minusActiveFrame = 2,
		plusActiveFrame = 3,
		onPress = stepPress,		
		}
	optionsGroup:insert(decStep)
	decStep.x = 70
	decStep.y = backEdgeY + 110
    
	measure = widget.newButton
	{
		id = "measureButt",
    width = 125,
    height = 52,
		label = "TO METRIC",
		labelColor = { default = {0.15, 0.4, 0.729}, over = {1}},
		font = "BerlinSansFB-Reg",
		fontSize = 20,
    defaultFile = "Images/button.png",
    overFile = "Images/buttonOver.png",
		onEvent = measureChange,
		}
	optionsGroup:insert(measure)
	measure.x = 70
	measure.y = backEdgeY + 170
	
	menu = widget.newButton
	{
		id = "menuButt",
    width = 125,
    height = 52,
		label = "MENU",
		labelColor = { default = {0.15, 0.4, 0.729}, over = {1}},
		font = "BerlinSansFB-Reg",
		fontSize = 20,
    defaultFile = "Images/button.png",
    overFile = "Images/buttonOver.png",
		onRelease = goBack,
		}
	optionsGroup:insert(menu)
	menu.x = 70
	menu.y = backEdgeY + 230
	
	reset = widget.newButton
	{
		id = "resetButt",
    width = 125,
    height = 52,
		label = "RESET",
		labelColor = { default = {0.15, 0.4, 0.729}, over = {1}},
		font = "BerlinSansFB-Reg",
		fontSize = 20,
    defaultFile = "Images/button.png",
    overFile = "Images/buttonOver.png",
		onEvent = resetCalc,
		}
	optionsGroup:insert(reset)
	reset.x = 70
	reset.y = backEdgeY + 290
    
	optionsGroup.alpha = 0
	
  optionsBack = display.newRect(screenGroup, 0, 0, 200, 365)
  optionsBack:setFillColor(1)
  optionsBack.anchorX = 0; optionsBack.anchorY = 0; 
  optionsBack.x = -170
  optionsBack.y = -335  
  
  optionsButt = display.newImageRect(screenGroup, "Images/Options.png", 38, 38)
  optionsButt.x = 15
  optionsButt.y = 15
  optionsButt:addEventListener ( "touch", optionsMove )
  optionsButt.isHitTestable = true
    
	decPlaces = display.newEmbossedText( backGroup, "Decimal Places:", 0, 0, "BerlinSansFB-Reg", 16 )
  decPlaces:setFillColor(1)
  decPlaces:setEmbossColor({highlight = {r=0, g=0, b=0, a=1}, shadow = {r=1,g=1,b=1, a=0}})
	decPlaces.x = backEdgeX + 150
	decPlaces.y = backEdgeY + 85
    
	places = 4
	decLabel = display.newText( screenGroup, places, 0, 0, "BerlinSansFB-Reg", 22 )
	decLabel.x = backEdgeX + 210
	decLabel.y = backEdgeY + 85
    
  measureLabel = display.newEmbossedText(backGroup, "Imperial", 0, 0, "BerlinSansFB-Reg", 20)
  measureLabel:setFillColor(1)
  measureLabel:setEmbossColor({highlight = {r=0, g=0, b=0, a=1}, shadow = {r=1,g=1,b=1, a=0}})
	measureLabel.x = backEdgeX + 150
	measureLabel.y = backEdgeY + 60
    
  sineText = display.newEmbossedText(backGroup, "Bar Size:", 0, 0, "BerlinSansFB-Reg", 17)
  sineText:setFillColor(1)
  sineText:setEmbossColor({highlight = {r=0, g=0, b=0, a=1}, shadow = {r=1,g=1,b=1, a=0}})
  sineText.rotation = 18
  sineText.x = backEdgeX + 210
  sineText.y = backEdgeY + 165
      
  sineSize = display.newText( textOptionsL )
  backGroup:insert(sineSize)
	sineSize.anchorX = 0.5; sineSize.anchorY = 0.5; 
	sineSize:addEventListener ( "touch", calcTouch )
  sineSize.rotation = 18
	sineSize.x = backEdgeX + 290
	sineSize.y = backEdgeY + 190
	tapTable[1] = sineSize
	sineSize.tap = 1
  sineSize.alpha = 0
    
  --sineSizeTap = display.newSprite(tapSheet, tapAniSequenceData["tapAniv2"])
  sineSizeTap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
	sineSizeTap.x = backEdgeX + 260
	sineSizeTap.y = backEdgeY + 183
  sineSizeTap.rotation = 18
	backGroup:insert(sineSizeTap)
	sineSizeTap:addEventListener ( "touch", calcTouch )
	sineSizeTap.tap = 11
  aniTable[1] = sineSizeTap
	--sineSizeTap:play()
		
	stackSize = display.newText( textOptionsL )
  backGroup:insert(stackSize)
	stackSize.anchorX = 0.5; stackSize.anchorY = 0.5; 
	stackSize:addEventListener ( "touch", calcTouch )
	stackSize.x = backEdgeX + 200
	stackSize.y = backEdgeY + 250
	tapTable[2] = stackSize
	stackSize.tap = 2
	stackSize.alpha = 0
    
  --stackSizeTap = display.newSprite(tapSheet, tapAniSequenceData["tapAniv2"])
  stackSizeTap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
	stackSizeTap.x = backEdgeX + 155
	stackSizeTap.y = backEdgeY + 250
	backGroup:insert(stackSizeTap)
	stackSizeTap:addEventListener ( "touch", calcTouch )
	stackSizeTap.tap = 12
  aniTable[2] = stackSizeTap
	--stackSizeTap:play()
  stackSizeTap.alpha = 0
		
	angle1 = display.newText( textOptionsR )
  backGroup:insert(angle1)
	angle1.anchorX = 0.5; angle1.anchorY = 0.5; 
	angle1:addEventListener ( "touch", calcTouch )
	angle1.x = backEdgeX + 280
	angle1.y = backEdgeY + 275
	tapTable[3] = angle1
	angle1.tap = 3
	angle1.alpha = 0
    
  --angle1Tap = display.newSprite(tapSheet, tapAniSequenceData["tapAniv2"])
  angle1Tap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
	angle1Tap.x = backEdgeX + 315
	angle1Tap.y = backEdgeY + 275
	backGroup:insert(angle1Tap)
	angle1Tap:addEventListener ( "touch", calcTouch )
	angle1Tap.tap = 13
  aniTable[3] = angle1Tap
	--angle1Tap:play()
  angle1Tap.alpha = 0
		
	angle2 = display.newText( textOptionsR )
  backGroup:insert(angle2)
	angle2.anchorX = 0.5; angle2.anchorY = 0.5; 
	angle2:addEventListener ( "touch", calcTouch )
	angle2.x = backEdgeX + 310
	angle2.y = backEdgeY + 155
	tapTable[4] = angle2
	angle2.tap = 4
	angle2.alpha = 0
    
  --angle2Tap = display.newSprite(tapSheet, tapAniSequenceData["tapAniv2"])
  angle2Tap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
	angle2Tap.x = backEdgeX + 345
	angle2Tap.y = backEdgeY + 155
	backGroup:insert(angle2Tap)
	angle2Tap:addEventListener ( "touch", calcTouch )
	angle2Tap.tap = 14
  aniTable[4] = angle2Tap
	--angle2Tap:play()
  angle2Tap.alpha = 0
    
  optionsGroup.anchorX = 0.5; optionsGroup.anchorY = 0.5;
  backGroup.anchorX = 0.5; backGroup.anchorY = 0.5;
  backGroup.alpha = 0
  transition.to ( backGroup, { time = 500, alpha = 1, delay = 200} )
  optionsBack.alpha = 0
  transition.to ( optionsBack, { time = 500, alpha = 1, delay = 600} )
  optionsButt.alpha = 0
  transition.to ( optionsButt, { time = 500, alpha = 1, delay = 600} )
  
  screenGroup:insert(backGroup)
		
end

-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
   elseif ( phase == "did" ) then
      composer.removeScene( "menu", true)
   end
end

-- "scene:hide()"
function scene:hide( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is on screen (but is about to go off screen).
      -- Insert code here to "pause" the scene.
      -- Example: stop timers, stop animation, stop audio, etc.
      Runtime:removeEventListener( "key", onKeyEvent )
   elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.
   end
end

-- "scene:destroy()"
function scene:destroy( event )

   local sceneGroup = self.view
   
   	optionsGroup:removeSelf()
    backGroup:removeSelf()

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