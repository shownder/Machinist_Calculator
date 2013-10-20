--
-- Project: Trades Math Calculator
-- Description: 
--
-- Version: 1.0
-- Managed with http://CoronaProjectManager.com
--
-- Copyright 2013 . All Rights Reserved.
-- 

--Require
local widget = require ( "widget" )
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local stepperDataFile = require("Images.stepSheet_stepSheet")
--local tapAniDataFile = require("Images.tapSheetv2_tapSheetv2")

--Local forward references

local back, menuBack, backEdgeX, backEdgeY, optionsGroup, backGroup

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

local function helpScreen(event)
	local phase = event.phase
  
  if "ended" == phase then	

    if options then
				transition.to ( optionsGroup, { time = 500, x=(backEdgeX - 125) } )
				transition.to ( optionsGroup, { time = 500, alpha = 0, delay = 200} )
				transition.to ( optionsButt, {time = 500, x=(backEdgeX + 115)} )
				options = false
    end
    
    Runtime:removeEventListener( "touch", onScreenTouch  )
    
    storyboard.showOverlay( "help", { effect="zoomInOut", time=200, params = { helpType = "bolt" }, isModal = true}  )
    
  end
      
end

local function optionsMove(event)
	local phase = event.phase
  if "ended" == phase then
		
    if not options then
      options = true
      transition.to ( optionsBack, { time = 200, x = -50 } )
      transition.to ( optionsBack, { time = 200, y = 0 } )
			transition.to ( optionsGroup, { time = 500, alpha = 1} )
      transition.to ( backGroup, { time = 200, x=400 } )
      transition.to (decLabel, { time = 200, x = backEdgeX - 43, y = backEdgeY + 110} )
      decLabel:setTextColor(39, 102, 186)
		elseif options then 
			transition.to ( optionsGroup, { time = 100, alpha = 0} )
      transition.to ( backGroup, { time = 200, x=display.contentCenterX } )
      transition.to ( optionsBack, { time = 200, x = -170 } )
      transition.to ( optionsBack, { time = 200, y = -335 } )
      transition.to (decLabel, { time = 200, x = backEdgeX + 177, y = backEdgeY + 100} )
      decLabel:setTextColor(255)
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
      transition.to ( backGroup, { time = 200, x=display.contentCenterX } )
      transition.to ( optionsBack, { time = 200, x = -170 } )
      transition.to ( optionsBack, { time = 200, y = -335 } )
      transition.to (decLabel, { time = 200, x = backEdgeX + 177, y = backEdgeY + 100} )
      decLabel:setTextColor(255)
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
			storyboard.showOverlay( "calculator", { effect="fromRight", time=400, params = { negTrue = true, needDec = true }, isModal = true}  )
		elseif whatTap == 1 then
			storyboard.showOverlay( "calculator", { effect="fromRight", time=400, params = { negTrue = false, needDec = false }, isModal = true} )
		elseif isDegree then
			storyboard.showOverlay( "calculator", { effect="fromRight", time=400, params = { negTrue = false, needDec = true, isDegree = true }, isModal = true} )
     else
       storyboard.showOverlay( "calculator", { effect="fromRight", time=400, params = { negTrue = false, needDec = true, isDegree = false }, isModal = true} )
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
      transition.to ( backGroup, { time = 200, x=display.contentCenterX } )
      transition.to ( optionsBack, { time = 200, x = -170 } )
      transition.to ( optionsBack, { time = 200, y = -335 } )
      transition.to (decLabel, { time = 200, x = backEdgeX + 177, y = backEdgeY + 100} )
      decLabel:setTextColor(255)
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
	storyboard.gotoScene( "menu", { effect="slideRight", time=800})
	return true
	end
end

local function answerScene( event )
	if event.phase == "ended" then
		
		storyboard.answer = bolts(numHoles.text, diam.text, circleX.text, circleY.text, firstHole.text)
    bolts2(numHoles.text, diam.text, circleX.text, circleY.text, firstHole.text)
    storyboard.answerX = answerX
    storyboard.answerY = answerY
    storyboard.diam = diam.text
    
    calcClick = false
    
		storyboard.showOverlay( "boltAnswer", { effect="fromRight", time=400, isModal = true }  )
				
		return true
	end
end

--End Listeners

function scene:createScene( event )
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
	
