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

--Listeners

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
      transition.to (decLabel, { time = 200, x = backEdgeX + 177, y = backEdgeY + 100} )
      decLabel:setFillColor(1)
			options = false
    end
  end
  return true
end

local function measureChange( event )
	local phase = event.phase
	
	if "ended" == phase then	
		if measure:getLabel() == "TO METRIC" then
			measure:setLabel("TO IMPERIAL")
			measureLabel:setText("Metric")
			if diam.text ~= "Tap Me" then
				diam.text = math.round(toMill(diam.text) * math.pow(10, places)) / math.pow(10, places)
			end
		else
			measure:setLabel("TO METRIC")
			measureLabel:setText("Imperial")
			if diam.text ~= "Tap Me" then
				diam.text = math.round(toInch(diam.text) * math.pow(10, places)) / math.pow(10, places)
			end
		end
	end
	if options then
			transition.to ( optionsGroup, { time = 100, alpha = 0} )
      transition.to ( backGroup, { time = 200, x=0 } )
      transition.to ( optionsBack, { time = 200, x = -170 } )
      transition.to ( optionsBack, { time = 200, y = -335 } )
      transition.to (decLabel, { time = 200, x = backEdgeX + 177, y = backEdgeY + 100} )
      decLabel:setFillColor(1)
			options = false
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
    --transition.to(circleXtext, {time = 300, alpha = 0})
		--transition.to(circleYtext, {time = 300, alpha = 0})
		--transition.to(firstHoleText, {time = 300, alpha = 0})
    transition.to(circleXTap, {time = 300, alpha = 0})
		transition.to(circleYTap, {time = 300, alpha = 0})
		transition.to(firstHoleTap, {time = 300, alpha = 0})
    transition.to(numHolesTap, {time = 300, alpha = 1})
		transition.to(diamTap, {time = 300, alpha = 1})
    
    numHoles.text = "Tap Me"
    diam.text = "Tap Me"
    circleX.text = "Tap Me"
    circleY.text = "Tap Me"
    firstHole.text = "Tap Me"
    
    if options then
			transition.to ( optionsGroup, { time = 100, alpha = 0} )
      transition.to ( backGroup, { time = 200, x=0 } )
      transition.to ( optionsBack, { time = 200, x = -170 } )
      transition.to ( optionsBack, { time = 200, y = -335 } )
      transition.to (decLabel, { time = 200, x = backEdgeX + 177, y = backEdgeY + 100} )
      decLabel:setFillColor(1)
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
		
		myData.answer = bolts(numHoles.text, diam.text, circleX.text, circleY.text, firstHole.text)
    bolts2(numHoles.text, diam.text, circleX.text, circleY.text, firstHole.text)
    myData.answerX = answerX
    myData.answerY = answerY
    myData.diam = diam.text
    
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
    
    if calcClick == true then
    
    tapTable[whatTap].text = myData.number
    
    if whatTap == 1 then
    	if tonumber(numHoles.text)  <= 0 then
    		native.showAlert ( "Error", "You need more than 0 holes!", { "OK" }, alertListener )
    		numHoles.text = "Tap Me"
    	end
    elseif whatTap == 2 then    
  	  if tonumber(diam.text)  <= 0 then
    		native.showAlert ( "Error", "Diameter must be greater than 0!", { "OK" }, alertListener )
    		diam.text = "Tap Me"
        diam.alpha = 0
        diamTap.alpha = 1
  	  end
    end
        
    if diam.text ~= "Tap Me" and numHoles.text ~= "Tap Me" then
    	circleXtext.alpha = 1
    	circleXTap.alpha = 1
    	circleYTap.alpha = 1
    	circleYtext.alpha = 1
    	firstHoleText.alpha = 1
    	firstHoleTap.alpha = 1
    	answer.alpha = 1
    end    
       
    for i = 1, 5, 1 do
      if tapTable[i].text ~= "Tap Me" then
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
	decPlaces.x = backEdgeX + 115
	decPlaces.y = backEdgeY + 100
	
	places = 4
	decLabel = display.newText( screenGroup, places, 0, 0, "BerlinSansFB-Reg", 22 )
	decLabel.x = backEdgeX + 178
	decLabel.y = backEdgeY + 100
  
  measureLabel = display.newEmbossedText(backGroup, "Imperial", 0, 0, "BerlinSansFB-Reg", 20)
  measureLabel:setFillColor(1)
  measureLabel:setEmbossColor({highlight = {r=0, g=0, b=0, a=1}, shadow = {r=1,g=1,b=1, a=0}})
	measureLabel.x = backEdgeX + 115
	measureLabel.y = backEdgeY + 75
	
	numHolesText = display.newEmbossedText(backGroup, "No. of Holes:", 0, 0, "BerlinSansFB-Reg", 18)
  numHolesText:setFillColor(1)
  numHolesText:setEmbossColor({highlight = {r=0, g=0, b=0, a=1}, shadow = {r=1,g=1,b=1, a=0}})
	numHolesText.x = backEdgeX + 100
	numHolesText.y = backEdgeY + 140
	
	numHoles = display.newText( textOptionsL )
  backGroup:insert(numHoles)
	numHoles:addEventListener ( "touch", calcTouch )
	numHoles.anchorX = 0.5; numHoles.anchorY = 0.5; 
	numHoles.x = backEdgeX + 200
	numHoles.y = backEdgeY + 140
	numHoles.tap = 1
	tapTable[1] = numHoles
  numHoles.alpha = 0
  
  --numHolesTap = display.newSprite(tapSheet, tapAniSequenceData["tapAniv2"])
  numHolesTap = display.newImageRect(backGroup, "Images/tapTarget.png", 33, 33)
	numHolesTap.x = backEdgeX + 170
	numHolesTap.y = backEdgeY + 140
	numHolesTap:addEventListener ( "touch", calcTouch )
	numHolesTap.tap = 11
  aniTable[1] = numHolesTap
	--numHolesTap:play()
	
	diamText = display.newEmbossedText(backGroup, "Circle Diameter:", 0, 0, "BerlinSansFB-Reg", 18)
  diamText:setFillColor(1)
  diamText:setEmbossColor({highlight = {r=0, g=0, b=0, a=1}, shadow = {r=1,g=1,b=1, a=0}})
	diamText.x = backEdgeX + 111
	diamText.y = backEdgeY + 185
	
	diam = display.newText( textOptionsL )
	diam:addEventListener ( "touch", calcTouch )
	diam.anchorX = 0.5; diam.anchorY = 0.5; 
	diam.x = backEdgeX + 220
	diam.y = backEdgeY + 185
	diam.tap = 2
	tapTable[2] = diam
  diam.alpha = 0
  
  --diamTap = display.newSprite(tapSheet, tapAniSequenceData["tapAniv2"])
  diamTap = display.newImageRect(backGroup, "Images/tapTarget.png", 33, 33)
	diamTap.x = backEdgeX + 190
	diamTap.y = backEdgeY + 185
	backGroup:insert(diamTap)
	diamTap:addEventListener ( "touch", calcTouch )
	diamTap.tap = 12
  aniTable[2] = diamTap
	--diamTap:play()
	
	circleXtext = display.newEmbossedText(backGroup, "Circle Centre - X:", 0, 0, "BerlinSansFB-Reg", 18)
  circleXtext:setFillColor(1)
  circleXtext:setEmbossColor({highlight = {r=0, g=0, b=0, a=1}, shadow = {r=1,g=1,b=1, a=0}})
	circleXtext.x = backEdgeX + 116
	circleXtext.y = backEdgeY + 230
	circleXtext.alpha = 1
	
	circleX = display.newText( textOptionsL )
	circleX:addEventListener ( "touch", calcTouch )
	circleX.anchorX = 0.5; circleX.anchorY = 0.5; 
	circleX.x = backEdgeX + 225
	circleX.y = backEdgeY + 230
	circleX.tap = 3
	tapTable[3] = circleX
	circleX.alpha = 0
  
  --circleXTap = display.newSprite(tapSheet, tapAniSequenceData["tapAniv2"])
  circleXTap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
	circleXTap.x = backEdgeX + 205
	circleXTap.y = backEdgeY + 230
	backGroup:insert(circleXTap)
	circleXTap:addEventListener ( "touch", calcTouch )
	circleXTap.tap = 13
  circleXTap[3] = circleXTap
  circleXTap.alpha = 0
  aniTable[3] = circleXTap
	
	circleYtext = display.newEmbossedText(backGroup, "Circle Centre - Y:", 0, 0, "BerlinSansFB-Reg", 18)
  circleYtext:setFillColor(1)
  circleYtext:setEmbossColor({highlight = {r=0, g=0, b=0, a=1}, shadow = {r=1,g=1,b=1, a=0}})
	circleYtext.x = backEdgeX + 116
	circleYtext.y = backEdgeY + 275
	circleYtext.alpha = 1
	
	circleY = display.newText( textOptionsL )
	circleY:addEventListener ( "touch", calcTouch )
	circleY.anchorX = 0.5; circleY.anchorY = 0.5; 
	circleY.x = backEdgeX + 225
	circleY.y = backEdgeY + 275
	circleY.tap = 4
	tapTable[4] = circleY
	circleY.alpha = 0
  
  --circleYTap = display.newSprite(tapSheet, tapAniSequenceData["tapAniv2"])
  circleYTap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
	circleYTap.x = backEdgeX + 205
	circleYTap.y = backEdgeY + 275
	backGroup:insert(circleYTap)
	circleYTap:addEventListener ( "touch", calcTouch )
	circleYTap.tap = 14
  aniTable[4] = circleYTap
  circleYTap.alpha = 0
  aniTable[4] = circleYTap
	
	firstHoleText = display.newEmbossedText(backGroup, "First Hole Angle:", 0, 0, "BerlinSansFB-Reg", 18)
  firstHoleText:setFillColor(1)
  firstHoleText:setEmbossColor({highlight = {r=0, g=0, b=0, a=1}, shadow = {r=1,g=1,b=1, a=0}})
	firstHoleText.x = backEdgeX + 116
	firstHoleText.y = backEdgeY + 320
	firstHoleText.alpha = 1
	
	firstHole = display.newText( textOptionsL )
	firstHole:addEventListener ( "touch", calcTouch )
	firstHole.anchorX = 0.5; firstHole.anchorY = 0.5; 
	firstHole.x = backEdgeX + 225
	firstHole.y = backEdgeY + 320
	firstHole.tap = 5
	tapTable[5] = firstHole
	firstHole.alpha = 0
  
  --firstHoleTap = display.newSprite(tapSheet, tapAniSequenceData["tapAniv2"])
  firstHoleTap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
	firstHoleTap.x = backEdgeX + 200
	firstHoleTap.y = backEdgeY + 320
	backGroup:insert(firstHoleTap)
	firstHoleTap:addEventListener ( "touch", calcTouch )
	firstHoleTap.tap = 15
  aniTable[5] = firstHoleTap
  firstHoleTap.alpha = 0
  aniTable[5] = firstHoleTap
	
	answer = widget.newButton{
		left = 0,
		top = 0,
		width = 90,
		height = 35,
		font = "BerlinSansFB-Reg",
    fontSize = 14,
    labelColor = { default = {1}, over = {0.15, 0.4, 0.729}},
		label = "CALCULATE",
		id = "answer",
    defaultFile = "Images/chartButtD.png",
    overFile = "Images/chartButtO.png",
		onEvent = answerScene
		}
	backGroup:insert(answer)
	answer.x = backEdgeX + 430
	answer.y = backEdgeY + 300
	answer.alpha = 0
  
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