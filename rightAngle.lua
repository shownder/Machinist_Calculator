--
-- Project: Trades Math Calculator
-- Description: 
--
-- Version: 1.0
-- Managed with http://CoronaProjectManager.com
--
-- Copyright 2013 . All Rights Reserved.
-- 
--"WCManoNegraBta"
--Require
local widget = require ( "widget" )
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local stepperDataFile = require("Images.stepSheet_stepSheet")
--local tapAniDataFile = require("Images.tapSheetv2_tapSheetv2")

display.setStatusBar(display.HiddenStatusBar)

--Local forward references


local back, isDegree
local angleAtext, angleBtext, sideAtext, sideBtext, sideCtext
local whatTap
local tapTable, aniTable

local backEdgeX, backEdgeY
local tapCount, doneCount

local area, areaAnswer
local continue

local angleAtap, angleBtap, sideAtap, sideBtap, sideCtap
local stepSheet, buttSheet, tapSheet

local decPlaces, measureLabel, optionsGroup
local decStep, decLabel, places, menuBack
local menu, reset, helpButt
local measure

local options, angAcalc, angBcalc, sideAcalc, sideBcalc, sideCcalc
local addListeners, removeListeners, toMill, toInch, goBack2
local backGroup, rightDisplay, optionsButt, optionsBack


--Listeners
local function onKeyEvent( event )

   local phase = event.phase
   local keyName = event.keyName
   
   if ( "back" == keyName and phase == "up" ) then
       
       timer.performWithDelay(100,goBack2,1)
   end
   return true
end

local function resetCalc(event)
	local phase = event.phase
		
    sideAtext.text = "Tap Me"
    sideBtext.text = "Tap Me"
    sideCtext.text = "Tap Me"
    angleAtext.text = "Tap Me"
    angleBtext.text = "Tap Me"
    
		transition.to(angleAtext, {time = 300, alpha = 0})
		transition.to(angleAtap, {time = 300, alpha = 1})
		transition.to(angleBtext, {time = 300, alpha = 0})
		transition.to(angleBtap, {time = 300, alpha = 1})
		transition.to(sideAtext, {time = 300, alpha = 0})
		transition.to(sideAtap, {time = 300, alpha = 1})
		transition.to(sideBtext, {time = 300, alpha = 0})
		transition.to(sideBtap, {time = 300, alpha = 1})
		transition.to(sideCtext, {time = 300, alpha = 0})
		transition.to(sideCtap, {time = 300, alpha = 1})
    
    areaAnswer.text = ""
    
    tapCount = 0
		continue = false
    storyboard.number = nil
    
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

local function goBack(event)
	
	transition.to ( optionsGroup, { time = 100, alpha = 0} )
    transition.to ( backGroup, { time = 100, alpha = 0 } )
    transition.to ( optionsBack, { time = 500, x = -170 } )
    transition.to ( optionsBack, { time = 500, y = -335 } )
	options = false
	storyboard.gotoScene( "menu", { effect="slideRight", time=800})
	return true
end

local function alertListener2 ( event )
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
			tapCount = tapCount + 1
      whatTap = whatTap + 10
      if whatTap == 14 or whatTap == 15 then isDegree = true else isDegree = false end
        if isDegree then
          storyboard.showOverlay( "calculator", { effect="fromRight", time=200, params = { negTrue = false, needDec = true, isDegree = true }, isModal = true }  )
        else
          storyboard.showOverlay( "calculator", { effect="fromRight", time=200, params = { negTrue = false, needDec = true, isDegree = fasle }, isModal = true }  )
        end
    elseif 2 == i then
      print("Cancel was pressed")
    end
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

local function helpScreen(event)
	local phase = event.phase
  
  if "ended" == phase then	

    if options then
				transition.to ( optionsGroup, { time = 500, x=(backEdgeX - 125) } )
				transition.to ( optionsGroup, { time = 500, alpha = 0, delay = 200} )
				--transition.to ( optionsButt, {time = 500, x=(backEdgeX + 115)} )
				options = false
    end
    
    --Runtime:removeEventListener( "touch", onScreenTouch  )
    
    storyboard.showOverlay( "help", { effect="zoomInOut", time=200, params = { helpType = "rightAngle" }, isModal = true}  )
    
  end
      
