local composer = require( "composer" )
local scene = composer.newScene()
local stepperDataFile = require("Images.stepSheet_stepSheet")
local myData = require("myData")
local widget = require ( "widget" )
local loadsave = require("loadsave")
local fm = require("fontmanager")
fm.FontManager:setEncoding("utf8")

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
local gMeasure, measureText, optionLabels, infoLabel

--Forward Functions

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
      transition.to (decLabel, { time = 200, x = backEdgeX + 177, y = backEdgeY + 115} )
	  decLabel:setFont("inputFont")
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
    
    sideAtext:setText("Tap Me")
    sideBtext:setText("Tap Me")
    sideCtext:setText("Tap Me")
    angleAtext:setText("Tap Me")
    angleBtext:setText("Tap Me")
    angleCtext:setText("Tap Me")
    
    areaAnswer:setText("")
    
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
      transition.to (decLabel, { time = 200, x = backEdgeX + 177, y = backEdgeY + 115} )
	  decLabel:setFont("inputFont")
	  options = false
    end
end

local function measureChange( event )
	local phase = event.phase
	
	if "ended" == phase then	
		if optionLabels[1]:getText() == "TO METRIC" then
			gMeasure.measure = "TO IMPERIAL"
			loadsave.saveTable(gMeasure, "obliqueMeasure.json")
			optionLabels[1]:setText("TO IMPERIAL")
			measureLabel:setText("Metric")
		for i = 1, 3, 1 do			
        if tapTable[i]:getText() ~= "Tap Me" then
					tapTable[i]:setText(math.round(toMill(tapTable[i]:getText()) * math.pow(10, places)) / math.pow(10, places))
				end
			end
		else
			gMeasure.measure = "TO METRIC"
			loadsave.saveTable(gMeasure, "obliqueMeasure.json")
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
      transition.to (decLabel, { time = 200, x = backEdgeX + 177, y = backEdgeY + 115} )
	  decLabel:setFont("inputFont")
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
      transition.to (decLabel, { time = 200, x = backEdgeX + 177, y = backEdgeY + 115} )
	  decLabel:setFont("inputFont")
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
		decLabel:setText(places)
	elseif "decrement" == phase then
		places = places - 1
		decLabel:setText(places)
	end
end

local function infoPress( event )
	local phase = event.phase		
		if "ended" == phase then
			
if resetVal then
	timer.performWithDelay( 1000, resetCalc("ended") )
    resetVal = false
    infoLabel:setText("Input")
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
		angleAtext:setText("")
		angleBtext:setText("")
		angleCtext:setText("Tap Me")
		sideAtext:setText("Tap Me")
		sideBtext:setText("Tap Me")
		sideCtext:setText("")
       	angleAtap.alpha = 0
       	angleBtap.alpha = 0
       	angleCtap.alpha = 1
       	sideAtap.alpha = 1
       	sideBtap.alpha = 1
       	sideCtap.alpha = 0
	elseif infoButt.info == 2 then
		infoButt.info = 3
		infoText:setText("2 Sides, Opposite Angle")
		angleAtext:setText("Tap Me")
		angleBtext:setText("")
		angleCtext:setText("")
		sideAtext:setText("Tap Me")
		sideBtext:setText("Tap Me")
		sideCtext:setText("")
       	angleAtap.alpha = 1
       	angleBtap.alpha = 0
       	angleCtap.alpha = 0
       	sideAtap.alpha = 1
       	sideBtap.alpha = 1
       	sideCtap.alpha = 0
	elseif infoButt.info == 3 then
		infoButt.info = 4
		infoText:setText("All Sides")
		angleAtext:setText("")
		angleBtext:setText("")
		angleCtext:setText("")
		sideAtext:setText("Tap Me")
		sideBtext:setText("Tap Me")
		sideCtext:setText("Tap Me")
      	angleAtap.alpha = 0
       	angleBtap.alpha = 0
       	angleCtap.alpha = 0
       	sideAtap.alpha = 1
       	sideBtap.alpha = 1
       	sideCtap.alpha = 1
	elseif infoButt.info == 4 then
		infoButt.info = 1
		infoText:setText("1 Side, 2 Angles")
		angleAtext:setText("Tap Me")
		angleBtext:setText("Tap Me")
		angleCtext:setText("")
		sideAtext:setText("Tap Me")
		sideBtext:setText("")
		sideCtext:setText("")
       	angleAtap.alpha = 1
       	angleBtap.alpha = 1
       	angleCtap.alpha = 0
       	sideAtap.alpha = 1
       	sideBtap.alpha = 0
       	sideCtap.alpha = 0
	end		
      
	areaAnswer:setText("")
    
	end
	end	
