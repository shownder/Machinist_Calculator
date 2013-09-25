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

local back, menuBack
local backEdgeX, backEdgeY

local places, decPlaces
local area, areaAnswer

local angleAtext, angleBtext, angleCtext, sideAtext, sideBtext, sideCtext
local angleAtap, angleBtap, angleCtap, sideAtap, sideBtap, sideCtap
local tapTable, whatTap, tapCount, aniTable

local menu, reset, measure, decStep

local infoButt, infoText, measureLabel, decLabel

local optionsGroup
local stepSheet, buttSheet, tapSheet

local addListeners, removeListeners, toMill, toInch
local update, goBack2


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
    
    storyboard.showOverlay( "help", { effect="zoomInOut", time=200, params = { helpType = "oblique" }, isModal = true}  )
    
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
		
		transition.to(angleAtext, {time = 300, alpha = 0})
		transition.to(angleBtext, {time = 300, alpha = 0})
		transition.to(angleCtext, {time = 300, alpha = 0})
		transition.to(sideAtext, {time = 300, alpha = 0})
		transition.to(sideBtext, {time = 300, alpha = 0})
		transition.to(sideCtext, {time = 300, alpha = 0})
    
    sideAtext.text = "Tap Me"
    sideBtext.text = "Tap Me"
    sideCtext.text = "Tap Me"
    angleAtext.text = "Tap Me"
    angleBtext.text = "Tap Me"
    angleCtext.text = "Tap Me"
    
    for i = 1, 6, 1 do
      tapTable[i]:setTextColor(0, 0, 0)
    end
    
    areaAnswer.text = ""
    
    tapCount = 0
    storyboard.number = nil
    
    if infoButt.info == 2 then
				angleAtap.alpha = 0
       	angleBtap.alpha = 0
       	angleCtap.alpha = 1
       	sideAtap.alpha = 1
       	sideBtap.alpha = 1
       	sideCtap.alpha = 0
			elseif infoButt.info == 3 then
       	angleAtap.alpha = 1
        	angleBtap.alpha = 0
        	angleCtap.alpha = 0
        	sideAtap.alpha = 1
        	sideBtap.alpha = 1
        	sideCtap.alpha = 0
			elseif infoButt.info == 4 then
        	angleAtap.alpha = 0
        	angleBtap.alpha = 0
        	angleCtap.alpha = 0
        	sideAtap.alpha = 1
        	sideBtap.alpha = 1
        	sideCtap.alpha = 1
			elseif infoButt.info == 1 then
        	angleAtap.alpha = 1
        	angleBtap.alpha = 1
        	angleCtap.alpha = 0
        	sideAtap.alpha = 1
        	sideBtap.alpha = 0
        	sideCtap.alpha = 0
			end
    
    timer.performWithDelay( 10, addListeners )
    
    if options then
				transition.to ( optionsGroup, { time = 500, x=(backEdgeX - 125) } )
				transition.to ( optionsGroup, { time = 500, alpha = 0, delay = 200} )
				transition.to ( optionsButt, {time = 500, x=(backEdgeX + 115)} )
				options = false
		end		
end

local function measureChange( event )
	local phase = event.phase
	
	if "ended" == phase then	
		if measure:getLabel() == "TO METRIC" then
			measure:setLabel("TO IMPERIAL")
			measureLabel:setText("metric")
			for i = 1, 3, 1 do
				if (tapTable[i].text ~= "Tap Me") and (tapTable[i].text ~= "") then
					tapTable[i].text = math.round(toMill(tapTable[i].text) * math.pow(10, places)) / math.pow(10, places)

				end
			end
		else
			measure:setLabel("TO METRIC")
			measureLabel:setText("imperial")
			for i = 1, 3, 1 do
				if (tapTable[i].text ~= "Tap Me") and (tapTable[i].text ~= "") then
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
end

local function goBack(event)
	
			transition.to (optionsGroup, { time = 100, alpha = 0 } )
			storyboard.gotoScene( "menu", { effect="slideRight", time=800})
		
end

