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

local diam, pointLength, pointAngle
local decPlaces, places, decLabel, measureLabel

local whatTap, tapTable

local stepSheet, buttSheet, tapSheet
local angleTap, diamTap, lengthTap
local options, charts, switch2

local toMill, toInch, goBack2, calculate
local gMeasure, measureText
local optionLabels, chartLabel

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
      transition.to (decLabel, { time = 200, x = backEdgeX + 180, y = backEdgeY + 125} )
	  decLabel:setFont("inputFont")
	  options = false
    end
  end
end

local function resetCalc(event)
	local phase = event.phase
		
		transition.to(pointAngle, {time = 300, alpha = 0})
		transition.to(diam, {time = 300, alpha = 0})
    transition.to(pointLength, {time = 300, alpha = 0})

    transition.to(angleTap, {time = 300, alpha = 1})
		transition.to(diamTap, {time = 300, alpha = 1})
    transition.to(lengthTap, {time = 300, alpha = 1})

    
    pointAngle:setText( "Tap Me")
    diam:setText( "Tap Me")
    pointLength:setText( "Tap Me")
    
    if options then
	  transition.to ( optionsGroup, { time = 100, alpha = 0} )
      transition.to ( backGroup, { time = 200, x=0 } )
      transition.to ( optionsBack, { time = 200, x = -170 } )
      transition.to ( optionsBack, { time = 200, y = -335 } )
      transition.to (decLabel, { time = 200, x = backEdgeX + 180, y = backEdgeY + 125} )
	  decLabel:setFont("inputFont")
	  options = false
    end	
end

local function alertListener2 ( event )
	if "clicked" == event.action then
    local i = event.index
    if 1 == i then
      timer.performWithDelay( 1000, resetCalc("ended") )
      whatTap = 2
      myData.isOverlay = true
      composer.showOverlay( "charts", { effect="fromTop", time=100, isModal = true }  )
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
      transition.to (decLabel, { time = 200, x = backEdgeX + 180, y = backEdgeY + 125} )
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
    
    local isDegree = false
    
    if options then
	  transition.to ( optionsGroup, { time = 100, alpha = 0} )
      transition.to ( backGroup, { time = 200, x=0 } )
      transition.to ( optionsBack, { time = 200, x = -170 } )
      transition.to ( optionsBack, { time = 200, y = -335 } )
      transition.to (decLabel, { time = 200, x = backEdgeX + 180, y = backEdgeY + 125} )
	  decLabel:setFont("inputFont")
	  options = false
    end
		
    whatTap = event.target.tap
    
    if whatTap == 1 or whatTap == 11 then
      isDegree = true
    end
    
    if isDegree then
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
			loadsave.saveTable(gMeasure, "counterMeasure.json")
			optionLabels[1]:setText("TO IMPERIAL")
			measureLabel:setText("Metric")
		for i = 2, 3, 1 do			
			if tapTable[i]:getText() ~= "Tap Me" then
					tapTable[i]:setText(math.round(toMill(tapTable[i]:getText()) * math.pow(10, places)) / math.pow(10, places))
				end
			end
		else
			gMeasure.measure = "TO METRIC"
			loadsave.saveTable(gMeasure, "counterMeasure.json")
			optionLabels[1]:setText("TO METRIC")
			measureLabel:setText("Imperial")
			for i = 2, 3, 1 do
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
      transition.to (decLabel, { time = 200, x = backEdgeX + 180, y = backEdgeY + 125} )
	  decLabel:setFont("inputFont")
	  options = false
		end
    
	end
end

local function alertListener ( event )
	if "clicked" == event.action then

    
	end
end

