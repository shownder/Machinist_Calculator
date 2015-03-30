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

local decStep, menu, reset
local places, decLabel, decPlaces

local whatTap, tapCount, tapTable, aniTable

local options, continue
local stepSheet, buttSheet, tapSheet

local addListeners, removeListeners, goBack2
local gMeasure, measureText, optionLabels

local majorDiamLabel, measurement, threadAngleLabel
local typeTap, angleWheel, diaWheel
local infoButt, infoLabel, pickerGroup, backBox, backLabel
local angleTap, threadTap, basicMajorTap, actualWireTap, effectiveTap, overTap
local angleNum, threadNum, basicMajorNum, actualWireNum, effectiveNum, overNum
local wireSize, tolButt, infoGroup

local bestWireCalc, softReset, pitchMath, overMath


---Listeners

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
      transition.to (decLabel, { time = 200, x = backEdgeX + 490, y = backEdgeY + 93} )
	  decLabel:setFont("inputFont")
	  options = false
    transition.to( infoGroup, { time = 200, x = display.contentWidth } )
    end
  end
end

local function tolInfoMove(event)
  local phase = event.phase

  if phase == "ended" then
    if infoGroup.x > 0 then
      transition.to( infoGroup, { time = 200, x = 0 } )
    else
      transition.to( infoGroup, { time = 200, x = display.contentWidth } )
    end
  end
end

local function measureChange( event )
  local phase = event.phase

  local function threadCalc()
    local temp = 1 / threadNum:getText()
    threadNum:setText((math.round(temp * math.pow(10, places)) / math.pow(10, places)))
  end

  local function pitchCalc()
    local temp = 1 / threadNum:getText()
    threadNum:setText((math.round(temp * math.pow(10, 2)) / math.pow(10, 2)))
  end
  
  if "began" == phase then

    if threadNum:getText() ~= "Tap Me" then
      if measurement:getText() == "Threads per Inch" then
        threadCalc()
      elseif measurement:getText() == "Pitch of Thread" then
        pitchCalc()
      end
    end

  elseif "ended" == phase then  
    if optionLabels[1]:getText() == "TPI" then
      gMeasure.measure = "Pitch"
      loadsave.saveTable(gMeasure, "threadMeasure.json")
      optionLabels[1]:setText("Pitch")
      measurement:setText("Threads per Inch")
      if angleNum:getText() == "60° ISO Metric" or angleNum:getText() == "30° Trapezoid" then
        angleNum:setText("Tap Me")
        angleNum.alpha = 0
        angleTap.alpha = 1
        wireSize:setText("0")
        wireSize.alpha = 0
        threadNum:setText("Tap Me")
        threadNum.alpha = 0
        threadTap.alpha = 1
      end
    else
      gMeasure.measure = "TPI"
      loadsave.saveTable(gMeasure, "threadMeasure.json")
      optionLabels[1]:setText("TPI")
      measurement:setText("Pitch of Thread")
    end
    
    if options then
    transition.to ( optionsGroup, { time = 100, alpha = 0} )
      transition.to ( backGroup, { time = 200, x=0 } )
      transition.to ( optionsBack, { time = 200, x = -170 } )
      transition.to ( optionsBack, { time = 200, y = -335 } )
      transition.to (decLabel, { time = 200, x = backEdgeX + 490, y = backEdgeY + 93} )
    decLabel:setFont("inputFont")
    options = false
    transition.to( infoGroup, { time = 200, x = display.contentWidth } )
    end

    if wireSize:getText() ~= "0" and angleNum:getText() ~= "Tap Me" then
      bestWireCalc()
    end
    
  end
end

local function resetCalc(event)
	local phase = event.phase

  if phase == "ended" then

  for i = 1, #tapTable, 1 do
    transition.to(tapTable[i], {time = 300, alpha = 0})
    transition.to(aniTable[i], {time = 300, alpha = 0})
    tapTable[i]:setText("Tap Me")
  end

  -- transition.to(angleNum, {time = 300, alpha = 0})
  -- angleNum:setText("Tap Me")
  transition.to(wireSize, {time = 300, alpha = 0})
  wireSize:setText("0")

  -- transition.to(angleTap, {time = 300, alpha = 1})
  transition.to(threadTap, {time = 300, alpha = 1})
    
  --timer.performWithDelay( 10, addListeners )
    
  if options then
	  transition.to ( optionsGroup, { time = 100, alpha = 0} )
      transition.to ( backGroup, { time = 200, x=0 } )
      transition.to ( optionsBack, { time = 200, x = -170 } )
      transition.to ( optionsBack, { time = 200, y = -335 } )
      transition.to (decLabel, { time = 200, x = backEdgeX + 490, y = backEdgeY + 93} )
    decLabel:setFont("inputFont")
    options = false
   transition.to( infoGroup, { time = 200, x = display.contentWidth } )
	end