end

local function calcTouch( event )
	if event.phase == "ended" then
    
    local continue = false
    
      for i = 1, 5, 1 do
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
		
		if whatTap > 5 then
			tapCount = tapCount + 1
		end
    
    if whatTap == 4 or whatTap == 5 or whatTap == 14 or whatTap == 15 then isDegree = true else isDegree = false end
    
    if not continue then
      native.showAlert ("Continue?", "Press OK to reset all values and continue.", { "OK", "Cancel" }, alertListener2 )
    elseif isDegree then
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
			--measureLabel.text = "Metric"
      measureLabel:setText("Metric")
      measureLabel.x = backEdgeX + 115
      measureLabel.y = backEdgeY + 95
			for i = 1, 3, 1 do			
        if tapTable[i].text ~= "Tap Me" then
					tapTable[i].text = math.round(toMill(tapTable[i].text) * math.pow(10, places)) / math.pow(10, places)
				end
			end
		else
			measure:setLabel("TO METRIC")
			--measureLabel.text = "Imperial"
      measureLabel:setText("Imperial")
      measureLabel.x = backEdgeX + 115
      measureLabel.y = backEdgeY + 95
			for i = 1, 3, 1 do
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

local function alertListener ( event )
	if "clicked" == event.action then

		sideAtap.alpha = 1
		sideAtext.alpha = 0
		sideBtap.alpha = 1
		sideBtext.alpha = 0
		sideAtext.text = "Tap Me"
		sideBtext.text = "Tap Me"
		tapCount = 1
		if angleAtext.text == "Tap Me" then
			angleAtap.alpha = 1
			angleAtext.alpha = 0
		end
		if angleBtext.text == "Tap Me" then
			angleBtap.alpha = 1
			angleBtext.alpha = 0
		end
	end
end

--End Listeners


--Called when the scene doesn't exist, only called once unless purged/removed

function scene:createScene( event )
	local screenGroup = self.view
	
  doneCount = 0
	tapTable = {}
	aniTable = {}
	optionsGroup = display.newGroup ( )
  backGroup = display.newGroup()
	options = false
  local textOptionsR = {text="Tap Me", x=0, y=0, width=100, align="right", font="BerlinSansFB-Reg", fontSize=24}
  local textOptionsC = {text="Tap Me", x=0, y=0, width=100, align="center", font="BerlinSansFB-Reg", fontSize=24}
  local textOptionsL = {text="Tap Me", x=0, y=0, width=100, align="left", font="BerlinSansFB-Reg", fontSize=24}
  local textOptionsL2 = {text="", x=0, y=0, width=200, align="left", font="BerlinSansFB-Reg", fontSize=24}
  
  Runtime:addEventListener( "key", onKeyEvent )
  
	stepSheet = graphics.newImageSheet("Images/stepSheet_stepSheet.png", stepperDataFile.getSpriteSheetData() )
	
--	tapSheet = graphics.newImageSheet("Images/tapSheetv2_tapSheetv2.png", tapAniDataFile.getSpriteSheetData() )
--	local tapAniSequenceDataFile = require("Images.tapAniv2");
--	local tapAniSequenceData = tapAniSequenceDataFile:getAnimationSequences();
	
	tapCount = 0
	continue = false
	
	back = display.newImageRect( screenGroup, "backgrounds/background.png", 570, 360 )
	back.x = display.contentCenterX
	back.y = display.contentCenterY
  backEdgeX = back.contentBounds.xMin
	backEdgeY = back.contentBounds.yMin
  
  rightDisplay = display.newImageRect(backGroup, "backgrounds/rightangle.png", 570, 360)
  rightDisplay.x = display.contentCenterX
  rightDisplay.y = display.contentCenterY  


