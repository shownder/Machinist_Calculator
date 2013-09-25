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

local stepperDataFile = require("Images.customStep_customStep")
local tapAniDataFile = require("Images.tapSheetv2_tapSheetv2")

--Local forward references

local back, menuBack, backEdgeX, backEdgeY, optionsGroup

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

local function onScreenTouch( event )
	if event.phase == "ended" then
		
		if event.xStart < event.x and (event.x - event.xStart) >= 30 then
			transition.to ( optionsGroup, { time = 500, x=(backEdgeX + 118) } )
			transition.to ( optionsGroup, { time = 500, alpha = 1, delay = 200} )
			options = true
			return true

		elseif event.xStart > event.x and (event.xStart - event.x) >= 30 then 
	    transition.to ( optionsGroup, { time = 500, x=(backEdgeX - 125) } )
			transition.to ( optionsGroup, { time = 500, alpha = 0, delay = 200} )
			options = false
	        return true
	end
	end 
endlocal function measureChange( event )
	local phase = event.phase
	
	if "ended" == phase then	
		if measure:getLabel() == "TO METRIC" then
			measure:setLabel("TO IMPERIAL")
			measureLabel:setText("metric")
			if diam.text ~= "Tap Me" then
				diam.text = math.round(toMill(diam.text) * math.pow(10, places)) / math.pow(10, places)
			end
		else
			measure:setLabel("TO METRIC")
			measureLabel:setText("imperial")
			if diam.text ~= "Tap Me" then
				diam.text = math.round(toInch(diam.text) * math.pow(10, places)) / math.pow(10, places)
			end
		end
	end
	if options then
				transition.to ( optionsGroup, { time = 500, x=(backEdgeX - 125) } )
				transition.to ( optionsGroup, { time = 500, alpha = 0, delay = 200} )
				transition.to ( optionsButt, {time = 500, x=(backEdgeX + 115)} )
				options = false
		endend

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
		
    Runtime:removeEventListener( "touch", onScreenTouch  )
    Runtime:removeEventListener( "touch", onScreenTouch  )
    
    whatTap = event.target.tap
    
    calcClick = true
    
    if whatTap >= 6 then
      whatTap = whatTap - 10
    end
    
		if whatTap == 3 or whatTap == 4 then
			storyboard.showOverlay( "calculator", { effect="fromTop", time=400, params = { negTrue = true, needDec = true }, isModal = true}  )
		elseif whatTap == 1 then
			storyboard.showOverlay( "calculator", { effect="fromTop", time=400, params = { negTrue = false, needDec = false }, isModal = true} )		else			storyboard.showOverlay( "calculator", { effect="fromTop", time=400, params = { negTrue = false, needDec = true }, isModal = true} )
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
    transition.to(circleXtext, {time = 300, alpha = 0})
		transition.to(circleYtext, {time = 300, alpha = 0})
		transition.to(firstHoleText, {time = 300, alpha = 0})
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
    
    --addListener()
    
    timer.performWithDelay( 10, addListeners )
    
    if options then
				transition.to ( optionsGroup, { time = 500, x=(backEdgeX - 125) } )
				transition.to ( optionsGroup, { time = 500, alpha = 0, delay = 200} )
				transition.to ( optionsButt, {time = 500, x=(backEdgeX + 115)} )
				options = false
		end		
end

local function goBack (event)
	if event.phase == "ended" then
    
    transition.to (optionsGroup, { time = 100, alpha = 0 } )
		storyboard.gotoScene( "menu", { effect="slideRight", time=800})
    
	end
end

local function answerScene( event )
	if event.phase == "ended" then
    
    Runtime:removeEventListener( "touch", onScreenTouch  )
		
		storyboard.answer = bolts(numHoles.text, diam.text, circleX.text, circleY.text, firstHole.text)
    bolts2(numHoles.text, diam.text, circleX.text, circleY.text, firstHole.text)
    storyboard.answerX = answerX
    storyboard.answerY = answerY
    storyboard.diam = diam.text
    
    calcClick = false
    
		storyboard.showOverlay( "boltAnswer", { effect="fromTop", time=400 }  )
				
		return true
	end