end
end

local function negAlert(event)
if event.action == "clicked" then

  print("Okay was pressed")

  for i = 1, #tapTable, 1 do
    transition.to(tapTable[i], {time = 300, alpha = 0})
    transition.to(aniTable[i], {time = 300, alpha = 0})
    tapTable[i]:setText("Tap Me")
  end

  transition.to(wireSize, {time = 300, alpha = 0})
  wireSize:setText("0")

  transition.to(threadTap, {time = 300, alpha = 1})

end
end

softReset = function()

  for i = 1, #tapTable, 1 do
    tapTable[i]:setText("Tap Me")
    tapTable[i].alpha = 0
  end

  threadTap.alpha = 1
  basicMajorTap.alpha = 0
  actualWireTap.alpha = 0

  wireSize:setText("0")
  wireSize.alpha = 0

--   if majorDiamLabel:getText() == "Measurement over Wires" then
--       effectiveTap.alpha = 1
--       overTap.alpha = 0
--     elseif majorDiamLabel:getText() == "Pitch Diameter" then
--       overTap.alpha = 1
--       effectiveTap.alpha = 0
--     elseif majorDiamLabel:getText() == "Basic Major Diam Only" then
--       effectiveTap.alpha = 0
--       overTap.alpha = 0
--   end

end

local function goBack(event)
	
	transition.to ( optionsGroup, { time = 100, alpha = 0} )
    transition.to ( backGroup, { time = 100, alpha = 0 } )
    transition.to ( optionsBack, { time = 500, x = -170 } )
    transition.to ( optionsBack, { time = 500, y = -335 } )
	options = false
	composer.gotoScene( "menu", { effect="fromBottom", time=800})
  transition.to( infoGroup, { time = 200, x = display.contentWidth } )
	return true
end

local function calcTouch( event )
	if event.phase == "ended" then
		
		whatTap = event.target.tap
    if whatTap > 3 then
      whatTap = whatTap - 10
    end

    print( whatTap )
    
    if options then
	  transition.to ( optionsGroup, { time = 100, alpha = 0} )
      transition.to ( backGroup, { time = 200, x=0 } )
      transition.to ( optionsBack, { time = 200, x = -170 } )
      transition.to ( optionsBack, { time = 200, y = -335 } )
      transition.to (decLabel, { time = 200, x = backEdgeX + 490, y = backEdgeY + 93} )
    decLabel:setFont("inputFont")
    options = false
    transition.to( infoGroup, { time = 200, x = display.contentWidth } )
		end

    if whatTap == 2 and angleNum:getText() == "60° UN" then
      print("NEED A SCREW!")
      composer.showOverlay( "calculator", { effect="fromRight", time=200, params = { negTrue = false, needDec = true, isDegree = false, needScrew = true }, isModal = true }  )
    else
      print("DO NOT NEED A SCREW!")
      composer.showOverlay( "calculator", { effect="fromRight", time=200, params = { negTrue = false, needDec = true, isDegree = false }, isModal = true }  )
    end
		return true
	end
end

-- local function typeTouch( event )
--   if event.phase == "began" then
    
--     if majorDiamLabel:getText() == "Basic Major Diam Only" then
--       majorDiamLabel:setText("Pitch Diameter")
--       effectiveTap.alpha = 0
--       overTap.alpha = 1
--     elseif majorDiamLabel:getText() == "Pitch Diameter" then
--       majorDiamLabel:setText("Measurement over Wires")
--       overTap.alpha = 0
--       effectiveTap.alpha = 1
--     elseif majorDiamLabel:getText() == "Measurement over Wires" then
--       majorDiamLabel:setText("Basic Major Diam Only")
--       effectiveTap.alpha = 0
--       overTap.alpha = 0
--     end

--     effectiveNum:setText("Tap Me")
--     effectiveNum.alpha = 0
--     overNum:setText("Tap Me")
--     overNum.alpha = 0