--  helpButt = widget.newButton
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

  area = display.newEmbossedText(backGroup, "Area:", 0, 0, "BerlinSansFB-Reg", 20)
  area:setTextColor(255)
  area:setEmbossColor({highlight = {r=0, g=0, b=0, a=200}, shadow = {r=0,g=0,b=0, a=0}})
	area.x = backEdgeX + 320
	area.y = backEdgeY + 230
  
  areaAnswer = display.newText( textOptionsL2 )
  backGroup:insert(areaAnswer)
	areaAnswer.x = backEdgeX + 450
	areaAnswer.y = backEdgeY + 230
	
	sideCtext = display.newText( textOptionsR )
	sideCtext:addEventListener ( "touch", calcTouch )
  backGroup:insert(sideCtext)
	sideCtext.x = backEdgeX + 250
	sideCtext.y = backEdgeY + 145
	sideCtext.tap = 1
	tapTable[1] = sideCtext
	sideCtext.alpha = 0

	--sideCtap = display.newSprite(tapSheet, tapAniSequenceData["tapAniv2"])
  sideCtap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
	sideCtap.x = backEdgeX + 280
	sideCtap.y = backEdgeY + 140
	backGroup:insert(sideCtap)
	sideCtap:addEventListener ( "touch", calcTouch )
	sideCtap.tap = 11
	aniTable[11] = sideCtap
	--sideCtap:play()

	sideAtext = display.newText( textOptionsC )
	sideAtext:addEventListener ( "touch", calcTouch )
  backGroup:insert(sideAtext)
	sideAtext.x = backEdgeX + 330
	sideAtext.y = backEdgeY + 275
	sideAtext.tap = 2
	tapTable[2] = sideAtext
	sideAtext.alpha = 0
	
	--sideAtap = display.newSprite(tapSheet, tapAniSequenceData["tapAniv2"])
  sideAtap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
	sideAtap.x = backEdgeX + 330
	sideAtap.y = backEdgeY + 270
	backGroup:insert(sideAtap)
	sideAtap:addEventListener ( "touch", calcTouch )
	sideAtap.tap = 12
	aniTable[12] = sideAtap
	--sideAtap:play()
	
	sideBtext = display.newText( textOptionsR )
	sideBtext:addEventListener ( "touch", calcTouch )
  backGroup:insert(sideBtext)
	sideBtext.x = backEdgeX + 420
	sideBtext.y = backEdgeY + 180
	sideBtext.tap = 3
	tapTable[3] = sideBtext
	sideBtext.alpha = 0
	
	--sideBtap = display.newSprite(tapSheet, tapAniSequenceData["tapAniv2"])
  sideBtap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
	sideBtap.x = backEdgeX + 460
	sideBtap.y = backEdgeY + 180
	backGroup:insert(sideBtap)
	sideBtap:addEventListener ( "touch", calcTouch )
	sideBtap.tap = 13
	aniTable[13] = sideBtap
	--sideBtap:play()
		
	angleAtext = display.newText( textOptionsR )
	angleAtext:addEventListener ( "touch", calcTouch )
  backGroup:insert(angleAtext)
	angleAtext.x = backEdgeX + 395
	angleAtext.y = backEdgeY + 70
	angleAtext.tap = 4
	tapTable[4] = angleAtext
	angleAtext.alpha = 0
	
	--angleAtap = display.newSprite(tapSheet, tapAniSequenceData["tapAniv2"])
  angleAtap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
	angleAtap.x = backEdgeX + 430
	angleAtap.y = backEdgeY + 70
	backGroup:insert(angleAtap)
	angleAtap:addEventListener ( "touch", calcTouch )
	angleAtap.tap = 14
	aniTable[14] = angleAtap
	--angleAtap:play()
	
	angleBtext = display.newText( textOptionsL )
	angleBtext:addEventListener ( "touch", calcTouch )
  backGroup:insert(angleBtext)
	angleBtext.x = backEdgeX + 190
	angleBtext.y = backEdgeY + 290
	angleBtext.tap = 5
	tapTable[5] = angleBtext
	angleBtext.alpha = 0
	
	--angleBtap = display.newSprite(tapSheet, tapAniSequenceData["tapAniv2"])
  angleBtap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
	angleBtap.x = backEdgeX + 160
	angleBtap.y = backEdgeY + 290
	backGroup:insert(angleBtap)
	angleBtap:addEventListener ( "touch", calcTouch )
	angleBtap.tap = 15
	aniTable[15] = angleBtap
	--angleBtap:play()

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