endlocal function alertListener ( event )
	if "clicked" == event.action then
		
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
  Runtime:addEventListener( "touch", onScreenTouch  )
  
  optionsGroup = display.newGroup ( )
  local textOptionsL = {parent = screenGroup, text="Tap Me", x=0, y=0, width=80, height=0, font="WCManoNegraBta", fontSize=24, align="left"}
  
  stepSheet = graphics.newImageSheet("Images/customStep_customStep.png", stepperDataFile.getSpriteSheetData() )
	
	tapSheet = graphics.newImageSheet("Images/tapSheetv2_tapSheetv2.png", tapAniDataFile.getSpriteSheetData() )
	local tapAniSequenceDataFile = require("Images.tapAniv2");
	local tapAniSequenceData = tapAniSequenceDataFile:getAnimationSequences();
	
	back = display.newImageRect ( screenGroup, "backgrounds/bolt.png",  570, 360 )
	back.x = display.contentCenterX
	back.y = display.contentCenterY		
	backEdgeX = back.contentBounds.xMin
	backEdgeY = back.contentBounds.yMin
  
  menuBack = display.newImageRect( optionsGroup, "backgrounds/optionsBack.png", 143, 294 )
  menuBack.x = backEdgeX + 120
  menuBack.y = backEdgeY + 180
  
    helpButt = widget.newButton
	{
		id = "helpButt",
		--label = "HELP",
		--labelColor = { default = {0, 0, 0, 150}, over = {192, 192, 192}},
		--font = "Rock Salt",
		fontSize = 16,
		onEvent = helpScreen,
		defaultFile = "Images/infoButt.png",
		overFile = "Images/infoButtOver.png",
		}
	optionsGroup:insert(helpButt)
	helpButt.x = backEdgeX + 105
	helpButt.y = backEdgeY + 85
	
	decStep = widget.newStepper
    {		
		left = 0,
		top = 0,
		initialValue = 4,
		minimumValue = 2,
		maximumValue = 5,
		sheet = stepSheet,
		defaultFrame = 1,
		noMinusFrame = 4,
		noPlusFrame = 5,
		minusActiveFrame = 2,
		plusActiveFrame = 3,
		onPress = stepPress,		
		}
    optionsGroup:insert(decStep)
    decStep.x = backEdgeX + 105
    decStep.y = backEdgeY + 120
    
  measure = widget.newButton
	{
		id = "measureButt",
		label = "TO METRIC",
		labelColor = { default = {0, 0, 0, 150}, over = {192, 192, 192}},
		--font = "Rock Salt",
		fontSize = 16,
		onEvent = measureChange,
		defaultFile = "Images/buttonDefault.png",
		overFile = "Images/buttonOver.png",
		}
    optionsGroup:insert(measure)
    measure.x = backEdgeX + 115
    measure.y = backEdgeY + 170
    
  menu = widget.newButton
	{
		id = "menuButt",
		label = "MENU",
		labelColor = { default = {0, 0, 0, 150}, over = {192, 192, 192}},
		--font = "WCManoNegraBta",
		fontSize = 16,
		onRelease = goBack,

		defaultFile = "Images/buttonDefault.png",
		overFile = "Images/buttonOver.png",
		}
    optionsGroup:insert(menu)
    menu.x = backEdgeX + 115
    menu.y = backEdgeY + 230
    
  reset = widget.newButton
	{
		id = "resetButt",
		label = "RESET",
		labelColor = { default = {128, 0, 0, 150}, over = {192, 192, 192}},
		--font = "Rock Salt",
		fontSize = 18,
		onEvent = resetCalc,

		defaultFile = "Images/buttonDefault.png",
		overFile = "Images/buttonOver.png",
		}
    optionsGroup:insert(reset)
    reset.x = backEdgeX + 115
    reset.y = backEdgeY + 290
    
  optionsGroup.alpha = 0
  transition.to ( optionsGroup, { time = 500, alpha = 1, delay = 500} )
  transition.to ( optionsGroup, { time = 500, x=(backEdgeX - 125), delay = 1300} )
  transition.to ( optionsGroup, { time = 500, alpha = 0, delay = 1500} )
  
  decPlaces = display.newEmbossedText( screenGroup, "dec places:", 0, 0, "Rock Salt", 16 )
  decPlaces:setTextColor(255)
  decPlaces:setEmbossColor({highlight = {r=0, g=0, b=0, a=200}, shadow = {r=0,g=0,b=0, a=0}})
  decPlaces.x = backEdgeX + 120
  decPlaces.y = backEdgeY + 117
		
