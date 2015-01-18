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

--Local Functions

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
  myData.number = nil
    
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
      transition.to ( backGroup, { time = 200, x=0 } )
      transition.to ( optionsBack, { time = 200, x = -170 } )
      transition.to ( optionsBack, { time = 200, y = -335 } )
      transition.to (decLabel, { time = 200, x = backEdgeX + 177, y = backEdgeY + 115} )
      decLabel:setFillColor(1)
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
		if measure:getLabel() == "TO METRIC" then
			gMeasure.measure = "TO IMPERIAL"
			loadsave.saveTable(gMeasure, "rightMeasure.json")
			measure:setLabel("TO IMPERIAL")
      measureLabel:setText("Metric")
      measureLabel.x = backEdgeX + 115
      measureLabel.y = backEdgeY + 95
			for i = 1, 3, 1 do			
        if tapTable[i].text ~= "Tap Me" then
					tapTable[i].text = math.round(toMill(tapTable[i].text) * math.pow(10, places)) / math.pow(10, places)
				end
			end
		else
			gMeasure.measure = "TO METRIC"
			loadsave.saveTable(gMeasure, "rightMeasure.json")
			measure:setLabel("TO METRIC")
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
      transition.to ( backGroup, { time = 200, x=0 } )
      transition.to ( optionsBack, { time = 200, x = -170 } )
      transition.to ( optionsBack, { time = 200, y = -335 } )
      transition.to (decLabel, { time = 200, x = backEdgeX + 177, y = backEdgeY + 115} )
      decLabel:setFillColor(1)
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

--Functions used by Calculate()
toMill = function(num)
  return num * 25.4	
end

toInch = function(num)
  return num / 25.4
end

local function sideAcalc()
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

local function sideBcalc()
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

local function sideCcalc()
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

local function angAcalc()
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

local function angBcalc()
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
	
    tapTable[whatTap].text = myData.number
	
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

-- "scene:create()"
function scene:create( event )
  local screenGroup = self.view
	
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

  local textOptionsR = {text="Tap Me", x=0, y=0, width=100, align="right", font="BerlinSansFB-Reg", fontSize=24}
  local textOptionsC = {text="Tap Me", x=0, y=0, width=100, align="center", font="BerlinSansFB-Reg", fontSize=24}
  local textOptionsL = {text="Tap Me", x=0, y=0, width=100, align="left", font="BerlinSansFB-Reg", fontSize=24}
  local textOptionsL2 = {text="", x=0, y=0, width=200, align="left", font="BerlinSansFB-Reg", fontSize=24}
  
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
  optionsBack.anchorX = 0
  optionsBack.anchorY = 0
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

  area = display.newEmbossedText(backGroup, "Area:", 0, 0, "BerlinSansFB-Reg", 20)
  area:setFillColor(1)
  area:setEmbossColor({highlight = {r=0, g=0, b=0, a=1}, shadow = {r=1,g=1,b=1, a=0}})
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

  sideCtap = display.newImageRect(screenGroup, "Images/tapTarget.png", 33, 33)
	sideCtap.x = backEdgeX + 280
	sideCtap.y = backEdgeY + 140
	backGroup:insert(sideCtap)
	sideCtap:addEventListener ( "touch", calcTouch )
	sideCtap.tap = 11
	aniTable[11] = sideCtap

	sideAtext = display.newText( textOptionsC )
	sideAtext:addEventListener ( "touch", calcTouch )
  backGroup:insert(sideAtext)
	sideAtext.x = backEdgeX + 330
	sideAtext.y = backEdgeY + 275
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
	
	sideBtext = display.newText( textOptionsR )
	sideBtext:addEventListener ( "touch", calcTouch )
  backGroup:insert(sideBtext)
	sideBtext.x = backEdgeX + 420
	sideBtext.y = backEdgeY + 180
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
		
	angleAtext = display.newText( textOptionsR )
	angleAtext:addEventListener ( "touch", calcTouch )
  backGroup:insert(angleAtext)
	angleAtext.x = backEdgeX + 395
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
	
	angleBtext = display.newText( textOptionsL )
	angleBtext:addEventListener ( "touch", calcTouch )
  backGroup:insert(angleBtext)
	angleBtext.x = backEdgeX + 190
	angleBtext.y = backEdgeY + 290
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