--     gMeasure.type = majorDiamLabel:getText()
--     loadsave.saveTable(gMeasure, "threadMeasure.json")

--     if options then
--     transition.to ( optionsGroup, { time = 100, alpha = 0} )
--       transition.to ( backGroup, { time = 200, x=0 } )
--       transition.to ( optionsBack, { time = 200, x = -170 } )
--       transition.to ( optionsBack, { time = 200, y = -335 } )
--       transition.to (decLabel, { time = 200, x = backEdgeX + 490, y = backEdgeY + 93} )
--     decLabel:setFont("inputFont")
--     options = false
--     end

--   end
-- end

local function angleTouch( event )
  if event.phase == "began" then

    if options then
    transition.to ( optionsGroup, { time = 100, alpha = 0} )
      transition.to ( backGroup, { time = 200, x=0 } )
      transition.to ( optionsBack, { time = 200, x = -170 } )
      transition.to ( optionsBack, { time = 200, y = -335 } )
      transition.to (decLabel, { time = 200, x = backEdgeX + 490, y = backEdgeY + 93} )
    decLabel:setFont("inputFont")
    options = false
    end

    if angleWheel.x >= display.contentWidth then
      transition.to( angleWheel, { time = 300, x = display.contentWidth - angleWheel.contentWidth} )
      transition.to( backBox, { time = 300, x = display.contentWidth - angleWheel.contentWidth} )
      transition.to( backLabel, { time = 300, x = display.contentWidth - angleWheel.contentWidth + 7} )
    else
      transition.to( angleWheel, { time = 300, x = display.contentWidth} )
      transition.to( backBox, { time = 300, x = display.contentWidth} )
      transition.to( backLabel, { time = 300, x = display.contentWidth} )

      if angleWheel:getValues()[1].value ~= angleNum:getText() then
        softReset()
      end

      angleNum:setText(angleWheel:getValues()[1].value)
      angleNum.alpha = 1
      angleTap.alpha = 0

      if angleNum:getText() == "60° ISO Metric" or angleNum:getText() == "30° Trapezoid" then
        if gMeasure.measure == "Pitch" then
          gMeasure.measure = "TPI"
          loadsave.saveTable(gMeasure, "threadMeasure.json")
          optionLabels[1]:setText("TPI")
          measurement:setText("Pitch of Thread")
          native.showAlert( "Notice", "Changed to Pitch of Thread" , { "OK" } )
        end
      else
        if gMeasure.measure == "TPI" then
          gMeasure.measure = "Pitch"
          loadsave.saveTable(gMeasure, "threadMeasure.json")
          optionLabels[1]:setText("Pitch")
          measurement:setText("Threads per Inch")
          native.showAlert( "Notice", "Changed to Threads per Inch" , { "OK" } )
        end
      end
    end
  end
  return true
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

--Local Functions

-- addListeners = function()
  
--   sineSize:addEventListener ( "touch", calcTouch )
  
-- end

-- removeListeners = function()
  
--   sineSize:removeEventListener ( "touch", calcTouch )
  
-- end

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
  transition.to( infoGroup, { time = 200, x = display.contentWidth } )
  end
		
end

bestWireCalc = function()

  print("calculate the best wire size!")

  local temp = string.sub( angleNum:getText(), 1 , 2 )
  temp = tonumber( temp )
  
  local temp2 = threadNum:getText()
  
  if measurement:getText() == "Threads per Inch" then
    temp2 = 1 / temp2
  end

  local temp3 = (temp2 / 2) * (1 / math.cos(math.rad(temp) / 2))

  wireSize:setText(math.round(temp3 * math.pow(10, places)) / math.pow(10, places))

  wireSize.alpha = 1
  
  if basicMajorNum:getText() == "Tap Me" and actualWireNum:getText() == "Tap Me" then
    basicMajorTap.alpha = 1
    actualWireTap.alpha = 1
  end
end

