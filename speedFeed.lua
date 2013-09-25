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

local optionsGroup
local back, menuBack, backEdgeX, backEdgeY

local decStep, menu, reset, measure

local diam, surfaceSpeed, rpm, rev, minute, speedText, revText, minText
local decPlaces, places, decLabel, measureLabel

local whatTap, tapTable
local feedFlag, speedFlag

local stepSheet, buttSheet, tapSheet
local rpmTap, diamTap, revTap, surfaceSpeedTap, minuteTap
local options

local calc, clac2
local addListeners, removeListeners, toMill, toInch, goBack2

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
    
    storyboard.showOverlay( "help", { effect="zoomInOut", time=200, params = { helpType = "speed" }, isModal = true}  )
    
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
end

local function resetCalc(event)
	local phase = event.phase
		
		transition.to(rpm, {time = 300, alpha = 0})
		transition.to(diam, {time = 300, alpha = 0})
    transition.to(surfaceSpeed, {time = 300, alpha = 0})
		transition.to(rev, {time = 300, alpha = 0})
		transition.to(minute, {time = 300, alpha = 0})
    transition.to(rpmTap, {time = 300, alpha = 1})
		transition.to(diamTap, {time = 300, alpha = 1})
    transition.to(surfaceSpeedTap, {time = 300, alpha = 0})
		transition.to(revTap, {time = 300, alpha = 0})
		transition.to(minuteTap, {time = 300, alpha = 0})
    
    rpm.text = "Tap Me"
    diam.text = "Tap Me"
    surfaceSpeed.text = "Tap Me"
    minute.text = "Tap Me"
    rev.text = "Tap Me"
    
    speedFlag = false
    feedFlag = false
    
    for i = 1, 5, 1 do
      tapTable[i]:setTextColor(0, 0, 0)
    end
    
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
    if options then
				transition.to ( optionsGroup, { time = 500, x=(backEdgeX - 125) } )
				transition.to ( optionsGroup, { time = 500, alpha = 0, delay = 200} )
				transition.to ( optionsButt, {time = 500, x=(backEdgeX + 115)} )
				options = false
		end
		
    whatTap = event.target.tap
		
		storyboard.showOverlay( "calculator", { effect="fromTop", time=400, params = { negTrue = false, needDec = true }, isModal = true}  )
		
		return true
	end
end

local function measureChange( event )
	local phase = event.phase
	
	if "ended" == phase then	
		if measure:getLabel() == "TO METRIC" then
			measure:setLabel("TO IMPERIAL")
			measureLabel:setText("metric")
      speedText.text = "meters/min"
      minText.text = "mill"
      revText.text = "mill"
			for i = 2, 5, 1 do
				if tapTable[i].text ~= "Tap Me" then
					tapTable[i].text = math.round(toMill(tapTable[i].text) * math.pow(10, places)) / math.pow(10, places)

				end
			end
		else
			measure:setLabel("TO METRIC")
			measureLabel:setText("imperial")
      speedText.text = "feet/min"
      minText.text = "inch"
      revText.text = "inch"
			for i = 2, 5, 1 do
				if tapTable[i].text ~= "Tap Me" then
					tapTable[i].text = math.round(toInch(tapTable[i].text) * math.pow(10, places)) / math.pow(10, places)
				end
			end
		end
    if options then
				transition.to ( optionsGroup, { time = 500, x=(backEdgeX - 125) } )
				transition.to ( optionsGroup, { time = 500, alpha = 0, delay = 200} )
				transition.to ( optionsButt, {time = 500, x=(backEdgeX + 115)} )
				options = false
		end
	end	
	
	calc()
	
end

--End Listeners

function scene:createScene( event )
	local screenGroup = self.view
	
	tapTable = {}
	feedFlag = false
	speedFlag = false
  options = false
  optionsGroup = display.newGroup ( )
	local textOptionsR = {text="Tap Me", x=0, y=0, width=100, align="right", font="WCManoNegraBta", fontSize=24}
  local textOptionsC = {text="Tap Me", x=0, y=0, width=100, align="center", font="WCManoNegraBta", fontSize=24}
  local textOptionsL = {text="Tap Me", x=0, y=0, width=100, align="left", font="WCManoNegraBta", fontSize=24}
  
  Runtime:addEventListener( "key", onKeyEvent )
  Runtime:addEventListener( "touch", onScreenTouch  )
  
  stepSheet = graphics.newImageSheet("Images/customStep_customStep.png", stepperDataFile.getSpriteSheetData() )
	
	tapSheet = graphics.newImageSheet("Images/tapSheetv2_tapSheetv2.png", tapAniDataFile.getSpriteSheetData() )
	local tapAniSequenceDataFile = require("Images.tapAniv2");
	local tapAniSequenceData = tapAniSequenceDataFile:getAnimationSequences();
	
	back = display.newImageRect ( screenGroup, "backgrounds/speeds.png",  570, 360 )
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