local function calcTouch( event )
	if event.phase == "ended" then
		
    Runtime:removeEventListener( "touch", onScreenTouch  )
		whatTap = event.target.tap
    print(whatTap)
    
    if whatTap > 6 then
      tapCount = tapCount + 1
    end
    
    if options then
				transition.to ( optionsGroup, { time = 500, x=(backEdgeX - 125) } )
				transition.to ( optionsGroup, { time = 500, alpha = 0, delay = 200} )
				transition.to ( optionsButt, {time = 500, x=(backEdgeX + 115)} )
				options = false
		end
		
		storyboard.showOverlay( "calculator", { effect="fromTop", time=400, params = { negTrue = false, needDec = true }, isModal = true}  )
		
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

local function infoPress( event )
	local phase = event.phase		
		if "ended" == phase then
			
			tapCount = 0
      
      for i = 1, 6, 1 do
      tapTable[i]:setTextColor(0, 0, 0)
      end
    
			angleAtext.alpha = 0
			angleBtext.alpha = 0
			angleCtext.alpha = 0
			sideAtext.alpha = 0
			sideBtext.alpha = 0
			sideCtext.alpha = 0
		
			if infoButt.info == 1 then
				infoButt.info = 2
				infoText:setText("2 sides, included angle")
				angleAtext.text = ""
				angleBtext.text = ""
				angleCtext.text = "Tap Me"
				sideAtext.text = "Tap Me"
				sideBtext.text = "Tap Me"
				sideCtext.text = ""
        	angleAtap.alpha = 0
       	angleBtap.alpha = 0
       	angleCtap.alpha = 1
       	sideAtap.alpha = 1
       	sideBtap.alpha = 1
       	sideCtap.alpha = 0
			elseif infoButt.info == 2 then
				infoButt.info = 3
				infoText:setText("2 sides, opposite angle")
				angleAtext.text = "Tap Me"
				angleBtext.text = ""
				angleCtext.text = ""
				sideAtext.text = "Tap Me"
				sideBtext.text = "Tap Me"
				sideCtext.text = ""
       	angleAtap.alpha = 1
        	angleBtap.alpha = 0
        	angleCtap.alpha = 0
        	sideAtap.alpha = 1
        	sideBtap.alpha = 1
        	sideCtap.alpha = 0
			elseif infoButt.info == 3 then
				infoButt.info = 4
				infoText:setText("all sides")
				angleAtext.text = ""
				angleBtext.text = ""
				angleCtext.text = ""
				sideAtext.text = "Tap Me"
				sideBtext.text = "Tap Me"
				sideCtext.text = "Tap Me"
        	angleAtap.alpha = 0
        	angleBtap.alpha = 0
        	angleCtap.alpha = 0
        	sideAtap.alpha = 1
        	sideBtap.alpha = 1
        	sideCtap.alpha = 1
			elseif infoButt.info == 4 then
				infoButt.info = 1
				infoText:setText("1 side, 2 angles")
				angleAtext.text = "Tap Me"
				angleBtext.text = "Tap Me"
				angleCtext.text = ""
				sideAtext.text = "Tap Me"
				sideBtext.text = ""
				sideCtext.text = ""
        	angleAtap.alpha = 1
        	angleBtap.alpha = 1
        	angleCtap.alpha = 0
        	sideAtap.alpha = 1
        	sideBtap.alpha = 0
        	sideCtap.alpha = 0
			end		
      
		areaAnswer.text = ""
    timer.performWithDelay( 10, addListeners )
    
		end	
end

local function alertListener ( event )
	if "clicked" == event.action then

		angleAtext.text = ""
		angleBtext.text = ""
		angleCtext.text = ""
		sideAtext.text = "Tap Me"
		sideBtext.text = "Tap Me"
		sideCtext.text = "Tap Me"
    angleAtap.alpha = 0
    angleBtap.alpha = 0
    angleCtap.alpha = 0
    sideAtap.alpha = 1
    sideBtap.alpha = 1
    sideCtap.alpha = 1
    sideAtext.alpha = 0
    sideBtext.alpha = 0
    sideCtext.alpha = 0
    
    
    tapCount = 0
    
	end
end

local function alertListener2 ( event )
	if "clicked" == event.action then

		angleCtext.text = ""
		sideAtext.text = "Tap Me"
		sideBtext.text = ""
		sideCtext.text = ""
    angleCtap.alpha = 0
    sideAtap.alpha = 1
    sideAtext.alpha = 0
    sideBtap.alpha = 0
    sideCtap.alpha = 0
       
    tapCount = 2
    
	end
end

--end listeners

