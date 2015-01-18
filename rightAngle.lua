local composer = require( "composer" )
local scene = composer.newScene()
local widget = require ( "widget" )
local stepperDataFile = require("Images.stepSheet_stepSheet")
display.setStatusBar(display.HiddenStatusBar)
local myData = require("myData")
local loadsave = require("loadsave")
local fm = require("fontmanager")
fm.FontManager:setEncoding("utf8")

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here

local back, isDegree, rightDisplay
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
local toMill, toInch, goBack2
local gMeasure, measureText
local optionLabels

local BerlinSansFB 

--Local Functions

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

local function resetCalc(event)
	local phase = event.phase
		
  sideAtext:setText("Tap Me")
  sideBtext:setText("Tap Me")
  sideCtext:setText("Tap Me")
  angleAtext:setText("Tap Me")
  angleBtext:setText("Tap Me")
    
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
    
  areaAnswer:setText("")
    
  tapCount = 0
	continue = false
  myData.number = nil
    
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

local function goBack(event)
	
	transition.to ( optionsGroup, { time = 100, alpha = 0} )
    transition.to ( backGroup, { time = 100, alpha = 0 } )
    transition.to ( optionsBack, { time = 500, x = -170 } )
    transition.to ( optionsBack, { time = 500, y = -335 } )
	options = false
	composer.gotoScene( "menu", { effect="fromBottom", time=800})
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
     
      if whatTap == 14 or whatTap == 15 then
        isDegree = true else isDegree = false
      end
      
      if isDegree then
        composer.showOverlay( "calculator", { effect="fromRight", time=200, params = { negTrue = false, needDec = true, isDegree = true }, isModal = true }  )
      else
        composer.showOverlay( "calculator", { effect="fromRight", time=200, params = { negTrue = false, needDec = true, isDegree = fasle }, isModal = true }  )
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

local function calcTouch( event )
	if event.phase == "ended" then
    
    local continue = false
    
    for i = 1, 5, 1 do
      if tapTable[i]:getText() == "Tap Me" then
        continue = true
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
		
	  whatTap = event.target.tap
		
		if whatTap > 5 then
			tapCount = tapCount + 1
		end
    
    if whatTap == 4 or whatTap == 5 or whatTap == 14 or whatTap == 15 then
      isDegree = true
    else
      isDegree = false
    end
        
    if not continue then
      native.showAlert ("Continue?", "Press OK to reset all values and continue.", { "OK", "Cancel" }, alertListener2 )
    elseif isDegree then
		composer.showOverlay( "calculator", { effect="fromRight", time=200, params = { negTrue = false, needDec = true, isDegree = true }, isModal = true }  )
    else
      composer.showOverlay( "calculator", { effect="fromRight", time=200, params = { negTrue = false, needDec = true, isDegree = false }, isModal = true }  )
    end
		
		return true
	end
end

local function measureChange( event )
	local phase = event.phase
	
	if "ended" == phase then	
		if optionLabels[1]:getText() == "TO METRIC" then
			gMeasure.measure = "TO IMPERIAL"
			loadsave.saveTable(gMeasure, "rightMeasure.json")
			optionLabels[1]:setText("TO IMPERIAL")
			measureLabel:setText("Metric")
		for i = 1, 3, 1 do			
        if tapTable[i]:getText() ~= "Tap Me" then
					tapTable[i]:setText(math.round(toMill(tapTable[i]:getText()) * math.pow(10, places)) / math.pow(10, places))
				end
			end
		else
			gMeasure.measure = "TO METRIC"
			loadsave.saveTable(gMeasure, "rightMeasure.json")
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

local function alertListener ( event )
	if "clicked" == event.action then

		sideAtap.alpha = 1
		sideAtext.alpha = 0
		sideBtap.alpha = 1
		sideBtext.alpha = 0
		sideAtext:setText("Tap Me")
		sideBtext:setText("Tap Me")
		tapCount = 1
    
		if angleAtext:getText() == "Tap Me" then
			angleAtap.alpha = 1
			angleAtext.alpha = 0
		end
    
		if angleBtext:getText() == "Tap Me" then
			angleBtap.alpha = 1
			angleBtext.alpha = 0
		end
    
	end
