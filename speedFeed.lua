local composer = require( "composer" )
local scene = composer.newScene()
local widget = require ( "widget" )
local stepperDataFile = require("Images.stepSheet_stepSheet")
display.setStatusBar(display.HiddenStatusBar)
local myData = require("myData")
local loadsave = require("loadsave")

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

local function onKeyEvent( event )

   local phase = event.phase
   local keyName = event.keyName
   print( event.phase, event.keyName )
   
   if ( "back" == keyName and phase == "up" ) then
       
     timer.performWithDelay(100,goBack2,1)
     
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
      transition.to ( backGroup, { time = 200, x=0 } )
      transition.to ( optionsBack, { time = 200, x = -170 } )
      transition.to ( optionsBack, { time = 200, y = -335 } )
      transition.to (decLabel, { time = 200, x = backEdgeX + 177, y = backEdgeY + 115} )
      decLabel:setFillColor(1)
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
      transition.to ( backGroup, { time = 200, x=160 } )
      transition.to (decLabel, { time = 200, x = 70, y = backEdgeY + 110} )
      decLabel:setFillColor(0.15, 0.4, 0.729)
		elseif options then 
			transition.to ( optionsGroup, { time = 100, alpha = 0} )
      transition.to ( backGroup, { time = 200, x=0 } )
      transition.to ( optionsBack, { time = 200, x = -170 } )
      transition.to ( optionsBack, { time = 200, y = -335 } )
      transition.to (decLabel, { time = 200, x = backEdgeX + 177, y = backEdgeY + 115} )
      decLabel:setFillColor(1)
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
      transition.to (decLabel, { time = 200, x = backEdgeX + 177, y = backEdgeY + 115} )
      decLabel:setFillColor(1)
      options = false
    end	
    if tapTable[1].text ~= "Tap Me" and tapTable[2].text ~= "Tap Me" and tapTable[3].text ~= "Tap Me" then
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
      transition.to (decLabel, { time = 200, x = backEdgeX + 177, y = backEdgeY + 115} )
      decLabel:setFillColor(1)
      options = false
    end	
    if tapTable[1].text ~= "Tap Me" and tapTable[2].text ~= "Tap Me" and tapTable[3].text ~= "Tap Me" then
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
      transition.to ( backGroup, { time = 200, x=0 } )
      transition.to ( optionsBack, { time = 200, x = -170 } )
      transition.to ( optionsBack, { time = 200, y = -335 } )
      transition.to (decLabel, { time = 200, x = backEdgeX + 177, y = backEdgeY + 115} )
      decLabel:setFillColor(1)
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
		if measure:getLabel() == "TO METRIC" then
      gMeasure.measure = "TO IMPERIAL"
      loadsave.saveTable(gMeasure, "speedMeasure.json")
			measure:setLabel("TO IMPERIAL")
			measureLabel:setText("Metric")
      speedText.text = "Meters/min"
      minText.text = "Mill"
      revText.text = "Mill"
			for i = 2, 5, 1 do
				if tapTable[i].text ~= "Tap Me" then
					if i == 3 then
            tapTable[i].text = math.round(toMeter(tapTable[i].text) * math.pow(10, places)) / math.pow(10, places)
          else
            tapTable[i].text = math.round(toMill(tapTable[i].text) * math.pow(10, places)) / math.pow(10, places)
          end
        end
      end
    else
      gMeasure.measure = "TO METRIC"
      loadsave.saveTable(gMeasure, "speedMeasure.json")
			measure:setLabel("TO METRIC")
			measureLabel:setText("Imperial")
      speedText.text = "Feet/min"
      minText.text = "Inch"
      revText.text = "Inch"
			for i = 2, 5, 1 do
				if tapTable[i].text ~= "Tap Me" then
					if i == 3 then
            tapTable[i].text = math.round(toFoot(tapTable[i].text) * math.pow(10, places)) / math.pow(10, places)
          else
            tapTable[i].text = math.round(toInch(tapTable[i].text) * math.pow(10, places)) / math.pow(10, places)
          end
        end          
			end
		end
    if options then
			transition.to ( optionsGroup, { time = 100, alpha = 0} )
      transition.to ( backGroup, { time = 200, x=0 } )
      transition.to ( optionsBack, { time = 200, x = -170 } )
      transition.to ( optionsBack, { time = 200, y = -335 } )
      transition.to (decLabel, { time = 200, x = backEdgeX + 177, y = backEdgeY + 115} )
      decLabel:setFillColor(1)
			options = false
		end
	end	
	
	calc()
	
end