--	decPlaces = display.newText( screenGroup, "dec places:", 0, 0, "Rock Salt", 16 )
--  decPlaces.x = backEdgeX + 120
--  decPlaces.y = backEdgeY + 120

	places = 4
	decLabel = display.newText( screenGroup, places, 0, 0, "WCManoNegraBta", 18 )
	decLabel.x = backEdgeX + 180
	decLabel.y = backEdgeY + 117
  
  measureLabel = display.newEmbossedText(screenGroup, "imperial", 0, 0, "Rock Salt", 16)
  measureLabel:setTextColor(255)
  measureLabel:setEmbossColor({highlight = {r=0, g=0, b=0, a=200}, shadow = {r=0,g=0,b=0, a=0}})
  measureLabel.x = backEdgeX + 115
  measureLabel.y = backEdgeY + 90
  
--  measureLabel = display.newText( screenGroup, "imperial", 0, 0, "Rock Salt", 16 )
--  measureLabel.x = backEdgeX + 115
--  measureLabel.y = backEdgeY + 90
	
	numHolesText = display.newText( screenGroup, "no. of holes: ", 0, 0, "Rock Salt", 12 )
	numHolesText.x = backEdgeX + 105
	numHolesText.y = backEdgeY + 160
	
	numHoles = display.newText( textOptionsL )
	numHoles:addEventListener ( "touch", calcTouch )
	numHoles:setReferencePoint(display.topLeftReferencePoint)
	numHoles.x = backEdgeX + 190
	numHoles.y = backEdgeY + 160
	numHoles.tap = 1
	tapTable[1] = numHoles
  numHoles.alpha = 0
  
  numHolesTap = display.newSprite(tapSheet, tapAniSequenceData["tapAniv2"])
	numHolesTap.x = backEdgeX + 190
	numHolesTap.y = backEdgeY + 160
	screenGroup:insert(numHolesTap)
	numHolesTap:addEventListener ( "touch", calcTouch )
	numHolesTap.tap = 11
  aniTable[1] = numHolesTap
	numHolesTap:play()
	
	diamText = display.newText( screenGroup, "circle diameter: ", 0, 0, "Rock Salt", 12 )
	diamText.x = backEdgeX + 122
	diamText.y = backEdgeY + 190
	
	diam = display.newText( textOptionsL )
	diam:addEventListener ( "touch", calcTouch )
	diam:setReferencePoint(display.topLeftReferencePoint)
	diam.x = backEdgeX + 225
	diam.y = backEdgeY + 190
	diam.tap = 2
	tapTable[2] = diam
  diam.alpha = 0
  
  diamTap = display.newSprite(tapSheet, tapAniSequenceData["tapAniv2"])
	diamTap.x = backEdgeX + 225
	diamTap.y = backEdgeY + 190
	screenGroup:insert(diamTap)
	diamTap:addEventListener ( "touch", calcTouch )
	diamTap.tap = 12
  aniTable[2] = diamTap
	diamTap:play()
	
	circleXtext = display.newText( screenGroup, "circle centre - X: ", 0, 0, "Rock Salt", 12 )
	circleXtext.x = backEdgeX + 128
	circleXtext.y = backEdgeY + 230
	circleXtext.alpha = 0
	
	circleX = display.newText( textOptionsL )
	circleX:addEventListener ( "touch", calcTouch )
	circleX:setReferencePoint(display.topLeftReferencePoint)
	circleX.x = backEdgeX + 235
	circleX.y = backEdgeY + 230
	circleX.tap = 3
	tapTable[3] = circleX
	circleX.alpha = 0
  
  circleXTap = display.newSprite(tapSheet, tapAniSequenceData["tapAniv2"])
	circleXTap.x = backEdgeX + 235
	circleXTap.y = backEdgeY + 230
	screenGroup:insert(circleXTap)
	circleXTap:addEventListener ( "touch", calcTouch )
	circleXTap.tap = 13
  circleXTap[3] = circleXTap
  circleXTap.alpha = 0
  aniTable[3] = circleXTap
	
	circleYtext = display.newText( screenGroup, "circle centre - Y: ", 0, 0, "Rock Salt", 12 )
	circleYtext.x = backEdgeX + 128
	circleYtext.y = backEdgeY + 270
	circleYtext.alpha = 0
	
	circleY = display.newText( textOptionsL )
	circleY:addEventListener ( "touch", calcTouch )
	circleY:setReferencePoint(display.topLeftReferencePoint)
	circleY.x = backEdgeX + 235
	circleY.y = backEdgeY + 270
	circleY.tap = 4
	tapTable[4] = circleY
	circleY.alpha = 0
  
  circleYTap = display.newSprite(tapSheet, tapAniSequenceData["tapAniv2"])
	circleYTap.x = backEdgeX + 235
	circleYTap.y = backEdgeY + 270
	screenGroup:insert(circleYTap)
	circleYTap:addEventListener ( "touch", calcTouch )
	circleYTap.tap = 14
  aniTable[4] = circleYTap
  circleYTap.alpha = 0
  aniTable[4] = circleYTap
	
	firstHoleText = display.newText( screenGroup, "first hole angle: ", 0, 0, "Rock Salt", 12 )
	firstHoleText.x = backEdgeX + 123
	firstHoleText.y = backEdgeY + 310
	firstHoleText.alpha = 0
	
	firstHole = display.newText( textOptionsL )
	firstHole:addEventListener ( "touch", calcTouch )
	firstHole:setReferencePoint(display.topLeftReferencePoint)
	firstHole.x = backEdgeX + 225
	firstHole.y = backEdgeY + 310
	firstHole.tap = 5
	tapTable[5] = firstHole
	firstHole.alpha = 0
  
  firstHoleTap = display.newSprite(tapSheet, tapAniSequenceData["tapAniv2"])
	firstHoleTap.x = backEdgeX + 225
	firstHoleTap.y = backEdgeY + 310
	screenGroup:insert(firstHoleTap)
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
		--font = "WCManoNegraBta",
    --fontSize = 24,
		label = "CALCULATE",
		id = "answer",
		onEvent = answerScene
		}
	screenGroup:insert(answer)
	answer.x = backEdgeX + 430
	answer.y = backEdgeY + 300
	answer.alpha = 0
  
  for i = 1, 5, 1 do
    tapTable[i]:setTextColor(0, 0, 0)
  end
    
  optionsGroup:setReferencePoint(display.CenterReferencePoint)
	
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )	local group = self.view
        
		storyboard.purgeScene( "menu" )