end

--Functions used by Calculate()
toMill = function(num)
  return num * 25.4	
end

toInch = function(num)
  return num / 25.4
end

local function sideAcalc()
	if sideAtext:getText() ~= "Tap Me" and sideCtext:getText() ~= "Tap Me" then
		sideBtext:setText(math.sqrt(( sideCtext:getText() * sideCtext:getText()) - ( sideAtext:getText() * sideAtext:getText())))
		angleAtext:setText(math.deg(math.atan( sideAtext:getText() / sideBtext:getText() )))
		angleBtext:setText(90 - angleAtext:getText())
	elseif sideAtext:getText() ~= "Tap Me" and sideBtext:getText() ~= "Tap Me" then
		angleAtext:setText(math.deg(math.atan( sideAtext:getText() / sideBtext:getText() )))
		angleBtext:setText(90 - angleAtext:getText())
		sideCtext:setText(math.sqrt(( sideAtext:getText() * sideAtext:getText()) + ( sideBtext:getText() * sideBtext:getText())))
	elseif sideAtext:getText() ~= "Tap Me" and angleAtext:getText() ~= "Tap Me" then
		sideBtext:setText((sideAtext:getText() / (math.tan(math.rad(angleAtext:getText())))))
		angleBtext:setText(90 - angleAtext:getText())
		sideCtext:setText(math.sqrt(( sideAtext:getText() * sideAtext:getText()) + ( sideBtext:getText() * sideBtext:getText())))
	elseif sideAtext:getText() ~= "Tap Me" and angleBtext:getText() ~= "Tap Me" then
		angleAtext:setText(90 - angleBtext:getText())
		sideBtext:setText((sideAtext:getText() / (math.tan(math.rad(angleAtext:getText())))))
		sideCtext:setText(math.sqrt(( sideAtext:getText() * sideAtext:getText()) + ( sideBtext:getText() * sideBtext:getText())))
	end
end

local function sideBcalc()
	if sideBtext:getText() ~= "Tap Me" and sideCtext:getText() ~= "Tap Me" then
		sideAtext:setText(math.sqrt (( sideCtext:getText() * sideCtext:getText() ) - ( sideBtext:getText() * sideBtext:getText() )))
		angleAtext:setText(math.deg(math.atan( sideAtext:getText() / sideBtext:getText())))
		angleBtext:setText(90 - angleAtext:getText())
	elseif sideBtext:getText() ~= "Tap Me" and angleAtext:getText() ~= "Tap Me" then
		angleBtext:setText(90 - angleAtext:getText())
		sideAtext:setText((sideBtext:getText() / (math.tan(math.rad(angleBtext:getText())))))
		sideCtext:setText(math.sqrt(( sideAtext:getText() * sideAtext:getText()) + ( sideBtext:getText() * sideBtext:getText())))
	elseif sideBtext:getText() ~= "Tap Me" and angleBtext:getText() ~= "Tap Me" then
		angleAtext:setText(90 - angleBtext:getText())
		sideAtext:setText((sideBtext:getText() / (math.tan(math.rad(angleBtext:getText())))))
		sideCtext:setText(math.sqrt(( sideAtext:getText() * sideAtext:getText()) + ( sideBtext:getText() * sideBtext:getText())))
	elseif sideAtext:getText() ~= "Tap Me" and sideBtext:getText() ~= "Tap Me" then
		angleAtext:setText(math.deg(math.atan( sideAtext:getText() / sideBtext:getText() )))
		angleBtext:setText(90 - angleAtext:getText())
		sideCtext:setText(math.sqrt(( sideAtext:getText() * sideAtext:getText()) + ( sideBtext:getText() * sideBtext:getText())))
	end
end

local function sideCcalc()
	if sideCtext:getText() ~= "Tap Me" and angleAtext:getText() ~= "Tap Me" then
		angleBtext:setText(90 - angleAtext:getText())
		sideAtext:setText(sideCtext:getText() * (math.sin(math.rad(angleAtext:getText()))))
		sideBtext:setText(sideCtext:getText() * (math.cos(math.rad(angleAtext:getText()))))
	elseif sideCtext:getText() ~= "Tap Me" and angleBtext:getText() ~= "Tap Me" then
		angleAtext:setText(90 - angleBtext:getText())
		sideAtext:setText(sideCtext:getText() * (math.sin(math.rad(angleAtext:getText()))))
		sideBtext:setText(sideCtext:getText() * (math.cos(math.rad(angleAtext:getText()))))
	elseif sideBtext:getText() ~= "Tap Me" and sideCtext:getText() ~= "Tap Me" then
		sideAtext:setText(math.sqrt (( sideCtext:getText() * sideCtext:getText() ) - ( sideBtext:getText() * sideBtext:getText() )))
		angleAtext:setText(math.deg(math.atan( sideAtext:getText() / sideBtext:getText() )))
		angleBtext:setText(90 - angleAtext:getText())
	elseif sideAtext:getText() ~= "Tap Me" and sideCtext:getText() ~= "Tap Me" then
		sideBtext:setText(math.sqrt(( sideCtext:getText() * sideCtext:getText()) - ( sideAtext:getText() * sideAtext:getText())))
		angleAtext:setText(math.deg(math.atan( sideAtext:getText() / sideBtext:getText() )))
		angleBtext:setText(90 - angleAtext:getText())
	end
end

local function angAcalc()
	if sideCtext:getText() ~= "Tap Me" and angleAtext:getText() ~= "Tap Me" then
		angleBtext:setText(90 - angleAtext:getText())
		sideAtext:setText(sideCtext:getText() * (math.sin(math.rad(angleAtext:getText()))))
		sideBtext:setText(sideCtext:getText() * (math.cos(math.rad(angleAtext:getText()))))
	elseif sideBtext:getText() ~= "Tap Me" and angleAtext:getText() ~= "Tap Me" then
		angleBtext:setText(90 - angleAtext:getText())
		sideAtext:setText((sideBtext:getText() / (math.tan(math.rad(angleBtext:getText())))))
		sideCtext:setText(math.sqrt(( sideAtext:getText() * sideAtext:getText()) + ( sideBtext:getText() * sideBtext:getText())))
	elseif sideAtext:getText() ~= "Tap Me" and angleAtext:getText() ~= "Tap Me" then
		sideBtext:setText((sideAtext:getText() / (math.tan(math.rad(angleAtext:getText())))))
		angleBtext:setText(90 - angleAtext:getText())
		sideCtext:setText(math.sqrt(( sideAtext:getText() * sideAtext:getText()) + ( sideBtext:getText() * sideBtext:getText())))
	end
end

local function angBcalc()
	if sideCtext:getText() ~= "Tap Me" and angleBtext:getText() ~= "Tap Me" then
		angleAtext:setText(90 - angleBtext:getText())
		sideAtext:setText(sideCtext:getText() * (math.sin(math.rad(angleAtext:getText()))))
		sideBtext:setText(sideCtext:getText() * (math.cos(math.rad(angleAtext:getText()))))
	elseif sideBtext:getText() ~= "Tap Me" and angleBtext:getText() ~= "Tap Me" then
		angleAtext:setText(90 - angleBtext:getText())
		sideAtext:setText((sideBtext:getText() / (math.tan(math.rad(angleBtext:getText())))))
		sideCtext:setText(math.sqrt(( sideAtext:getText() * sideAtext:getText()) + ( sideBtext:getText() * sideBtext:getText())))
	elseif sideAtext:getText() ~= "Tap Me" and angleBtext:getText() ~= "Tap Me" then
		angleAtext:setText(90 - angleBtext:getText())
		sideBtext:setText((sideAtext:getText() / (math.tan(math.rad(angleAtext:getText())))))
		sideCtext:setText(math.sqrt(( sideAtext:getText() * sideAtext:getText()) + ( sideBtext:getText() * sideBtext:getText())))
	end
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

---------------------------------------------------------------------------------
--Functions for Use in the Overlay
---------------------------------------------------------------------------------