pitchMath = function()

  local factorPitch
  local angleNumber = string.sub( angleNum:getText(), 1 , 2 )
  local acme = false
  if angleNum:getText()== "29° Stub Acme" then
    acme = true
  end
  local answer
  local pitch = threadNum:getText()

  if measurement:getText() == "Threads per Inch" then
    pitch = 1 / pitch
  end

  if angleNumber == "60" then
    factorPitch = 0.649519
  elseif angleNumber == "55" then
    factorPitch = 0.640327
  elseif acme then
    factorPitch = 0.3
  else
    factorPitch = 0.5
  end

  answer = basicMajorNum:getText() - (pitch * factorPitch)

  if angleNumber == "29" then
    answer = answer - (0.008 * math.sqrt(basicMajorNum:getText()))
  end

  print(answer)

  return answer

end

overMath = function()

  local pitch = threadNum:getText()
  local angleNumber = string.sub( angleNum:getText(), 1 , 2 )
  local answer
  local actual = tonumber(actualWireNum:getText())

  if measurement:getText() == "Threads per Inch" then
    pitch = 1 / pitch
  end

  if angleNumber == "55" then
    answer = effectiveNum:getText() - (0.9605 * pitch) + (3.1657 * actual)
  elseif angleNumber == "60" then
    answer = effectiveNum:getText() - (0.86603 * pitch) + (3 * actual)
  elseif angleNumber == "30" then
    answer = effectiveNum:getText() + (actualWireNum:getText() * (1 + math.sin(math.rad(15))))
  elseif angleNumber == "29" then
    answer = effectiveNum:getText() + (actualWireNum:getText() * (1 + math.sin(math.rad(14.5))))
  end

  return answer

end

function scene:calculate()

  local screenGroup = self.view
  
      myData.isOverlay = false
    
    if myData.number ~= "Tap Me" then

      if whatTap > 5 then
        whatTap = whatTap - 10
      end

      tapTable[whatTap]:setText(myData.number)
      tapTable[whatTap].alpha = 1
      aniTable[whatTap].alpha = 0

      if angleNum:getText() ~= "Tap Me" and threadNum:getText() ~= "Tap Me" then
        bestWireCalc()
      end

      if wireSize:getText() ~= "0" and basicMajorNum:getText() ~= "Tap Me" and actualWireNum:getText() ~= "Tap Me" then
        effectiveNum:setText(pitchMath())
      end      

      if effectiveNum:getText() ~= "Tap Me" then
        overNum:setText(overMath())
      end

      if overNum:getText() ~= "Tap Me" then
        overNum:setText(math.round(overNum:getText() * math.pow(10, places)) / math.pow(10, places))
        overNum.alpha = 1
      end

      if effectiveNum:getText() ~= "Tap Me" then
        effectiveNum:setText(math.round(effectiveNum:getText() * math.pow(10, places)) / math.pow(10, places))
        effectiveNum.alpha = 1
      end

      if effectiveNum:getText() ~= "Tap Me" and overNum:getText() ~= "Tap Me" then
        if tonumber(effectiveNum:getText()) < 0 or tonumber(overNum:getText()) < 0 then
          native.showAlert( "Error", "Negative values are not correct. Please check your input.", { "OK" }, negAlert )   
        end
      end

    end

end

