local composer = require( "composer" )
local scene = composer.newScene()
local stepperDataFile = require("Images.stepSheet_stepSheet")
local myData = require("myData")
local widget = require ( "widget" )
local loadsave = require("loadsave")

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

local back, rightDisplay
local backEdgeX, backEdgeY, rightDisplay

local places, decPlaces
local area, areaAnswer

local angleAtext, angleBtext, angleCtext, sideAtext, sideBtext, sideCtext
local angleAtap, angleBtap, angleCtap, sideAtap, sideBtap, sideCtap
local tapTable, whatTap, tapCount, aniTable

local menu, reset, measure, decStep, resetVal

local infoButt, infoText, measureLabel, decLabel

local optionsGroup, backGroup
local stepSheet, buttSheet, tapSheet

local addListeners, removeListeners, toMill, toInch
local update, goBack2
local gMeasure, measureText

--Forward Functions

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
      transition.to (decLabel, { time = 200, x = backEdgeX + 178, y = backEdgeY + 125} )
      decLabel:setFillColor(1)
			options = false
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
    
    areaAnswer.text = ""
    
    tapCount = 0
    myData.number = nil
    
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
    
    if options then
			transition.to ( optionsGroup, { time = 100, alpha = 0} )
      transition.to ( backGroup, { time = 200, x=0 } )
      transition.to ( optionsBack, { time = 200, x = -170 } )
      transition.to ( optionsBack, { time = 200, y = -335 } )
      transition.to (decLabel, { time = 200, x = backEdgeX + 178, y = backEdgeY + 125} )
      decLabel:setFillColor(1)
			options = false
    end
end

local function measureChange( event )
	local phase = event.phase
	
	if "ended" == phase then	
		if measure:getLabel() == "TO METRIC" then
      gMeasure.measure = "TO IMPERIAL"
      loadsave.saveTable(gMeasure, "obliqueMeasure.json")
			measure:setLabel("TO IMPERIAL")
			measureLabel:setText("Metric")
			for i = 1, 3, 1 do
				if (tapTable[i].text ~= "Tap Me") and (tapTable[i].text ~= "") then
					tapTable[i].text = math.round(toMill(tapTable[i].text) * math.pow(10, places)) / math.pow(10, places)

				end
			end
		else
      gMeasure.measure = "TO METRIC"
      loadsave.saveTable(gMeasure, "obliqueMeasure.json")
			measure:setLabel("TO METRIC")
			measureLabel:setText("Imperial")
			for i = 1, 3, 1 do
				if (tapTable[i].text ~= "Tap Me") and (tapTable[i].text ~= "") then
					tapTable[i].text = math.round(toInch(tapTable[i].text) * math.pow(10, places)) / math.pow(10, places)
				end
			end
		end
    if options then
			transition.to ( optionsGroup, { time = 100, alpha = 0} )
      transition.to ( backGroup, { time = 200, x=0 } )
      transition.to ( optionsBack, { time = 200, x = -170 } )
      transition.to ( optionsBack, { time = 200, y = -335 } )
      transition.to (decLabel, { time = 200, x = backEdgeX + 178, y = backEdgeY + 125} )
      decLabel:setFillColor(1)
			options = false
		end

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
    
    local isDegree
		
    whatTap = event.target.tap
    print(whatTap)
    
    if whatTap > 6 then
      tapCount = tapCount + 1
    end
    
    if options then
			transition.to ( optionsGroup, { time = 100, alpha = 0} )
      transition.to ( backGroup, { time = 200, x=0 } )
      transition.to ( optionsBack, { time = 200, x = -170 } )
      transition.to ( optionsBack, { time = 200, y = -335 } )
      transition.to (decLabel, { time = 200, x = backEdgeX + 178, y = backEdgeY + 125} )
      decLabel:setFillColor(1)
			options = false
		end
    
    if whatTap == 4 or whatTap == 5 or whatTap == 6 or whatTap == 14 or whatTap == 15 or whatTap == 16 then isDegree = true else isDegree = false end
		
    if isDegree then
      composer.showOverlay( "calculator", { effect="fromRight", time=200, params = { negTrue = false, needDec = true, isDegree = true }, isModal = true }  )
    else
      composer.showOverlay( "calculator", { effect="fromRight", time=200, params = { negTrue = false, needDec = true, isDegree = false }, isModal = true }  )
    end
  
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
			
      if resetVal then
        timer.performWithDelay( 1000, resetCalc("ended") )
        resetVal = false
        infoButt:setLabel("Input")
      else
			
      tapCount = 0
    
			angleAtext.alpha = 0
			angleBtext.alpha = 0
			angleCtext.alpha = 0
			sideAtext.alpha = 0
			sideBtext.alpha = 0
			sideCtext.alpha = 0
		
			if infoButt.info == 1 then
				infoButt.info = 2
				infoText:setText("2 Sides, Included Angle")
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
				infoText:setText("2 Sides, Opposite Angle")
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
				infoText:setText("All Sides")
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
				infoText:setText("1 Side, 2 Angles")
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
    end
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

