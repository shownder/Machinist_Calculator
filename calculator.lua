--
-- Project: Trades Math Calculator
-- Description: 
--
-- Version: 1.0
-- Managed with http://CoronaProjectManager.com
--
-- Copyright 2013 . All Rights Reserved.
-- 
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local widget = require( "widget" )


local num1, num2, num3, num4, num5, num6, num7, num8, num9, num0, neg, dec, clear, enter, backButt
local deg, degText, degBorder, min, minText, minBorder, sec, secText, secBorder
local numDisplay, displayBorder
local numBack, maskBack, convert
local needNeg, needDec
local backEdgeX, backEdgeY
local decPress, count, isFocus, degreeGroup, isDegree
local tempDec, decPlace

local deleteChar

local function buttonEvent( event )
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

    if isFocus == 1 and event.target:getLabel() == "." then decPushed = true end	

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

    --if decPlace ~= nil then


    if isFocus == 1 then
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
  
local function catchStrays(event)
   return true
end
	
	local function buttonEvent2( event )
		local phase = event.phase
		
		if "ended" == phase then 
		
		if numDisplay.text:sub(numDisplay.text:len(),numDisplay.text:len()) == "." then
         numDisplay.text = numDisplay.text .. "0"
         storyboard.number = numDisplay.text 		
         transition.to ( maskBack, { time = 10, alpha = 0 } )
         storyboard.hideOverlay(true, "slideRight", 200 )
      elseif numDisplay.text ~= "0" then
         storyboard.number = numDisplay.text 
         transition.to ( maskBack, { time = 10, alpha = 0 } )
         storyboard.hideOverlay(true, "slideRight", 200 )
      elseif numDisplay.text == "0" then
          --do nothing
          count = count - 1
      end
      count = count + 1
    end 
	end
  
local function buttonEvent3( event )
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
    
    if focusD.text == "" then focusD.text = "0" end

    if isFocus == 2 or isFocus == 3 or isFocus == 4 then
    	if hoursText.text ~= "0" or minText.text ~= "0" or secText.text ~= "0" then
    		numDisplay.text = toHours(hoursText.text, minText.text, secText.text)
    		numDisplay.text = math.round(numDisplay.text * math.pow(10, 5)) / math.pow(10, 5)
    	end
    end

    if not decPushed then
    	decTemp = numDisplay.text
    end

    if isFocus == 1 then
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
  
  local function buttonEvent4( event )
		local phase = event.phase
		
		if "ended" == phase then
		
      storyboard.number = "Tap Me"
      decPushed = false
      transition.to ( maskBack, { time = 10, alpha = 0 } )
			storyboard.hideOverlay(true, "slideRight", 200 )
    
    end
	end
  
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
      
      -- if hoursText.text ~= "0" and minText.text ~= "0" and secText.text ~= "0" then
      --   local temp = toHours(hoursText.text, minText.text, secText.text)
      --   numDisplay.text = math.round(temp * math.pow(10, 5)) / math.pow(10, 5)
      -- end 
    		
		return true
	end
end

