local composer = require( "composer" )
local scene = composer.newScene()
local widget = require ( "widget" )
local myData = require("myData")
local fm = require("fontmanager")
fm.FontManager:setEncoding("utf8")

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here

local num1, num2, num3, num4, num5, num6, num7, num8, num9, num0, neg, dec, clear, enter, backButt
local deg, degText, degBorder, min, minText, minBorder, sec, secText, secBorder
local numDisplay, displayBorder
local numBack, maskBack, convert
local needNeg, needDec
local backEdgeX, backEdgeY
local decPress, count, isFocus, degreeGroup, isDegree, decTemp
local tempDec, decPlace
local needNeg, needDec, isDegree, isBolt
local BerlinSansFB, digital
local bitLabelTable, buttonTable, goBack2

local deleteChar, toHours

--Scene-wide Functions

local function onKeyEvent( event )

  local phase = event.phase
  local keyName = event.keyName
  local platformName = system.getInfo("platformName")

  if platformName == "Android" then
   if ( "back" == keyName and phase == "up" ) and not myData.isOverlay then
    timer.performWithDelay(100,goBack2,1)
   end
  elseif platformName == "WinPhone" then
   if ( "back" == keyName ) and not myData.isOverlay then
    timer.performWithDelay(100,goBack2,1)
   end
  end
  return true
end

goBack2 = function()
  
	myData.number = "Tap Me"
	decPushed = false
	decTemp = 0
	transition.to ( maskBack, { time = 10, alpha = 0 } )
	composer.hideOverlay(true, "slideRight", 200 )
		
end

--Called when a number or . or - is pushed

local function numPushed( event )
	local phase = event.phase
	local label = event.target.input
		
	if "ended" == phase then
      
    local focusD
      
    if isFocus == 1 then
      focusD = numDisplay
    elseif isFocus == 2 then
      focusD = hoursText
    elseif isFocus == 3 then
      focusD = minText
    elseif isFocus == 4 then
      focusD = secText
    end

    if isFocus == 1 and label == "." then 
      decPushed = true
    end	

    if not decPushed then
      decTemp = numDisplay:getText() .. label
    
      print(decTemp)
    end
    
    if isFocus == 1 and focusD.count <= 8 or isFocus ~= 1 and focusD.count <= 9 then
    
      if label == "." and decPress == false and (isFocus == 1 or isFocus == 4) then
        if focusD:getText() == "-" then
          focusD:setText("-0.")
        else
          focusD:setText(focusD:getText() .. label)
		  print("decimal was pushed")
        end
        
        decPress = true
        
      end
    		
      if focusD:getText() ~= "0" and label == "-" then
        --do nothing
        focusD.count = focusD.count - 1
      elseif label == "." then
        --do nothing
        focusD.count = focusD.count - 1
      elseif focusD:getText() == "0" and label == "-" then
        focusD:setText("-")
      elseif focusD:getText() == "0" then
        focusD:setText("")
        focusD:setText(focusD:getText() .. label)
      elseif decPushed and label == "0" then
        focusD:setText(focusD:getText() .. "0") 
      else
        focusD:setText(focusD:getText() .. label)
      end
        
        focusD.count = focusD.count + 1
    end	

    if isFocus == 2 or isFocus == 3 or isFocus == 4 then
      if hoursText:getText() ~= "0" or minText:getText() ~= "0" or secText:getText() ~= "0" then
        numDisplay:setText(toHours(hoursText:getText(), minText:getText(), secText:getText()))
        numDisplay:setText(math.round(numDisplay:getText() * math.pow(10, 5)) / math.pow(10, 5))
      end
    end

    if isFocus == 1 and degreeGroup.alpha ~= 0 then
      if numDisplay:getText() ~= 0 or numDisplay:getText() ~= 0 then
        print("decTemp is: " .. decTemp)
        hoursText:setText(decTemp + 1 - 1)
        print(numDisplay:getText())
        minText:setText((tonumber(numDisplay:getText()) - decTemp) * 60)
      end
        
      if string.find(minText:getText(), ".") == nil then
        --do nothing
      else
        local temp = minText:getText()
        decPlace = string.find(minText:getText(), ".")
        minText:setText(minText:getText():sub(1, decPlace+1))
        secText:setText((temp - minText:getText()) * 60)
        secText:setText(math.round(secText:getText() * math.pow(10, 5)) / math.pow(10, 5))
      end
    end
  end     