--	tapSheet = graphics.newImageSheet("Images/tapSheetv2_tapSheetv2.png", tapAniDataFile.getSpriteSheetData() )
--	local tapAniSequenceDataFile = require("Images.tapAniv2");
--	local tapAniSequenceData = tapAniSequenceDataFile:getAnimationSequences();
	
  back = display.newImageRect( screenGroup, "backgrounds/background.png", 570, 360 )
	back.x = display.contentCenterX
	back.y = display.contentCenterY		
	backEdgeX = back.contentBounds.xMin
	backEdgeY = back.contentBounds.yMin
  
  rightDisplay = display.newImageRect(backGroup, "backgrounds/bolt.png", 570, 360)
  rightDisplay.x = display.contentCenterX
  rightDisplay.y = display.contentCenterY  
  
--    helpButt = widget.newButton
--	{
--		id = "helpButt",
--		--label = "HELP",
--		--labelColor = { default = {0, 0, 0, 150}, over = {192, 192, 192}},
--		--font = "Rock Salt",
--		fontSize = 16,
--		onEvent = helpScreen,
--		defaultFile = "Images/infoButt.png",
--		overFile = "Images/infoButtOver.png",
--		}
--	optionsGroup:insert(helpButt)
--	helpButt.x = backEdgeX + 105
--	helpButt.y = backEdgeY + 85
	
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
		label = "TO METRIC",
		labelColor = { default = {39, 102, 186, 200}, over = {255, 255, 255}},
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
		label = "MENU",
		labelColor = { default = {39, 102, 186, 200}, over = {255, 255, 255}},
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
		label = "RESET",
		labelColor = { default = {39, 102, 186, 200}, over = {255, 255, 255}},
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
  optionsBack:setFillColor(255, 255, 255)
  optionsBack:setReferencePoint(display.TopLeftReferencePoint)
  optionsBack.x = -170
  optionsBack.y = -335  
  
  optionsButt = display.newImageRect(screenGroup, "Images/Options.png", 38, 38)
  optionsButt.x = 15
  optionsButt.y = 15
  optionsButt:addEventListener ( "touch", optionsMove )
  optionsButt.isHitTestable = true
	
	decPlaces = display.newEmbossedText( backGroup, "Decimal Places:", 0, 0, "BerlinSansFB-Reg", 16 )
  decPlaces:setTextColor(255)
  decPlaces:setEmbossColor({highlight = {r=0, g=0, b=0, a=200}, shadow = {r=0,g=0,b=0, a=0}})
	decPlaces.x = backEdgeX + 115
	decPlaces.y = backEdgeY + 100
	
	places = 4
	decLabel = display.newText( backGroup, places, 0, 0, "BerlinSansFB-Reg", 22 )
	decLabel.x = backEdgeX + 178
	decLabel.y = backEdgeY + 100
  
  measureLabel = display.newEmbossedText(backGroup, "Imperial", 0, 0, "BerlinSansFB-Reg", 20)
  measureLabel:setTextColor(255)
  measureLabel:setEmbossColor({highlight = {r=0, g=0, b=0, a=200}, shadow = {r=0,g=0,b=0, a=0}})
	measureLabel.x = backEdgeX + 115
	measureLabel.y = backEdgeY + 75
	
	numHolesText = display.newEmbossedText(backGroup, "No. of Holes:", 0, 0, "BerlinSansFB-Reg", 18)
  numHolesText:setTextColor(255)
  numHolesText:setEmbossColor({highlight = {r=0, g=0, b=0, a=200}, shadow = {r=0,g=0,b=0, a=0}})
	numHolesText.x = backEdgeX + 100
	numHolesText.y = backEdgeY + 140
	
	numHoles = display.newText( textOptionsL )
  backGroup:insert(numHoles)
	numHoles:addEventListener ( "touch", calcTouch )
	numHoles:setReferencePoint(display.topLeftReferencePoint)
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
  diamText:setTextColor(255)
  diamText:setEmbossColor({highlight = {r=0, g=0, b=0, a=200}, shadow = {r=0,g=0,b=0, a=0}})
	diamText.x = backEdgeX + 111
	diamText.y = backEdgeY + 185
	
	diam = display.newText( textOptionsL )
	diam:addEventListener ( "touch", calcTouch )
	diam:setReferencePoint(display.topLeftReferencePoint)
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
  circleXtext:setTextColor(255)
  circleXtext:setEmbossColor({highlight = {r=0, g=0, b=0, a=200}, shadow = {r=0,g=0,b=0, a=0}})
	circleXtext.x = backEdgeX + 116
	circleXtext.y = backEdgeY + 230
	circleXtext.alpha = 1
	
	circleX = display.newText( textOptionsL )
	circleX:addEventListener ( "touch", calcTouch )
	circleX:setReferencePoint(display.topLeftReferencePoint)
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
  circleYtext:setTextColor(255)
  circleYtext:setEmbossColor({highlight = {r=0, g=0, b=0, a=200}, shadow = {r=0,g=0,b=0, a=0}})
	circleYtext.x = backEdgeX + 116
	circleYtext.y = backEdgeY + 275
	circleYtext.alpha = 1
	
	circleY = display.newText( textOptionsL )
	circleY:addEventListener ( "touch", calcTouch )
	circleY:setReferencePoint(display.topLeftReferencePoint)
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
  firstHoleText:setTextColor(255)
  firstHoleText:setEmbossColor({highlight = {r=0, g=0, b=0, a=200}, shadow = {r=0,g=0,b=0, a=0}})
	firstHoleText.x = backEdgeX + 116
	firstHoleText.y = backEdgeY + 320
	firstHoleText.alpha = 1
	
	firstHole = display.newText( textOptionsL )
	firstHole:addEventListener ( "touch", calcTouch )
	firstHole:setReferencePoint(display.topLeftReferencePoint)
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
		width = 150,
		height = 35,
		font = "BerlinSansFB-Reg",
    fontSize = 20,
		label = "CALCULATE",
		id = "answer",
		onEvent = answerScene
		}
	backGroup:insert(answer)
	answer.x = backEdgeX + 430
	answer.y = backEdgeY + 300
	answer.alpha = 0
  
	optionsGroup:setReferencePoint(display.CenterReferencePoint)
  backGroup:setReferencePoint(display.CenterReferencePoint)
  backGroup.alpha = 0
  transition.to ( backGroup, { time = 500, alpha = 1, delay = 200} )
  optionsBack.alpha = 0
  transition.to ( optionsBack, { time = 500, alpha = 1, delay = 600} )
  optionsButt.alpha = 0
  transition.to ( optionsButt, { time = 500, alpha = 1, delay = 600} )
  
  screenGroup:insert(backGroup)
	
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
        
		storyboard.purgeScene( "menu" )