local function measureChange2()

	  if optionLabels[1]:getText() == "TO METRIC" then
			gMeasure.measure = "TO IMPERIAL"
			loadsave.saveTable(gMeasure, "counterMeasure.json")
			optionLabels[1]:setText("TO IMPERIAL")
			measureLabel:setText("Metric")
		for i = 2, 3, 1 do			
			if tapTable[i]:getText() ~= "Tap Me" then
				tapTable[i]:setText(math.round(toMill(tapTable[i]:getText()) * math.pow(10, places)) / math.pow(10, places))
			end
		end
	  else
			gMeasure.measure = "TO METRIC"
			loadsave.saveTable(gMeasure, "counterMeasure.json")
			optionLabels[1]:setText("TO METRIC")
			measureLabel:setText("Imperial")
			for i = 2, 3, 1 do
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
      transition.to (decLabel, { time = 200, x = backEdgeX + 180, y = backEdgeY + 125} )
	  decLabel:setFont("inputFont")
	  options = false
	end
end	

-----------------------------------
--Functions Used After Calculate
-----------------------------------

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

function scene:calculate()
  local screenGroup = self.view
  
  myData.isOverlay = false
  local continue = false
  local errorBox = false
    
  if whatTap == 1 or whatTap == 11 then
    if tonumber(myData.number) > 179 then
      native.showAlert ( "Error", "Point Angle must be less than 180°", { "OK" }, alertListener )
      errorBox = true
    end
  end
    
  if myData.number ~= "Tap Me" and not errorBox then    
          	
    if whatTap > 3 then
      tapTable[whatTap - 10]:setText( myData.number)
    else
      tapTable[whatTap]:setText( myData.number)
    end
    
    if whatTap == 1 or whatTap == 11 then
      if pointAngle:getText() ~= "Tap Me" and pointLength:getText() ~= "Tap Me" then
        diam:setText( math.tan(math.rad(pointAngle:getText()) / 2) * pointLength:getText() * 2)
        continue = true
      elseif pointAngle:getText() ~= "Tap Me" and diam:getText() ~= "Tap Me" then
        pointLength:setText( (diam:getText() / 2) / (math.tan(math.rad(pointAngle:getText()) / 2)))
        continue = true
      end
    end
        
    if whatTap == 2 or whatTap == 12 then
      if diam:getText() ~= "Tap Me" and pointAngle:getText() ~= "Tap Me" then
        pointLength:setText( (diam:getText() / 2) / (math.tan(math.rad(pointAngle:getText()) / 2)))
        continue = true
      elseif diam:getText() ~= "Tap Me" and pointLength:getText() ~= "Tap Me" then
        pointAngle:setText( math.deg((math.atan(diam:getText() / 2 / pointLength:getText())) * 2))
        continue = true
      end
    end
    
    if whatTap == 3 or whatTap == 13 then
      if pointAngle:getText() ~= "Tap Me" and pointLength:getText() ~= "Tap Me" then
        diam:setText( math.tan(math.rad(pointAngle:getText()) / 2) * pointLength:getText() * 2)
        continue = true
      elseif diam:getText() ~= "Tap Me" and pointLength:getText() ~= "Tap Me" then
        pointAngle:setText( math.deg((math.atan(diam:getText()/2 / pointLength:getText())) * 2))
        continue = true
      end
    end
        
  
    for i = 1, 3, 1 do
      if tapTable[i]:getText() ~= "Tap Me"then
        tapTable[i].alpha = 1
        aniTable[i].alpha = 0
      end
    end
    
    if continue then   
      diam:setText( math.round(diam:getText() * math.pow(10, places)) / math.pow(10, places))
      pointLength:setText( math.round(pointLength:getText() * math.pow(10, places)) / math.pow(10, places))
      pointAngle:setText( math.round(pointAngle:getText() * math.pow(10, places)) / math.pow(10, places))
    end
  end
end

toMill = function(num)

	return num * 25.4	

end

toInch = function(num)
	
	return num / 25.4
	
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