--  decPlaces = display.newText( screenGroup, "dec places:", 0, 0, "Rock Salt", 16 )
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
		
	rpm = display.newText( textOptionsR )
  screenGroup:insert(rpm)
	rpm :addEventListener ( "touch", calcTouch )
	rpm .x = backEdgeX + 290
	rpm .y = backEdgeY + 170
	tapTable[1] = rpm 
	rpm.tap = 1
  rpm.alpha = 0
  
  rpmTap = display.newSprite(tapSheet, tapAniSequenceData["tapAniv2"])
	rpmTap.x = backEdgeX + 295
	rpmTap.y = backEdgeY + 170
	screenGroup:insert(rpmTap)
	rpmTap:addEventListener ( "touch", calcTouch )
	rpmTap.tap = 11
	rpmTap:play()
	
	diam = display.newText( textOptionsR )
  screenGroup:insert(diam)
	diam:addEventListener ( "touch", calcTouch )
	diam.x = backEdgeX + 305
	diam.y = backEdgeY + 260
	tapTable[2] = diam
	diam.tap = 2
  diam.alpha = 0
  
  diamTap = display.newSprite(tapSheet, tapAniSequenceData["tapAniv2"])
	diamTap.x = backEdgeX + 315
	diamTap.y = backEdgeY + 260
	screenGroup:insert(diamTap)
	diamTap:addEventListener ( "touch", calcTouch )
	diamTap.tap = 12
	diamTap:play()
	
	surfaceSpeed = display.newText( textOptionsR )
  screenGroup:insert(surfaceSpeed)
	surfaceSpeed:addEventListener ( "touch", calcTouch )
	surfaceSpeed.x = backEdgeX + 320
	surfaceSpeed.y = backEdgeY + 310
	surfaceSpeed.alpha = 0
	tapTable[3] = surfaceSpeed
	surfaceSpeed.tap = 3
  
  surfaceSpeedTap = display.newSprite(tapSheet, tapAniSequenceData["tapAniv2"])
	surfaceSpeedTap.x = backEdgeX + 330
	surfaceSpeedTap.y = backEdgeY + 310
	screenGroup:insert(surfaceSpeedTap)
	surfaceSpeedTap:addEventListener ( "touch", calcTouch )
	surfaceSpeedTap.tap = 13
	surfaceSpeedTap:play()
  surfaceSpeedTap.alpha = 0

	rev = display.newText( textOptionsL )
	rev:addEventListener ( "touch", calcTouch )
  screenGroup:insert(rev)
	rev.x = backEdgeX + 150
	rev.y = backEdgeY + 270
	rev.alpha = 0
	tapTable[4] = rev
	rev.tap = 4
  
  revTap = display.newSprite(tapSheet, tapAniSequenceData["tapAniv2"])
	revTap.x = backEdgeX + 140
	revTap.y = backEdgeY + 270
	screenGroup:insert(revTap)
	revTap:addEventListener ( "touch", calcTouch )
	revTap.tap = 14
	revTap:play()
  revTap.alpha = 0

	minute = display.newText( textOptionsL )
	minute:addEventListener ( "touch", calcTouch )
  screenGroup:insert(minute)
	minute.x = backEdgeX + 150
	minute.y = backEdgeY + 220
	minute.alpha = 0
	tapTable[5] = minute
	minute.tap = 5
  
  minuteTap = display.newSprite(tapSheet, tapAniSequenceData["tapAniv2"])
	minuteTap.x = backEdgeX + 140
	minuteTap.y = backEdgeY + 220
	screenGroup:insert(minuteTap)
	minuteTap:addEventListener ( "touch", calcTouch )
	minuteTap.tap = 15
	minuteTap:play()
  minuteTap.alpha = 0
	
	speedText = display.newText( screenGroup, "feet/min", 0, 0, "Rock Salt", 12 )
	speedText.alpha = 0.8
	speedText.x = backEdgeX + 470
	speedText.y = backEdgeY + 300
	
	revText = display.newText( screenGroup, "inch", 0, 0, "Rock Salt", 12 )
	revText:setReferencePoint(display.TopRightReferencePoint)
	revText.alpha = 0.8
	revText.x = backEdgeX + 94
	revText.y = backEdgeY + 230
	
	minText = display.newText( screenGroup, "inch", 0, 0, "Rock Salt", 12 )
	minText:setReferencePoint(display.TopRightReferencePoint)
	minText.alpha = 0.8
	minText.x = backEdgeX + 94
	minText.y = backEdgeY + 182
  
  for i = 1, 5, 1 do
    tapTable[i]:setTextColor(0, 0, 0)
  end
  
	
  optionsGroup:setReferencePoint(display.CenterReferencePoint)
	
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
  local group = self.view
        
		storyboard.purgeScene( "menu" )

end

function scene:exitScene( event )
  local group = self.view

	Runtime:removeEventListener( "touch", onScreenTouch  )
  Runtime:removeEventListener( "key", onKeyEvent )
   