-- Called immediately after scene has moved onscreen, called everytime scene is loaded

function scene:enterScene( event )
  local group = self.view
        
		storyboard.purgeScene( "menu" )

end

--Called when user leaves scene

function scene:exitScene( event )
  local group = self.view
   
  Runtime:removeEventListener( "key", onKeyEvent )
  
	
end

--Called when scene is Purged or Removed

function scene:destroyScene( event )
   local group = self.view

		optionsGroup:removeSelf()
    backGroup:removeSelf()
   
end

scene:addEventListener( "createScene", scene )

scene:addEventListener( "enterScene", scene )

scene:addEventListener( "destroyScene", scene )

scene:addEventListener( "exitScene", scene )

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
  
  print(tapCount)

	if whatTap > 5 then
			for i = 11, 15, 1 do
				if whatTap == i then					
					aniTable[i].alpha = 0
					tapTable[i - 10].alpha = 1
					whatTap = (whatTap - 10)	
				end
			end
	end
	
  tapTable[whatTap].text = storyboard.number
	
	if angleAtext.text ~= "Tap Me" then
		if tonumber(angleAtext.text) >= 90 then
			angleAtext.text = 89
		end
	elseif angleBtext.text ~= "Tap Me" then
		if tonumber(angleBtext.text) >= 90 then
			angleBtext. text = 89
		end
	end
	
	if tapCount == 2 then
		continue = true
		angleAtext.alpha = 1
		angleBtext.alpha = 1
		sideAtext.alpha = 1
		sideBtext.alpha = 1
		sideCtext.alpha = 1
		angleAtap.alpha = 0
		angleBtap.alpha = 0
		sideAtap.alpha = 0
		sideBtap.alpha = 0
		sideCtap.alpha = 0
	end
	
	if continue ~= true then
		if whatTap == 4 then		
			angleBtext.text = 90 - angleAtext.text
			angleBtext.alpha = 1
			angleBtap.alpha = 0
		elseif whatTap == 5 then		
			angleAtext.text = 90 - angleBtext.text
			angleAtext.alpha = 1
			angleAtap.alpha = 0
		end
	end
		
	if (continue) then
		if sideCtext.text ~= "Tap Me" then
			if sideAtext.text ~= "Tap Me" then
				if tonumber(sideCtext.text) < tonumber(sideAtext.text) then
				native.showAlert ( "Error", "Hypotenuse cannot be smaller than another side!", { "OK" }, alertListener )
				continue = false
				end
			elseif sideBtext.text ~= "Tap Me" then
				if tonumber(sideCtext.text) < tonumber(sideBtext.text) then
				native.showAlert ( "Error", "Hypotenuse cannot be smaller than another side!", { "OK" }, alertListener )
				continue = false
				end
			end
		end
	end
		
	if (continue) then
		if whatTap == 1 then
			sideCcalc()
		elseif whatTap == 2 then
			sideAcalc()
		elseif whatTap == 3 then
			sideBcalc()
		elseif whatTap == 4 then
			angAcalc()
		elseif whatTap == 5 then
			angBcalc()
		end
	end
  
  
	if (continue) then
		local areaContent = 0.5 * (sideAtext.text * sideBtext.text)
		areaAnswer.text = math.round(areaContent * math.pow(10, places)) / math.pow(10, places)
	end
		
	if (continue) then
		for i =1, 5, 1 do
			tapTable[i].text = math.round(tapTable[i].text * math.pow(10, places)) / math.pow(10, places)
		end
	end
  
  for i = 1, 5, 1 do
    if tapTable[i].text ~= "Tap Me" then
      doneCount = doneCount + 1
    end
  end
  
else
  tapCount = tapCount - 1
  end	
 
end
	

function toMill(num)

	return num * 25.4	

end