-- "scene:create()"
function scene:create( event )
local screenGroup = self.view
   
  tapTable = {}
  aniTable = {}
  options = false

  gMeasure = loadsave.loadTable("counterMeasure.json")
  if gMeasure == nil then
    gMeasure = {}
    gMeasure.measure = "TO METRIC"
    loadsave.saveTable(gMeasure, "counterMeasure.json")
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
  backGroup = display.newGroup()
   
  back = display.newImageRect( screenGroup, "backgrounds/background.png", 570, 360 )
	back.x = display.contentCenterX
	back.y = display.contentCenterY
  backEdgeX = back.contentBounds.xMin
	backEdgeY = back.contentBounds.yMin
  
  Runtime:addEventListener( "key", onKeyEvent )
  
	stepSheet = graphics.newImageSheet("Images/stepSheet_stepSheet.png", stepperDataFile.getSpriteSheetData() )
  
  rightDisplay = display.newImageRect(backGroup, "backgrounds/counter.png", 570, 360)
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
  decPlaces.x = backEdgeX + 117
  decPlaces.y = backEdgeY + 127
	
  places = 4
  decLabel = display.newBitmapText(places, 0, 0, "inputFont", 24)
  screenGroup:insert(decLabel)
  decLabel.x = backEdgeX + 180
  decLabel.y = backEdgeY + 125
  
  measureLabel = display.newBitmapText(measureText, 0, 0, "uiFont", 20)
  backGroup:insert(measureLabel)
  measureLabel.x = backEdgeX + 118
  measureLabel.y = backEdgeY + 100
  
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
	charts.x = backEdgeX + 420
	charts.y = backEdgeY + 110

  chartLabel = display.newBitmapText("Drill Charts", 0, 0, "uiFont", 16)
  chartLabel.x = charts.contentWidth / 2
  chartLabel.y = charts.contentHeight / 2
  charts:insert(chartLabel)

  pointAngle = display.newBitmapText("Tap Me", 0, 0, "inputFont", 22)
  backGroup:insert(pointAngle)
  pointAngle:setJustification(pointAngle.Justify.RIGHT)
  pointAngle:setAnchor(1, 0.5)
  pointAngle:addEventListener ( "touch", calcTouch )
  pointAngle.x = backEdgeX + 265
  pointAngle.y = backEdgeY + 300
  tapTable[1] = pointAngle 
  pointAngle.tap = 1
  pointAngle.alpha = 0
  
  angleTap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
  angleTap.x = backEdgeX + 250
  angleTap.y = backEdgeY + 305
  backGroup:insert(angleTap)
  angleTap:addEventListener ( "touch", calcTouch )
  angleTap.tap = 11
  aniTable[1] = angleTap
  
  diam = display.newBitmapText("Tap Me", 0, 0, "inputFont", 22)
  backGroup:insert(diam)
  diam:setAnchor(0, 0.5)
  diam:addEventListener ( "touch", calcTouch )
  diam.x = backEdgeX + 390
  diam.y = backEdgeY + 48
  tapTable[2] = diam
  diam.tap = 2
  diam.alpha = 0
  
  diamTap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
  diamTap.x = backEdgeX + 407
  diamTap.y = backEdgeY + 53
  backGroup:insert(diamTap)
  diamTap:addEventListener ( "touch", calcTouch )
  diamTap.tap = 12
  aniTable[2] = diamTap 
	
  pointLength = display.newBitmapText("Tap Me", 0, 0, "inputFont", 22)
  backGroup:insert(pointLength)
  pointLength:setAnchor(0, 0.5)
  pointLength:addEventListener ( "touch", calcTouch )
  pointLength.x = backEdgeX + 390
  pointLength.y = backEdgeY + 260
  pointLength.alpha = 0
  tapTable[3] = pointLength
  pointLength.tap = 3
  
  lengthTap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
  lengthTap.x = backEdgeX + 410
  lengthTap.y = backEdgeY + 265
  backGroup:insert(lengthTap)
  lengthTap:addEventListener ( "touch", calcTouch )
  lengthTap.tap = 13
  aniTable[3] = lengthTap
  
  optionsGroup.anchorX = 0.5; optionsGroup.anchorY = 0.5; 
  backGroup.anchorX = 0.5; backGroup.anchorY = 0.5; 
  backGroup.alpha = 0
  transition.to ( backGroup, { time = 500, alpha = 1, delay = 200} )
  optionsBack.alpha = 0
  transition.to ( optionsBack, { time = 500, alpha = 1, delay = 600} )
  optionsButt.alpha = 0
  transition.to ( optionsButt, { time = 500, alpha = 1, delay = 600} )
  
  screenGroup:insert(backGroup)

   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
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