local composer = require( "composer" )
local scene = composer.newScene()
local widget = require ( "widget" )
local stepperDataFile = require("Images.stepSheet_stepSheet")
display.setStatusBar(display.HiddenStatusBar)
local myData = require("myData")
local loadsave = require("loadsave")
local fm = require("fontmanager")
fm.FontManager:setEncoding("utf8")

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
local gMeasure, measureText, optionLabels


---Listeners

local function onKeyEvent( event )

  local phase = event.phase
  local keyName = event.keyName
  local platformName = system.getInfo("platformName")

  if platformName == "Android" then
   if ( "back" == keyName and phase == "up" ) then
    timer.performWithDelay(100,goBack2,1)
   end
  elseif platformName == "WinPhone" then
   if ( "back" == keyName ) then
    timer.performWithDelay(100,goBack2,1)
   end
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
      transition.to (decLabel, { time = 200, x = 70, y = backEdgeY + 110} )
      transition.to ( backGroup, { time = 200, x = 160} )
	  decLabel:setFont("berlinFont")
	elseif options then 
	  transition.to ( optionsGroup, { time = 100, alpha = 0} )
      transition.to ( backGroup, { time = 200, x=0 } )
      transition.to ( optionsBack, { time = 200, x = -170 } )
      transition.to ( optionsBack, { time = 200, y = -335 } )
      transition.to (decLabel, { time = 200, x = backEdgeX + 215, y = backEdgeY + 80} )
	  decLabel:setFont("inputFont")
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
    
    angle1:setText("Tap Me")
    angle2:setText("Tap Me")
    stackSize:setText("Tap Me")
    sineSize:setText("Tap Me")
    
	continue = false
    
    timer.performWithDelay( 10, addListeners )
    
    if options then
	  transition.to ( optionsGroup, { time = 100, alpha = 0} )
      transition.to ( backGroup, { time = 200, x=0 } )
      transition.to ( optionsBack, { time = 200, x = -170 } )
      transition.to ( optionsBack, { time = 200, y = -335 } )
      transition.to (decLabel, { time = 200, x = backEdgeX + 215, y = backEdgeY + 80} )
	  decLabel:setFont("inputFont")
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
      transition.to (decLabel, { time = 200, x = backEdgeX + 215, y = backEdgeY + 80} )
	  decLabel:setFont("inputFont")
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
		if optionLabels[1]:getText() == "TO METRIC" then
			gMeasure.measure = "TO IMPERIAL"
			loadsave.saveTable(gMeasure, "sineMeasure.json")
			optionLabels[1]:setText("TO IMPERIAL")
			measureLabel:setText("Metric")
		for i = 1, 3, 1 do			
			if tapTable[i]:getText() ~= "Tap Me" then
					tapTable[i]:setText(math.round(toMill(tapTable[i]:getText()) * math.pow(10, places)) / math.pow(10, places))
				end
			end
		else
			gMeasure.measure = "TO METRIC"
			loadsave.saveTable(gMeasure, "sineMeasure.json")
			optionLabels[1]:setText("TO METRIC")
			measureLabel:setText("Imperial")
			for i = 1, 3, 1 do
				if tapTable[i]:getText() ~= "Tap Me" then
					tapTable[i]:setText(math.round(toInch(tapTable[i]:getText()) * math.pow(10, places)) / math.pow(10, places))
				end
			end
		end
    
    if options then
	  transition.to ( optionsGroup, { time = 100, alpha = 0} )
      transition.to ( backGroup, { time = 200, x=0 } )
      transition.to ( optionsBack, { time = 200, x = -170 } )
      transition.to ( optionsBack, { time = 200, y = -335 } )
      transition.to (decLabel, { time = 200, x = backEdgeX + 215, y = backEdgeY + 80} )
	  decLabel:setFont("inputFont")
	  options = false
	end
    
	end
end

local function stepPress( event )
	local phase = event.phase
	
	if "increment" == phase then
		places = places + 1
		decLabel:setText(places)
	elseif "decrement" == phase then
		places = places - 1
		decLabel:setText(places)
	end
end

local function sineBarSize( event )
	local values = sizePicker:getValues()
	sineSize:setText(values[1].value)
end

local function alertListener ( event )
	if "clicked" == event.action then
		stackSize:setText("Tap Me")
		tapCount = 0
	end