function toInch(num)
	
	return num / 25.4
	
end

function sideAcalc()
		if sideAtext.text ~= "Tap Me" and sideCtext.text ~= "Tap Me" then
			sideBtext.text = math.sqrt(( sideCtext.text * sideCtext.text) - ( sideAtext.text * sideAtext.text))
			angleAtext.text = math.deg(math.atan( sideAtext.text / sideBtext.text ))
			angleBtext.text = 90 - angleAtext.text
		elseif sideAtext.text ~= "Tap Me" and sideBtext.text ~= "Tap Me" then
			angleAtext.text = math.deg(math.atan( sideAtext.text / sideBtext.text ))
			angleBtext.text = 90 - angleAtext.text
			sideCtext.text = math.sqrt(( sideAtext.text * sideAtext.text) + ( sideBtext.text * sideBtext.text))
		elseif sideAtext.text ~= "Tap Me" and angleAtext.text ~= "Tap Me" then
			sideBtext.text = (sideAtext.text / (math.tan(math.rad(angleAtext.text))))
			angleBtext.text = 90 - angleAtext.text
			sideCtext.text = math.sqrt(( sideAtext.text * sideAtext.text) + ( sideBtext.text * sideBtext.text))
		elseif sideAtext.text ~= "Tap Me" and angleBtext.text ~= "Tap Me" then
			angleAtext.text = 90 - angleBtext.text
			sideBtext.text = (sideAtext.text / (math.tan(math.rad(angleAtext.text))))
			sideCtext.text = math.sqrt(( sideAtext.text * sideAtext.text) + ( sideBtext.text * sideBtext.text))
		
	end
end

function sideBcalc()
		if sideBtext.text ~= "Tap Me" and sideCtext.text ~= "Tap Me" then
			sideAtext.text = math.sqrt (( sideCtext.text * sideCtext.text ) - ( sideBtext.text * sideBtext.text ))
			angleAtext.text = math.deg(math.atan( sideAtext.text / sideBtext.text ))
			angleBtext.text = 90 - angleAtext.text
		elseif sideBtext.text ~= "Tap Me" and angleAtext.text ~= "Tap Me" then
			angleBtext.text = 90 - angleAtext.text
			sideAtext.text = (sideBtext.text / (math.tan(math.rad(angleBtext.text))))
			sideCtext.text = math.sqrt(( sideAtext.text * sideAtext.text) + ( sideBtext.text * sideBtext.text))
		elseif sideBtext.text ~= "Tap Me" and angleBtext.text ~= "Tap Me" then
			angleAtext.text = 90 - angleBtext.text
			sideAtext.text = (sideBtext.text / (math.tan(math.rad(angleBtext.text))))
			sideCtext.text = math.sqrt(( sideAtext.text * sideAtext.text) + ( sideBtext.text * sideBtext.text))

		elseif sideAtext.text ~= "Tap Me" and sideBtext.text ~= "Tap Me" then
			angleAtext.text = math.deg(math.atan( sideAtext.text / sideBtext.text ))
			angleBtext.text = 90 - angleAtext.text
			sideCtext.text = math.sqrt(( sideAtext.text * sideAtext.text) + ( sideBtext.text * sideBtext.text))
	end
end

function sideCcalc()
	if sideCtext.text ~= "Tap Me" and angleAtext.text ~= "Tap Me" then
		angleBtext.text = 90 - angleAtext.text
		sideAtext.text = sideCtext.text * (math.sin(math.rad(angleAtext.text)))
		sideBtext.text = sideCtext.text * (math.cos(math.rad(angleAtext.text)))
	elseif sideCtext.text ~= "Tap Me" and angleBtext.text ~= "Tap Me" then
		angleAtext.text = 90 - angleBtext.text
		sideAtext.text = sideCtext.text * (math.sin(math.rad(angleAtext.text)))
		sideBtext.text = sideCtext.text * (math.cos(math.rad(angleAtext.text)))
	elseif sideBtext.text ~= "Tap Me" and sideCtext.text ~= "Tap Me" then
		sideAtext.text = math.sqrt (( sideCtext.text * sideCtext.text ) - ( sideBtext.text * sideBtext.text ))
		angleAtext.text = math.deg(math.atan( sideAtext.text / sideBtext.text ))
		angleBtext.text = 90 - angleAtext.text
	elseif sideAtext.text ~= "Tap Me" and sideCtext.text ~= "Tap Me" then
		sideBtext.text = math.sqrt(( sideCtext.text * sideCtext.text) - ( sideAtext.text * sideAtext.text))
		angleAtext.text = math.deg(math.atan( sideAtext.text / sideBtext.text ))
		angleBtext.text = 90 - angleAtext.text
	end