end

function scene:exitScene( event )
   local group = self.view

		Runtime:removeEventListener( "touch", onScreenTouch  )
    Runtime:removeEventListener( "key", onKeyEvent )
   
endfunction scene:destroyScene( event )
   local group = self.view

		optionsGroup:removeSelf()
   
end

scene:addEventListener( "createScene", scene )

scene:addEventListener( "enterScene", scene )

scene:addEventListener( "exitScene", scene )scene:addEventListener( "destroyScene", scene )

--Overlay
-- the following event is dispatched once overlay is enabled
function scene:overlayBegan( event )
    print( "Showing overlay: " .. event.sceneName )
end

-- the following event is dispatched once overlay is removed
function scene:overlayEnded( event )
    local group = self.view
    
    Runtime:addEventListener( "touch", onScreenTouch  )
    storyboard.isOverlay = false
    
    if storyboard.number ~= "Tap Me" then
    
    if calcClick == true then
    
    tapTable[whatTap].text = storyboard.number        if whatTap == 1 then    	if tonumber(numHoles.text)  <= 0 then    		native.showAlert ( "Error", "You need more than 0 holes!", { "OK" }, alertListener )    		numHoles.text = "Tap Me"    	end    elseif whatTap == 2 then      	  if tonumber(diam.text)  <= 0 then    		native.showAlert ( "Error", "Diameter must be greater than 0!", { "OK" }, alertListener )    		diam.text = "Tap Me"      	  end    end
        
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
		local temp = {}		if circleX == "Tap Me" then		circleX = 0	end		if circleY == "Tap Me" then		circleY = 0	end		if firstHole == "Tap Me" then		firstHole = 0	end
	
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