end

local function alertListener2 ( event )
	if "clicked" == event.action then
		angle1:setText("Tap Me")
		angle2:setText("Tap Me")
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
	transition.to ( optionsGroup, { time = 100, alpha = 0} )
    transition.to ( backGroup, { time = 100, alpha = 0 } )
    transition.to ( optionsBack, { time = 500, x = -170 } )
    transition.to ( optionsBack, { time = 500, y = -335 } )
	options = false
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
      tapTable[1]:setText(myData.number)
      stackSizeTap.alpha = 1
	  angle1Tap.alpha = 1
	  angle2Tap.alpha = 1
    elseif whatTap > 11 then
      tapTable[whatTap - 10]:setText(myData.number)
      aniTable[whatTap - 10].alpha = 0
      tapTable[whatTap -10].alpha = 1
    else
      tapTable[whatTap]:setText(myData.number)
    end
		
		if whatTap == 2 or whatTap == 12 then
			if tonumber(stackSize:getText()) >= tonumber(sineSize:getText()) then
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
			if (stackSize:getText() ~= "Tap Me") and (whatTap == 2 or whatTap == 12) then
				angle1:setText(math.deg(math.asin( stackSize:getText() / sineSize:getText() )))
				angle2:setText(90 - angle1:getText())
			elseif (angle1:getText() ~= "Tap Me") and (whatTap == 3 or whatTap == 13) then
				angle2:setText(90 - angle1:getText())
				stackSize:setText(math.sin(math.rad(angle1:getText())) * sineSize:getText())
			elseif (angle2:getText() ~= "Tap Me") and (whatTap == 4 or whatTap == 14) then
				angle1:setText(90 - angle2:getText())
				stackSize:setText(math.sin(math.rad(angle1:getText())) * sineSize:getText())
			end
		end
    
    if continue and whatTap == 1 then
      angle1:setText(math.deg(math.asin( stackSize:getText() / sineSize:getText() )))
			angle2:setText(90 - angle1:getText())
    end
    
		if continue then
			for i =2, 4, 1 do
				tapTable[i]:setText(math.round(tapTable[i]:getText() * math.pow(10, places)) / math.pow(10, places))
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

  gMeasure = loadsave.loadTable("sineMeasure.json")
  if gMeasure == nil then
    gMeasure = {}
    gMeasure.measure = "TO METRIC"
    loadsave.saveTable(gMeasure, "sineMeasure.json")
  end

  if gMeasure.measure == "TO METRIC" then
    measureText = "Imperial"
  else
    measureText = "Metric"
  end

  optionLabels = {}

  for i = 1, 3, 1 do
	optionLabels[i] = display.newBitmapText("", 0, 0, "berlinFont", 18)
  end

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
    defaultFile = "Images/button.png",
    overFile = "Images/buttonOver.png",
	onEvent = measureChange,
	}
	optionsGroup:insert(measure)
	measure.x = 70
	measure.y = backEdgeY + 170

	optionLabels[1]:setText(gMeasure.measure)
	optionLabels[1].x = measure.contentWidth / 2
	optionLabels[1].y = measure.contentHeight / 2
	measure:insert(optionLabels[1])
	
	menu = widget.newButton
	{
	id = "menuButt",
    width = 125,
    height = 52,
    defaultFile = "Images/button.png",
    overFile = "Images/buttonOver.png",
	onRelease = goBack,
	}
	optionsGroup:insert(menu)
	menu.x = 70
	menu.y = backEdgeY + 230

	optionLabels[2]:setText("MENU")
	optionLabels[2].x = menu.contentWidth / 2
	optionLabels[2].y = menu.contentHeight / 2
	menu:insert(optionLabels[2])
	
	reset = widget.newButton
	{
	id = "resetButt",
    width = 125,
    height = 52,
    defaultFile = "Images/button.png",
    overFile = "Images/buttonOver.png",
	onEvent = resetCalc,
	}
	optionsGroup:insert(reset)
	reset.x = 70
	reset.y = backEdgeY + 290

	optionLabels[3]:setText("RESET")
	optionLabels[3].x = reset.contentWidth / 2
	optionLabels[3].y = reset.contentHeight / 2
	reset:insert(optionLabels[3])
	
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

  decPlaces = display.newBitmapText("Decimal Places:", 0, 0, "uiFont", 16)
  backGroup:insert(decPlaces)
  decPlaces.x = backEdgeX + 150
  decPlaces.y = backEdgeY + 80
	
  places = 4
  decLabel = display.newBitmapText(places, 0, 0, "inputFont", 24)
  screenGroup:insert(decLabel)
  decLabel.x = backEdgeX + 215
  decLabel.y = backEdgeY + 80
  
  measureLabel = display.newBitmapText(measureText, 0, 0, "uiFont", 20)
  backGroup:insert(measureLabel)
  measureLabel.x = backEdgeX + 150
  measureLabel.y = backEdgeY + 55
    
  sineText = display.newBitmapText("Bar Size:", 0, 0, "uiFont", 22)
  backGroup:insert(sineText)
  sineText.rotation = 18
  sineText.x = backEdgeX + 210
  sineText.y = backEdgeY + 162

  sineSize = display.newBitmapText("Tap Me", 0, 0, "inputFont", 22)
  backGroup:insert(sineSize)
  sineSize:setAnchor(0, 0.5) 
  sineSize:addEventListener ( "touch", calcTouch )
  sineSize.rotation = 18
  sineSize.x = backEdgeX + 260
  sineSize.y = backEdgeY + 180
  tapTable[1] = sineSize
  sineSize.tap = 1
  sineSize.alpha = 0

  sineSizeTap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
  sineSizeTap.x = backEdgeX + 265
  sineSizeTap.y = backEdgeY + 185
  sineSizeTap.rotation = 18
  backGroup:insert(sineSizeTap)
  sineSizeTap:addEventListener ( "touch", calcTouch )
  sineSizeTap.tap = 11
  aniTable[1] = sineSizeTap
	
  stackSize = display.newBitmapText("Tap Me", 0, 0, "inputFont", 22)
  backGroup:insert(stackSize)
  stackSize:setAnchor(0, 0.5)
  stackSize:addEventListener ( "touch", calcTouch )
  stackSize.x = backEdgeX + 140
  stackSize.y = backEdgeY + 250
  tapTable[2] = stackSize
  stackSize.tap = 2
  stackSize.alpha = 0

  stackSizeTap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
  stackSizeTap.x = backEdgeX + 155
  stackSizeTap.y = backEdgeY + 250
  backGroup:insert(stackSizeTap)
  stackSizeTap:addEventListener ( "touch", calcTouch )
  stackSizeTap.tap = 12
  aniTable[2] = stackSizeTap
  stackSizeTap.alpha = 0
		
  angle1 = display.newBitmapText("Tap Me", 0, 0, "inputFont", 22)
  backGroup:insert(angle1)
  angle1:setJustification(angle1.Justify.RIGHT)
  angle1:setAnchor(1, 0.5)
  angle1:addEventListener ( "touch", calcTouch )
  angle1.x = backEdgeX + 330
  angle1.y = backEdgeY + 275
  tapTable[3] = angle1
  angle1.tap = 3
  angle1.alpha = 0
    
  angle1Tap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
  angle1Tap.x = backEdgeX + 315
  angle1Tap.y = backEdgeY + 275
  backGroup:insert(angle1Tap)
  angle1Tap:addEventListener ( "touch", calcTouch )
  angle1Tap.tap = 13
  aniTable[3] = angle1Tap
  angle1Tap.alpha = 0
		
  angle2 = display.newBitmapText("Tap Me", 0, 0, "inputFont", 22)
  backGroup:insert(angle2)
  angle2:setJustification(angle2.Justify.RIGHT)
  angle2:setAnchor(1, 0.5)
  angle2:addEventListener ( "touch", calcTouch )
  angle2.x = backEdgeX + 360
  angle2.y = backEdgeY + 150
  tapTable[4] = angle2
  angle2.tap = 4
  angle2.alpha = 0
    
  angle2Tap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
  angle2Tap.x = backEdgeX + 345
  angle2Tap.y = backEdgeY + 155
  backGroup:insert(angle2Tap)
  angle2Tap:addEventListener ( "touch", calcTouch )
  angle2Tap.tap = 14
  aniTable[4] = angle2Tap
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
  screenGroup:insert( optionsGroup)
		
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
	  decLabel.alpha = 0
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