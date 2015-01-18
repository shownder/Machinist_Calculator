local composer = require( "composer" )
local scene = composer.newScene()
local widget = require ( "widget" )
local myData = require("myData")

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
local decPress, count, isFocus, degreeGroup, isDegree
local tempDec, decPlace
local needNeg, needDec, isDegree, isBolt

local deleteChar, toHours

--Scene-wide Functions

--Called when a number or . or - is pushed

local function numPushed( event )
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

    if isFocus == 1 and event.target:getLabel() == "." then 
      decPushed = true 
    end	

    if not decPushed then
      decTemp = numDisplay.text .. event.target:getLabel()
    end
      
    print(decTemp)
    
    if isFocus == 1 and focusD.count <= 11 or isFocus ~= 1 and focusD.count <= 9 then
    
      if event.target:getLabel() == "." and decPress == false and isFocus == 1 then
        if focusD.text == "-" then
          focusD.text = "-0."
        else
          focusD.text = focusD.text .. event.target:getLabel()
        end
        
      decPress = true
        
      end
    		
      if focusD.text ~= "0" and event.target:getLabel() == "-" then
        --do nothing
        focusD.count = focusD.count - 1
      elseif event.target:getLabel() == "." then
        --do nothing
        focusD.count = focusD.count - 1
      elseif focusD.text == "0" and event.target:getLabel() == "-" then
        focusD.text = "-"
      elseif focusD.text == "0" then
        focusD.text = ""
        focusD.text = focusD.text .. event.target:getLabel()
      else
        focusD.text = focusD.text .. event.target:getLabel()
      end
        
        focusD.count = focusD.count +1
    end	

    if isFocus == 2 or isFocus == 3 or isFocus == 4 then
      if hoursText.text ~= "0" or minText.text ~= "0" or secText.text ~= "0" then
        numDisplay.text = toHours(hoursText.text, minText.text, secText.text)
        numDisplay.text = math.round(numDisplay.text * math.pow(10, 5)) / math.pow(10, 5)
      end
    end

    if isFocus == 1 and degreeGroup.alpha ~= 0 then
      if numDisplay.text ~= "0" or numDisplay.text ~= "0." then
        hoursText.text = decTemp + 1 - 1
        minText.text = (numDisplay.text - decTemp) * 60
      end
        
      if string.find(minText.text, ".") == nil then
        --do nothing
      else
        local temp = minText.text
        decPlace = string.find(minText.text, ".")
        minText.text = minText.text:sub(1, decPlace+1)
        secText.text = (temp - minText.text) * 60
        secText.text = math.round(secText.text * math.pow(10, 5)) / math.pow(10, 5)
      end
    end
  end     
end

--Called when GO is pushed

