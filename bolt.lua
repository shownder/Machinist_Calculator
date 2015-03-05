local composer = require( "composer" )
local scene = composer.newScene()
local widget = require ( "widget" )
local stepperDataFile = require("Images.stepSheet_stepSheet")
display.setStatusBar(display.HiddenStatusBar)
local myData = require("myData")
local loadsave = require("loadsave")
--local analytics = require( "analytics" )
local fm = require("fontmanager")
fm.FontManager:setEncoding("utf8")

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

local back, menuBack, backEdgeX, backEdgeY, optionsGroup, backGroup, rightDisplay

local numHolesText, diamText, circleXtext, circleYtext, firstHoleText, calculate
local numHolesTap, diamTap, circleXTap, circleYTap, firstHoleTap
local numHoles, diam, circleX, circleY, firstHole

local menu, reset, measure, decStep
local decLabel, places, measureLabel

local tapTable, aniTable, whatTap
local answer, options, answerX, answerY

local stepSheet, buttSheet, tapSheet, calcClick

local toMill, toInch
local bolts, bolts2, goBack2
local gMeasure, measureText
local optionLabels, calcLabel

--Listeners
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
      transition.to (decLabel, { time = 200, x = backEdgeX + 180, y = backEdgeY + 100} )
	  decLabel:setFont("inputFont")
	  options = false
    end
  end
end

local function measureChange( event )
	local phase = event.phase
	
	if "ended" == phase then	
		if optionLabels[1]:getText() == "TO METRIC" then
			gMeasure.measure = "TO IMPERIAL"
			loadsave.saveTable(gMeasure, "boltMeasure.json")
			optionLabels[1]:setText("TO IMPERIAL")
			measureLabel:setText("Metric")
		for i = 1, 3, 1 do			
			if tapTable[i]:getText() ~= "Tap Me" then
					tapTable[i]:setText(math.round(toMill(tapTable[i]:getText()) * math.pow(10, places)) / math.pow(10, places))
				end
			end
		else
			gMeasure.measure = "TO METRIC"
			loadsave.saveTable(gMeasure, "boltMeasure.json")
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
      transition.to (decLabel, { time = 200, x = backEdgeX + 180, y = backEdgeY + 100} )
	  decLabel:setFont("inputFont")
	  options = false
    end
    
	end
end

local function stepPress( event )
	local phase = event.phase
	
	if "increment" == phase then
		places = places + 1
		decLabel:setText( places)
	elseif "decrement" == phase then
		places = places - 1
		decLabel:setText( places)
	end
end

local function calcTouch( event )
	if event.phase == "ended" then
		
    whatTap = event.target.tap
    
    local isDegree
    
    calcClick = true
    
    if whatTap >= 6 then
      whatTap = whatTap - 10
    end
    
    if whatTap == 5 then isDegree = true end
    
		if whatTap == 3 or whatTap == 4 then
			composer.showOverlay( "calculator", { effect="fromRight", time=400, params = { negTrue = true, needDec = true, isBolt = true}, isModal = true}  )
		elseif whatTap == 1 then
			composer.showOverlay( "calculator", { effect="fromRight", time=400, params = { negTrue = false, needDec = false }, isModal = true} )
		elseif isDegree then
			composer.showOverlay( "calculator", { effect="fromRight", time=400, params = { negTrue = false, needDec = true, isDegree = true, isBolt = true }, isModal = true} )
     else
       composer.showOverlay( "calculator", { effect="fromRight", time=400, params = { negTrue = false, needDec = true, isDegree = false }, isModal = true} )
		end		
		return true
	end
end

local function resetCalc(event)
	local phase = event.phase
		
    transition.to(answer, {time = 300, alpha = 0})
		transition.to(numHoles, {time = 300, alpha = 0})
		transition.to(diam, {time = 300, alpha = 0})
    transition.to(circleX, {time = 300, alpha = 0})
		transition.to(circleY, {time = 300, alpha = 0})
		transition.to(firstHole, {time = 300, alpha = 0})
    transition.to(circleXTap, {time = 300, alpha = 0})
		transition.to(circleYTap, {time = 300, alpha = 0})
		transition.to(firstHoleTap, {time = 300, alpha = 0})
    transition.to(numHolesTap, {time = 300, alpha = 1})
		transition.to(diamTap, {time = 300, alpha = 1})
    
    numHoles:setText( "Tap Me")
    diam:setText( "Tap Me")
    circleX:setText( "Tap Me")
    circleY:setText( "Tap Me")
    firstHole:setText( "Tap Me")
    
    if options then
	  transition.to ( optionsGroup, { time = 100, alpha = 0} )
      transition.to ( backGroup, { time = 200, x=0 } )
      transition.to ( optionsBack, { time = 200, x = -170 } )
      transition.to ( optionsBack, { time = 200, y = -335 } )
      transition.to (decLabel, { time = 200, x = backEdgeX + 180, y = backEdgeY + 100} )
	  decLabel:setFont("inputFont")
	  options = false
    end	
