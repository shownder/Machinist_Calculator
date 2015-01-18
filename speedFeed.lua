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

local optionsGroup, backGroup
local back, menuBack, backEdgeX, backEdgeY, rightDisplay

local decStep, menu, reset, measure

local diam, surfaceSpeed, rpm, rev, minute, speedText, revText, minText
local decPlaces, places, decLabel, measureLabel

local whatTap, tapTable, aniTap
local feedFlag, speedFlag

local stepSheet, buttSheet, tapSheet
local rpmTap, diamTap, revTap, surfaceSpeedTap, minuteTap
local options, charts, mats

local calc, clac2, addListeners, removeListeners, toMill, toInch, goBack2, calculate, toFoot, toMeter
local gMeasure, measureText, measureFeed, measureSurface
local optionLabels, matLabel, chartLabel

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
		
	transition.to(rpm, {time = 300, alpha = 0})
	transition.to(diam, {time = 300, alpha = 0})
    transition.to(surfaceSpeed, {time = 300, alpha = 0})
	transition.to(rev, {time = 300, alpha = 0})
	transition.to(minute, {time = 300, alpha = 0})
    transition.to(rpmTap, {time = 300, alpha = 1})
	transition.to(diamTap, {time = 300, alpha = 1})
    transition.to(surfaceSpeedTap, {time = 300, alpha = 1})
	transition.to(revTap, {time = 300, alpha = 0})
	transition.to(minuteTap, {time = 300, alpha = 0})
    
    rpm:setText( "Tap Me")
    diam:setText( "Tap Me")
    surfaceSpeed:setText( "Tap Me")
    minute:setText( "Tap Me")
    rev:setText( "Tap Me")
    
    speedFlag = false
    feedFlag = false
    
    timer.performWithDelay( 10, addListeners )
    
    if options then
	  transition.to ( optionsGroup, { time = 100, alpha = 0} )
      transition.to ( backGroup, { time = 200, x=0 } )
      transition.to ( optionsBack, { time = 200, x = -170 } )
      transition.to ( optionsBack, { time = 200, y = -335 } )
      transition.to (decLabel, { time = 200, x = backEdgeX + 183, y = backEdgeY + 115} )
	  decLabel:setFont("inputFont")
	  options = false
		end
    myData.inch = false
		
end

local function alertListener2 ( event )
	if "clicked" == event.action then
    local i = event.index
    if 1 == i then
      timer.performWithDelay( 500, resetCalc("ended") )
      whatTap = 2
      myData.isOverlay = true
      composer.showOverlay( "charts", { effect="fromTop", time=100, isModal = true }  )
    end
  end
end

local function alertListener3 ( event )
	if "clicked" == event.action then
    local i = event.index
    if 1 == i then
      timer.performWithDelay( 500, resetCalc("ended") )
      whatTap = 2
      myData.isOverlay = true
      composer.showOverlay( "materials", { effect="fromTop", time=500, isModal = true }  )
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
      transition.to (decLabel, { time = 200, x = backEdgeX + 183, y = backEdgeY + 115} )
	  decLabel:setFont("inputFont")
	  options = false
    end
  end
end

local function goToCharts(event)
  local phase = event.phase  
  
  if "ended" == phase then
    if options then
	  transition.to ( optionsGroup, { time = 100, alpha = 0} )
      transition.to ( backGroup, { time = 200, x=0 } )
      transition.to ( optionsBack, { time = 200, x = -170 } )
      transition.to ( optionsBack, { time = 200, y = -335 } )
      transition.to (decLabel, { time = 200, x = backEdgeX + 183, y = backEdgeY + 115} )
	  decLabel:setFont("inputFont")
	  options = false
    end
    if tapTable[1]:getText() ~= "Tap Me" and tapTable[2]:getText() ~= "Tap Me" and tapTable[3]:getText() ~= "Tap Me" then
      native.showAlert ("Continue?", "Choosing new Diameter will reset all values!", { "OK", "Cancel" }, alertListener2 )
    else
      whatTap = 2
      myData.isOverlay = true
      composer.showOverlay( "charts", { effect="fromTop", time=100, isModal = true }  )
    end
  end  
end