addListeners = function()
  
  sideAtext:addEventListener( "touch", calcTouch )
  sideBtext:addEventListener( "touch", calcTouch )
  sideCtext:addEventListener( "touch", calcTouch )
  angleAtext:addEventListener( "touch", calcTouch )
  angleBtext:addEventListener( "touch", calcTouch )
  angleCtext:addEventListener( "touch", calcTouch )
  
end

removeListeners = function()
  
  sideAtext:removeEventListener ( "touch", calcTouch )
  sideBtext:removeEventListener ( "touch", calcTouch )
  sideCtext:removeEventListener ( "touch", calcTouch )
  angleAtext:removeEventListener ( "touch", calcTouch )
  angleBtext:removeEventListener ( "touch", calcTouch )
  angleCtext:removeEventListener ( "touch", calcTouch )
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

toMill = function(num)
  return num * 25.4	
end

toInch = function(num)
  return num / 25.4
end

---------------------------------------------------------------------------------
--Called when the overlay ends
--------------------------------------

function scene:calculate()
  local group = self.view
    
  local temp
  local filled
  local continue = false
  myData.isOverlay = false
    
  if myData.number ~= "Tap Me" then
    
	if whatTap > 6 then
		for i = 11, 16, 1 do
			if whatTap == i then					
				aniTable[i].alpha = 0
				tapTable[i - 10].alpha = 1
				whatTap = (whatTap - 10)	
			end
		end
  end
	
  tapTable[whatTap].text = myData.number
	 
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
      local temp = (sideAtext.text + sideBtext.text + sideCtext.text) / 2
      areaAnswer.text = math.round(math.sqrt(temp * (temp - sideAtext.text) * (temp - sideBtext.text) * (temp - sideCtext.text)) * math.pow(10, places)) / math.pow(10, places)

      for i =1, 6, 1 do
        tapTable[i].text = math.round(tapTable[i].text * math.pow(10, places)) / math.pow(10, places)
      end
	
      timer.performWithDelay( 10, removeListeners, 2 )
      infoButt:setLabel("Reset")
      resetVal = true
    end
    
  else
    tapCount = tapCount - 1
	end
end