function scene:createScene( event )
	local screenGroup = self.view
		
		tapTable = {}
		aniTable = {}
		tapCount = 0
    options = false
		optionsGroup = display.newGroup ( )
    local textOptionsR = {text="Tap Me", x=0, y=0, width=100, align="right", font="WCManoNegraBta", fontSize=24}
    local textOptionsC = {text="Tap Me", x=0, y=0, width=100, align="center", font="WCManoNegraBta", fontSize=24}
    local textOptionsL = {text="Tap Me", x=0, y=0, width=100, align="left", font="WCManoNegraBta", fontSize=24}
    local textOptionsL2 = {text="", x=0, y=0, width=120, align="left", font="WCManoNegraBta", fontSize=24}
    
    Runtime:addEventListener( "key", onKeyEvent )
    Runtime:addEventListener( "touch", onScreenTouch  )
		
		stepSheet = graphics.newImageSheet("Images/customStep_customStep.png", stepperDataFile.getSpriteSheetData() )
		
		tapSheet = graphics.newImageSheet("Images/tapSheetv2_tapSheetv2.png", tapAniDataFile.getSpriteSheetData() )
		local tapAniSequenceDataFile = require("Images.tapAniv2");
		local tapAniSequenceData = tapAniSequenceDataFile:getAnimationSequences();
	
		back = display.newImageRect ( screenGroup, "backgrounds/Oblique.png",  570, 360 )
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
		
		places = 4
		decLabel = display.newText( screenGroup, places, 0, 0, "WCManoNegraBta", 18 )
		decLabel.x = backEdgeX + 178
		decLabel.y = backEdgeY + 117
    
  decPlaces = display.newEmbossedText( screenGroup, "dec places:", 0, 0, "Rock Salt", 16 )
  decPlaces:setTextColor(255)
  decPlaces:setEmbossColor({highlight = {r=0, g=0, b=0, a=200}, shadow = {r=0,g=0,b=0, a=0}})
	decPlaces.x = backEdgeX + 115
	decPlaces.y = backEdgeY + 117
		
--		decPlaces = display.newText( screenGroup, "dec places:", 0, 0, "Rock Salt", 16 )
--		decPlaces.x = backEdgeX + 115
--		decPlaces.y = backEdgeY + 117
		
		infoButt = widget.newButton
		{
    	left = 0,
   		top = 0,
  		width = 100,
 		  height = 40,
 		  fontSize = 12,
  		id = "info",
  		label = "CHANGE INPUT",
  		emboss = true,
 		  onEvent = infoPress,
		}
		screenGroup:insert(infoButt)
		infoButt.x = backEdgeX + 460
		infoButt.y = backEdgeY + 60
		infoButt.info = 1
    
    infoText = display.newEmbossedText( screenGroup, "1 side, 2 angle", 0, 0, "Rock Salt", 14 )
		infoText:setTextColor(255)
    infoText:setEmbossColor({highlight = {r=0, g=0, b=0, a=200}, shadow = {r=0,g=0,b=0, a=0}})
    infoText.x = backEdgeX + 335
    infoText.y = backEdgeY + 185
  
--		infoText = display.newText( screenGroup, "1 side, 2 angle", 0, 0, "WCManoNegraBta", 20 )
--		infoText.x = backEdgeX + 350
--		infoText.y = backEdgeY + 185
    
    measureLabel = display.newEmbossedText(screenGroup, "imperial", 0, 0, "Rock Salt", 16)
    measureLabel:setTextColor(255)
    measureLabel:setEmbossColor({highlight = {r=0, g=0, b=0, a=200}, shadow = {r=0,g=0,b=0, a=0}})
    measureLabel.x = backEdgeX + 115
    measureLabel.y = backEdgeY + 95
		
--		measureLabel = display.newText( screenGroup, "imperial", 0, 0, "Rock Salt", 16 )
--		measureLabel.x = backEdgeX + 115
--		measureLabel.y = backEdgeY + 95

  area = display.newEmbossedText(screenGroup, "Area:", 0, 0, "Rock Salt", 16)
  area:setTextColor(255)
  area:setEmbossColor({highlight = {r=0, g=0, b=0, a=200}, shadow = {r=0,g=0,b=0, a=0}})
	area.x = backEdgeX + 280
	area.y = backEdgeY + 220
  
  areaAnswer = display.newText( textOptionsL2 )
  screenGroup:insert(areaAnswer)
	areaAnswer.x = backEdgeX + 365
	areaAnswer.y = backEdgeY + 220
		