local function goToMats(event)
  local phase = event.phase  
  
  if "ended" == phase then
    if options then
	  transition.to ( optionsGroup, { time = 100, alpha = 0} )
      transition.to ( backGroup, { time = 200, x=0 } )
      transition.to ( optionsBack, { time = 200, x = -170 } )
      transition.to ( optionsBack, { time = 200, y = -335 } )
      transition.to (decLabel, { time = 200, x = backEdgeX + 183, y = backEdgeY + 115} )
	  decLabel:setFont("inputFont")
	  options = false
    end
    if tapTable[1]:getText() ~= "Tap Me" and tapTable[2]:getText() ~= "Tap Me" and tapTable[3]:getText() ~= "Tap Me" then
      native.showAlert ("Continue?", "Choosing new Surface Speed will reset all values!", { "OK", "Cancel" }, alertListener3 )
    else
      whatTap = 3
      myData.isOverlay = true
      composer.showOverlay( "materials", { effect="fromTop", time=500, isModal = true }  )
    end
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
      composer.showOverlay( "calculator", { effect="fromTop", time=200, params = { negTrue = false, needDec = true }, isModal = true }  )
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
	composer.gotoScene( "menu", { effect="fromBottom", time=800})
	return true   
	end
end

local function stepPress( event )
	local phase = event.phase
	
	if "increment" == phase then
		places = places + 1
		decLabel:setText( places)
	elseif "decrement" == phase then
		places = places - 1
		decLabel:setText( places)
	end
end

local function calcTouch( event )
	if event.phase == "ended" then
    
    local continue = false
    
    for i = 1, 3, 1 do
      if tapTable[i]:getText() == "Tap Me" then
         continue = true
      end
    end
    
    if options then
	  transition.to ( optionsGroup, { time = 100, alpha = 0} )
      transition.to ( backGroup, { time = 200, x=0 } )
      transition.to ( optionsBack, { time = 200, x = -170 } )
      transition.to ( optionsBack, { time = 200, y = -335 } )
      transition.to (decLabel, { time = 200, x = backEdgeX + 183, y = backEdgeY + 115} )
	  decLabel:setFont("inputFont")
	  options = false
    end
		
    whatTap = event.target.tap
    
    if whatTap > 3 then
      continue = true
    end
    		
    if not continue then
      native.showAlert ("Continue?", "Press OK to reset all values and continue.", { "OK", "Cancel" }, alertListener )
    else
      composer.showOverlay( "calculator", { effect="fromRight", time=200, params = { negTrue = false, needDec = true }, isModal = true }  )
    end
		
		return true
	end
end

local function measureChange( event )
	local phase = event.phase
	if "ended" == phase then	
		if optionLabels[1]:getText() == "TO METRIC" then
			gMeasure.measure = "TO IMPERIAL"
			loadsave.saveTable(gMeasure, "speedMeasure.json")
			optionLabels[1]:setText("TO IMPERIAL")
			measureLabel:setText("Metric")
			speedText:setText("Meters/min")
			minText:setText("MM")
			revText:setText("MM")
			for i = 2, 5, 1 do
				if tapTable[i]:getText() ~= "Tap Me" then
					if i == 3 then
						tapTable[i]:setText(math.round(toMeter(tapTable[i]:getText()) * math.pow(10, places)) / math.pow(10, places))
					else
						tapTable[i]:setText(math.round(toMill(tapTable[i]:getText()) * math.pow(10, places)) / math.pow(10, places))
					end
				end
			end
		else
			gMeasure.measure = "TO METRIC"
			loadsave.saveTable(gMeasure, "speedMeasure.json")
			optionLabels[1]:setText("TO METRIC")
			measureLabel:setText("Imperial")
			speedText:setText("Feet/min")
			minText:setText("Inch")
			revText:setText("Inch")
			for i = 2, 5, 1 do
				if tapTable[i]:getText() ~= "Tap Me" then
					if i == 3 then
						tapTable[i]:setText(math.round(toFoot(tapTable[i]:getText()) * math.pow(10, places)) / math.pow(10, places))
					else
						tapTable[i]:setText(math.round(toInch(tapTable[i]:getText()) * math.pow(10, places)) / math.pow(10, places))
					end
				end          
			end
		end
    if options then
	  transition.to ( optionsGroup, { time = 100, alpha = 0} )
      transition.to ( backGroup, { time = 200, x=0 } )
      transition.to ( optionsBack, { time = 200, x = -170 } )
      transition.to ( optionsBack, { time = 200, y = -335 } )
      transition.to (decLabel, { time = 200, x = backEdgeX + 183, y = backEdgeY + 115} )
	  decLabel:setFont("inputFont")
	  options = false
	end
	end	
	
	calc()
	