end

--Called when GO is pushed

local function goEvent( event )
	local phase = event.phase
		
	if "ended" == phase then
		
    if numDisplay:getText():sub(numDisplay:getText():len(),numDisplay:getText():len()) == "." and not isBolt then
      numDisplay:setText(numDisplay:getText() .. "0")
      myData.number = numDisplay:getText() 		
      transition.to ( maskBack, { time = 10, alpha = 0 } )
      decTemp = 0
      composer.hideOverlay(true, "slideRight", 200 )
    elseif numDisplay:getText() ~= "0" and isBolt then
      if numDisplay:getText() == "-0." or numDisplay:getText() == "-" or numDisplay:getText() == "-0.0" or numDisplay:getText() == "0." or numDisplay:getText() == "0.0" then 
        myData.number = 0 else myData.number = numDisplay:getText() 
      end
        transition.to ( maskBack, { time = 10, alpha = 0 } )
        decTemp = 0
        composer.hideOverlay(true, "slideRight", 200 )
    elseif numDisplay:getText() ~= "0" then
      myData.number = numDisplay:getText() 
      transition.to ( maskBack, { time = 10, alpha = 0 } )
      decTemp = 0
      composer.hideOverlay(true, "slideRight", 200 )
    elseif numDisplay:getText() == "0" and isBolt then
      myData.number = numDisplay:getText() 
      transition.to ( maskBack, { time = 10, alpha = 0 } )
      decTemp = 0
      composer.hideOverlay(true, "slideRight", 200 )
    elseif numDisplay:getText() == "0" then
      --do nothing
      count = count - 1
    end
      
      count = count + 1
      decPushed = false
  end 
end

--Called when Back is pushed

local function deleteEvent( event )
  local phase = event.phase
		
	if "ended" == phase then
      
    local focusD
    
    if isFocus == 1 then
      focusD = numDisplay
    elseif isFocus == 2 then
      focusD = hoursText
    elseif isFocus == 3 then
      focusD = minText
    elseif isFocus == 4 then
      focusD = secText
    end
		
    if focusD:getText() == "0" then
      --do nothing
    else
      focusD:setText(deleteChar(focusD:getText()))
			focusD.count = focusD.count - 1
		end
    
    if focusD:getText() == "" then 
      focusD:setText("0")
    end

    if isFocus == 2 or isFocus == 3 or isFocus == 4 then
    	if hoursText:getText() ~= "0" or minText:getText() ~= "0" or secText:getText() ~= "0" then
    		numDisplay:setText(toHours(hoursText:getText(), minText:getText(), secText:getText()))
    		numDisplay:setText(math.round(numDisplay:getText() * math.pow(10, 5)) / math.pow(10, 5))
    	end
    end

    if not decPushed then
    	decTemp = numDisplay:getText()
    end

    if isFocus == 1 and degreeGroup.alpha ~= 0 then
    	if numDisplay:getText() ~= "0" or numDisplay:getText() ~= "0." then
    		hoursText:setText(decTemp + 1 - 1)
    		minText:setText((numDisplay:getText() - decTemp) * 60)
    	end
    	
      if string.find(minText:getText(), ".") == nil then
    		--do nothing
    	else
    		local temp = minText:getText()
    		decPlace = string.find(minText:getText(), ".")
    		minText:setText(minText:getText():sub(1, decPlace+1))
    		secText:setText((temp - minText:getText()) * 60)
    		secText:setText(math.round(secText:getText() * math.pow(10, 5)) / math.pow(10, 5))
    	end
    end
  end
end

--Called when reset is pushed

local function resetEvent( event )
	local phase = event.phase
		
	if "ended" == phase then
		myData.number = "Tap Me"
		decPushed = false
		decTemp = 0
		transition.to ( maskBack, { time = 10, alpha = 0 } )
		composer.hideOverlay(true, "slideRight", 200 )
  end
end

--Called when the focus changes