function scene:createScene( event )
	local screenGroup = self.view
  
  storyboard.number = "Tap Me"
  degreeGroup = display.newGroup()
  
  count = 0
  decPress = false
  isFocus = 1
	
	needNeg = event.params.negTrue
	needDec = event.params.needDec
  isDegree = event.params.isDegree
  print(isDegree)
  

  maskBack = display.newImageRect( screenGroup, "backgrounds/maskBack.png", 570, 360 )
	maskBack.alpha = 0
	maskBack.x = display.contentCenterX
	maskBack.y = display.contentCenterY
	transition.to ( maskBack, { time = 400, alpha = 1, delay = 300} )	
  maskBack:addEventListener( "tap", catchStrays )
  maskBack:addEventListener( "touch", catchStrays )
	backEdgeX = maskBack.contentBounds.xMin
	backEdgeY = maskBack.contentBounds.yMin

  numBack = display.newRect(screenGroup, 0, 0, display.contentWidth/2, display.contentHeight)
  numBack:setFillColor(255, 255, 255)
  numBack.strokeWidth = 2
  numBack:setStrokeColor(39, 102, 186, 200)
  numBack:setReferencePoint(display.TopLeftReferencePoint)
  numBack.x = display.contentCenterX
  
  convert = display.newRect(degreeGroup, 0, 0, display.contentWidth/2, display.contentHeight/2)
  convert:setFillColor(255, 255, 255)
  convert.strokeWidth = 2
  convert:setStrokeColor(39, 102, 186, 200)
  convert:setReferencePoint(display.TopLeftReferencePoint)
  convert.x = 0
  
  local textOptionsR = {text="", x=0, y=0, width=numBack.contentWidth/1.05-20, height = 50, align="right", font="Digital-7Mono", fontSize=34}
    
  local textOptionsR2 = {text="", x=0, y=0, width = 100, height = 50, align="right", font="Digital-7Mono", fontSize=22}
  local textOptionsL = {parent = degreeGroup, text="", x=0, y=0, width=50, align="left", font="BerlinSansFB-Reg", fontSize=14}
  
  hours = display.newText(textOptionsL)
  hours.text = "Whole Degrees"
  hours:setTextColor(39, 102, 186, 200)
  hours.x = display.contentCenterX-70
  hours.y = 30
  
  hoursBorder = display.newRect(degreeGroup, 0, 0, numBack.contentWidth/2.10, 36)
  hoursBorder:setFillColor(0, 0, 0, 0)
  hoursBorder.strokeWidth = 2
  hoursBorder:setStrokeColor(39, 102, 186, 200)
  hoursBorder:setReferencePoint(display.TopLeftReferencePoint)
  hoursBorder.x = 20
  hoursBorder.y = 15
  hoursBorder:addEventListener ( "touch", focusTouch )
  hoursBorder.isHitTestable = true
  hoursBorder.focus = 2
  
  hoursText = display.newText( textOptionsR2 )
  degreeGroup:insert(hoursText)
  hoursText.x = 80
  hoursText.y = 45
	hoursText:setTextColor ( 39, 102, 186 )
  hoursText.text = "0"
  hoursText.count = 0
  
  min = display.newText(textOptionsL)
  min.text = "Minutes"
  min:setTextColor(39, 102, 186, 200)
  min.x = display.contentCenterX-70
  min.y = 85
  
  minBorder = display.newRect(degreeGroup, 0, 0, numBack.contentWidth/2.10, 36)
  minBorder.strokeWidth = 2
  minBorder:setStrokeColor(39, 102, 186, 200)
  minBorder:setReferencePoint(display.TopLeftReferencePoint)
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
	minText:setTextColor ( 39, 102, 186 )
  minText.text = "0"
  minText.count = 0
  
  sec = display.newText(textOptionsL)
  sec.text = "Seconds"
  sec:setTextColor(39, 102, 186, 200)
  sec.x = display.contentCenterX-70
  sec.y = 135
  
  secBorder = display.newRect(degreeGroup, 0, 0, numBack.contentWidth/2.10, 36)
  secBorder:setFillColor(0, 0, 0, 0)
  secBorder.strokeWidth = 2
  secBorder:setStrokeColor(39, 102, 186, 200)
  secBorder:setReferencePoint(display.TopLeftReferencePoint)
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
	secText:setTextColor ( 39, 102, 186 )
  secText.text = "0"
  secText.count = 0
  
  displayBorder = display.newRect(screenGroup, 0, 0, numBack.contentWidth/1.05, 75)
  displayBorder:setFillColor(0, 0, 0, 0)
  displayBorder.strokeWidth = 5
  displayBorder:setStrokeColor(39, 102, 186, 200)
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
	numDisplay:setTextColor ( 39, 102, 186 )
  numDisplay.text = "0"
  numDisplay.count = 0
  
  screenGroup:insert(degreeGroup)
  
  if not isDegree then 
    degreeGroup.alpha = 0 
  end

	
	--Create Buttons
  
	num1 = widget.newButton
	{
		id = "num1",
		label = "1",
		labelColor = { default = {39, 102, 186, 200}, over = {255, 255, 255}},
		--font = "WC Mano Negra Bta",
		fontSize = 16,
		onEvent = buttonEvent,
		defaultFile = "Images/calcButt.png",
		overFile = "Images/calcButtOver.png",
		}
	num1.x = display.contentCenterX+30
	num1.y = backEdgeY + 135	
		
	num2 = widget.newButton
	{
		id = "num2",
		label = "2",
		labelColor = { default = {39, 102, 186, 200}, over = {255, 255, 255}},
		--font = "WC Mano Negra Bta",
		fontSize = 16,
		onEvent = buttonEvent,
		defaultFile = "Images/calcButt.png",
		overFile = "Images/calcButtOver.png",
		}
	num2.x = display.contentCenterX+90
	num2.y = backEdgeY + 135
		
	num3 = widget.newButton
	{
		id = "num3",
		label = "3",
		labelColor = { default = {39, 102, 186, 200}, over = {255, 255, 255}},
		--font = "WC Mano Negra Bta",
		fontSize = 16,
		onEvent = buttonEvent,
		defaultFile = "Images/calcButt.png",
		overFile = "Images/calcButtOver.png",
		}
	num3.x = display.contentCenterX+150
	num3.y = backEdgeY + 135
		
	num4 = widget.newButton
	{
		id = "num4",
		label = "4",
		labelColor = { default = {39, 102, 186, 200}, over = {255, 255, 255}},
		--font = "WC Mano Negra Bta",
		fontSize = 16,
		onEvent = buttonEvent,
		defaultFile = "Images/calcButt.png",
		overFile = "Images/calcButtOver.png",
		}
	num4.x = display.contentCenterX+30
	num4.y = backEdgeY + 190
		
	num5 = widget.newButton
	{
		id = "num5",
		label = "5",
		labelColor = { default = {39, 102, 186, 200}, over = {255, 255, 255}},
		--font = "WC Mano Negra Bta",
		fontSize = 16,
		onEvent = buttonEvent,
		defaultFile = "Images/calcButt.png",
		overFile = "Images/calcButtOver.png",
		}
	num5.x = display.contentCenterX+90
	num5.y = backEdgeY + 190
		
	num6 = widget.newButton
	{
		id = "num6",
		label = "6",
		labelColor = { default = {39, 102, 186, 200}, over = {255, 255, 255}},
		--font = "WC Mano Negra Bta",
		fontSize = 16,
		onEvent = buttonEvent,
		defaultFile = "Images/calcButt.png",
		overFile = "Images/calcButtOver.png",
		}
	num6.x = display.contentCenterX+150
	num6.y = backEdgeY + 190
		
	num7 = widget.newButton
	{
		id = "num7",
		label = "7",
		labelColor = { default = {39, 102, 186, 200}, over = {255, 255, 255}},
		--font = "WC Mano Negra Bta",
		fontSize = 16,
		onEvent = buttonEvent,
		defaultFile = "Images/calcButt.png",
		overFile = "Images/calcButtOver.png",
		}
	num7.x = display.contentCenterX+30
	num7.y = backEdgeY + 245
		
	num8 = widget.newButton
	{
		id = "num8",
		label = "8",
		labelColor = { default = {39, 102, 186, 200}, over = {255, 255, 255}},
		--font = "WC Mano Negra Bta",
		fontSize = 16,
		onEvent = buttonEvent,
		defaultFile = "Images/calcButt.png",
		overFile = "Images/calcButtOver.png",
		}
	num8.x = display.contentCenterX+90
	num8.y = backEdgeY + 245
		
	num9 = widget.newButton
	{
		id = "num9",
		label = "9",
		labelColor = { default = {39, 102, 186, 200}, over = {255, 255, 255}},
		--font = "WC Mano Negra Bta",
		fontSize = 16,
		onEvent = buttonEvent,
		defaultFile = "Images/calcButt.png",
		overFile = "Images/calcButtOver.png",
		}
	num9.x = display.contentCenterX+150
	num9.y = backEdgeY + 245
		
	dec = widget.newButton
	{
		id = "dec",
		label = ".",
		labelColor = { default = {39, 102, 186, 200}, over = {255, 255, 255}},
		--font = "WC Mano Negra Bta",
		fontSize = 16,
		onEvent = buttonEvent,
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
		id = "num0",
		label = "0",
		labelColor = { default = {39, 102, 186, 200}, over = {255, 255, 255}},
		--font = "WC Mano Negra Bta",
		fontSize = 16,
		onEvent = buttonEvent,
		defaultFile = "Images/calcButt.png",
		overFile = "Images/calcButtOver.png",
		}
	num0.x = display.contentCenterX+90
	num0.y = backEdgeY + 305
		
	neg = widget.newButton
	{
		id = "neg",
		label = "-",
		labelColor = { default = {39, 102, 186, 200}, over = {255, 255, 255}},
		--font = "WC Mano Negra Bta",
		fontSize = 16,
		onEvent = buttonEvent,
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
		--left = 320,
		--top = 90,
		labelColor = { default = {255, 255, 255}, over = {39, 102, 186, 200} },
		label = "GO",
		id = "enter",
    defaultFile = "Images/calcButtOver.png",
    overFile = "Images/calcButt.png",
		onEvent = buttonEvent2
  }
  enter.x = display.contentCenterX+210
  enter.y = backEdgeY + 190

    backButt = widget.newButton
	{
		id = "back",
		label = "DEL",
		labelColor = { default = {255, 255, 255}, over = {39, 102, 186, 200}},
		--font = "WC Mano Negra Bta",
		fontSize = 14,
		onEvent = buttonEvent3,
		defaultFile = "Images/calcButtOver.png",
		overFile = "Images/calcButt.png",
		}
	backButt.x = display.contentCenterX+210
	backButt.y = backEdgeY + 135
		
	clear = widget.newButton
	{
		--left = 320,
		--top = 240,
		labelColor = { default = {198, 68, 68}, over = {255, 255, 255} },
		label = "C",
		id = "clear",
    defaultFile = "Images/cancButt.png",
    overFile = "Images/cancButtOver.png",
		onEvent = buttonEvent4
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

function scene:exitScene( event )
   local group = self.view

	maskBack:removeSelf()
  --storyboard.purgeScene( "calculator" )	
   
end

function scene:enterScene( event )
   local group = self.view
   
   storyboard.isOverlay = true
   
end

function deleteChar(s)
  
  local length = s:len()
  if s:sub(length, length) == "." then
    decPress = false
    decPushed = false
  end
  
  s = s:sub(1,length - 1)
  return s
  
end

function toHours(h, m, s)

  return h + (m/60) + (s/3600)
  
end

scene:addEventListener( "createScene", scene )

scene:addEventListener( "exitScene", scene )

scene:addEventListener( "enterScene", scene )

return scene
