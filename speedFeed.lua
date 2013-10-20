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

local optionsGroup, backGroup
local back, menuBack, backEdgeX, backEdgeY

local decStep, menu, reset, measure

local diam, surfaceSpeed, rpm, rev, minute, speedText, revText, minText
local decPlaces, places, decLabel, measureLabel

local whatTap, tapTable, aniTap
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
      transition.to (decLabel, { time = 200, x = backEdgeX + 177, y = backEdgeY + 115} )
      decLabel:setTextColor(255)
			options = false
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
    
    timer.performWithDelay( 10, addListeners )
    
    if options then
			transition.to ( optionsGroup, { time = 100, alpha = 0} )
      transition.to ( backGroup, { time = 200, x=display.contentCenterX } )
      transition.to ( optionsBack, { time = 200, x = -170 } )
      transition.to ( optionsBack, { time = 200, y = -335 } )
      transition.to (decLabel, { time = 200, x = backEdgeX + 177, y = backEdgeY + 115} )
      decLabel:setTextColor(255)
			options = false
		end		
end

local function alertListener ( event )
	if "clicked" == event.action then
    local i = event.index
    if 1 == i then
     timer.performWithDelay( 1000, resetCalc("ended") )
     if options then
			transition.to ( optionsGroup, { time = 100, alpha = 0} )
      transition.to ( backGroup, { time = 500, x=display.contentCenterX, delay = 200 } )
      transition.to ( optionsBack, { time = 500, x = -170 } )
      transition.to ( optionsBack, { time = 500, y = -335 } )
		end
			--tapCount = tapCount + 1
      whatTap = whatTap + 10
      storyboard.showOverlay( "calculator", { effect="fromTop", time=200, params = { negTrue = false, needDec = true }, isModal = true }  )
    elseif 2 == i then
      print("Cancel was pressed")
    end
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
    
    local continue = false
    
    for i = 1, 3, 1 do
      if tapTable[i].text == "Tap Me" then
         continue = true
      end
    end
    
    if options then
			transition.to ( optionsGroup, { time = 100, alpha = 0} )
      transition.to ( backGroup, { time = 200, x=display.contentCenterX } )
      transition.to ( optionsBack, { time = 200, x = -170 } )
      transition.to ( optionsBack, { time = 200, y = -335 } )
      transition.to (decLabel, { time = 200, x = backEdgeX + 177, y = backEdgeY + 115} )
      decLabel:setTextColor(255)
			options = false
		end
		
    whatTap = event.target.tap
    
    if whatTap > 3 then
      continue = true
    end
    		
    if not continue then
      native.showAlert ("Continue?", "Press OK to reset all values and continue.", { "OK", "Cancel" }, alertListener )
    else
      storyboard.showOverlay( "calculator", { effect="fromRight", time=200, params = { negTrue = false, needDec = true }, isModal = true }  )
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
      speedText.text = "meters/min"
      minText.text = "Mill"
      revText.text = "Mill"
			for i = 2, 5, 1 do
				if tapTable[i].text ~= "Tap Me" then
					tapTable[i].text = math.round(toMill(tapTable[i].text) * math.pow(10, places)) / math.pow(10, places)

				end
			end
		else
			measure:setLabel("TO METRIC")
			measureLabel:setText("Imperial")
      speedText.text = "feet/min"
      minText.text = "Inch"
      revText.text = "Inch"
			for i = 2, 5, 1 do
				if tapTable[i].text ~= "Tap Me" then
					tapTable[i].text = math.round(toInch(tapTable[i].text) * math.pow(10, places)) / math.pow(10, places)
				end
			end
		end
    if options then
			transition.to ( optionsGroup, { time = 100, alpha = 0} )
      transition.to ( backGroup, { time = 200, x=display.contentCenterX } )
      transition.to ( optionsBack, { time = 200, x = -170 } )
      transition.to ( optionsBack, { time = 200, y = -335 } )
      transition.to (decLabel, { time = 200, x = backEdgeX + 177, y = backEdgeY + 115} )
      decLabel:setTextColor(255)
			options = false
		end
	end	
	
	calc()
	
end

--End Listeners

function scene:createScene( event )
	local screenGroup = self.view
	
	tapTable = {}
  aniTable = {}
	feedFlag = false
	speedFlag = false
  options = false
  optionsGroup = display.newGroup ( )
  backGroup = display.newGroup()
	local textOptionsR = {text="Tap Me", x=0, y=0, width=100, align="right", font="BerlinSansFB-Reg", fontSize=24}
  local textOptionsC = {text="Tap Me", x=0, y=0, width=100, align="center", font="BerlinSansFB-Reg", fontSize=24}
  local textOptionsL = {text="Tap Me", x=0, y=0, width=100, align="left", font="BerlinSansFB-Reg", fontSize=24}
  local textOptionsL2 = {text="Feet/min", x=0, y=0, width=100, align="left", font="BerlinSansFB-Reg", fontSize=12}
  local textOptionsR2 = {text="Inch", x=0, y=0, width=100, align="right", font="BerlinSansFB-Reg", fontSize=12}
  
  Runtime:addEventListener( "key", onKeyEvent )
  
	stepSheet = graphics.newImageSheet("Images/stepSheet_stepSheet.png", stepperDataFile.getSpriteSheetData() )
	
--	tapSheet = graphics.newImageSheet("Images/tapSheetv2_tapSheetv2.png", tapAniDataFile.getSpriteSheetData() )
--	local tapAniSequenceDataFile = require("Images.tapAniv2");
--	local tapAniSequenceData = tapAniSequenceDataFile:getAnimationSequences();
	
	back = display.newImageRect ( screenGroup, "backgrounds/background.png",  570, 360 )
	back.x = display.contentCenterX
	back.y = display.contentCenterY		
	backEdgeX = back.contentBounds.xMin
	backEdgeY = back.contentBounds.yMin
  
  rightDisplay = display.newImageRect(backGroup, "backgrounds/speeds.png", 570, 360)
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
	decPlaces.y = backEdgeY + 117
	
	places = 4
	decLabel = display.newText( backGroup, places, 0, 0, "BerlinSansFB-Reg", 22 )
	decLabel.x = backEdgeX + 178
	decLabel.y = backEdgeY + 115
  
  measureLabel = display.newEmbossedText(backGroup, "Imperial", 0, 0, "BerlinSansFB-Reg", 20)
  measureLabel:setTextColor(255)
  measureLabel:setEmbossColor({highlight = {r=0, g=0, b=0, a=200}, shadow = {r=0,g=0,b=0, a=0}})
	measureLabel.x = backEdgeX + 115
	measureLabel.y = backEdgeY + 95
		
	rpm = display.newText( textOptionsR )
  backGroup:insert(rpm)
	rpm :addEventListener ( "touch", calcTouch )
	rpm .x = backEdgeX + 290
	rpm .y = backEdgeY + 170
	tapTable[1] = rpm 
	rpm.tap = 1
  rpm.alpha = 0
  
  --rpmTap = display.newSprite(tapSheet, tapAniSequenceData["tapAniv2"])
  rpmTap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
	rpmTap.x = backEdgeX + 320
	rpmTap.y = backEdgeY + 170
	backGroup:insert(rpmTap)
	rpmTap:addEventListener ( "touch", calcTouch )
	rpmTap.tap = 11
	--rpmTap:play()
  aniTable[1] = rpmTap 
	
	diam = display.newText( textOptionsR )
  backGroup:insert(diam)
	diam:addEventListener ( "touch", calcTouch )
	diam.x = backEdgeX + 305
	diam.y = backEdgeY + 260
	tapTable[2] = diam
	diam.tap = 2
  diam.alpha = 0
  
  --diamTap = display.newSprite(tapSheet, tapAniSequenceData["tapAniv2"])
  diamTap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
	diamTap.x = backEdgeX + 330
	diamTap.y = backEdgeY + 260
	backGroup:insert(diamTap)
	diamTap:addEventListener ( "touch", calcTouch )
	diamTap.tap = 12
	--diamTap:play()
  aniTable[2] = diamTap 
	
	surfaceSpeed = display.newText( textOptionsR )
  backGroup:insert(surfaceSpeed)
	surfaceSpeed:addEventListener ( "touch", calcTouch )
	surfaceSpeed.x = backEdgeX + 320
	surfaceSpeed.y = backEdgeY + 310
	surfaceSpeed.alpha = 0
	tapTable[3] = surfaceSpeed
	surfaceSpeed.tap = 3
  
  --surfaceSpeedTap = display.newSprite(tapSheet, tapAniSequenceData["tapAniv2"])
  surfaceSpeedTap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
	surfaceSpeedTap.x = backEdgeX + 355
	surfaceSpeedTap.y = backEdgeY + 310
	backGroup:insert(surfaceSpeedTap)
	surfaceSpeedTap:addEventListener ( "touch", calcTouch )
	surfaceSpeedTap.tap = 13
	--surfaceSpeedTap:play()
  surfaceSpeedTap.alpha = 0
  aniTable[3] = surfaceSpeedTap

	rev = display.newText( textOptionsL )
	rev:addEventListener ( "touch", calcTouch )
  backGroup:insert(rev)
	rev.x = backEdgeX + 150
	rev.y = backEdgeY + 270
	rev.alpha = 0
	tapTable[4] = rev
	rev.tap = 4
  
  --revTap = display.newSprite(tapSheet, tapAniSequenceData["tapAniv2"])
  revTap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
	revTap.x = backEdgeX + 120
	revTap.y = backEdgeY + 270
	backGroup:insert(revTap)
	revTap:addEventListener ( "touch", calcTouch )
	revTap.tap = 14
	--revTap:play()
  revTap.alpha = 0

	minute = display.newText( textOptionsL )
	minute:addEventListener ( "touch", calcTouch )
  backGroup:insert(minute)
	minute.x = backEdgeX + 150
	minute.y = backEdgeY + 220
	minute.alpha = 0
	tapTable[5] = minute
	minute.tap = 5
  
  --minuteTap = display.newSprite(tapSheet, tapAniSequenceData["tapAniv2"])
  minuteTap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
	minuteTap.x = backEdgeX + 120
	minuteTap.y = backEdgeY + 220
	backGroup:insert(minuteTap)
	minuteTap:addEventListener ( "touch", calcTouch )
	minuteTap.tap = 15
	--minuteTap:play()
  minuteTap.alpha = 0
	
	speedText = display.newText( textOptionsL2 )
  backGroup:insert(speedText)
	--speedText.alpha = 0.8
	speedText.x = backEdgeX + 508
	speedText.y = backEdgeY + 281
	
	revText = display.newText( textOptionsR2 )
  backGroup:insert(revText)
	--revText:setReferencePoint(display.TopRightReferencePoint)
	--revText.alpha = 0.8
	revText.x = backEdgeX + 42
	revText.y = backEdgeY + 247
	
	minText = display.newText( textOptionsR2 )
  backGroup:insert(minText)
	--minText:setReferencePoint(display.TopRightReferencePoint)
	--minText.alpha = 0.8
	minText.x = backEdgeX + 42
	minText.y = backEdgeY + 198
  
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
          	
    if whatTap > 5 then
      tapTable[whatTap - 10].text = storyboard.number
    else
      tapTable[whatTap].text = storyboard.number
    end
    
    if diam.text ~= "Tap Me" and rpm.text == "Tap Me" then
      surfaceSpeedTap.alpha = 1
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
    
    for i = 1, 3, 1 do
      if tapTable[i].text ~= "Tap Me"then
        tapTable[i].alpha = 1
        aniTable[i].alpha = 0
      end
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
  
  surfaceSpeed:addEventListener ( "touch", calcTouch )
  
end

function removeListeners()
  
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