function scene:calculate()
  local screenGroup = self.view
    
  myData.isOverlay = false
    
  if myData.number ~= "Tap Me" then
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
	
    tapTable[whatTap]:setText(myData.number)
	
    if angleAtext:getText() ~= "Tap Me" then
      if tonumber(angleAtext:getText()) >= 90 then
			angleAtext:setText("89")
      end
    elseif angleBtext:getText() ~= "Tap Me" then
      if tonumber(angleBtext:getText()) >= 90 then
        angleBtext:setText("89")
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
        angleBtext:setText(90 - angleAtext:getText())
        angleBtext.alpha = 1
        angleBtap.alpha = 0
      elseif whatTap == 5 then		
        angleAtext:setText(90 - angleBtext:getText())
        angleAtext.alpha = 1
        angleAtap.alpha = 0
      end
    end
		
    if (continue) then
      if sideCtext:getText() ~= "Tap Me" then
        if sideAtext:getText() ~= "Tap Me" then
          if tonumber(sideCtext:getText()) < tonumber(sideAtext:getText()) then
            native.showAlert ( "Error", "Hypotenuse cannot be smaller than another side!", { "OK" }, alertListener )
            continue = false
          end
        elseif sideBtext:getText() ~= "Tap Me" then
          if tonumber(sideCtext:getText()) < tonumber(sideBtext:getText()) then
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
      local areaContent = 0.5 * (sideAtext:getText() * sideBtext:getText())
      areaAnswer:setText(math.round(areaContent * math.pow(10, places)) / math.pow(10, places))
    end
		
    if (continue) then
      for i =1, 5, 1 do
        tapTable[i]:setText(math.round(tapTable[i]:getText() * math.pow(10, places)) / math.pow(10, places))
      end
    end
  
    for i = 1, 5, 1 do
      if tapTable[i]:getText() ~= "Tap Me" then
        doneCount = doneCount + 1
      end
    end
  
  else
    tapCount = tapCount - 1
  end	 
end 