local function measureChange2()

		if measure:getLabel() == "TO METRIC" then
			measure:setLabel("TO IMPERIAL")
			measureLabel:setText("Metric")
      speedText.text = "Meters/min"
      minText.text = "Mill"
      revText.text = "Mill"
			for i = 2, 5, 1 do
				if tapTable[i].text ~= "Tap Me" then
					if i == 3 then
            tapTable[i].text = math.round(toMeter(tapTable[i].text) * math.pow(10, places)) / math.pow(10, places)
          else
            tapTable[i].text = math.round(toMill(tapTable[i].text) * math.pow(10, places)) / math.pow(10, places)
          end
        end
      end
    else
			measure:setLabel("TO METRIC")
			measureLabel:setText("Imperial")
      speedText.text = "Feet/min"
      minText.text = "Inch"
      revText.text = "Inch"
			for i = 2, 5, 1 do
				if tapTable[i].text ~= "Tap Me" then
					if i == 3 then
            tapTable[i].text = math.round(toFoot(tapTable[i].text) * math.pow(10, places)) / math.pow(10, places)
          else
            tapTable[i].text = math.round(toInch(tapTable[i].text) * math.pow(10, places)) / math.pow(10, places)
          end
        end          
			end
		end
    if options then
			transition.to ( optionsGroup, { time = 100, alpha = 0} )
      transition.to ( backGroup, { time = 200, x=0 } )
      transition.to ( optionsBack, { time = 200, x = -170 } )
      transition.to ( optionsBack, { time = 200, y = -335 } )
      transition.to (decLabel, { time = 200, x = backEdgeX + 177, y = backEdgeY + 115} )
      decLabel:setFillColor(1)
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
      tapTable[whatTap - 10].text = myData.number
    else
      tapTable[whatTap].text = myData.number
    end
    
--    if diam.text ~= "Tap Me" and rpm.text == "Tap Me" then
--      surfaceSpeedTap.alpha = 1
--    end

    if rpm.text ~= "Tap Me" and diam.text == "Tap Me" then
      surfaceSpeedTap.alpha = 0
      surfaceSpeed.alpha = 0
    elseif surfaceSpeed.text ~= "Tap Me" and diam.text == "Tap Me" then
      rpmTap.alpha = 0
      rpm.alpha = 0
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

function scene:switch()
  local screenGroup = self.view
  
  if measure:getLabel() == "TO IMPERIAL" and myData.number ~= "Tap Me" then
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
  
  if measure:getLabel() == "TO IMPERIAL" and myData.inch == true then
    native.showAlert ("Caution", "You have chosen an INCH drill. Switch to IMPERIAL calculations?", { "OK", "Cancel" }, alertListener4 )
  elseif measure:getLabel() == "TO METRIC" and myData.inch == false then
    native.showAlert ("Caution", "You have chosen an MM drill. Switch to METRIC calculations?", { "OK", "Cancel" }, alertListener4 )
  else
    scene:calculate()
  end
  
end

calc = function()
	
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
        tapTable[i]:setFillColor(1)
      end
    end	
	
end

calc2 = function()
  
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
    measureFeed = "Mill"
    measureSurface = "Meters/min"
  end

  optionsGroup = display.newGroup ( )
  backGroup = display.newGroup()
	local textOptionsR = {text="Tap Me", x=0, y=0, width=100, align="right", font="BerlinSansFB-Reg", fontSize=24}
  local textOptionsC = {text="Tap Me", x=0, y=0, width=100, align="center", font="BerlinSansFB-Reg", fontSize=24}
  local textOptionsL = {text="Tap Me", x=0, y=0, width=100, align="left", font="BerlinSansFB-Reg", fontSize=24}
  local textOptionsL2 = {text=measureSurface, x=0, y=0, width=100, align="left", font="BerlinSansFB-Reg", fontSize=12}
  local textOptionsR2 = {text=measureFeed, x=0, y=0, width=100, align="right", font="BerlinSansFB-Reg", fontSize=12}
  
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
	decPlaces.y = backEdgeY + 117
	
	places = 4
	decLabel = display.newText( screenGroup, places, 0, 0, "BerlinSansFB-Reg", 22 )
	decLabel.x = backEdgeX + 178
	decLabel.y = backEdgeY + 115
  
  measureLabel = display.newEmbossedText(backGroup, measureText, 0, 0, "BerlinSansFB-Reg", 20)
  measureLabel:setFillColor(1)
  measureLabel:setEmbossColor({highlight = {r=0, g=0, b=0, a=1}, shadow = {r=1,g=1,b=1, a=0}})
	measureLabel.x = backEdgeX + 115
	measureLabel.y = backEdgeY + 95
  
  charts = widget.newButton
	{
		id = "chartsButt",
    width = 90,
    height = 37,
		label = "Drill Charts",
		labelColor = { default = {1}, over = {0.15, 0.4, 0.729}},
		font = "BerlinSansFB-Reg",
		fontSize = 16,
    defaultFile = "Images/chartButtD.png",
    overFile = "Images/chartButtO.png",
		onEvent = goToCharts,
		}
	backGroup:insert(charts)
	charts.x = backEdgeX + 255
	charts.y = backEdgeY + 90
  
  mats = widget.newButton
	{
		id = "chartsButt",
    width = 90,
    height = 37,
		label = "Materials",
		labelColor = { default = {1}, over = {0.15, 0.4, 0.729}},
		font = "BerlinSansFB-Reg",
		fontSize = 16,
    defaultFile = "Images/chartButtD.png",
    overFile = "Images/chartButtO.png",
		onEvent = goToMats,
		}
	backGroup:insert(mats)
	mats.x = backEdgeX + 255
	mats.y = backEdgeY + 132
		
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
  --surfaceSpeedTap.alpha = 0
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