end

function scene:exitScene( event )
   local group = self.view

    Runtime:removeEventListener( "key", onKeyEvent )
   
end

function scene:destroyScene( event )
   local group = self.view

		optionsGroup:removeSelf()
    backGroup:removeSelf()
   
end

scene:addEventListener( "createScene", scene )

scene:addEventListener( "enterScene", scene )

scene:addEventListener( "exitScene", scene )

scene:addEventListener( "destroyScene", scene )

--Overlay
-- the following event is dispatched once overlay is enabled
function scene:overlayBegan( event )
    print( "Showing overlay: " .. event.sceneName )
end

-- the following event is dispatched once overlay is removed
function scene:overlayEnded( event )
    local group = self.view
    
    storyboard.isOverlay = false
    
    if storyboard.number ~= "Tap Me" then
    
    if calcClick == true then
    
    tapTable[whatTap].text = storyboard.number
    
    if whatTap == 1 then
    	if tonumber(numHoles.text)  <= 0 then
    		native.showAlert ( "Error", "You need more than 0 holes!", { "OK" }, alertListener )
    		numHoles.text = "Tap Me"
    	end
    elseif whatTap == 2 then    
  	  if tonumber(diam.text)  <= 0 then
    		native.showAlert ( "Error", "Diameter must be greater than 0!", { "OK" }, alertListener )
    		diam.text = "Tap Me"    
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
	
	--Inches/Mill Functions
	
function toMill(num)

	return num * 25.4	

end

function toInch(num)
	
	return num / 25.4
	
end

function bolts(numHoles, diam, circleX, circleY, firstHole)
	
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

function bolts2(numHoles, diam, circleX, circleY, firstHole)
	
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

function goBack2()
	
  if (storyboard.isOverlay) then
    storyboard.number = "Tap Me"
    storyboard.hideOverlay()
  else
		storyboard.gotoScene( "menu", { effect="slideRight", time=800})
  end
		
end
	
scene:addEventListener( "overlayEnded" )

scene:addEventListener( "overlayBegan" )

return scene