-- "scene:create()"
function scene:create( event )
  local screenGroup = self.view
		
	tapTable = {}
	aniTable = {}
	tapCount = 0
  options = false

  gMeasure = loadsave.loadTable("obliqueMeasure.json")
  if gMeasure == nil then
    gMeasure = {}
    gMeasure.measure = "TO METRIC"
    loadsave.saveTable(gMeasure, "obliqueMeasure.json")
  end

  if gMeasure.measure == "TO METRIC" then
    measureText = "Imperial"
  else
    measureText = "Metric"
  end

	optionsGroup = display.newGroup ( )
  backGroup = display.newGroup ( )
  local textOptionsR = {text="Tap Me", x=0, y=0, width=100, align="right", font="BerlinSansFB-Reg", fontSize=24}
  local textOptionsC = {text="Tap Me", x=0, y=0, width=100, align="center", font="BerlinSansFB-Reg", fontSize=24}
  local textOptionsL = {text="Tap Me", x=0, y=0, width=100, align="left", font="BerlinSansFB-Reg", fontSize=24}
  local textOptionsL2 = {text="", x=0, y=0, width=120, align="left", font="BerlinSansFB-Reg", fontSize=24}
    
  Runtime:addEventListener( "key", onKeyEvent )
		
	stepSheet = graphics.newImageSheet("Images/stepSheet_stepSheet.png", stepperDataFile.getSpriteSheetData() )
	
	back = display.newImageRect( screenGroup, "backgrounds/background.png", 570, 360 )
	back.x = display.contentCenterX
	back.y = display.contentCenterY	
    
  backEdgeX = back.contentBounds.xMin
	backEdgeY = back.contentBounds.yMin
    
  rightDisplay = display.newImageRect(backGroup, "backgrounds/Oblique.png", 570, 360)
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
		label = gMeasure.measure,
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
	decPlaces.y = backEdgeY + 127
	
	places = 4
	decLabel = display.newText( screenGroup, places, 0, 0, "BerlinSansFB-Reg", 22 )
	decLabel.x = backEdgeX + 178
	decLabel.y = backEdgeY + 125
  
  measureLabel = display.newEmbossedText(backGroup, measureText, 0, 0, "BerlinSansFB-Reg", 20)
  measureLabel:setFillColor(1)
  measureLabel:setEmbossColor({highlight = {r=0, g=0, b=0, a=1}, shadow = {r=1,g=1,b=1, a=0}})
	measureLabel.x = backEdgeX + 115
	measureLabel.y = backEdgeY + 105
		
	infoButt = widget.newButton
	{
   	left = 0,
  	top = 0,
  	width = 90,
 	  height = 37,
 	  fontSize = 14,
  	id = "info",
  	label = "Change Input",
    labelColor = { default = {1}, over = {0.15, 0.4, 0.729}},
    font = "BerlinSansFB-Reg",
    defaultFile = "Images/chartButtD.png",
    overFile = "Images/chartButtO.png",
  	--emboss = true,
 	  onEvent = infoPress,
	}
	backGroup:insert(infoButt)
	infoButt.x = backEdgeX + 460
	infoButt.y = backEdgeY + 60
	infoButt.info = 1
    
  infoText = display.newEmbossedText( backGroup, "1 Side, 2 Angles", 0, 0, "BerlinSansFB-Reg", 18 )
	infoText:setFillColor(1)
  infoText:setEmbossColor({highlight = {r=0, g=0, b=0, a=1}, shadow = {r=1,g=1,b=1, a=0}})
  infoText.x = backEdgeX + 335
  infoText.y = backEdgeY + 185

  area = display.newEmbossedText(backGroup, "Area:", 0, 0, "BerlinSansFB-Reg", 20)
  area:setFillColor(1)
  area:setEmbossColor({highlight = {r=0, g=0, b=0, a=1}, shadow = {r=1,g=1,b=1, a=0}})
	area.x = backEdgeX + 280
	area.y = backEdgeY + 220
  
  areaAnswer = display.newText( textOptionsL2 )
  backGroup:insert(areaAnswer)
	areaAnswer.x = backEdgeX + 365
	areaAnswer.y = backEdgeY + 220
			
	sideAtext = display.newText( textOptionsC )
  backGroup:insert(sideAtext)
	sideAtext:addEventListener ( "touch", calcTouch )
	sideAtext.x = backEdgeX + 320
	sideAtext.y = backEdgeY + 260
	sideAtext.tap = 1
	tapTable[1] = sideAtext
	sideAtext.alpha = 0
		
  sideAtap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
	sideAtap.x = backEdgeX + 315
	sideAtap.y = backEdgeY + 255
	backGroup:insert(sideAtap)
	sideAtap:addEventListener ( "touch", calcTouch )
	sideAtap.tap = 11
	aniTable[11] = sideAtap

	sideBtext = display.newText( textOptionsL )
  backGroup:insert(sideBtext)
  sideBtext.text = ""
  sideBtext:addEventListener ( "touch", calcTouch )
	sideBtext.x = backEdgeX + 480
	sideBtext.y = backEdgeY + 130
	sideBtext.tap = 2
	tapTable[2] = sideBtext
	sideBtext.alpha = 0

  sideBtap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
  sideBtap.x = backEdgeX + 460
	sideBtap.y = backEdgeY + 130
	backGroup:insert(sideBtap)
	sideBtap:addEventListener ( "touch", calcTouch )
	sideBtap.tap = 12
	aniTable[12] = sideBtap
	sideBtap.alpha = 0

	sideCtext = display.newText( textOptionsR )
  backGroup:insert(sideCtext)
  sideCtext.text = ""
  sideCtext:addEventListener ( "touch", calcTouch )
	sideCtext.x = backEdgeX + 120
	sideCtext.y = backEdgeY + 205
	sideCtext.tap = 3
	tapTable[3] = sideCtext
	sideCtext.alpha = 0

  sideCtap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
  sideCtap.x = backEdgeX + 150
	sideCtap.y = backEdgeY + 205
	backGroup:insert(sideCtap)
	sideCtap:addEventListener ( "touch", calcTouch )
	sideCtap.tap = 13
	aniTable[13] = sideCtap
	sideCtap.alpha = 0

	angleAtext = display.newText( textOptionsR )
  backGroup:insert(angleAtext)
  angleAtext:addEventListener ( "touch", calcTouch )
  angleAtext.x = backEdgeX + 275
	angleAtext.y = backEdgeY + 75
	angleAtext.tap = 4
	tapTable[4] = angleAtext
	angleAtext.alpha = 0
		
  angleAtap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
  angleAtap.x = backEdgeX + 315
	angleAtap.y = backEdgeY + 75
	backGroup:insert(angleAtap)
	angleAtap:addEventListener ( "touch", calcTouch )
	angleAtap.tap = 14
	aniTable[14] = angleAtap
	
	angleBtext = display.newText( textOptionsL )
  backGroup:insert(angleBtext)
	angleBtext:addEventListener ( "touch", calcTouch )
	angleBtext.x = backEdgeX + 200
	angleBtext.y = backEdgeY + 280
	angleBtext.tap = 5
	tapTable[5] = angleBtext
	angleBtext.alpha = 0
		
  angleBtap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
  angleBtap.x = backEdgeX + 165
	angleBtap.y = backEdgeY + 280
	backGroup:insert(angleBtap)
	angleBtap:addEventListener ( "touch", calcTouch )
	angleBtap.tap = 15
	aniTable[15] = angleBtap
	
	angleCtext = display.newText( textOptionsR )
  backGroup:insert(angleCtext)
  angleCtext.text = ""
	angleCtext:addEventListener ( "touch", calcTouch )
	angleCtext.x = backEdgeX + 425
	angleCtext.y = backEdgeY + 260
	angleCtext.tap = 6
	tapTable[6] = angleCtext
	angleCtext.alpha = 0

  angleCtap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
  angleCtap.x = backEdgeX + 440
	angleCtap.y = backEdgeY + 260
	backGroup:insert(angleCtap)
	angleCtap:addEventListener ( "touch", calcTouch )
	angleCtap.tap = 16
	aniTable[16] = angleCtap
	angleCtap.alpha = 0
		
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
     Runtime:removeEventListener( "key", onKeyEvent )
      -- Called when the scene is on screen (but is about to go off screen).
      -- Insert code here to "pause" the scene.
      -- Example: stop timers, stop animation, stop audio, etc.
      
   elseif ( phase == "did" ) then
     
      -- Called immediately after scene goes off screen.
   end
end

-- "scene:destroy()"
function scene:destroy( event )

  local sceneGroup = self.view

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