end

local function measureChange2()

		if optionLabels[1]:getText() == "TO METRIC" then
			gMeasure.measure = "TO IMPERIAL"
			loadsave.saveTable(gMeasure, "speedMeasure.json")
			optionLabels[1]:setText("TO IMPERIAL")
			measureLabel:setText("Metric")
			speedText:setText("Meters/min")
			minText:setText("MM")
			revText:setText("MM")
			for i = 2, 5, 1 do
				if tapTable[i]:getText() ~= "Tap Me" then
					if i == 3 then
						tapTable[i]:setText(math.round(toMeter(tapTable[i]:getText()) * math.pow(10, places)) / math.pow(10, places))
					else
						tapTable[i]:setText(math.round(toMill(tapTable[i]:getText()) * math.pow(10, places)) / math.pow(10, places))
					end
				end
			end
		else
			gMeasure.measure = "TO METRIC"
			loadsave.saveTable(gMeasure, "speedMeasure.json")
			optionLabels[1]:setText("TO METRIC")
			measureLabel:setText("Imperial")
			speedText:setText("Feet/min")
			minText:setText("Inch")
			revText:setText("Inch")
			for i = 2, 5, 1 do
				if tapTable[i]:getText() ~= "Tap Me" then
					if i == 3 then
						tapTable[i]:setText(math.round(toFoot(tapTable[i]:getText()) * math.pow(10, places)) / math.pow(10, places))
					else
						tapTable[i]:setText(math.round(toInch(tapTable[i]:getText()) * math.pow(10, places)) / math.pow(10, places))
					end
				end          
			end
		end
    if options then
	  transition.to ( optionsGroup, { time = 100, alpha = 0} )
      transition.to ( backGroup, { time = 200, x=0 } )
      transition.to ( optionsBack, { time = 200, x = -170 } )
      transition.to ( optionsBack, { time = 200, y = -335 } )
      transition.to (decLabel, { time = 200, x = backEdgeX + 183, y = backEdgeY + 115} )
	  decLabel:setFont("inputFont")
	  options = false
	end
	
	calc()
	
end

---------------------------------------------------
--Functions used after overlay
---------------------------------------------------

function scene:calculate()
  local screenGroup = self.view
  
  myData.isOverlay = false
    
  if myData.number ~= "Tap Me" then    
          	
    if whatTap > 5 then
      tapTable[whatTap - 10]:setText( myData.number)
    else
      tapTable[whatTap]:setText( myData.number)
    end
    
--    if diam:getText() ~= "Tap Me" and rpm:getText() == "Tap Me" then
--      surfaceSpeedTap.alpha = 1
--    end

    if rpm:getText() ~= "Tap Me" and diam:getText() == "Tap Me" then
      surfaceSpeedTap.alpha = 0
      surfaceSpeed.alpha = 0
    elseif surfaceSpeed:getText() ~= "Tap Me" and diam:getText() == "Tap Me" then
      rpmTap.alpha = 0
      rpm.alpha = 0
    end
                
    if rpm:getText() ~= "Tap Me" and (rev:getText() ~= "Tap Me" or minute:getText() ~= "Tap Me") then
    	feedFlag = true
    else 
    	feedFlag = false
    end
    
    if diam:getText() ~= "Tap Me" and (rpm:getText() ~= "Tap Me" or surfaceSpeed:getText() ~= "Tap Me") then
    	speedFlag = true
    else
    	speedFlag = false
    end
    
    if rpm:getText() ~= "Tap Me" and diam:getText() ~= "Tap Me" and surfaceSpeed:getText() ~= "Tap Me" then
      --do nothing
    else
      calc()
    end
    
    if rev:getText() ~= "Tap Me" or minute:getText() ~= "Tap Me" then
      calc2()
    end
    
    if rpm:getText() ~= "Tap Me" then
      revTap.alpha = 1
      minuteTap.alpha = 1
    end
    
    if rev:getText() ~= "Tap Me" or minute:getText() ~= "Tap Me" then
      revTap.alpha = 0
      rev.alpha = 1
      minuteTap.alpha = 0
      minute.alpha = 1
    end
    
    for i = 1, 3, 1 do
      if tapTable[i]:getText() ~= "Tap Me"then
        tapTable[i].alpha = 1
        aniTable[i].alpha = 0
      end
    end
  end