---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )

   local screenGroup = self.view

   pickerGroup = display.newGroup( )

	tapCount = 0
	tapTable = {}
  aniTable = {}
  optionsGroup = display.newGroup ( )
  backGroup = display.newGroup ( )
  infoGroup = display.newGroup ( )
	continue = false

  gMeasure = loadsave.loadTable("threadMeasure.json")
  if gMeasure == nil then
    gMeasure = {}
    gMeasure.measure = "Pitch"
    --gMeasure.type = "Basic Major Diam Only"
    loadsave.saveTable(gMeasure, "threadMeasure.json")
  end

  if gMeasure.measure == "Pitch" then
    gMeasure.label = "Threads per Inch"
  else
    gMeasure.label = "Pitch of Thread"
  end

  optionLabels = {}

  for i = 1, 4, 1 do
	optionLabels[i] = display.newBitmapText("", 0, 0, "berlinFont", 18)
  end

    local textOptionsR = {text="Tap Me", x=0, y=0, width=100, align="right", font="BerlinSansFB-Reg", fontSize=24}
    local textOptionsC = {text="Tap Me", x=0, y=0, width=100, align="center", font="BerlinSansFB-Reg", fontSize=24}
    local textOptionsL = {text="Tap Me", x=0, y=0, width=100, align="left", font="BerlinSansFB-Reg", fontSize=24} 
    
    Runtime:addEventListener( "key", onKeyEvent )
    
    stepSheet = graphics.newImageSheet("Images/stepSheet_stepSheet.png", stepperDataFile.getSpriteSheetData() )
	
		back = display.newImageRect( screenGroup, "backgrounds/background.png", 570, 360 )
		back.x = display.contentCenterX
		back.y = display.contentCenterY		
    
		backEdgeX = back.contentBounds.xMin
		backEdgeY = back.contentBounds.yMin
    
    rightDisplay = display.newImageRect(backGroup, "backgrounds/Threads.png", 570, 360)
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

  tolButt = widget.newButton
  {
  id = "tolButt",
    width = 35,
    height = 35,
    defaultFile = "Images/calcButt.png",
  overFile = "Images/calcButtOver.png",
  onEvent = tolInfoMove,
  }
  optionsGroup:insert(tolButt)
  tolButt.x = 70
  tolButt.y = backEdgeY + 70

  optionLabels[4]:setText("i")
  optionLabels[4]:setFontSize(28)
  optionLabels[4].x = tolButt.contentWidth / 2 - 0.5
  optionLabels[4].y = tolButt.contentHeight / 2 - 5
  tolButt:insert(optionLabels[4])
	
	optionsGroup.alpha = 0
	
  optionsBack = display.newRect(screenGroup, 0, 0, 200, 365)
  optionsBack:setFillColor(1)
  optionsBack.anchorX = 0; optionsBack.anchorY = 0; 
  optionsBack.x = -170
  optionsBack.y = -335

  local infoBack = display.newRect(infoGroup, 0, 0, display.actualContentWidth - 150, 365)
  infoBack:setFillColor(1)
  infoBack.anchorX = 0; infoBack.anchorY = 0; 
  infoBack.x = 150
  infoBack.y = 0

  local infoText = display.newBitmapText("", 0, 0, "berlinFont", 16)
  infoGroup:insert(infoText)
  infoText:setJustification(infoText.Justify.LEFT)
  infoText:setAnchor(0, 0.5)
  infoText.x = backEdgeX + 200
  infoText.y = backEdgeY + 180

  local tempText = "TOLERANCES USED IN THIS APP:\n\n-The pitch diameter generated for a UN\nthread" ..
  " is the top tolerance for a class 3A\n\n-The pitch diameter generated for an Acme\nor Stub Acme thread" ..
  " is the maximum basic\npitch diameter minus the allowance for a class\n2-G General Purpose single start"..
  " external\nAcme thread\n\n-The pitch (effective) diameter for the ISO\nmetric thread is for -4h external" ..
  " threads, top\ntolerance. This tolerance is the basic size of a\ngiven thread\n\n-The pitch diameters" ..
  " generated for the other\nthreads are for medium fit external threads"
  
  infoText:setText(tempText)

  optionsButt = display.newImageRect(screenGroup, "Images/Options.png", 38, 38)
  optionsButt.x = 15
  optionsButt.y = 15
  optionsButt:addEventListener ( "touch", optionsMove )
  optionsButt.isHitTestable = true

  decPlaces = display.newBitmapText("Decimal Places:", 0, 0, "uiFont", 16)
  backGroup:insert(decPlaces)
  decPlaces:setAnchor(0, 0)
  decPlaces.x = backEdgeX + 372
  decPlaces.y = backEdgeY + 85
	
  places = 4
  decLabel = display.newBitmapText(places, 0, 0, "inputFont", 24)
  screenGroup:insert(decLabel)
  decLabel.x = backEdgeX + 490
  decLabel.y = backEdgeY + 93

  -- majorDiamLabel = display.newBitmapText(gMeasure.type, 0, 0, "uiFont", 13)
  -- backGroup:insert(majorDiamLabel)
  -- majorDiamLabel:setAnchor(0, 0)
  -- majorDiamLabel.x = backEdgeX + 371
  -- majorDiamLabel.y = backEdgeY + 68

  measurement = display.newBitmapText(gMeasure.label, 0, 0, "uiFont", 13)
  backGroup:insert(measurement)
  measurement.x = backEdgeX + 440
  measurement.y = backEdgeY + 189

  threadAngleLabel = display.newBitmapText("Thread Form", 0, 0, "uiFont", 13)
  backGroup:insert(threadAngleLabel)
  threadAngleLabel.x = backEdgeX + 440
  threadAngleLabel.y = backEdgeY + 125

  optionsGroup.anchorX = 0.5; optionsGroup.anchorY = 0.5;
  backGroup.anchorX = 0.5; backGroup.anchorY = 0.5;
  backGroup.alpha = 0
  transition.to ( backGroup, { time = 500, alpha = 1, delay = 200} )
  optionsBack.alpha = 0
  transition.to ( optionsBack, { time = 500, alpha = 1, delay = 600} )
  optionsButt.alpha = 0
  transition.to ( optionsButt, { time = 500, alpha = 1, delay = 600} )
  
  screenGroup:insert(backGroup)

  -- infoButt = widget.newButton
  -- {
  --   left = 0,
  --   top = 0,
  --   width = 80,
  --   height = 32,
  --   fontSize = 14,
  --   id = "info",
  --   font = "BerlinSansFB-Reg",
  --   defaultFile = "Images/chartButtD.png",
  --   overFile = "Images/chartButtO.png",
  --   --emboss = true,
  --   onEvent = typeTouch,
  -- }
  -- backGroup:insert(infoButt)
  -- infoButt.x = backEdgeX + 325
  -- infoButt.y = backEdgeY + 79
  -- infoButt.info = 1

  -- infoLabel = display.newBitmapText("Change Input", 0, 0, "uiFont", 12)
  -- infoLabel.x = infoButt.contentWidth / 2
  -- infoLabel.y = infoButt.contentHeight / 2
  -- infoButt:insert(infoLabel)

  local columnData = {

      {
      startIndex = 3,
      labels = { "55° BSW", "60° UN", "60° ISO Metric", "30° Trapezoid", "29° Acme-2G", "29° Stub Acme" }
      }

    }

  angleWheel = widget.newPickerWheel
  { 
    columns = columnData,
  }

  angleWheel.anchorX = 0
  angleWheel.anchorY = 0.5

  angleWheel.x = display.contentWidth
  angleWheel.y = display.contentCenterY

  pickerGroup:insert(angleWheel)

  backBox = display.newRect( pickerGroup, 0, 0, 60, 30 )
  backBox.anchorX = 0
  backBox.anchorY = 1
  backBox.x = angleWheel.x
  backBox.y = (display.contentHeight - angleWheel.contentHeight) / 2
  backBox:addEventListener( "touch", angleTouch )

  backLabel = display.newBitmapText("DONE", 0, 0, "berlinFont", 16)
  backLabel:setAnchor(0, 0.5)
  backLabel.x = backBox.x
  backLabel.y = backBox.y - 15

  angleTap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
  angleTap.x = backEdgeX + 440
  angleTap.y = backEdgeY + 153
  backGroup:insert(angleTap)
  angleTap:addEventListener ( "touch", angleTouch )
  angleTap.isHitTestMasked = false

  angleNum = display.newBitmapText("Tap Me", 0, 0, "inputFont", 20)
  backGroup:insert(angleNum)
  angleNum:setJustification(angleNum.Justify.CENTER)
  angleNum:addEventListener ( "touch", angleTouch )
  angleNum.x = angleTap.x
  angleNum.y = angleTap.y
  angleNum.alpha = 0

  threadTap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
  threadTap.x = backEdgeX + 440
  threadTap.y = backEdgeY + 215
  backGroup:insert(threadTap)
  threadTap:addEventListener ( "touch", calcTouch )
  threadTap.isHitTestMasked = false
  threadTap.tap = 11
  aniTable[1] = threadTap

  threadNum = display.newBitmapText("Tap Me", 0, 0, "inputFont", 22)
  backGroup:insert(threadNum)
  threadNum:setJustification(threadNum.Justify.CENTER)
  threadNum.x = threadTap.x
  threadNum.y = threadTap.y
  threadNum.alpha = 0
  threadNum.tap = 1
  tapTable[1] = threadNum
  threadNum:addEventListener ( "touch", calcTouch )

  wireSize = display.newBitmapText("0", 0, 0, "inputFont", 22)
  backGroup:insert(wireSize)
  wireSize:setJustification(wireSize.Justify.CENTER)
  wireSize.x = backEdgeX + 115
  wireSize.y = backEdgeY + 315
  wireSize.alpha = 0

  basicMajorTap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
  basicMajorTap.x = backEdgeX + 370
  basicMajorTap.y = backEdgeY + 260
  backGroup:insert(basicMajorTap)
  basicMajorTap:addEventListener ( "touch", calcTouch )
  basicMajorTap.isHitTestMasked = false
  basicMajorTap.tap = 12
  aniTable[2] = basicMajorTap
  basicMajorTap.alpha = 0

  basicMajorNum = display.newBitmapText("Tap Me", 0, 0, "inputFont", 22)
  backGroup:insert(basicMajorNum)
  basicMajorNum:setJustification(basicMajorNum.Justify.LEFT)
  basicMajorNum:setAnchor(0, 0.5)
  basicMajorNum.x = basicMajorTap.x - 15
  basicMajorNum.y = basicMajorTap.y
  basicMajorNum.alpha = 0
  basicMajorNum.tap = 2
  tapTable[2] = basicMajorNum
  basicMajorNum:addEventListener ( "touch", calcTouch )

  actualWireTap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
  actualWireTap.x = backEdgeX + 287
  actualWireTap.y = backEdgeY + 310
  backGroup:insert(actualWireTap)
  actualWireTap:addEventListener ( "touch", calcTouch )
  actualWireTap.isHitTestMasked = false
  actualWireTap.tap = 13
  aniTable[3] = actualWireTap
  actualWireTap.alpha = 0

  actualWireNum = display.newBitmapText("Tap Me", 0, 0, "inputFont", 22)
  backGroup:insert(actualWireNum)
  actualWireNum:setAnchor(0, 0.5)
  actualWireNum:setJustification(actualWireNum.Justify.LEFT)
  actualWireNum.x = actualWireTap.x - 15
  actualWireNum.y = actualWireTap.y
  actualWireNum.alpha = 0
  actualWireNum.tap = 3
  tapTable[3] = actualWireNum
  actualWireNum:addEventListener ( "touch", calcTouch )

  -- effectiveTap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
  -- effectiveTap.x = backEdgeX + 123
  -- effectiveTap.y = backEdgeY + 165
  -- backGroup:insert(effectiveTap)
  -- effectiveTap:addEventListener ( "touch", calcTouch )
  -- effectiveTap.isHitTestMasked = false
  -- effectiveTap.tap = 14
  -- aniTable[4] = effectiveTap

  effectiveNum = display.newBitmapText("Tap Me", 0, 0, "inputFont", 22)
  backGroup:insert(effectiveNum)
  effectiveNum:setAnchor(1, 0.5)
  effectiveNum:setJustification(effectiveNum.Justify.RIGHT)
  -- effectiveNum.x = effectiveTap.x + 13
  -- effectiveNum.y = effectiveTap.y + 3
  effectiveNum.x = backEdgeX + 136
  effectiveNum.y = backEdgeY + 168
  effectiveNum.alpha = 0
  effectiveNum.tap = 4
  tapTable[4] = effectiveNum
  -- effectiveNum:addEventListener ( "touch", calcTouch )

  -- overTap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
  -- overTap.x = backEdgeX + 190
  -- overTap.y = backEdgeY + 65
  -- backGroup:insert(overTap)
  -- overTap:addEventListener ( "touch", calcTouch )
  -- overTap.isHitTestMasked = false
  -- overTap.tap = 15
  -- aniTable[5] = overTap

  overNum = display.newBitmapText("Tap Me", 0, 0, "inputFont", 22)
  backGroup:insert(overNum)
  overNum:setJustification(overNum.Justify.RIGHT)
  overNum:setAnchor(0, 0.5)
  -- overNum.x = overTap.x - 30
  -- overNum.y = overTap.y
  overNum.x = backEdgeX + 160
  overNum.y = backEdgeY + 65
  overNum.alpha = 0
  overNum.tap = 5
  tapTable[5] = overNum
  -- overNum:addEventListener ( "touch", calcTouch )

  screenGroup:insert( backGroup )
  screenGroup:insert( optionsGroup)

  -- if majorDiamLabel:getText() == "Basic Major Diam Only" then
    -- effectiveTap.alpha = 0
    -- overTap.alpha = 0
  -- elseif majorDiamLabel:getText() == "Pitch Diameter" then
  --   effectiveTap.alpha = 0
  -- else
  --   overTap.alpha = 0
  -- end

  screenGroup:insert(infoGroup)
  infoGroup.anchorY = 0.5
  infoGroup.anchorX = 1
  infoGroup.x = display.contentWidth 
		
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