end

local function goBack (event)
	if event.phase == "ended" then
    
	transition.to ( optionsGroup, { time = 100, alpha = 0} )
    transition.to ( backGroup, { time = 100, alpha = 0 } )
    transition.to ( optionsBack, { time = 500, x = -170 } )
    transition.to ( optionsBack, { time = 500, y = -335 } )
	options = false
	composer.gotoScene( "menu", { effect="fromBottom", time=800})
	return true
	end
end

local function answerScene( event )
	if event.phase == "ended" then
		
		myData.answer = bolts(numHoles:getText(), diam:getText(), circleX:getText(), circleY:getText(), firstHole:getText())
    bolts2(numHoles:getText(), diam:getText(), circleX:getText(), circleY:getText(), firstHole:getText())
    myData.answerX = answerX
    myData.answerY = answerY
    myData.diam = diam:getText()
    
    calcClick = false
    
		composer.showOverlay( "boltAnswer", { effect="fromRight", time=400, isModal = true }  )
				
		return true
	end
end

--Local Functions

toMill = function(num)

	return num * 25.4	

end

toInch = function(num)
	
	return num / 25.4
	
end

bolts = function(numHoles, diam, circleX, circleY, firstHole)
	
	local temp = {}
	
	if circleX == "Tap Me" then
		circleX = 0
	end
	
	if circleY == "Tap Me" then
		circleY = 0
	end
	
	if firstHole == "Tap Me" then
		firstHole = 0
	end
	
	local radius = diam / 2
  local degree
	local xpoint, ypoint
	
	for i = 0, numHoles-1, 1 do
    degree = i * (360 / numHoles) + firstHole
		xpoint = radius * math.cos(math.rad(degree)) + circleX
		ypoint = radius * math.sin(math.rad(degree)) + circleY
		xpoint = math.round(xpoint * math.pow(10, places)) / math.pow(10, places)
		ypoint = math.round(ypoint * math.pow(10, places)) / math.pow(10, places)
		temp[i] = "#" .. i+1 .. "  " .. "X: " .. xpoint .. ", Y: " .. ypoint
		--firstHole = firstHole + angle	
	end
	
	return temp
end

bolts2 = function(numHoles, diam, circleX, circleY, firstHole)
	
	if circleX == "Tap Me" then
		circleX = 0
	end
	
	if circleY == "Tap Me" then
		circleY = 0
	end
	
	if firstHole == "Tap Me" then
		firstHole = 0
	end
	
	local radius = 15 / 2
	local degree
	local xpoint, ypoint
	
	for i = 0, numHoles-1, 1 do
    degree = i * (360 / numHoles) + firstHole
		xpoint = radius * math.cos(math.rad(degree)) + circleX
		ypoint = radius * math.sin(math.rad(degree)) + circleY
		xpoint = math.round(xpoint * math.pow(10, places)) / math.pow(10, places)
		ypoint = math.round(ypoint * math.pow(10, places)) / math.pow(10, places)
		answerX[i] = xpoint
    answerY[i] = ypoint
		--firstHole = firstHole + angle	
	end
	
	return temp
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
    
    if calcClick == true then
    
    tapTable[whatTap]:setText( myData.number)
    
    if whatTap == 1 then
    	if tonumber(numHoles:getText())  <= 0 then
    		native.showAlert ( "Error", "You need more than 0 holes!", { "OK" }, alertListener )
    		numHoles:setText( "Tap Me")
    	end
    elseif whatTap == 2 then    
  	  if tonumber(diam:getText())  <= 0 then
    		native.showAlert ( "Error", "Diameter must be greater than 0!", { "OK" }, alertListener )
    		diam:setText( "Tap Me")
        diam.alpha = 0
        diamTap.alpha = 1
  	  end
    end
        
    if diam:getText() ~= "Tap Me" and numHoles:getText() ~= "Tap Me" then
    	circleXtext.alpha = 1
    	circleXTap.alpha = 1
    	circleYTap.alpha = 1
    	circleYtext.alpha = 1
    	firstHoleText.alpha = 1
    	firstHoleTap.alpha = 1
    	answer.alpha = 1
    end    
       
    for i = 1, 5, 1 do
      if tapTable[i]:getText() ~= "Tap Me" then
        tapTable[i].alpha = 1
        aniTable[i].alpha = 0
      end
    end
    
  end
  
  end