-- "scene:create()"
function scene:create( event )
  local screenGroup = self.view

  BerlinSansFB = "BerlinSansFB-Reg.tff#Berlin Sans FB"

  optionLabels = {}

  for i = 1, 3, 1 do
	optionLabels[i] = display.newBitmapText("", 0, 0, "berlinFont", 18)
  end
	
  doneCount = 0
	tapTable = {}
	aniTable = {}
	optionsGroup = display.newGroup ( )
  backGroup = display.newGroup()
	options = false


  gMeasure = loadsave.loadTable("rightMeasure.json")
  if gMeasure == nil then
    gMeasure = {}
    gMeasure.measure = "TO METRIC"
    loadsave.saveTable(gMeasure, "rightMeasure.json")
  end

	if gMeasure.measure == "TO METRIC" then
		measureText = "Imperial"
	else
		measureText = "Metric"
	end
  
  Runtime:addEventListener( "key", onKeyEvent )
  
	stepSheet = graphics.newImageSheet("Images/stepSheet_stepSheet.png", stepperDataFile.getSpriteSheetData() )
	
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
  optionsBack.anchorX = 0
  optionsBack.anchorY = 0
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
  decPlaces.y = backEdgeY + 117
	
  places = 4
  decLabel = display.newBitmapText(places, 0, 0, "inputFont", 24)
  screenGroup:insert(decLabel)
  decLabel.x = backEdgeX + 178
  decLabel.y = backEdgeY + 115
  
  measureLabel = display.newBitmapText(measureText, 0, 0, "uiFont", 20)
  backGroup:insert(measureLabel)
  measureLabel.x = backEdgeX + 115
  measureLabel.y = backEdgeY + 95

  area = display.newBitmapText("Area:", 0, 0, "uiFont", 20)
  backGroup:insert(area)
  area.x = backEdgeX + 320
  area.y = backEdgeY + 230
  
  areaAnswer = display.newBitmapText("", 0, 0, "uiFont", 24)
  backGroup:insert(areaAnswer)
  areaAnswer:setAnchor(0, 0.5)
  areaAnswer:setJustification(areaAnswer.Justify.LEFT)
  areaAnswer.x = backEdgeX + 350
  areaAnswer.y = backEdgeY + 230
	
  sideCtext = display.newBitmapText("Tap Me", 0, 0, "inputFont", 22)
  sideCtext:addEventListener ( "touch", calcTouch )
  backGroup:insert(sideCtext)
  sideCtext:setJustification(sideCtext.Justify.CENTER)
  sideCtext.x = backEdgeX + 290
  sideCtext.y = backEdgeY + 145
  sideCtext.tap = 1
  tapTable[1] = sideCtext
  sideCtext.alpha = 0

  sideCtap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
  sideCtap.x = backEdgeX + 280
  sideCtap.y = backEdgeY + 140
  backGroup:insert(sideCtap)
  sideCtap:addEventListener ( "touch", calcTouch )
  sideCtap.tap = 11
  aniTable[11] = sideCtap

  sideAtext = display.newBitmapText("Tap Me", 0, 0, "inputFont", 22)
  sideAtext:addEventListener ( "touch", calcTouch )
  backGroup:insert(sideAtext)
  sideAtext:setJustification(sideAtext.Justify.CENTER)
  sideAtext.x = backEdgeX + 330
  sideAtext.y = backEdgeY + 270
  sideAtext.tap = 2
  tapTable[2] = sideAtext
  sideAtext.alpha = 0
	
  sideAtap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
  sideAtap.x = backEdgeX + 330
  sideAtap.y = backEdgeY + 270
  backGroup:insert(sideAtap)
  sideAtap:addEventListener ( "touch", calcTouch )
  sideAtap.tap = 12
  aniTable[12] = sideAtap
	
  sideBtext = display.newBitmapText("Tap Me", 0, 0, "inputFont", 22)
  sideBtext:addEventListener ( "touch", calcTouch )
  backGroup:insert(sideBtext)
  sideBtext:setAnchor(1, 0.5)
  sideBtext:setJustification(sideBtext.Justify.RIGHT)
  sideBtext.x = backEdgeX + 490
  sideBtext.y = backEdgeY + 175
  sideBtext.tap = 3
  tapTable[3] = sideBtext
  sideBtext.alpha = 0
	
  sideBtap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
  sideBtap.x = backEdgeX + 460
  sideBtap.y = backEdgeY + 180
  backGroup:insert(sideBtap)
  sideBtap:addEventListener ( "touch", calcTouch )
  sideBtap.tap = 13
  aniTable[13] = sideBtap
		
  angleAtext = display.newBitmapText("Tap Me", 0, 0, "inputFont", 22)
  angleAtext:addEventListener ( "touch", calcTouch )
  backGroup:insert(angleAtext)
  angleAtext:setAnchor(1, 0.5)
  angleAtext:setJustification(angleAtext.Justify.RIGHT)
  angleAtext.x = backEdgeX + 445
  angleAtext.y = backEdgeY + 70
  angleAtext.tap = 4
  tapTable[4] = angleAtext
  angleAtext.alpha = 0
	
  angleAtap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
  angleAtap.x = backEdgeX + 430
  angleAtap.y = backEdgeY + 70
  backGroup:insert(angleAtap)
  angleAtap:addEventListener ( "touch", calcTouch )
  angleAtap.tap = 14
  aniTable[14] = angleAtap
	
  angleBtext = display.newBitmapText("Tap Me", 0, 0, "inputFont", 22)
  angleBtext:addEventListener ( "touch", calcTouch )
  backGroup:insert(angleBtext)
  angleBtext:setAnchor(0, 0.5)
  angleBtext:setJustification(angleBtext.Justify.LEFT)
  angleBtext.x = backEdgeX + 135
  angleBtext.y = backEdgeY + 295
  angleBtext.tap = 5
  tapTable[5] = angleBtext
  angleBtext.alpha = 0
	
  angleBtap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
  angleBtap.x = backEdgeX + 160
  angleBtap.y = backEdgeY + 290
  backGroup:insert(angleBtap)
  angleBtap:addEventListener ( "touch", calcTouch )
  angleBtap.tap = 15
  aniTable[15] = angleBtap

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

   local screenGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
      
   elseif ( phase == "did" ) then
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