local function focusTouch( event )
	if event.phase == "ended" then
    
    local focus = event.target.focus
      
    if focus == 1 then
      isFocus = 1
      displayBorder.strokeWidth = 5
      hoursBorder.strokeWidth = 2
      minBorder.strokeWidth = 2
      secBorder.strokeWidth = 2
    elseif focus == 2 then
      isFocus = 2
      displayBorder.strokeWidth = 2
      hoursBorder.strokeWidth = 5
      minBorder.strokeWidth = 2
      secBorder.strokeWidth = 2
    elseif focus == 3 then
      isFocus = 3
      displayBorder.strokeWidth = 2
      hoursBorder.strokeWidth = 2
      minBorder.strokeWidth = 5
      secBorder.strokeWidth = 2
    elseif focus == 4 then
      isFocus = 4
      displayBorder.strokeWidth = 2
      hoursBorder.strokeWidth = 2
      minBorder.strokeWidth = 2
      secBorder.strokeWidth = 5
    end 
    		
		return true
	end
end

deleteChar = function(s)
  
  local length = s:len()
  if s:sub(length, length) == "." then
    decPress = false
    decPushed = false
  end
  
  s = s:sub(1,length - 1)
  return s
  
end

toHours = function(h, m, s)

  return h + (m/60) + (s/3600)
  
end

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
--Create the Scene

function scene:create( event )

  local screenGroup = self.view

  Runtime:addEventListener( "key", onKeyEvent )

  decTemp = 0

  BerlinSansFB = "BerlinSansFB-Reg.tff#Berlin Sans FB"
  bitLabelTable = {}
  buttonTable = {}

  for i = 1, 15, 1 do
	bitLabelTable[i] = display.newBitmapText("", 0, 0, "berlinFont", 26)
  end

  myData.number = "Tap Me"
  degreeGroup = display.newGroup()
  
  count = 0
  decPress = false
  isFocus = 1
	
  needNeg = event.params.negTrue
  needDec = event.params.needDec
  isDegree = event.params.isDegree
  if isDegree ~= true then isDegree = false end
  isBolt = event.params.isBolt
  

  maskBack = display.newImageRect( screenGroup, "backgrounds/maskBack.png", 570, 360 )
  maskBack.alpha = 0
  maskBack.x = display.contentCenterX
  maskBack.y = display.contentCenterY
  transition.to ( maskBack, { time = 400, alpha = 1, delay = 300} )	
  --  maskBack:addEventListener( "tap", catchStrays )
  --  maskBack:addEventListener( "touch", catchStrays )
  backEdgeX = maskBack.contentBounds.xMin
  backEdgeY = maskBack.contentBounds.yMin

  numBack = display.newRect(screenGroup, 0, 0, display.contentWidth/2, display.contentHeight)
  numBack:setFillColor(255, 255, 255)
  numBack.strokeWidth = 2
  numBack:setStrokeColor(39, 102, 186, 200)
  numBack.anchorX = 0; numBack.anchorY = 0
  numBack.x = display.contentCenterX
  
  convert = display.newRect(degreeGroup, 0, 0, display.contentWidth/2, display.contentHeight/2)
  convert:setFillColor(255, 255, 255)
  convert.strokeWidth = 2
  convert:setStrokeColor(39, 102, 186, 200)
  convert.anchorX = 0; convert.anchorY = 0
  convert.x = 0
  
  local textOptionsR = {text="", x=0, y=0, width=numBack.contentWidth/1.05-20, height = 50, align="right", font=digital, fontSize=34} 
  local textOptionsR2 = {text="", x=0, y=0, width = 100, height = 50, align="right", font=digital, fontSize=22}
  local textOptionsL = {parent = degreeGroup, text="", x=0, y=0, width=50, align="left", font=BerlinSansFB, fontSize=14}
  
  hoursBorder = display.newRect(degreeGroup, 0, 0, numBack.contentWidth/2.10, 36)
  hoursBorder:setFillColor(1, 0)
  hoursBorder.strokeWidth = 2
  hoursBorder:setStrokeColor(0.153, 0.4, 0.729)
  hoursBorder.anchorX = 0; hoursBorder.anchorY = 0
  hoursBorder.x = 20
  hoursBorder.y = 15
  hoursBorder:addEventListener ( "touch", focusTouch )
  hoursBorder.isHitTestable = true
  hoursBorder.focus = 2

  hours = display.newBitmapText("Whole\nDegrees", 0, 0, "berlinFont", 16)
  degreeGroup:insert(hours)
  hours:setAnchor(0, 0.5)
  hours.x = 35 + hoursBorder.contentWidth
  hours.y = 30
  
  hoursText = display.newBitmapText("0", 0, 0, "digitalFont", 24)
  hoursText:setAnchor(1, 0.5)
  degreeGroup:insert(hoursText)
  hoursText:setJustification(hoursText.Justify.RIGHT)
  hoursText.x = hoursBorder.x + hoursBorder.contentWidth - 5
  hoursText.y = 35
  hoursText.count = 0
  
  minBorder = display.newRect(degreeGroup, 0, 0, numBack.contentWidth/2.10, 36)
  minBorder.strokeWidth = 2
  minBorder:setStrokeColor(0.153, 0.4, 0.729)
  minBorder.anchorX = 0; minBorder.anchorY = 0
  minBorder.x = 20
  minBorder.y = 65
  minBorder:addEventListener ( "touch", focusTouch )
  minBorder.isHitTestable = true
  minBorder.focus = 3
  minBorder.count = 0

  min = display.newBitmapText("Minutes", 0, 0, "berlinFont", 16)
  degreeGroup:insert(min)
  min:setAnchor(0, 0.5)
  min.x = 35 + hoursBorder.contentWidth
  min.y = 85
  
  minText = display.newBitmapText("0", 0, 0, "digitalFont", 24)
  minText:setAnchor(1, 0.5)
  degreeGroup:insert(minText)
  minText:setJustification(minText.Justify.RIGHT)
  minText.x = hoursBorder.x + hoursBorder.contentWidth - 5
  minText.y = 85
  minText.count = 0
  
  secBorder = display.newRect(degreeGroup, 0, 0, numBack.contentWidth/2.10, 36)
  secBorder:setFillColor(1, 0)
  secBorder.strokeWidth = 2
  secBorder:setStrokeColor(0.153, 0.4, 0.729)
  secBorder.anchorX = 0; secBorder.anchorY = 0
  secBorder.x = 20
  secBorder.y = 115
  secBorder:addEventListener ( "touch", focusTouch )
  secBorder.isHitTestable = true
  secBorder.focus = 4
  secBorder.count = 0

  sec = display.newBitmapText("Seconds", 0, 0, "berlinFont", 16)
  degreeGroup:insert(sec)
  sec:setAnchor(0, 0.5)
  sec.x = 35 + hoursBorder.contentWidth
  sec.y = 135
  
  secText = display.newBitmapText("0", 0, 0, "digitalFont", 24)
  secText:setAnchor(1, 0.5)
  degreeGroup:insert(secText)
  secText:setJustification(secText.Justify.RIGHT)
  secText.x = hoursBorder.x + hoursBorder.contentWidth - 5
  secText.y = 135
  secText.count = 0
  
  displayBorder = display.newRect(screenGroup, 0, 0, numBack.contentWidth/1.05, 75)
  displayBorder:setFillColor(1, 0)
  displayBorder.strokeWidth = 5
  displayBorder:setStrokeColor(0.153, 0.4, 0.729)
  displayBorder.x = display.contentCenterX+display.contentCenterX/2
  displayBorder.y = 45
  displayBorder:addEventListener ( "touch", focusTouch )
  displayBorder.isHitTestable = true
  displayBorder.focus = 1
  displayBorder.count = 0
  
  numDisplay = display.newBitmapText("0", 0, 0, "digitalFont", 50)
  numDisplay:setAnchor(1, 0.5)
  screenGroup:insert(numDisplay)
  numDisplay:setJustification(numDisplay.Justify.RIGHT)
  numDisplay.x = displayBorder.x + displayBorder.contentWidth/2 - 5
  numDisplay.y = 50
  numDisplay.count = 0
  
  screenGroup:insert(degreeGroup)
  
  if not isDegree then 
    degreeGroup.alpha = 0 
  end

	--Create Buttons
  
  num1 = widget.newButton
	{
	id = "1",
    width = 50,
    height = 50,
	label = "",
	onEvent = numPushed,
	defaultFile = "Images/calcButt.png",
	overFile = "Images/calcButtOver.png",
  }
	num1.x = display.contentCenterX+30
	num1.y = backEdgeY + 135
	buttonTable[1] = num1
	num1.input = "1"	
		
	num2 = widget.newButton
	{
	id = "2",
    width = 50,
    height = 50,
	label = "",
	onEvent = numPushed,
	defaultFile = "Images/calcButt.png",
	overFile = "Images/calcButtOver.png",
  }	
	num2.x = display.contentCenterX+90
	num2.y = backEdgeY + 135
	buttonTable[2] = num2
	num2.input = "2"
		
	num3 = widget.newButton
	{
	id = "3",
    width = 50,
    height = 50,
	label = "",
	onEvent = numPushed,
	defaultFile = "Images/calcButt.png",
	overFile = "Images/calcButtOver.png",
  }	
	num3.x = display.contentCenterX+150
	num3.y = backEdgeY + 135
	buttonTable[3] = num3
	num3.input = "3"
		
	num4 = widget.newButton
	{
	id = "4",
    width = 50,
    height = 50,
	label = "",
	onEvent = numPushed,
	defaultFile = "Images/calcButt.png",
	overFile = "Images/calcButtOver.png",
  }	
	num4.x = display.contentCenterX+30
	num4.y = backEdgeY + 190
	buttonTable[4] = num4
	num4.input = "4"
		
	num5 = widget.newButton
	{
	id = "5",
    width = 50,
    height = 50,
	label = "",
	onEvent = numPushed,
	defaultFile = "Images/calcButt.png",
	overFile = "Images/calcButtOver.png",
  }	
	num5.x = display.contentCenterX+90
	num5.y = backEdgeY + 190
	buttonTable[5] = num5
	num5.input = "5"
		
	num6 = widget.newButton
	{
	id = "6",
    width = 50,
    height = 50,
	label = "",
	onEvent = numPushed,
	defaultFile = "Images/calcButt.png",
	overFile = "Images/calcButtOver.png",
  }	
	num6.x = display.contentCenterX+150
	num6.y = backEdgeY + 190
	buttonTable[6] = num6
	num6.input = "6"
		
	num7 = widget.newButton
	{
	id = "7",
    width = 50,
    height = 50,
	label = "",
	onEvent = numPushed,
	defaultFile = "Images/calcButt.png",
	overFile = "Images/calcButtOver.png",
  }	
	num7.x = display.contentCenterX+30
	num7.y = backEdgeY + 245
	buttonTable[7] = num7
	num7.input = "7"
		
	num8 = widget.newButton
	{
	id = "8",
    width = 50,
    height = 50,
	label = "",
	onEvent = numPushed,
	defaultFile = "Images/calcButt.png",
	overFile = "Images/calcButtOver.png",
  }	
	num8.x = display.contentCenterX+90
	num8.y = backEdgeY + 245
	buttonTable[8] = num8
	num8.input = "8"
		
	num9 = widget.newButton
	{
	id = "9",
    width = 50,
    height = 50,
	label = "",
	onEvent = numPushed,
	defaultFile = "Images/calcButt.png",
	overFile = "Images/calcButtOver.png",
  }	
	num9.x = display.contentCenterX+150
	num9.y = backEdgeY + 245
	buttonTable[9] = num9
	num9.input = "9"
		
	dec = widget.newButton
	{
	id = ".",
    width = 50,
    height = 50,
	label = "",
	onEvent = numPushed,
	defaultFile = "Images/calcButt.png",
	overFile = "Images/calcButtOver.png",
  }	
	dec.x = display.contentCenterX+30
	dec.y = backEdgeY + 305
	buttonTable[11] = dec
	dec.input = "."
		
		if needDec then
			dec.alpha = 1
		else
			dec.alpha = 0
		end
		
	num0 = widget.newButton
	{
	id = "0",
    width = 50,
    height = 50,
	label = "",
	onEvent = numPushed,
	defaultFile = "Images/calcButt.png",
	overFile = "Images/calcButtOver.png",
  }	
	num0.x = display.contentCenterX+90
	num0.y = backEdgeY + 305
	buttonTable[10] = num0
	num0.input = "0"
		
	neg = widget.newButton
	{
	id = "-",
    width = 50,
    height = 50,
	label = "",
	onEvent = numPushed,
	defaultFile = "Images/calcButt.png",
	overFile = "Images/calcButtOver.png",
  }	
	neg.x = display.contentCenterX+150
	neg.y = backEdgeY + 305
	buttonTable[12] = neg
	neg.input = "-"
	
		if needNeg then
			neg.alpha = 1
		else
			neg.alpha = 0
		end
	
  enter = widget.newButton
	{
	id = "GO",
    width = 50,
    height = 50,
	labelColor = { default = {1}, over = {0.153, 0.4, 0.729} },
	id = "enter",
	font = BerlinSansFB,
	fontSize = 22,
    defaultFile = "Images/calcButtOver.png",
    overFile = "Images/calcButt.png",
		onEvent = goEvent
  }
  enter.x = display.contentCenterX+210
  enter.y = backEdgeY + 190
  buttonTable[13] = enter
  enter.input = "GO"

  backButt = widget.newButton
	{
	id = "DEL",
    width = 50,
    height = 50,
		id = "back",
		font = BerlinSansFB,
		labelColor = { default = {1}, over = {0.153, 0.4, 0.729}},
		fontSize = 20,
		onEvent = deleteEvent,
		defaultFile = "Images/calcButtOver.png",
		overFile = "Images/calcButt.png",
		}
	backButt.x = display.contentCenterX+210
	backButt.y = backEdgeY + 135
	buttonTable[14] = backButt
	backButt.input = "DEL"
		
	clear = widget.newButton
	{
    width = 50,
    height = 50,
	font = BerlinSansFB,
	fontSize = 24,
	labelColor = { default = {0.777, 0.267, 0.267}, over = {1} },
	id = "clear",
    defaultFile = "Images/cancButt.png",
    overFile = "Images/cancButtOver.png",
	onEvent = resetEvent
  }
  clear.x = display.contentCenterX+210
  clear.y = backEdgeY + 305
  buttonTable[15] = clear
  clear.input = "C"

  for i = 1, #bitLabelTable, 1 do
	bitLabelTable[i]:setText(buttonTable[i].input)
	bitLabelTable[i].x = buttonTable[i].contentWidth /2
	bitLabelTable[i].y = buttonTable[i].contentHeight /2
	buttonTable[i]:insert(bitLabelTable[i])
  end

  bitLabelTable[13]:setFont("uiFont")
  bitLabelTable[13]:setFontSize(20)
  bitLabelTable[14]:setFontSize(20)
  bitLabelTable[14]:setFont("uiFont")
  bitLabelTable[15]:setFont("redFont")
		
		screenGroup:insert( num1 )
		screenGroup:insert( num2 )
		screenGroup:insert( num3 )
		screenGroup:insert( num3 )
		screenGroup:insert( num4 )
		screenGroup:insert( num5 )
		screenGroup:insert( num6 )
		screenGroup:insert( num7 )
		screenGroup:insert( num8 )
		screenGroup:insert( num9 )
		screenGroup:insert( num0 )
		screenGroup:insert( dec )
		screenGroup:insert( neg )
		screenGroup:insert( enter )
		screenGroup:insert( clear )
    screenGroup:insert( backButt )
		screenGroup:insert( numDisplay )
end

-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
   elseif ( phase == "did" ) then
      
      myData.isOverlay = true
      
   end
end

-- "scene:hide()"
function scene:hide( event )
  local sceneGroup = self.view
  local phase = event.phase
  local parent = event.parent  --reference to the parent scene object

  local phase = event.phase

  if ( phase == "will" ) then
	Runtime:removeEventListener( "key", onKeyEvent )
    --calling the calculate function in the parent scene
    transition.to(maskBakc, {alpha = 0, time = 200})
    parent:calculate()
  elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.
  end
end

-- "scene:destroy()"
function scene:destroy( event )

   local sceneGroup = self.view

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