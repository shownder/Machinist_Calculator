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

local answer, backButt, scrollView, answerX, answerY, diamlocal back, numY
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
local function goBack( event )
	if event.phase == "ended" then
		
		storyboard.hideOverlay(true, "slideUp", 300 )		
	end
end	local function scrollListener( event )
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

--End Listeners

function scene:createScene( event )
	local screenGroup = self.view
	
	answer = storyboard.answer
  answerX = storyboard.answerX
  answerY = storyboard.answerY
  diam = storyboard.diam
  local textOptionsL = {parent = screenGroup, text="", x=0, y=0, width=250, height=0, fontSize=15, align="left"}		back = display.newImageRect ( screenGroup, "backgrounds/boltanswer.png",  570, 360 )
	back.x = display.contentCenterX
	back.y = display.contentCenterY		
	backEdgeX = back.contentBounds.xMin
	backEdgeY = back.contentBounds.yMin
  
  numY = backEdgeY + 50		backButt = widget.newButton {		left = 0,
		top = 0,
		width = 65,
		height = 35,
		label = "BACK",
		id = "backButt",
		onEvent = goBack
		}	screenGroup:insert(backButt)	backButt.x = backEdgeX + 480	backButt.y = backEdgeY + 60
  
  boltCenterX = backEdgeX + 400
  boltCenterY = backEdgeY + 180
  bolt = display.newCircle(screenGroup, boltCenterX, boltCenterY, 98)
  bolt:setFillColor(0, 0, 0, 0)
  bolt.strokeWidth = 2
  bolt:setStrokeColor(255, 255, 255)		if #answer > 7 then		scrollView = widget.newScrollView{			left = 0,
			top = 0,
			width = 240,
			height = 315,
			id = "answerScroll",
			hideBackground = true,
			horizontalScrollingDisabled = true,
			verticalScrollingDisabled = false,
			listener = scrollListener,				}		screenGroup:insert(scrollView)	end		for i = 0, #answer, 1 do	
		local temp = display.newText( textOptionsL )
    temp:setTextColor(0,0,0)
    temp.text = answer[i]		temp.y = backEdgeY + numY		temp.x = backEdgeX + 180				if #answer > 7 then			scrollView:insert(temp)		end
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
      temp:setStrokeColor(128, 0, 0)
    else
      temp:setStrokeColor(255, 255, 255)
    end
  end
  
  line1 = display.newLine(screenGroup, boltCenterX - 110, boltCenterY, boltCenterX + 110, boltCenterY)
  line2 = display.newLine(screenGroup, boltCenterX, boltCenterY - 110, boltCenterX, boltCenterY + 110)
  
	
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