end

function angAcalc()
	if sideCtext.text ~= "Tap Me" and angleAtext.text ~= "Tap Me" then
		angleBtext.text = 90 - angleAtext.text
		sideAtext.text = sideCtext.text * (math.sin(math.rad(angleAtext.text)))
		sideBtext.text = sideCtext.text * (math.cos(math.rad(angleAtext.text)))
	elseif sideBtext.text ~= "Tap Me" and angleAtext.text ~= "Tap Me" then
		angleBtext.text = 90 - angleAtext.text
		sideAtext.text = (sideBtext.text / (math.tan(math.rad(angleBtext.text))))
		sideCtext.text = math.sqrt(( sideAtext.text * sideAtext.text) + ( sideBtext.text * sideBtext.text))
	elseif sideAtext.text ~= "Tap Me" and angleAtext.text ~= "Tap Me" then
		sideBtext.text = (sideAtext.text / (math.tan(math.rad(angleAtext.text))))
		angleBtext.text = 90 - angleAtext.text
		sideCtext.text = math.sqrt(( sideAtext.text * sideAtext.text) + ( sideBtext.text * sideBtext.text))
	end
end

function angBcalc()
	if sideCtext.text ~= "Tap Me" and angleBtext.text ~= "Tap Me" then
		angleAtext.text = 90 - angleBtext.text
		sideAtext.text = sideCtext.text * (math.sin(math.rad(angleAtext.text)))
		sideBtext.text = sideCtext.text * (math.cos(math.rad(angleAtext.text)))
	elseif sideBtext.text ~= "Tap Me" and angleBtext.text ~= "Tap Me" then
		angleAtext.text = 90 - angleBtext.text
		sideAtext.text = (sideBtext.text / (math.tan(math.rad(angleBtext.text))))
		sideCtext.text = math.sqrt(( sideAtext.text * sideAtext.text) + ( sideBtext.text * sideBtext.text))
	elseif sideAtext.text ~= "Tap Me" and angleBtext.text ~= "Tap Me" then
		angleAtext.text = 90 - angleBtext.text
		sideBtext.text = (sideAtext.text / (math.tan(math.rad(angleAtext.text))))
		sideCtext.text = math.sqrt(( sideAtext.text * sideAtext.text) + ( sideBtext.text * sideBtext.text))
	end
end

--function addListeners()
--  print("adding event listeners")
--  sideAtext:addEventListener( "touch", calcTouch )
--  sideBtext:addEventListener( "touch", calcTouch )
--  sideCtext:addEventListener( "touch", calcTouch )
--  angleAtext:addEventListener( "touch", calcTouch )
--  angleBtext:addEventListener( "touch", calcTouch )
--end

--function removeListeners()
--  print("removing event listeners")
--  sideAtext:removeEventListener( "touch", calcTouch )
--  sideBtext:removeEventListener( "touch", calcTouch )
--  sideCtext:removeEventListener( "touch", calcTouch )
--  angleAtext:removeEventListener( "touch", calcTouch )
--  angleBtext:removeEventListener( "touch", calcTouch )
--end

function goBack2()
	
  if (storyboard.isOverlay) then
    storyboard.number = "Tap Me"
    storyboard.hideOverlay()
  else
		storyboard.gotoScene( "menu", { effect="slideRight", time=800})
  end
		
end
  
--Scene Overlay Listeners

scene:addEventListener( "overlayEnded" )

scene:addEventListener( "overlayBegan" )


return scene