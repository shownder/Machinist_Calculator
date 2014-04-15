--
-- Project: main.lua
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

local answer, backButt, scrollView, answerX, answerY, diam, emailButt, maskBack
local back, numY
local bolt, boltCenterX, boltCenterY, line1, line2, goBack2

--Listeners

local function onKeyEvent( event )

   local phase = event.phase
   local keyName = event.keyName
   print( event.phase, event.keyName )

  if ( "back" == keyName and phase == "down" ) then
    timer.performWithDelay(100,goBack2,1)
  end
  return true
end

local function catchStrays(event)
   return true
end

local function emailPush( event )
	if event.phase == "ended" then
    
    local text = ""
    
    for i = 0, #answer, 1 do
      text = text..answer[i].."\n"
    end
    
    print(text)
        
    local options = {
      
      to = "",
      subject = "Bolt Circle Answer",
      body = "Here is the list of coordinates: \n"..text      
      }
		
		native.showPopup("mail", options)
		return true
	end
end

local function goBack( event )
	if event.phase == "ended" then
		
		storyboard.hideOverlay(true, "slideRight", 300 )
		
	end
end

	local function scrollListener( event )
		local phase = event.phase
		local direction = event.direction
		
		if "began" == phase then
			--print( "Began" )
		elseif "moved" == phase then
			--print("moved")
		elseif "ended" == phase then
			--print( "Ended" )
		end
		
		-- If the scrollView has reached it's scroll limit
		if event.limitReached then
			if "up" == direction then
				print( "Reached Top Limit" )
			elseif "down" == direction then
				print( "Reached Bottom Limit" )
			elseif "left" == direction then
				print( "Reached Left Limit" )
			elseif "right" == direction then
				print( "Reached Right Limit" )
			end
		end
				
		return true
	end
  
function scene:overEnded()
  local screenGroup = self.view
  
      storyboard.isOverlay = false
    
    if storyboard.number ~= "Tap Me" then
    
    if calcClick == true then
    
    tapTable[whatTap].text = storyboard.number
    
    if whatTap == 1 then
    	if tonumber(numHoles.text)  <= 0 then
    		native.showAlert ( "Error", "You need more than 0 holes!", { "OK" }, alertListener )
    		numHoles.text = "Tap Me"
    	end
    elseif whatTap == 2 then    
  	  if tonumber(diam.text)  <= 0 then
    		native.showAlert ( "Error", "Diameter must be greater than 0!", { "OK" }, alertListener )
    		diam.text = "Tap Me"
        diam.alpha = 0
        diamTap.alpha = 1
  	  end
    end
        
    if diam.text ~= "Tap Me" and numHoles.text ~= "Tap Me" then
    	circleXtext.alpha = 1
    	circleXTap.alpha = 1
    	circleYTap.alpha = 1
    	circleYtext.alpha = 1
    	firstHoleText.alpha = 1
    	firstHoleTap.alpha = 1
    	answer.alpha = 1
    end    
       
    for i = 1, 5, 1 do
      if tapTable[i].text ~= "Tap Me" then
        tapTable[i].alpha = 1
        aniTable[i].alpha = 0
      end
    end
    
  end
  
  end

end
  

--End Listeners