--		area = display.newText( screenGroup, "test", 0, 0, "Rock Salt", 12 )
--		area.x = backEdgeX + 343
--		area.y = backEdgeY + 230
			
		sideAtext = display.newText( textOptionsC )
    screenGroup:insert(sideAtext)
		sideAtext:addEventListener ( "touch", calcTouch )
		sideAtext.x = backEdgeX + 320
		sideAtext.y = backEdgeY + 260
		sideAtext.tap = 1
		tapTable[1] = sideAtext
		sideAtext.alpha = 0
		
		sideAtap = display.newSprite(tapSheet, tapAniSequenceData["tapAniv2"])
		sideAtap.x = backEdgeX + 320
		sideAtap.y = backEdgeY + 260
		screenGroup:insert(sideAtap)
		sideAtap:addEventListener ( "touch", calcTouch )
		sideAtap.tap = 11
		aniTable[11] = sideAtap
		sideAtap:play()

		sideBtext = display.newText( textOptionsL )
    screenGroup:insert(sideBtext)
    sideBtext.text = ""
    sideBtext:addEventListener ( "touch", calcTouch )
		sideBtext.x = backEdgeX + 480
		sideBtext.y = backEdgeY + 130
		sideBtext.tap = 2
		tapTable[2] = sideBtext
		sideBtext.alpha = 0

		sideBtap = display.newSprite(tapSheet, tapAniSequenceData["tapAniv2"])
   	sideBtap.x = backEdgeX + 460
		sideBtap.y = backEdgeY + 130
		screenGroup:insert(sideBtap)
		sideBtap:addEventListener ( "touch", calcTouch )
		sideBtap.tap = 12
		aniTable[12] = sideBtap
		sideBtap:play()
		sideBtap.alpha = 0

		sideCtext = display.newText( textOptionsR )
    screenGroup:insert(sideCtext)
    sideCtext.text = ""
  	sideCtext:addEventListener ( "touch", calcTouch )
		sideCtext.x = backEdgeX + 120
		sideCtext.y = backEdgeY + 205
		sideCtext.tap = 3
		tapTable[3] = sideCtext
		sideCtext.alpha = 0

		sideCtap = display.newSprite(tapSheet, tapAniSequenceData["tapAniv2"])
    sideCtap.x = backEdgeX + 130
		sideCtap.y = backEdgeY + 205
		screenGroup:insert(sideCtap)
		sideCtap:addEventListener ( "touch", calcTouch )
		sideCtap.tap = 13
		aniTable[13] = sideCtap
		sideCtap:play()
		sideCtap.alpha = 0

		angleAtext = display.newText( textOptionsR )
    screenGroup:insert(angleAtext)
    angleAtext:addEventListener ( "touch", calcTouch )
    angleAtext.x = backEdgeX + 275
		angleAtext.y = backEdgeY + 75
		angleAtext.tap = 4
		tapTable[4] = angleAtext
		angleAtext.alpha = 0
		
		angleAtap = display.newSprite(tapSheet, tapAniSequenceData["tapAniv2"])
    angleAtap.x = backEdgeX + 285
		angleAtap.y = backEdgeY + 75
		screenGroup:insert(angleAtap)
		angleAtap:addEventListener ( "touch", calcTouch )
		angleAtap.tap = 14
		aniTable[14] = angleAtap
		angleAtap:play()

		angleBtext = display.newText( textOptionsL )
    screenGroup:insert(angleBtext)
		angleBtext:addEventListener ( "touch", calcTouch )
		angleBtext.x = backEdgeX + 200
		angleBtext.y = backEdgeY + 280
		angleBtext.tap = 5
		tapTable[5] = angleBtext
		angleBtext.alpha = 0
		
		angleBtap = display.newSprite(tapSheet, tapAniSequenceData["tapAniv2"])
    angleBtap.x = backEdgeX + 185
		angleBtap.y = backEdgeY + 280
		screenGroup:insert(angleBtap)
		angleBtap:addEventListener ( "touch", calcTouch )
		angleBtap.tap = 15
		aniTable[15] = angleBtap
		angleBtap:play()

		angleCtext = display.newText( textOptionsR )
    screenGroup:insert(angleCtext)
    angleCtext.text = ""
		angleCtext:addEventListener ( "touch", calcTouch )
		angleCtext.x = backEdgeX + 425
		angleCtext.y = backEdgeY + 260
		angleCtext.tap = 6
		tapTable[6] = angleCtext
		angleCtext.alpha = 0

		angleCtap = display.newSprite(tapSheet, tapAniSequenceData["tapAniv2"])
    angleCtap.x = backEdgeX + 430
		angleCtap.y = backEdgeY + 260
		screenGroup:insert(angleCtap)
		angleCtap:addEventListener ( "touch", calcTouch )
		angleCtap.tap = 16
		aniTable[16] = angleCtap
		angleCtap:play()
		angleCtap.alpha = 0
    
    for i = 1, 6, 1 do
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
    
    local temp
    local filled
    local continue = false
    Runtime:addEventListener( "touch", onScreenTouch  )
    storyboard.isOverlay = false
    
    if storyboard.number ~= "Tap Me" then
    
		if whatTap > 6 then
			for i = 11, 16, 1 do
				if whatTap == i then					
					aniTable[i].alpha = 0
					tapTable[i - 10].alpha = 1
					whatTap = (whatTap - 10)	
				end
			end
    end
	
    tapTable[whatTap].text = storyboard.number
	 
		if tapCount >= 3 then
        if infoButt.info == 1 then
          if tonumber(angleAtext.text) + tonumber(angleBtext.text) > 179 then
          native.showAlert ( "Error", "The sum of 2 angles cannot exceed 179 degrees!", { "OK" }, alertListener2 )
          else
          angleCtext.text = 180 - (angleAtext.text + angleBtext.text)
          sideBtext.text = (sideAtext.text * math.sin(math.rad(angleBtext.text))) / math.sin(math.rad(angleAtext.text))
          sideCtext.text = (sideAtext.text * math.sin(math.rad(angleCtext.text))) / math.sin(math.rad(angleAtext.text))
          continue = true
          end
        elseif infoButt.info == 2 then
          sideCtext.text = math.sqrt((sideAtext.text * sideAtext.text) + (sideBtext.text * sideBtext.text) - (2 * sideAtext.text * sideBtext.text * math.cos(math.rad(angleCtext.text))))
          temp = ((sideBtext.text * sideBtext.text) + (sideCtext.text * sideCtext.text) - (sideAtext.text * sideAtext.text)) / (2 * sideBtext.text * sideCtext.text)
          angleAtext.text = math.deg(math.atan(-temp / math.sqrt(-temp * temp + 1)) + 2 * math.atan(1))
          angleBtext.text = 180 - (angleAtext.text + angleCtext.text)
          continue = true
        elseif infoButt.info == 3 then
          temp = sideBtext.text * math.sin(math.rad(angleAtext.text)) / sideAtext.text
          angleBtext.text = math.deg(math.atan(temp / (math.sqrt(-temp * temp + 1))))
          angleCtext.text = 180 - (angleAtext.text + angleBtext.text)
          sideCtext.text = (sideAtext.text * math.sin(math.rad(angleCtext.text))) / math.sin(math.rad(angleAtext.text))
          continue = true
        elseif infoButt.info == 4 then
          local one = tonumber(sideCtext.text)
          local two = tonumber(sideBtext.text)
          local three = tonumber(sideAtext.text)
          if (one + two > three) and (two + three > one) and (three + one > two) then          
          temp = ((sideBtext.text * sideBtext.text) + (sideCtext.text * sideCtext.text) - (sideAtext.text * sideAtext.text)) / (2 * sideBtext.text * sideCtext.text)
          angleAtext.text = math.deg(math.atan(-temp / (math.sqrt(-temp * temp + 1))) + 2 * math.atan(1))
          temp = sideBtext.text * math.sin(math.rad(angleAtext.text)) / sideAtext.text
          angleBtext.text = math.deg(math.atan(temp / (math.sqrt(-temp * temp + 1))))
          angleCtext.text = 180 - (angleAtext.text + angleBtext.text)
          continue = true
          else
          native.showAlert ( "Error", "Sum of every 2 sides must exceed 3rd side!", { "OK" }, alertListener )
          continue = false
          end
        end
    end
    
    if continue then
      angleAtap.alpha = 0
      angleBtap.alpha = 0
      angleCtap.alpha = 0
      sideAtap.alpha = 0
      sideBtap.alpha = 0
      sideCtap.alpha = 0
      angleAtext.alpha = 1
      angleBtext.alpha = 1
      angleCtext.alpha = 1
      sideAtext.alpha = 1
      sideBtext.alpha = 1
      sideCtext.alpha = 1
    end

	if continue then
		--areaAnswer.text = 0.5 * (sideAtext.text * sideBtext.text * (math.sin(angleCtext.text)))
		--areaAnswer.text = math.round(sideAtext.text * sideBtext.text * (math.sin(angleCtext.text)) / 2 * math.pow(10, places)) / math.pow(10, places)
    local temp = (sideAtext.text + sideBtext.text + sideCtext.text) / 2
    areaAnswer.text = math.round(math.sqrt(temp * (temp - sideAtext.text) * (temp - sideBtext.text) * (temp - sideCtext.text)) * math.pow(10, places)) / math.pow(10, places)
	end
		
	if continue then
		for i =1, 6, 1 do
			tapTable[i].text = math.round(tapTable[i].text * math.pow(10, places)) / math.pow(10, places)
		end
	end
  
  if continue then
    for i =1, 6, 1 do
      tapTable[i]:setTextColor(255, 255, 255)
    end
  end
  
  
  if continue then
    timer.performWithDelay( 10, removeListeners, 2 )
  end
    
  else
    tapCount = tapCount - 1
	end
	end
	
	--Functions
	