local function goEvent( event )
	local phase = event.phase
		
	if "ended" == phase then
		
    if numDisplay.text:sub(numDisplay.text:len(),numDisplay.text:len()) == "." and not isBolt then
      numDisplay.text = numDisplay.text .. "0"
      myData.number = numDisplay.text 		
      transition.to ( maskBack, { time = 10, alpha = 0 } )
      decTemp = 0
      composer.hideOverlay(true, "slideRight", 200 )
    elseif numDisplay.text ~= "0" and isBolt then
      if numDisplay.text == "-0." or numDisplay.text == "-" or numDisplay.text == "-0.0" or numDisplay.text == "0." or numDisplay.text == "0.0" then 
        myData.number = 0 else myData.number = numDisplay.text 
      end
        transition.to ( maskBack, { time = 10, alpha = 0 } )
        decTemp = 0
        composer.hideOverlay(true, "slideRight", 200 )
    elseif numDisplay.text ~= "0" then
      myData.number = numDisplay.text 
      transition.to ( maskBack, { time = 10, alpha = 0 } )
      decTemp = 0
      composer.hideOverlay(true, "slideRight", 200 )
    elseif numDisplay.text == "0" and isBolt then
      myData.number = numDisplay.text 
      transition.to ( maskBack, { time = 10, alpha = 0 } )
      decTemp = 0
      composer.hideOverlay(true, "slideRight", 200 )
    elseif numDisplay.text == "0" then
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
		
    if focusD.text == "0" then
      --do nothing
    else
      focusD.text = deleteChar(focusD.text)
			focusD.count = focusD.count - 1
		end
    
    if focusD.text == "" then 
      focusD.text = "0" 
    end

    if isFocus == 2 or isFocus == 3 or isFocus == 4 then
    	if hoursText.text ~= "0" or minText.text ~= "0" or secText.text ~= "0" then
    		numDisplay.text = toHours(hoursText.text, minText.text, secText.text)
    		numDisplay.text = math.round(numDisplay.text * math.pow(10, 5)) / math.pow(10, 5)
    	end
    end

    if not decPushed then
    	decTemp = numDisplay.text
    end

    if isFocus == 1 and degreeGroup.alpha ~= 0 then
    	if numDisplay.text ~= "0" or numDisplay.text ~= "0." then
    		hoursText.text = decTemp + 1 - 1
    		minText.text = (numDisplay.text - decTemp) * 60
    	end
    	
      if string.find(minText.text, ".") == nil then
    		--do nothing
    	else
    		local temp = minText.text
    		decPlace = string.find(minText.text, ".")
    		minText.text = minText.text:sub(1, decPlace+1)
    		secText.text = (temp - minText.text) * 60
    		secText.text = math.round(secText.text * math.pow(10, 5)) / math.pow(10, 5)
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
  
  local textOptionsR = {text="", x=0, y=0, width=numBack.contentWidth/1.05-20, height = 50, align="right", font="Digital-7Mono", fontSize=34}
    
  local textOptionsR2 = {text="", x=0, y=0, width = 100, height = 50, align="right", font="Digital-7Mono", fontSize=22}
  local textOptionsL = {parent = degreeGroup, text="", x=0, y=0, width=50, align="left", font="BerlinSansFB-Reg", fontSize=14}
  
  hours = display.newText(textOptionsL)
  hours.text = "Whole Degrees"
  hours:setFillColor( 0.153, 0.4, 0.729 )
  hours.x = display.contentCenterX-70
  hours.y = 30
  
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
  
  hoursText = display.newText( textOptionsR2 )
  degreeGroup:insert(hoursText)
  hoursText.x = 80
  hoursText.y = 45
	hoursText:setFillColor( 0.153, 0.4, 0.729 )
  hoursText.text = "0"
  hoursText.count = 0
  
  min = display.newText(textOptionsL)
  min.text = "Minutes"
  min:setFillColor( 0.153, 0.4, 0.729 )
  min.x = display.contentCenterX-70
  min.y = 85
  
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
  
  minText = display.newText( textOptionsR2 )
  degreeGroup:insert(minText)
  minText.x = 80
  minText.y = 95
	minText:setFillColor( 0.153, 0.4, 0.729 )
  minText.text = "0"
  minText.count = 0
  
  sec = display.newText(textOptionsL)
  sec.text = "Seconds"
  sec:setFillColor( 0.153, 0.4, 0.729 )
  sec.x = display.contentCenterX-70
  sec.y = 135
  
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
  
  secText = display.newText( textOptionsR2 )
  degreeGroup:insert(secText)
  secText.x = 80
  secText.y = 145
	secText:setFillColor( 0.153, 0.4, 0.729 )
  secText.text = "0"
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
  
  numDisplay = display.newText( textOptionsR )
  screenGroup:insert(numDisplay)
  numDisplay.x = display.contentCenterX+display.contentCenterX/2-10
  numDisplay.y = 60
	numDisplay:setFillColor( 0.153, 0.4, 0.729 )
  numDisplay.text = "0"
  numDisplay.count = 0
  
  screenGroup:insert(degreeGroup)
  
  if not isDegree then 
    degreeGroup.alpha = 0 
  end

	
	--Create Buttons
  
	num1 = widget.newButton
	{
    width = 50,
    height = 50,
		id = "num1",
		label = "1",
		labelColor = { default = {0.153, 0.4, 0.729}, over = {1}},
		fontSize = 16,
		onEvent = numPushed,
		defaultFile = "Images/calcButt.png",
		overFile = "Images/calcButtOver.png",
		}
	num1.x = display.contentCenterX+30
	num1.y = backEdgeY + 135	
		
	num2 = widget.newButton
	{
    width = 50,
    height = 50,
		id = "num2",
		label = "2",
		labelColor = { default = {0.153, 0.4, 0.729}, over = {1}},
		fontSize = 16,
		onEvent = numPushed,
		defaultFile = "Images/calcButt.png",
		overFile = "Images/calcButtOver.png",
		}
	num2.x = display.contentCenterX+90
	num2.y = backEdgeY + 135
		
	num3 = widget.newButton
	{
    width = 50,
    height = 50,
		id = "num3",
		label = "3",
		labelColor = { default = {0.153, 0.4, 0.729}, over = {1}},
		fontSize = 16,
		onEvent = numPushed,
		defaultFile = "Images/calcButt.png",
		overFile = "Images/calcButtOver.png",
		}
	num3.x = display.contentCenterX+150
	num3.y = backEdgeY + 135
		
	num4 = widget.newButton
	{
    width = 50,
    height = 50,
		id = "num4",
		label = "4",
		labelColor = { default = {0.153, 0.4, 0.729}, over = {1}},
		fontSize = 16,
		onEvent = numPushed,
		defaultFile = "Images/calcButt.png",
		overFile = "Images/calcButtOver.png",
		}
	num4.x = display.contentCenterX+30
	num4.y = backEdgeY + 190
		
	num5 = widget.newButton
	{
    width = 50,
    height = 50,
		id = "num5",
		label = "5",
		labelColor = { default = {0.153, 0.4, 0.729}, over = {1}},
		fontSize = 16,
		onEvent = numPushed,
		defaultFile = "Images/calcButt.png",
		overFile = "Images/calcButtOver.png",
		}
	num5.x = display.contentCenterX+90
	num5.y = backEdgeY + 190
		
	num6 = widget.newButton
	{
    width = 50,
    height = 50,
		id = "num6",
		label = "6",
		labelColor = { default = {0.153, 0.4, 0.729}, over = {1}},
		fontSize = 16,
		onEvent = numPushed,
		defaultFile = "Images/calcButt.png",
		overFile = "Images/calcButtOver.png",
		}
	num6.x = display.contentCenterX+150
	num6.y = backEdgeY + 190
		
	num7 = widget.newButton
	{
    width = 50,
    height = 50,
		id = "num7",
		label = "7",
		labelColor = { default = {0.153, 0.4, 0.729}, over = {1}},
		fontSize = 16,
		onEvent = numPushed,
		defaultFile = "Images/calcButt.png",
		overFile = "Images/calcButtOver.png",
		}
	num7.x = display.contentCenterX+30
	num7.y = backEdgeY + 245
		
	num8 = widget.newButton
	{
    width = 50,
    height = 50,
		id = "num8",
		label = "8",
		labelColor = { default = {0.153, 0.4, 0.729}, over = {1}},
		fontSize = 16,
		onEvent = numPushed,
		defaultFile = "Images/calcButt.png",
		overFile = "Images/calcButtOver.png",
		}
	num8.x = display.contentCenterX+90
	num8.y = backEdgeY + 245
		
	num9 = widget.newButton
	{
    width = 50,
    height = 50,
		id = "num9",
		label = "9",
		labelColor = { default = {0.153, 0.4, 0.729}, over = {1}},
		fontSize = 16,
		onEvent = numPushed,
		defaultFile = "Images/calcButt.png",
		overFile = "Images/calcButtOver.png",
		}
	num9.x = display.contentCenterX+150
	num9.y = backEdgeY + 245
		
	dec = widget.newButton
	{
    width = 50,
    height = 50,
		id = "dec",
		label = ".",
		labelColor = { default = {0.153, 0.4, 0.729}, over = {1}},
		fontSize = 16,
		onEvent = numPushed,
		defaultFile = "Images/calcButt.png",
		overFile = "Images/calcButtOver.png",
		}
	dec.x = display.contentCenterX+30
	dec.y = backEdgeY + 305
		
		if needDec then
			dec.alpha = 1
		else
			dec.alpha = 0
		end
		
	num0 = widget.newButton
	{
    width = 50,
    height = 50,
		id = "num0",
		label = "0",
		labelColor = { default = {0.153, 0.4, 0.729}, over = {1}},
		fontSize = 16,
		onEvent = numPushed,
		defaultFile = "Images/calcButt.png",
		overFile = "Images/calcButtOver.png",
		}
	num0.x = display.contentCenterX+90
	num0.y = backEdgeY + 305
		
	neg = widget.newButton
	{
    width = 50,
    height = 50,
		id = "neg",
		label = "-",
		labelColor = { default = {0.153, 0.4, 0.729}, over = {1}},
		fontSize = 16,
		onEvent = numPushed,
		defaultFile = "Images/calcButt.png",
		overFile = "Images/calcButtOver.png",
		}
	neg.x = display.contentCenterX+150
	neg.y = backEdgeY + 305
	
		if needNeg then
			neg.alpha = 1
		else
			neg.alpha = 0
		end
	
	enter = widget.newButton
	{
    width = 50,
    height = 50,
		labelColor = { default = {1}, over = {0.153, 0.4, 0.729} },
		label = "GO",
		id = "enter",
    defaultFile = "Images/calcButtOver.png",
    overFile = "Images/calcButt.png",
		onEvent = goEvent
  }
  enter.x = display.contentCenterX+210
  enter.y = backEdgeY + 190

  backButt = widget.newButton
	{
    width = 50,
    height = 50,
		id = "back",
		label = "DEL",
		labelColor = { default = {1}, over = {0.153, 0.4, 0.729}},
		fontSize = 14,
		onEvent = deleteEvent,
		defaultFile = "Images/calcButtOver.png",
		overFile = "Images/calcButt.png",
		}
	backButt.x = display.contentCenterX+210
	backButt.y = backEdgeY + 135
		
	clear = widget.newButton
	{
    width = 50,
    height = 50,
		labelColor = { default = {0.777, 0.267, 0.267}, over = {1} },
		label = "C",
		id = "clear",
    defaultFile = "Images/cancButt.png",
    overFile = "Images/cancButtOver.png",
		onEvent = resetEvent
  }
  clear.x = display.contentCenterX+210
  clear.y = backEdgeY + 305
		
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