function scene:createScene( event )
	local screenGroup = self.view
	
	answer = storyboard.answer
  answerX = storyboard.answerX
  answerY = storyboard.answerY
  diam = storyboard.diam
  local textOptionsL = {parent = screenGroup, text="", x=0, y=0, width=250, height=0, fontSize=15, align="left"}
  
  maskBack = display.newImageRect( screenGroup, "backgrounds/maskBack.png", 570, 360 )
	maskBack.alpha = 0
	maskBack.x = display.contentCenterX
	maskBack.y = display.contentCenterY
	transition.to ( maskBack, { time = 400, alpha = 1, delay = 300} )	
  maskBack:addEventListener( "tap", catchStrays )
  maskBack:addEventListener( "touch", catchStrays )
	backEdgeX = maskBack.contentBounds.xMin
	backEdgeY = maskBack.contentBounds.yMin
	
	back = display.newRect(screenGroup, 0, 0, display.pixelHeight, display.pixelWidth )
	back.anchorX = 0; back.anchorY = 0; 
  back:setFillColor(1)
	backEdgeX = back.contentBounds.xMin
	backEdgeY = back.contentBounds.yMin
  
  
  numY = backEdgeY + 10
  --numY = 60
  
  boltCenterX = backEdgeX + 360
  boltCenterY = backEdgeY + 180
  bolt = display.newCircle(screenGroup, boltCenterX, boltCenterY, 98)
  bolt:setFillColor(0, 0)
  bolt.strokeWidth = 2
  bolt:setStrokeColor(0)
	
scrollView = widget.newScrollView
	{
		left = 0,
		top = 50,
		width = 240,
		height = 265,
		scrollWidth = 0,
		--scrollHeight = display.pixelHeight-50,
		id = "answerScroll",
		hideBackground = false,
		horizontalScrollDisabled = true,
		verticalScrollDisabled = false,
    	isBounceEnabled = false,
		listener = scrollListener,		
	}
	screenGroup:insert(scrollView)
	
	for i = 0, #answer, 1 do	
		local temp = display.newText( textOptionsL )
    	temp:setFillColor(0)
    	temp.text = answer[i]
		temp.y = numY
		temp.x = backEdgeX + 140
		scrollView:insert(temp)  
		numY = numY + 30 
	end
  
  for i = 0, #answer, 1 do
    local temp
    local diamTemp
    if #answer > 30 then
      diamTemp = 98 * 3.14 / #answer
      temp = display.newCircle(screenGroup, 0, 0, diamTemp)
    else
      temp = display.newCircle(screenGroup, 0, 0, 10)
    end
    
    temp.x = boltCenterX + (answerX[i] * 13)
    temp.y = boltCenterY - (answerY[i] * 13)
    temp:setFillColor(0, 0, 0, 0)
    temp.strokeWidth = 2
    if i == 0 then
      temp:setStrokeColor(0.777, 0.267, 0.267)
    else
      temp:setStrokeColor(0)
    end
  end
  
  line1 = display.newLine(screenGroup, boltCenterX - 110, boltCenterY, boltCenterX + 110, boltCenterY)
  line2 = display.newLine(screenGroup, boltCenterX, boltCenterY - 110, boltCenterX, boltCenterY + 110)
  line1:setColor(0)
  line2:setColor(0)
  
  topBar = display.newRect( screenGroup, 0, 0, display.pixelHeight, 50 )
	topBar.anchorX = 0; topBar.anchorY = 0; 
  topBar:setFillColor(0.153, 0.4, 0.729)

  backButt = display.newImageRect(screenGroup, "Images/backButt.png", 54, 22)
  backButt.anchorX = 0; backButt.anchorY = 0; 
  backButt:addEventListener("touch", goBack)
  backButt.isHitTestable = true
  backButt.x = 10
  backButt.y = 15
  
  emailButt = display.newImageRect(screenGroup, "Images/email.png", 40, 23)
  emailButt.x = display.contentWidth - 20
  print(display.pixelHeight)
  print(display.pixelWidth)
  emailButt.y = 26
  emailButt:addEventListener("touch", emailPush)
  emailButt.isHitTestable = true
  print(topBar.contentBounds.xMax)
	
end

function scene:enterScene( event )
  local group = self.view

    storyboard.isOverlay = true
   
end

function scene:destroyScene( event )
   local group = self.view

	storyboard.answer = nil
  storyboard.answerX = nil
  storyboard.answerY = nil
  storyboard.diam = nil
	
   
end

scene:addEventListener( "createScene", scene )

scene:addEventListener( "enterScene", scene )

scene:addEventListener( "destroyScene", scene )

return scene