end

local function alertListener ( event )
	if "clicked" == event.action then

		angleAtext:setText("")
		angleBtext:setText("")
		angleCtext:setText("")
		sideAtext:setText("Tap Me")
		sideBtext:setText("Tap Me")
		sideCtext:setText("Tap Me")
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

		angleCtext:setText("")
		sideAtext:setText("Tap Me")
		sideBtext:setText("")
		sideCtext:setText("")
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
	transition.to ( optionsGroup, { time = 100, alpha = 0} )
    transition.to ( backGroup, { time = 100, alpha = 0 } )
    transition.to ( optionsBack, { time = 500, x = -170 } )
    transition.to ( optionsBack, { time = 500, y = -335 } )
	options = false
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
	
  tapTable[whatTap]:setText(myData.number)
	 
	if tapCount >= 3 then
    if infoButt.info == 1 then
      if tonumber(angleAtext:getText()) + tonumber(angleBtext:getText()) > 179 then
        native.showAlert ( "Error", "The sum of 2 angles cannot exceed 179 degrees!", { "OK" }, alertListener2 )
      else
          angleCtext:setText(180 - (angleAtext:getText() + angleBtext:getText()))
          sideBtext:setText((sideAtext:getText() * math.sin(math.rad(angleBtext:getText()))) / math.sin(math.rad(angleAtext:getText())))
          sideCtext:setText((sideAtext:getText() * math.sin(math.rad(angleCtext:getText()))) / math.sin(math.rad(angleAtext:getText())))
          continue = true
      end
    elseif infoButt.info == 2 then
      sideCtext:setText(math.sqrt((sideAtext:getText() * sideAtext:getText()) + (sideBtext:getText() * sideBtext:getText()) - (2 * sideAtext:getText() * sideBtext:getText() * math.cos(math.rad(angleCtext:getText())))))
      temp = ((sideBtext:getText() * sideBtext:getText()) + (sideCtext:getText() * sideCtext:getText()) - (sideAtext:getText() * sideAtext:getText())) / (2 * sideBtext:getText() * sideCtext:getText())
      angleAtext:setText(math.deg(math.atan(-temp / math.sqrt(-temp * temp + 1)) + 2 * math.atan(1)))
      angleBtext:setText(180 - (angleAtext:getText() + angleCtext:getText()))
      continue = true
      elseif infoButt.info == 3 then
        temp = sideBtext:getText() * math.sin(math.rad(angleAtext:getText())) / sideAtext:getText()
        angleBtext:setText(math.deg(math.atan(temp / (math.sqrt(-temp * temp + 1)))))
        angleCtext:setText(180 - (angleAtext:getText() + angleBtext:getText()))
        sideCtext:setText((sideAtext:getText() * math.sin(math.rad(angleCtext:getText()))) / math.sin(math.rad(angleAtext:getText())))
        continue = true
      elseif infoButt.info == 4 then
        local one = tonumber(sideCtext:getText())
        local two = tonumber(sideBtext:getText())
        local three = tonumber(sideAtext:getText())
        if (one + two > three) and (two + three > one) and (three + one > two) then          
          temp = ((sideBtext:getText() * sideBtext:getText()) + (sideCtext:getText() * sideCtext:getText()) - (sideAtext:getText() * sideAtext:getText())) / (2 * sideBtext:getText() * sideCtext:getText())
          angleAtext:setText(math.deg(math.atan(-temp / (math.sqrt(-temp * temp + 1))) + 2 * math.atan(1)))
          temp = sideBtext:getText() * math.sin(math.rad(angleAtext:getText())) / sideAtext:getText()
          angleBtext:setText(math.deg(math.atan(temp / (math.sqrt(-temp * temp + 1)))))
          angleCtext:setText(180 - (angleAtext:getText() + angleBtext:getText()))
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
      local temp = (sideAtext:getText() + sideBtext:getText() + sideCtext:getText()) / 2
      areaAnswer:setText(math.round(math.sqrt(temp * (temp - sideAtext:getText()) * (temp - sideBtext:getText()) * (temp - sideCtext:getText())) * math.pow(10, places)) / math.pow(10, places))

      for i =1, 6, 1 do
        tapTable[i]:setText(math.round(tapTable[i]:getText() * math.pow(10, places)) / math.pow(10, places))
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

  optionLabels = {}

  for i = 1, 3, 1 do
	optionLabels[i] = display.newBitmapText("", 0, 0, "berlinFont", 18)
  end

  optionsGroup = display.newGroup ( )
  backGroup = display.newGroup ( )
    
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
  decPlaces.x = backEdgeX + 115
  decPlaces.y = backEdgeY + 127
	
  places = 4
  decLabel = display.newBitmapText(places, 0, 0, "inputFont", 24)
  screenGroup:insert(decLabel)
  decLabel.x = backEdgeX + 178
  decLabel.y = backEdgeY + 125
  
  measureLabel = display.newBitmapText(measureText, 0, 0, "uiFont", 20)
  backGroup:insert(measureLabel)
  measureLabel.x = backEdgeX + 115
  measureLabel.y = backEdgeY + 105

  area = display.newBitmapText("Area:", 0, 0, "uiFont", 20)
  backGroup:insert(area)
  area.x = backEdgeX + 280
  area.y = backEdgeY + 220

  areaAnswer = display.newBitmapText("", 0, 0, "uiFont", 24)
  backGroup:insert(areaAnswer)
  areaAnswer:setAnchor(0, 0.5)
  areaAnswer:setJustification(areaAnswer.Justify.LEFT)
  areaAnswer.x = backEdgeX + 310
  areaAnswer.y = backEdgeY + 220
		
  infoButt = widget.newButton
	{
   	left = 0,
  	top = 0,
  	width = 90,
 	height = 37,
 	fontSize = 14,
  	id = "info",
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

  infoLabel = display.newBitmapText("Change Input", 0, 0, "uiFont", 14)
  infoLabel.x = infoButt.contentWidth / 2
  infoLabel.y = infoButt.contentHeight / 2
  infoButt:insert(infoLabel)
    
  infoText = display.newBitmapText("1 Side, 2 Angles", 0, 0, "uiFont", 18)
  backGroup:insert(infoText)
  infoText.x = backEdgeX + 335
  infoText.y = backEdgeY + 185
			
  sideAtext = display.newBitmapText("Tap Me", 0, 0, "inputFont", 22)
  backGroup:insert(sideAtext)
  sideAtext:setJustification(sideAtext.Justify.CENTER)
  sideAtext:addEventListener ( "touch", calcTouch )
  sideAtext.x = backEdgeX + 315
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

  sideBtext = display.newBitmapText("Tap Me", 0, 0, "inputFont", 22)
  backGroup:insert(sideBtext)
  sideBtext:setAnchor(0, 0.5)
  sideBtext:addEventListener ( "touch", calcTouch )
  sideBtext.x = backEdgeX + 430
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

  sideCtext = display.newBitmapText("Tap Me", 0, 0, "inputFont", 22)
  backGroup:insert(sideCtext)
  sideCtext:setAnchor(1, 0.5)
  sideCtext:setJustification(sideCtext.Justify.RIGHT)
  sideCtext:addEventListener ( "touch", calcTouch )
  sideCtext.x = backEdgeX + 165
  sideCtext.y = backEdgeY + 200
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

  angleAtext = display.newBitmapText("Tap Me", 0, 0, "inputFont", 22)
  backGroup:insert(angleAtext)
  angleAtext:setAnchor(1, 0.5)
  angleAtext:setJustification(angleAtext.Justify.RIGHT)
  angleAtext:addEventListener ( "touch", calcTouch )
  angleAtext.x = backEdgeX + 330
  angleAtext.y = backEdgeY + 70
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
	
  angleBtext = display.newBitmapText("Tap Me", 0, 0, "inputFont", 22)
  backGroup:insert(angleBtext)
  angleBtext:setAnchor(0, 0.5)
  angleBtext:addEventListener ( "touch", calcTouch )
  angleBtext.x = backEdgeX + 150
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
	
  angleCtext = display.newBitmapText("Tap Me", 0, 0, "inputFont", 22)
  backGroup:insert(angleCtext)
  angleCtext:setAnchor(1, 0.5)
  angleCtext:setJustification(angleCtext.Justify.RIGHT)
  angleCtext:addEventListener ( "touch", calcTouch )
  angleCtext.x = backEdgeX + 475
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

	  decLabel.alpha = 0
      
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