end

---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )
	local screenGroup = self.view

  tapTable = {}
  aniTable = {}
  answerX = {}
  answerY = {}

  gMeasure = loadsave.loadTable("boltMeasure.json")
  if gMeasure == nil then
    gMeasure = {}
    gMeasure.measure = "TO METRIC"
    loadsave.saveTable(gMeasure, "boltMeasure.json")
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
  
  Runtime:addEventListener( "key", onKeyEvent )
  
  optionsGroup = display.newGroup ( )
  backGroup = display.newGroup()
  local textOptionsL = {parent = backGroup, text="Tap Me", x=0, y=0, width=80, height=0, font="BerlinSansFB-Reg", fontSize=24, align="left"}
  
  stepSheet = graphics.newImageSheet("Images/stepSheet_stepSheet.png", stepperDataFile.getSpriteSheetData() )
	
  back = display.newImageRect( screenGroup, "backgrounds/background.png", 570, 360 )
	back.x = display.contentCenterX
	back.y = display.contentCenterY		
	backEdgeX = back.contentBounds.xMin
	backEdgeY = back.contentBounds.yMin
  
  rightDisplay = display.newImageRect(backGroup, "backgrounds/bolt.png", 570, 360)
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
  decPlaces.x = backEdgeX + 117
  decPlaces.y = backEdgeY + 100
	
  places = 4
  decLabel = display.newBitmapText(places, 0, 0, "inputFont", 24)
  screenGroup:insert(decLabel)
  decLabel.x = backEdgeX + 180
  decLabel.y = backEdgeY + 100
  
  measureLabel = display.newBitmapText(measureText, 0, 0, "uiFont", 20)
  backGroup:insert(measureLabel)
  measureLabel.x = backEdgeX + 118
  measureLabel.y = backEdgeY + 75
	
  numHolesText = display.newBitmapText("No. of Holes:", 0, 0, "uiFont", 18)
  backGroup:insert(numHolesText)
  numHolesText.x = backEdgeX + 100
  numHolesText.y = backEdgeY + 140
	
  numHoles = display.newBitmapText("Tap Me", 0, 0, "inputFont", 22)
  backGroup:insert(numHoles)
  numHoles:setAnchor(0, 0.5)
  numHoles:addEventListener ( "touch", calcTouch )
  numHoles.anchorX = 0.5; numHoles.anchorY = 0.5; 
  numHoles.x = backEdgeX + 155
  numHoles.y = backEdgeY + 140
  numHoles.tap = 1
  tapTable[1] = numHoles
  numHoles.alpha = 0
  
  numHolesTap = display.newImageRect(backGroup, "Images/tapTarget.png", 33, 33)
  numHolesTap.x = backEdgeX + 170
  numHolesTap.y = backEdgeY + 140
  numHolesTap:addEventListener ( "touch", calcTouch )
  numHolesTap.tap = 11
  aniTable[1] = numHolesTap
  	
  diamText = display.newBitmapText("Circle Diameter:", 0, 0, "uiFont", 18)
  backGroup:insert(diamText)
  diamText.x = backEdgeX + 111
  diamText.y = backEdgeY + 185
	
  diam = display.newBitmapText("Tap Me", 0, 0, "inputFont", 22)
  backGroup:insert(diam)
  diam:addEventListener ( "touch", calcTouch )
  diam:setAnchor(0, 0.5)
  diam.x = backEdgeX + 180
  diam.y = backEdgeY + 185
  diam.tap = 2
  tapTable[2] = diam
  diam.alpha = 0
  
  diamTap = display.newImageRect(backGroup, "Images/tapTarget.png", 33, 33)
  diamTap.x = backEdgeX + 190
  diamTap.y = backEdgeY + 185
  backGroup:insert(diamTap)
  diamTap:addEventListener ( "touch", calcTouch )
  diamTap.tap = 12
  aniTable[2] = diamTap
	
  circleXtext = display.newBitmapText("Circle Centre - X:", 0, 0, "uiFont", 18)
  backGroup:insert(circleXtext)
  circleXtext.x = backEdgeX + 116
  circleXtext.y = backEdgeY + 230
  circleXtext.alpha = 1
	
  circleX = display.newBitmapText("Tap Me", 0, 0, "inputFont", 22)
  backGroup:insert(circleX)
  circleX:addEventListener ( "touch", calcTouch )
  circleX:setAnchor(0, 0.5)
  circleX.x = backEdgeX + 185
  circleX.y = backEdgeY + 230
  circleX.tap = 3
  tapTable[3] = circleX
  circleX.alpha = 0
  
  circleXTap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
  circleXTap.x = backEdgeX + 205
  circleXTap.y = backEdgeY + 230
  backGroup:insert(circleXTap)
  circleXTap:addEventListener ( "touch", calcTouch )
  circleXTap.tap = 13
  circleXTap.alpha = 0
  aniTable[3] = circleXTap
	
  circleYtext = display.newBitmapText("Circle Centre - Y:", 0, 0, "uiFont", 18)
  backGroup:insert(circleYtext)
  circleYtext.x = backEdgeX + 116
  circleYtext.y = backEdgeY + 275
  circleYtext.alpha = 1
	
  circleY = display.newBitmapText("Tap Me", 0, 0, "inputFont", 22)
  backGroup:insert(circleY)
  circleY:addEventListener ( "touch", calcTouch )
  circleY:setAnchor(0, 0.5)
  circleY.x = backEdgeX + 185
  circleY.y = backEdgeY + 275
  circleY.tap = 4
  tapTable[4] = circleY
  circleY.alpha = 0
  
  circleYTap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
  circleYTap.x = backEdgeX + 205
  circleYTap.y = backEdgeY + 275
  backGroup:insert(circleYTap)
  circleYTap:addEventListener ( "touch", calcTouch )
  circleYTap.tap = 14
  aniTable[4] = circleYTap
  circleYTap.alpha = 0
	
  firstHoleText = display.newBitmapText("First Hole Angle:", 0, 0, "uiFont", 18)
  backGroup:insert(firstHoleText)
  firstHoleText.x = backEdgeX + 116
  firstHoleText.y = backEdgeY + 320
  firstHoleText.alpha = 1
	
  firstHole = display.newBitmapText("Tap Me", 0, 0, "inputFont", 22)
  backGroup:insert(firstHole)
  firstHole:addEventListener ( "touch", calcTouch )
  firstHole:setAnchor(0, 0.5)
  firstHole.x = backEdgeX + 185
  firstHole.y = backEdgeY + 320
  firstHole.tap = 5
  tapTable[5] = firstHole
  firstHole.alpha = 0
  
  firstHoleTap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
  firstHoleTap.x = backEdgeX + 200
  firstHoleTap.y = backEdgeY + 320
  backGroup:insert(firstHoleTap)
  firstHoleTap:addEventListener ( "touch", calcTouch )
  firstHoleTap.tap = 15
  aniTable[5] = firstHoleTap
  firstHoleTap.alpha = 0
	
  answer = widget.newButton
	{
		id = "chartsButt",
		width = 90,
		height = 37,
		defaultFile = "Images/chartButtD.png",
		overFile = "Images/chartButtO.png",
		onEvent = answerScene,
	}
	backGroup:insert(answer)
	answer.x = backEdgeX + 430
	answer.y = backEdgeY + 300

  calcLabel = display.newBitmapText("CALCULATE", 0, 0, "uiFont", 14)
  calcLabel.x = answer.contentWidth / 2
  calcLabel.y = answer.contentHeight / 2
  answer:insert(calcLabel)
  
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
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc.
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

   -- Called prior to the removal of scene's view ("sceneGroup").
   -- Insert code here to clean up the scene.
   -- Example: remove display objects, save state, etc.
   optionsGroup:removeSelf()
   backGroup:removeSelf()
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene