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
local tapAniDataFile = require("Images.tapSheetv2_tapSheetv2")

--Local forward references

local optionsGroup, backGroup
local back, menuBack, backEdgeX, backEdgeY

local sineText
local decStep, menu, reset, measure
local places, decLabel, decPlaces, measureLabel

local sineSize, sineSizeTap, stackSize, angle1, angle2, stackSizeTap, angle1Tap, angle2Tap
local whatTap, tapCount, tapTable, aniTable

local options, continue
local stepSheet, buttSheet, tapSheet

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
    
    storyboard.showOverlay( "help", { effect="zoomInOut", time=200, params = { helpType = "sine" }, isModal = true}  )
    
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
      transition.to (decLabel, { time = 200, x = backEdgeX + 210, y = backEdgeY + 85} )
      decLabel:setTextColor(255)
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
      transition.to ( backGroup, { time = 200, x=display.contentCenterX } )
      transition.to ( optionsBack, { time = 200, x = -170 } )
      transition.to ( optionsBack, { time = 200, y = -335 } )
      transition.to (decLabel, { time = 200, x = backEdgeX + 210, y = backEdgeY + 85} )
      decLabel:setTextColor(255)
			options = false
		end		
end

local function goBack(event)
	
	transition.to ( optionsGroup, { time = 100, alpha = 0} )
    transition.to ( backGroup, { time = 100, alpha = 0 } )
    transition.to ( optionsBack, { time = 500, x = -170 } )
    transition.to ( optionsBack, { time = 500, y = -335 } )
	options = false
	storyboard.gotoScene( "menu", { effect="slideRight", time=800})
	return true
end

local function calcTouch( event )
	if event.phase == "ended" then
		
		whatTap = event.target.tap
    
    local isDegree
    
    if options then
			transition.to ( optionsGroup, { time = 100, alpha = 0} )
      transition.to ( backGroup, { time = 200, x=display.contentCenterX } )
      transition.to ( optionsBack, { time = 200, x = -170 } )
      transition.to ( optionsBack, { time = 200, y = -335 } )
      transition.to (decLabel, { time = 200, x = backEdgeX + 210, y = backEdgeY + 85} )
      decLabel:setTextColor(255)
			options = false
		end
		
    if whatTap == 3 or whatTap == 4 or whatTap == 13 or whatTap == 14 then isDegree = true else isDegree = false end
		
    if isDegree then
      storyboard.showOverlay( "calculator", { effect="fromRight", time=200, params = { negTrue = false, needDec = true, isDegree = true }, isModal = true }  )
    else
      storyboard.showOverlay( "calculator", { effect="fromRight", time=200, params = { negTrue = false, needDec = true, isDegree = false }, isModal = true }  )
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
      transition.to ( backGroup, { time = 200, x=display.contentCenterX } )
      transition.to ( optionsBack, { time = 200, x = -170 } )
      transition.to ( optionsBack, { time = 200, y = -335 } )
      transition.to (decLabel, { time = 200, x = backEdgeX + 210, y = backEdgeY + 85} )
      decLabel:setTextColor(255)
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

local function shakeListen (event)
	if event.isShake then		
		storyboard.reloadScene()
			
	end
	return true
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
--End Listeners

function scene:createScene( event )
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
	
    tapSheet = graphics.newImageSheet("Images/tapSheetv2_tapSheetv2.png", tapAniDataFile.getSpriteSheetData() )
    local tapAniSequenceDataFile = require("Images.tapAniv2");
    local tapAniSequenceData = tapAniSequenceDataFile:getAnimationSequences();
	
		back = display.newImageRect( screenGroup, "backgrounds/background.png", 570, 360 )
		back.x = display.contentCenterX
		back.y = display.contentCenterY		
    
		backEdgeX = back.contentBounds.xMin
		backEdgeY = back.contentBounds.yMin
    
    rightDisplay = display.newImageRect(backGroup, "backgrounds/sinebar.png", 570, 360)
    rightDisplay.x = display.contentCenterX
    rightDisplay.y = display.contentCenterY
    
--  helpButt = widget.newButton
--	{
--		id = "helpButt",
--    label = "HELP",
--    labelColor = { default = {0, 0, 0, 150}, over = {192, 192, 192}},
--    font = "Rock Salt",
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
	decPlaces.x = backEdgeX + 150
	decPlaces.y = backEdgeY + 85
    
	places = 4
	decLabel = display.newText( backGroup, places, 0, 0, "BerlinSansFB-Reg", 22 )
	decLabel.x = backEdgeX + 210
	decLabel.y = backEdgeY + 85
    
  measureLabel = display.newEmbossedText(backGroup, "Imperial", 0, 0, "BerlinSansFB-Reg", 20)
  measureLabel:setTextColor(255)
  measureLabel:setEmbossColor({highlight = {r=0, g=0, b=0, a=200}, shadow = {r=0,g=0,b=0, a=0}})
	measureLabel.x = backEdgeX + 150
	measureLabel.y = backEdgeY + 60
    
  sineText = display.newEmbossedText(backGroup, "Bar Size:", 0, 0, "BerlinSansFB-Reg", 17)
  sineText:setTextColor(255)
  sineText:setEmbossColor({highlight = {r=0, g=0, b=0, a=200}, shadow = {r=0,g=0,b=0, a=0}})
  sineText.rotation = 18
  sineText.x = backEdgeX + 210
  sineText.y = backEdgeY + 165
      
  sineSize = display.newText( textOptionsL )
  backGroup:insert(sineSize)
	sineSize:setReferencePoint ( topLeftReferencePoint )
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
	stackSize:setReferencePoint ( topLeftReferencePoint )
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
	angle1:setReferencePoint ( topRightReferencePoint )
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
	angle2:setReferencePoint ( topRightReferencePoint )
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

Runtime:addEventListener ( "accelerometer", shakeListen )

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
    
    if whatTap == 11 then
      sineSize.alpha = 1
      sineSizeTap.alpha = 0
      tapTable[1].text = storyboard.number
      stackSizeTap.alpha = 1
			angle1Tap.alpha = 1
			angle2Tap.alpha = 1
    elseif whatTap > 11 then
      tapTable[whatTap - 10].text = storyboard.number
      aniTable[whatTap - 10].alpha = 0
      tapTable[whatTap -10].alpha = 1
    else
      tapTable[whatTap].text = storyboard.number
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
			if tonumber(storyboard.number) >= 90 then
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
			if tonumber(storyboard.number) >= 90 then
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
    
		--continue = false
    
    end

end

	--Inches/Mill Functions
	
function toMill(num)

	return num * 25.4	

end

function toInch(num)
	
	return num / 25.4
	
end

function addListeners()
  
  sineSize:addEventListener ( "touch", calcTouch )
  
end

function removeListeners()
  
  sineSize:removeEventListener ( "touch", calcTouch )
  
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