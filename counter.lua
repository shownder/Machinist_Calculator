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

local diam, pointLength, pointAngle
local decPlaces, places, decLabel, measureLabel

local whatTap, tapTable

local stepSheet, buttSheet, tapSheet
local angleTap, diamTap, lengthTap
local options, charts, switch2

local toMill, toInch, goBack2, calculate
local gMeasure, measureText

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
      transition.to (decLabel, { time = 200, x = backEdgeX + 177, y = backEdgeY + 115} )
      decLabel:setFillColor(1)
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

    
    pointAngle.text = "Tap Me"
    diam.text = "Tap Me"
    pointLength.text = "Tap Me"
    
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
    
    local isDegree = false
    
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
		if measure:getLabel() == "TO METRIC" then
      gMeasure.measure = "TO IMPERIAL"
      loadsave.saveTable(gMeasure, "counterMeasure.json")
			measure:setLabel("TO IMPERIAL")
			measureLabel:setText("Metric")
			for i = 2, 3, 1 do
				if tapTable[i].text ~= "Tap Me" then
					tapTable[i].text = math.round(toMill(tapTable[i].text) * math.pow(10, places)) / math.pow(10, places)

				end
			end
		else
      gMeasure.measure = "TO METRIC"
      loadsave.saveTable(gMeasure, "counterMeasure.json")
			measure:setLabel("TO METRIC")
			measureLabel:setText("Imperial")
			for i = 2, 3, 1 do
				if tapTable[i].text ~= "Tap Me" then
					tapTable[i].text = math.round(toInch(tapTable[i].text) * math.pow(10, places)) / math.pow(10, places)
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
	
end

local function alertListener ( event )
	if "clicked" == event.action then

    
	end
end

local function measureChange2()

		if measure:getLabel() == "TO METRIC" then
			measure:setLabel("TO IMPERIAL")
			measureLabel:setText("Metric")
			for i = 2, 3, 1 do
				if tapTable[i].text ~= "Tap Me" then
					tapTable[i].text = math.round(toMill(tapTable[i].text) * math.pow(10, places)) / math.pow(10, places)

				end
			end
		else
			measure:setLabel("TO METRIC")
			measureLabel:setText("Imperial")
			for i = 2, 3, 1 do
				if tapTable[i].text ~= "Tap Me" then
					tapTable[i].text = math.round(toInch(tapTable[i].text) * math.pow(10, places)) / math.pow(10, places)
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
  
  if measure:getLabel() == "TO IMPERIAL" and myData.inch == true then
    native.showAlert ("Caution", "You have chosen an INCH drill. Switch to IMPERIAL calculations?", { "OK", "Cancel" }, alertListener4 )
  elseif measure:getLabel() == "TO METRIC" and myData.inch == false then
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
      tapTable[whatTap - 10].text = myData.number
    else
      tapTable[whatTap].text = myData.number
    end
    
    if whatTap == 1 or whatTap == 11 then
      if pointAngle.text ~= "Tap Me" and pointLength.text ~= "Tap Me" then
        diam.text = math.tan(math.rad(pointAngle.text) / 2) * pointLength.text * 2
        continue = true
      elseif pointAngle.text ~= "Tap Me" and diam.text ~= "Tap Me" then
        pointLength.text = (diam.text / 2) / (math.tan(math.rad(pointAngle.text) / 2))
        continue = true
      end
    end
        
    if whatTap == 2 or whatTap == 12 then
      if diam.text ~= "Tap Me" and pointAngle.text ~= "Tap Me" then
        pointLength.text = (diam.text / 2) / (math.tan(math.rad(pointAngle.text) / 2))
        continue = true
      elseif diam.text ~= "Tap Me" and pointLength.text ~= "Tap Me" then
        pointAngle.text = math.deg((math.atan(diam.text / 2 / pointLength.text)) * 2)
        continue = true
      end
    end
    
    if whatTap == 3 or whatTap == 13 then
      if pointAngle.text ~= "Tap Me" and pointLength.text ~= "Tap Me" then
        diam.text = math.tan(math.rad(pointAngle.text) / 2) * pointLength.text * 2
        continue = true
      elseif diam.text ~= "Tap Me" and pointLength.text ~= "Tap Me" then
        pointAngle.text = math.deg((math.atan(diam.text/2 / pointLength.text)) * 2)
        continue = true
      end
    end
        
  
    for i = 1, 3, 1 do
      if tapTable[i].text ~= "Tap Me"then
        tapTable[i].alpha = 1
        aniTable[i].alpha = 0
      end
    end
    
    if continue then   
      diam.text = math.round(diam.text * math.pow(10, places)) / math.pow(10, places)
      pointLength.text = math.round(pointLength.text * math.pow(10, places)) / math.pow(10, places)
      pointAngle.text = math.round(pointAngle.text * math.pow(10, places)) / math.pow(10, places)
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

  optionsGroup = display.newGroup ( )
  backGroup = display.newGroup()
  
  local textOptionsR = {text="Tap Me", x=0, y=0, width=100, align="right", font="BerlinSansFB-Reg", fontSize=24}
  local textOptionsL = {text="Tap Me", x=0, y=0, width=100, align="left", font="BerlinSansFB-Reg", fontSize=24}
  local textOptionsL2 = {text="Feet/min", x=0, y=0, width=100, align="left", font="BerlinSansFB-Reg", fontSize=12}
  local textOptionsR2 = {text="Inch", x=0, y=0, width=100, align="right", font="BerlinSansFB-Reg", fontSize=12}
   
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
	charts.x = backEdgeX + 420
	charts.y = backEdgeY + 110
  
  pointAngle = display.newText( textOptionsR )
  backGroup:insert(pointAngle)
	pointAngle:addEventListener ( "touch", calcTouch )
	pointAngle.x = backEdgeX + 220
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
  
  diam = display.newText( textOptionsL )
  backGroup:insert(diam)
	diam:addEventListener ( "touch", calcTouch )
	diam.x = backEdgeX + 440
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
	
	pointLength = display.newText( textOptionsL )
  backGroup:insert(pointLength)
	pointLength:addEventListener ( "touch", calcTouch )
	pointLength.x = backEdgeX + 440
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