function toMill(num)

	return num * 25.4	

end

function toInch(num)
	
	return num / 25.4
	
end

function update()
  
  local temp
  
  if whatTap == 1 or whatTap == 4 or whatTap == 5 then
    sideBtext.text = (sideAtext.text * math.sin(math.rad(angleBtext.text))) / math.sin(math.rad(angleAtext.text))
    angleCtext.text = 180 - (angleAtext.text + angleBtext.text)
    sideCtext.text = (sideAtext.text * math.sin(math.rad(angleCtext.text))) / math.sin(math.rad(angleAtext.text))
  elseif whatTap == 2 or whatTap == 6 then
    sideCtext.text = math.sqrt((sideAtext.text * sideAtext.text) + (sideBtext.text * sideBtext.text) - (2 * sideAtext.text * sideBtext.text * math.cos(math.rad(angleCtext.text))))
    temp = ((sideBtext.text * sideBtext.text) + (sideCtext.text * sideCtext.text) - (sideAtext.text * sideAtext.text)) / (2 * sideBtext.text * sideCtext.text)
    angleAtext.text = math.deg(math.atan(-temp / (math.sqrt(-temp * temp + 1))) + 2 * math.atan(1))
    angleBtext.text = 180 - (angleAtext.text + angleCtext.text)
  elseif whatTap == 3 then
    temp = ((sideBtext.text * sideBtext.text) + (sideCtext.text * sideCtext.text) - (sideAtext.text * sideAtext.text)) / (2 * sideBtext.text * sideCtext.text)
    angleAtext.text = math.deg(math.atan(-temp / (math.sqrt(-temp * temp + 1))) + 2 * math.atan(1))
    temp = sideBtext.text * math.sin(math.rad(angleAtext.text)) / sideAtext.text
    angleBtext.text = math.deg(math.atan(temp / (math.sqrt(-temp * temp + 1))))
    angleCtext.text = 180 - (angleAtext.text + angleBtext.text)
  end
end

function addListeners()
  
  sideAtext:addEventListener( "touch", calcTouch )
  sideBtext:addEventListener( "touch", calcTouch )
  sideCtext:addEventListener( "touch", calcTouch )
  angleAtext:addEventListener( "touch", calcTouch )
  angleBtext:addEventListener( "touch", calcTouch )
  angleCtext:addEventListener( "touch", calcTouch )
  
end

function removeListeners()
  
  sideAtext:removeEventListener ( "touch", calcTouch )
  sideBtext:removeEventListener ( "touch", calcTouch )
  sideCtext:removeEventListener ( "touch", calcTouch )
  angleAtext:removeEventListener ( "touch", calcTouch )
  angleBtext:removeEventListener ( "touch", calcTouch )
  angleCtext:removeEventListener ( "touch", calcTouch )
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