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
local numDisplay
local numBack, maskBack
local needNeg, needDec
local backEdgeX, backEdgeY
local decPress

local deleteChar

local function buttonEvent( event )
		local phase = event.phase
		
		if "ended" == phase then
      
    if event.target:getLabel() == "." and decPress == false then
      if numDisplay.text == "" then
        numDisplay.text = "0."
      elseif numDisplay.text == "-" then
        numDisplay.text = "-0."
      else
       numDisplay.text = numDisplay.text .. event.target:getLabel()
      end
      decPress = true
    end
    		
		if numDisplay.text ~= "" and event.target:getLabel() == "-" then
			--do nothing
    elseif event.target:getLabel() == "." then
      --do nothing
    else
      numDisplay.text = numDisplay.text .. event.target:getLabel()
		end
      
			
		end
	end
	
	local function buttonEvent2( event )
		local phase = event.phase
		
		if "ended" == phase then
		
			if numDisplay.text:sub(numDisplay.text:len(),numDisplay.text:len()) == "." then
         numDisplay.text = numDisplay.text .. "0"
         storyboard.number = numDisplay.text 		
         transition.to ( maskBack, { time = 10, alpha = 0 } )
         storyboard.hideOverlay(true, "slideUp", 200 )
      elseif numDisplay.text ~= "" then
         storyboard.number = numDisplay.text 
         transition.to ( maskBack, { time = 10, alpha = 0 } )
         storyboard.hideOverlay(true, "slideUp", 200 )
      elseif numDisplay.text == "" then
          --do nothing
      end
      
		end
	end
  
  local function buttonEvent3( event )
		local phase = event.phase
		
		if "ended" == phase then
		
    if numDisplay.text == "" then
      --do nothing
    else
      numDisplay.text = deleteChar(numDisplay.text)			
		end
    end
	end
  
  local function buttonEvent4( event )
		local phase = event.phase
		
		if "ended" == phase then
		
      storyboard.number = "Tap Me"
      transition.to ( maskBack, { time = 10, alpha = 0 } )
			storyboard.hideOverlay(true, "slideUp", 200 )
    
    end
	end