end

function scene:destroyScene( event )
  local group = self.view

		optionsGroup:removeSelf()
   
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
    
    Runtime:addEventListener( "touch", onScreenTouch  )
    storyboard.isOverlay = false
    
  if storyboard.number ~= "Tap Me" then    
      
    if whatTap == 11 then
      rpm.alpha = 1
      rpmTap.alpha = 0
      revTap.alpha = 1
      minuteTap.alpha = 1
    elseif whatTap == 12 then
      surfaceSpeedTap.alpha = 1
      diamTap.alpha = 0
      diam.alpha = 1
    elseif whatTap == 13 then
      surfaceSpeedTap.alpha = 0
      surfaceSpeed.alpha = 1
--    elseif whatTap == 14 or whatTap == 15 then
--      revTap.alpha = 0
--      minuteTap.alpha = 0
--      rev.alpha = 1
--      minute.alpha = 1
    end
          	
    if whatTap > 5 then
      tapTable[whatTap - 10].text = storyboard.number
    else
      tapTable[whatTap].text = storyboard.number
    end
        
    if rpm.text ~= "Tap Me" and (rev.text ~= "Tap Me" or minute.text ~= "Tap Me") then
    	feedFlag = true
    else 
    	feedFlag = false
    end
    
    if diam.text ~= "Tap Me" and (rpm.text ~= "Tap Me" or surfaceSpeed.text ~= "Tap Me") then
    	speedFlag = true
    else
    	speedFlag = false
    end
    
    if rpm.text ~= "Tap Me" and diam.text ~= "Tap Me" and surfaceSpeed.text ~= "Tap Me" then
      --do nothing
    else
      calc()
    end
    
    if rev.text ~= "Tap Me" or minute.text ~= "Tap Me" then
      calc2()
    end
    
    if rpm.text ~= "Tap Me" then
      revTap.alpha = 1
      minuteTap.alpha = 1
    end
    
    if rev.text ~= "Tap Me" or minute.text ~= "Tap Me" then
      revTap.alpha = 0
      rev.alpha = 1
      minuteTap.alpha = 0
      minute.alpha = 1
    end
    
  end
end

function calc ()
	
	if speedFlag then
    	if measure:getLabel() == "TO METRIC" then
    		if rpm.text ~= "Tap Me" then
          surfaceSpeed.text = rpm.text * diam.text / 3.8197
          surfaceSpeed.alpha = 1
          surfaceSpeedTap.alpha = 0
          print("surface speed")
    		elseif surfaceSpeed.text ~= "Tap Me" then
          rpm.text = 3.8197 * surfaceSpeed.text / diam.text
          rpmTap.alpha = 0
          rpm.alpha = 1
    		end
    	elseif measure:getLabel() == "TO IMPERIAL" then
    		if rpm.text ~= "Tap Me" then
          surfaceSpeed.text = diam.text * rpm.text / 318.31
          surfaceSpeed.alpha = 1
          surfaceSpeedTap.alpha = 0
    		elseif surfaceSpeed.text ~= "Tap Me" then
          rpm.text = 318.31 * surfaceSpeed.text / diam.text
          rpmTap.alpha = 0
          rpm.alpha = 1
    		end    			
    	end
      
      for i = 1, 5, 1 do
			if tapTable[i].text ~= "Tap Me" then
				if i == 1 then
					tapTable[1].text = math.round(tapTable[1].text * math.pow(10, 0)) / math.pow(10, 0)
				else
				tapTable[i].text = math.round(tapTable[i].text * math.pow(10, places)) / math.pow(10, places)
				end
			end
      end
    
      timer.performWithDelay( 10, removeListeners, 2 )
      for i = 1, 3, 1 do
        tapTable[i]:setTextColor(255, 255, 255)
      end
    end	
	
end

function calc2()
  
      if feedFlag then
    	if (minute.text ~= "Tap Me") and (whatTap == 5 or whatTap == 15) then
    		rev.text = minute.text / rpm.text
        tapTable[4].text = math.round(tapTable[4].text * math.pow(10, places)) / math.pow(10, places)
    	elseif (rev.text ~= "Tap Me") and (whatTap == 4 or whatTap == 14) then
    		minute.text = rev.text * rpm.text
        tapTable[5].text = math.round(tapTable[5].text * math.pow(10, places)) / math.pow(10, places)
    	end
    end
end

function addListeners()
  
  rpm:addEventListener ( "touch", calcTouch )
  diam:addEventListener ( "touch", calcTouch )
  surfaceSpeed:addEventListener ( "touch", calcTouch )
  
end

function removeListeners()
  
  rpm:removeEventListener ( "touch", calcTouch )
  diam:removeEventListener ( "touch", calcTouch )
  surfaceSpeed:removeEventListener ( "touch", calcTouch )
  
end
  

function toMill(num)

	return num * 25.4	

end

function toInch(num)
	
	return num / 25.4
	
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