end

function scene:switch()
  local screenGroup = self.view
  
  if optionLabels[1]:getText() == "TO IMPERIAL" and myData.number ~= "Tap Me" then
    myData.number = myData.number / 3.2808
    myData.number = math.round(myData.number * math.pow(10, places)) / math.pow(10, places)
    scene:calculate()
  else
    scene:calculate()
  end
end

local function alertListener4 ( event )
	if "clicked" == event.action then
    local i = event.index
    if 1 == i then
      measureChange2()
      timer.performWithDelay(100, scene:calculate())
    end
  end
end

function scene:switch2()
  local screenGroup = self.view
  
  if myData.inch == true then print("it's true") elseif myData.inch == false then print("it's false") else print("It's Nothing" .. " " .. myData.number) end
  
  if optionLabels[1]:getText() == "TO IMPERIAL" and myData.inch == true then
    native.showAlert ("Caution", "You have chosen an INCH drill. Switch to IMPERIAL calculations?", { "OK", "Cancel" }, alertListener4 )
  elseif optionLabels[1]:getText() == "TO METRIC" and myData.inch == false then
    native.showAlert ("Caution", "You have chosen an MM drill. Switch to METRIC calculations?", { "OK", "Cancel" }, alertListener4 )
  else
    scene:calculate()
  end
  
end

calc = function()
	
	if speedFlag then
    	if optionLabels[1]:getText() == "TO METRIC" then
    	  if rpm:getText() ~= "Tap Me" then
          surfaceSpeed:setText( rpm:getText() * diam:getText() / 3.8197)
          surfaceSpeed.alpha = 1
          surfaceSpeedTap.alpha = 0
          print("surface speed")
    	elseif surfaceSpeed:getText() ~= "Tap Me" then
          rpm:setText( 3.8197 * surfaceSpeed:getText() / diam:getText())
          rpmTap.alpha = 0
          rpm.alpha = 1
    	end
    elseif optionLabels[1]:getText() == "TO IMPERIAL" then
    	if rpm:getText() ~= "Tap Me" then
          surfaceSpeed:setText( diam:getText() * rpm:getText() / 318.31)
          surfaceSpeed.alpha = 1
          surfaceSpeedTap.alpha = 0
    	elseif surfaceSpeed:getText() ~= "Tap Me" then
          rpm:setText( 318.31 * surfaceSpeed:getText() / diam:getText())
          rpmTap.alpha = 0
          rpm.alpha = 1
    	end    			
    end
      
      for i = 1, 5, 1 do
			if tapTable[i]:getText() ~= "Tap Me" then
				if i == 1 then
					tapTable[1]:setText( math.round(tapTable[1]:getText() * math.pow(10, 0)) / math.pow(10, 0))
				else
				tapTable[i]:setText( math.round(tapTable[i]:getText() * math.pow(10, places)) / math.pow(10, places))
				end
			end
      end
    
      timer.performWithDelay( 10, removeListeners, 2 )
    end	
	
end

calc2 = function()
  
      if feedFlag then
    	if (minute:getText() ~= "Tap Me") and (whatTap == 5 or whatTap == 15) then
    		rev:setText( minute:getText() / rpm:getText())
        tapTable[4]:setText( math.round(tapTable[4]:getText() * math.pow(10, places)) / math.pow(10, places))
    	elseif (rev:getText() ~= "Tap Me") and (whatTap == 4 or whatTap == 14) then
    		minute:setText( rev:getText() * rpm:getText())
        tapTable[5]:setText( math.round(tapTable[5]:getText() * math.pow(10, places)) / math.pow(10, places))
    	end
    end
end

addListeners = function()
  
  surfaceSpeed:addEventListener ( "touch", calcTouch )
  
end

removeListeners = function()
  
  surfaceSpeed:removeEventListener ( "touch", calcTouch )
  
end
  

toMill = function(num)

	return num * 25.4	

end

toMeter = function(num)
  
  return num / 3.2808
end

toInch = function(num)
	
	return num / 25.4
	