function scene:createScene( event )
	local screenGroup = self.view
  
  storyboard.number = "Tap Me"
  
  local textOptionsR = {text="", x=0, y=0, width=500, height = 50, align="right", font="Digital-7Mono", fontSize=34}
  decPress = false
	
	needNeg = event.params.negTrue
	needDec = event.params.needDec
	
  maskBack = display.newImageRect( screenGroup, "backgrounds/maskBack.png", 570, 360 )
	maskBack.alpha = 0
	maskBack.x = display.contentCenterX
	maskBack.y = display.contentCenterY
	transition.to ( maskBack, { time = 400, alpha = 1, delay = 300} )	
	
	backEdgeX = maskBack.contentBounds.xMin
	backEdgeY = maskBack.contentBounds.yMin

	numDisplay = display.newText( textOptionsR )
  screenGroup:insert(numDisplay)
  numDisplay.x = backEdgeX + 120
  numDisplay.y = backEdgeY + 75
	numDisplay:setTextColor ( 255, 255, 204 )
  numDisplay.text = ""
	
	numBack = display.newImageRect ( screenGroup, "backgrounds/calcBack.png", 332, 303 )
	numBack.x = backEdgeX + 250
	numBack.y = backEdgeY + 180

	
	--Create Buttons
  
  backButt = widget.newButton
	{
		id = "back",
		--label = "<-",
		labelColor = { default = {255, 255, 255}, over = {192, 192, 192}},
		--font = "WC Mano Negra Bta",
		fontSize = 16,
		onEvent = buttonEvent3,
		defaultFile = "Images/backButtDef.png",
		overFile = "Images/backButtOver.png",
		}
	backButt.x = backEdgeX + 330
	backButt.y = backEdgeY + 120
			
	num1 = widget.newButton
	{
		id = "num1",
		label = "1",
		labelColor = { default = {255, 255, 255}, over = {192, 192, 192}},
		--font = "WC Mano Negra Bta",
		fontSize = 16,
		onEvent = buttonEvent,
		defaultFile = "Images/calcButtDef.png",
		overFile = "Images/calcButtOver.png",
		}
	num1.x = backEdgeX + 150
	num1.y = backEdgeY + 120	
		
	num2 = widget.newButton
	{
		id = "num2",
		label = "2",
		labelColor = { default = {255, 255, 255}, over = {192, 192, 192}},
		--font = "WC Mano Negra Bta",
		fontSize = 16,
		onEvent = buttonEvent,
		defaultFile = "Images/calcButtDef.png",
		overFile = "Images/calcButtOver.png",
		}
	num2.x = backEdgeX + 210
	num2.y = backEdgeY + 120
		
	num3 = widget.newButton
	{
		id = "num3",
		label = "3",
		labelColor = { default = {255, 255, 255}, over = {192, 192, 192}},
		--font = "WC Mano Negra Bta",
		fontSize = 16,
		onEvent = buttonEvent,
		defaultFile = "Images/calcButtDef.png",
		overFile = "Images/calcButtOver.png",
		}
	num3.x = backEdgeX + 270
	num3.y = backEdgeY + 120
		
	num4 = widget.newButton
	{
		id = "num4",
		label = "4",
		labelColor = { default = {255, 255, 255}, over = {192, 192, 192}},
		--font = "WC Mano Negra Bta",
		fontSize = 16,
		onEvent = buttonEvent,
		defaultFile = "Images/calcButtDef.png",
		overFile = "Images/calcButtOver.png",
		}
	num4.x = backEdgeX + 150
	num4.y = backEdgeY + 175
		
	num5 = widget.newButton
	{
		id = "num5",
		label = "5",
		labelColor = { default = {255, 255, 255}, over = {192, 192, 192}},
		--font = "WC Mano Negra Bta",
		fontSize = 16,
		onEvent = buttonEvent,
		defaultFile = "Images/calcButtDef.png",
		overFile = "Images/calcButtOver.png",
		}
	num5.x = backEdgeX + 210
	num5.y = backEdgeY + 175
		
	num6 = widget.newButton
	{
		id = "num6",
		label = "6",
		labelColor = { default = {255, 255, 255}, over = {192, 192, 192}},
		--font = "WC Mano Negra Bta",
		fontSize = 16,
		onEvent = buttonEvent,
		defaultFile = "Images/calcButtDef.png",
		overFile = "Images/calcButtOver.png",
		}
	num6.x = backEdgeX + 270
	num6.y = backEdgeY + 175
		
	num7 = widget.newButton
	{
		id = "num7",
		label = "7",
		labelColor = { default = {255, 255, 255}, over = {192, 192, 192}},
		--font = "WC Mano Negra Bta",
		fontSize = 16,
		onEvent = buttonEvent,
		defaultFile = "Images/calcButtDef.png",
		overFile = "Images/calcButtOver.png",
		}
	num7.x = backEdgeX + 150
	num7.y = backEdgeY + 235
		
	num8 = widget.newButton
	{
		id = "num8",
		label = "8",
		labelColor = { default = {255, 255, 255}, over = {192, 192, 192}},
		--font = "WC Mano Negra Bta",
		fontSize = 16,
		onEvent = buttonEvent,
		defaultFile = "Images/calcButtDef.png",
		overFile = "Images/calcButtOver.png",
		}
	num8.x = backEdgeX + 210
	num8.y = backEdgeY + 235
		
	num9 = widget.newButton
	{
		id = "num9",
		label = "9",
		labelColor = { default = {255, 255, 255}, over = {192, 192, 192}},
		--font = "WC Mano Negra Bta",
		fontSize = 16,
		onEvent = buttonEvent,
		defaultFile = "Images/calcButtDef.png",
		overFile = "Images/calcButtOver.png",
		}
	num9.x = backEdgeX + 270
	num9.y = backEdgeY + 235
		
	dec = widget.newButton
	{
		id = "dec",
		label = ".",
		labelColor = { default = {255, 255, 255}, over = {192, 192, 192}},
		--font = "WC Mano Negra Bta",
		fontSize = 16,
		onEvent = buttonEvent,
		defaultFile = "Images/calcButtDef.png",
		overFile = "Images/calcButtOver.png",
		}
	dec.x = backEdgeX + 150
	dec.y = backEdgeY + 295
		
		if needDec then
			dec.alpha = 1
		else
			dec.alpha = 0
		end
		
	num0 = widget.newButton
	{
		id = "num0",
		label = "0",
		labelColor = { default = {255, 255, 255}, over = {192, 192, 192}},
		--font = "WC Mano Negra Bta",
		fontSize = 16,
		onEvent = buttonEvent,
		defaultFile = "Images/calcButtDef.png",
		overFile = "Images/calcButtOver.png",
		}
	num0.x = backEdgeX + 210
	num0.y = backEdgeY + 295
		
	neg = widget.newButton
	{
		id = "neg",
		label = "-",
		labelColor = { default = {255, 255, 255}, over = {192, 192, 192}},
		--font = "WC Mano Negra Bta",
		fontSize = 16,
		onEvent = buttonEvent,
		defaultFile = "Images/calcButtDef.png",
		overFile = "Images/calcButtOver.png",
		}
	neg.x = backEdgeX + 270
	neg.y = backEdgeY + 295
	
		if needNeg then
			neg.alpha = 1
		else
			neg.alpha = 0
		end


		
	enter = widget.newButton
	{
		--left = 320,
		--top = 90,
		width = 57,
		height = 50,
		--labelColor = { default = { 2228, 228, 2285, 90 }, over = { 134, 134, 134, 255 } },
		--label = "enter",
		id = "enter",
    defaultFile = "Images/goButt.png",
    overFile = "Images/goButtOver.png",
		onEvent = buttonEvent2
  }
  enter.x = backEdgeX + 330
  enter.y = backEdgeY + 175
		
	clear = widget.newButton
	{
		--left = 320,
		--top = 240,
		width = 57,
		height = 50,
		--labelColor = { default = { 2228, 228, 2285, 90 }, over = { 134, 134, 134, 255 } },
		--label = "clear",
		id = "clear",
    defaultFile = "Images/cancelButt.png",
    overFile = "Images/cancelButtOver.png",
		onEvent = buttonEvent4
  }
  clear.x = backEdgeX + 330
  clear.y = backEdgeY + 295
		
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
  end
  
  s = s:sub(1,length - 1)
  return s
  
end

scene:addEventListener( "createScene", scene )

scene:addEventListener( "exitScene", scene )

scene:addEventListener( "enterScene", scene )

return scene