end

toFoot = function(num)
  
  return num * 3.2808
  
end

goBack2 = function()
	
  if (myData.isOverlay) then
    myData.number = "Tap Me"
    composer.hideOverlay("slideUp", 500)
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

-- "scene:create()"
function scene:create( event )
  local screenGroup = self.view
	
  tapTable = {}
  aniTable = {}
  feedFlag = false
  speedFlag = false
  options = false

  gMeasure = loadsave.loadTable("speedMeasure.json")
  if gMeasure == nil then
    gMeasure = {}
    gMeasure.measure = "TO METRIC"
    loadsave.saveTable(gMeasure, "speedMeasure.json")
  end

  if gMeasure.measure == "TO METRIC" then
    measureText = "Imperial"
    measureFeed = "Inch"
    measureSurface = "Feet/min"
  else
    measureText = "Metric"
    measureFeed = "MM"
    measureSurface = "Meters/min"
  end

  optionLabels = {}

  for i = 1, 3, 1 do
	optionLabels[i] = display.newBitmapText("", 0, 0, "berlinFont", 18)
  end

  optionsGroup = display.newGroup ( )
  backGroup = display.newGroup()
  
  Runtime:addEventListener( "key", onKeyEvent )
  
  stepSheet = graphics.newImageSheet("Images/stepSheet_stepSheet.png", stepperDataFile.getSpriteSheetData() )
	
  back = display.newImageRect ( screenGroup, "backgrounds/background.png",  570, 360 )
  back.x = display.contentCenterX
  back.y = display.contentCenterY		
  backEdgeX = back.contentBounds.xMin
  backEdgeY = back.contentBounds.yMin
  
  rightDisplay = display.newImageRect(backGroup, "backgrounds/speeds.png", 570, 360)
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
  decPlaces.x = backEdgeX + 120
  decPlaces.y = backEdgeY + 117
	
  places = 4
  decLabel = display.newBitmapText(places, 0, 0, "inputFont", 24)
  screenGroup:insert(decLabel)
  decLabel.x = backEdgeX + 183
  decLabel.y = backEdgeY + 115
  
  measureLabel = display.newBitmapText(measureText, 0, 0, "uiFont", 20)
  backGroup:insert(measureLabel)
  measureLabel.x = backEdgeX + 115
  measureLabel.y = backEdgeY + 90
  
  charts = widget.newButton
	{
		id = "chartsButt",
		width = 90,
		height = 37,
		defaultFile = "Images/chartButtD.png",
		overFile = "Images/chartButtO.png",
		onEvent = goToCharts,
	}
	backGroup:insert(charts)
	charts.x = backEdgeX + 255
	charts.y = backEdgeY + 90

  chartLabel = display.newBitmapText("Drill Charts", 0, 0, "uiFont", 16)
  chartLabel.x = charts.contentWidth / 2
  chartLabel.y = charts.contentHeight / 2
  charts:insert(chartLabel)

  mats = widget.newButton
	{
		id = "chartsButt",
		width = 90,
		height = 37,
		defaultFile = "Images/chartButtD.png",
		overFile = "Images/chartButtO.png",
		onEvent = goToMats,
	}
	backGroup:insert(mats)
	mats.x = backEdgeX + 255
	mats.y = backEdgeY + 132

  matLabel = display.newBitmapText("Materials", 0, 0, "uiFont", 16)
  matLabel.x = mats.contentWidth / 2
  matLabel.y = mats.contentHeight / 2
  mats:insert(matLabel)

  rpm = display.newBitmapText("Tap Me", 0, 0, "inputFont", 22)
  backGroup:insert(rpm)
  rpm:setJustification(rpm.Justify.RIGHT)
  rpm:setAnchor(1, 0.5)
  rpm:addEventListener ( "touch", calcTouch )
  rpm.x = backEdgeX + 335
  rpm.y = backEdgeY + 165
  tapTable[1] = rpm 
  rpm.tap = 1
  rpm.alpha = 0
  
  rpmTap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
  rpmTap.x = backEdgeX + 320
  rpmTap.y = backEdgeY + 170
  backGroup:insert(rpmTap)
  rpmTap:addEventListener ( "touch", calcTouch )
  rpmTap.tap = 11
  aniTable[1] = rpmTap 
	
  diam = display.newBitmapText("Tap Me", 0, 0, "inputFont", 22)
  backGroup:insert(diam)
  diam:setJustification(diam.Justify.RIGHT)
  diam:setAnchor(1, 0.5)
  diam:addEventListener ( "touch", calcTouch )
  diam.x = backEdgeX + 350
  diam.y = backEdgeY + 255
  tapTable[2] = diam
  diam.tap = 2
  diam.alpha = 0
  
  diamTap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)diamTap.x = backEdgeX + 330
  diamTap.y = backEdgeY + 260
  backGroup:insert(diamTap)
  diamTap:addEventListener ( "touch", calcTouch )
  diamTap.tap = 12
  aniTable[2] = diamTap 
	
  surfaceSpeed = display.newBitmapText("Tap Me", 0, 0, "inputFont", 22)
  backGroup:insert(surfaceSpeed)
  surfaceSpeed:setJustification(surfaceSpeed.Justify.RIGHT)
  surfaceSpeed:setAnchor(1, 0.5)
  surfaceSpeed:addEventListener ( "touch", calcTouch )
  surfaceSpeed.x = backEdgeX + 370
  surfaceSpeed.y = backEdgeY + 310
  surfaceSpeed.alpha = 0
  tapTable[3] = surfaceSpeed
  surfaceSpeed.tap = 3
  
  surfaceSpeedTap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
  surfaceSpeedTap.x = backEdgeX + 355
  surfaceSpeedTap.y = backEdgeY + 310
  backGroup:insert(surfaceSpeedTap)
  surfaceSpeedTap:addEventListener ( "touch", calcTouch )
  surfaceSpeedTap.tap = 13
  aniTable[3] = surfaceSpeedTap

  rev = display.newBitmapText("Tap Me", 0, 0, "inputFont", 22)
  rev:addEventListener ( "touch", calcTouch )
  backGroup:insert(rev)
  rev:setAnchor(0, 0.5)
  rev.x = backEdgeX + 100
  rev.y = backEdgeY + 265
  rev.alpha = 0
  tapTable[4] = rev
  rev.tap = 4
  
  revTap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
  revTap.x = backEdgeX + 120
  revTap.y = backEdgeY + 270
  backGroup:insert(revTap)
  revTap:addEventListener ( "touch", calcTouch )
  revTap.tap = 14
  revTap.alpha = 0

  minute = display.newBitmapText("Tap Me", 0, 0, "inputFont", 22)
  minute:addEventListener ( "touch", calcTouch )
  backGroup:insert(minute)
  minute:setAnchor(0, 0.5)
  minute.x = backEdgeX + 100
  minute.y = backEdgeY + 215
  minute.alpha = 0
  tapTable[5] = minute
  minute.tap = 5
  
  minuteTap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
  minuteTap.x = backEdgeX + 120
  minuteTap.y = backEdgeY + 220
  backGroup:insert(minuteTap)
  minuteTap:addEventListener ( "touch", calcTouch )
  minuteTap.tap = 15
  minuteTap.alpha = 0
	
  speedText = display.newBitmapText(measureSurface, 0, 0, "inputFont", 16)
  backGroup:insert(speedText)
  speedText:setAnchor(0, 0.5)
  speedText.x = backEdgeX + 458
  speedText.y = backEdgeY + 279
	
  revText = display.newBitmapText(measureFeed, 0, 0, "inputFont", 14)
  backGroup:insert(revText)
  revText:setJustification(revText.Justify.RIGHT)
  revText:setAnchor(1, 0.5)
  revText.x = backEdgeX + 90
  revText.y = backEdgeY + 245
	
  minText = display.newBitmapText(measureFeed, 0, 0, "inputFont", 14)
  backGroup:insert(minText)
  minText:setJustification(minText.Justify.RIGHT)
  minText:setAnchor(1, 0.5)
  minText.x = backEdgeX + 90
  minText.y = backEdgeY + 196
  
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
      -- Called when the scene is on screen (but is about to go off screen).
      -- Insert code here to "pause" the scene.
      -- Example: stop timers, stop animation, stop audio, etc.
      Runtime:removeEventListener( "key", onKeyEvent )
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

   -- Called prior to the removal of scene's view ("sceneGroup").
   -- Insert code here to clean up the scene.
   -- Example: remove display objects, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene