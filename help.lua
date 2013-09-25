local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local widget = require( "widget" )

--Forward Declarations

local backEdgeX, backEdgeY, maskBack
local pad
local backButt, whichHelp, helpText, scrollView


--Functions

local function goBack( event )
	if event.phase == "ended" then
		
    transition.to ( maskBack, { time = 10, alpha = 0 } )
		storyboard.hideOverlay(true, "slideUp", 200 )
		
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

function scene:createScene( event )
	local screenGroup = self.view
  
  storyboard.number = "Tap Me"
  local textOptions = {text="", x=0, y=0, width=250, align="left", font="WCManoNegraBta", fontSize=22}
  
  whichHelp = event.params.helpType
  
  maskBack = display.newImageRect( screenGroup, "backgrounds/maskBack.png", 570, 360 )
	maskBack.alpha = 0
	maskBack.x = display.contentCenterX
	maskBack.y = display.contentCenterY
	transition.to ( maskBack, { time = 400, alpha = 1, delay = 300} )	
	
	backEdgeX = maskBack.contentBounds.xMin
	backEdgeY = maskBack.contentBounds.yMin
  
  pad = display.newImageRect( screenGroup, "Images/notepad.png", 382, 500 )
  pad.x = 220
  pad.y = 170
  
  backButt = widget.newButton 
  {
		left = 0,
		top = 0,
		width = 65,
		height = 35,
		label = "BACK",
		id = "backButt",
		onEvent = goBack
		}
	screenGroup:insert(backButt)
	backButt.x = backEdgeX + 490
	backButt.y = backEdgeY + 60
  
  helpText = display.newText(textOptions)
  screenGroup:insert(helpText)
  helpText:setTextColor(0, 0, 0)
  helpText.x = backEdgeX + 270
  helpText.y = backEdgeY + 200
  
  scrollView = widget.newScrollView{
			left = 0,
			top = 0,
			width = 400,
			height = 280,
      --scrollHeight = maskBack.contentHeight + 70,
			id = "helpScroll",
			hideBackground = true,
			horizontalScrollingDisabled = true,
			verticalScrollingDisabled = false,
			listener = scrollListener,		
		}
		screenGroup:insert(scrollView)
  
  if whichHelp == "rightAngle" then
    helpText.text = "THE CALCULATOR WILL TAKE 2 USER INPUTS AND CALCULATE THE MISSING VALUES OF A RIGHT ANGLE TRIANGLE. WHEN ENOUGH INFO IS PROVIDED, IT WILL AUTO-CALCULATE AND ALL VALUES WILL TURN WHITE AND BECOME NON-EDITABLE."
  elseif whichHelp == "oblique" then
    helpText.y = backEdgeY + 235
    helpText.text = "THE CALCULATOR WILL TAKE 3 USER INPUTS AND CALCULATE THE MISSING VALUES OF THE TRIANGLE. PRES THE CHANGE INFO BUTTON TO CHOOSE WHICH FORMULA TO USE. WHEN ENOUGH INFO IS PROVIDED, IT WILL AUTO-CALCULATE AND ALL VALUES WILL TURN WHITE AND BECOME NON-EDITABLE."
  elseif whichHelp == "sine" then
    helpText.y = backEdgeY + 180
    helpText.text = "AFTER ENTERING THE SINE BAR SIZE AND 1 OTHER INPUT THE CALCULATOR WILL AUTO-CALCULATE THE OTHER 2 VALUES. THE ANSWERS WILL AUTO-UPDATE WHENEVER EDITED."
  elseif whichHelp == "speed" then
    helpText.y = backEdgeY + 180
    helpText.text = "AUTO-CALCULATES THE RPM OR SURFACE SPEED WHEN DIAMETER OF THE CUTTER AND 1 OTHER INPUT IS ENTERED. YOU CAN ALSO CALCULATE THE FEED/MIN AND FEED/REV AFTER THE RPM VALUE IS UPDATED."
  elseif whichHelp == "bolt" then
    helpText.y = backEdgeY + 320
    helpText.text = "CALCULATES A LIST OF X/Y COORDINATES AND A DIAGRAM. NUMBER OF HOLES AND DIAMETER ARE REQUIRED. X AND Y CENTRES REFER TO CENTRE COORDINATES OF THE CIRCLE MEASURED FROM ABSOLUTE ZERO AND WILL BE ADDED OR SUBTRACTED TO HOLE POSITIONS. START ANGLE REFERS TO THE POLAR DISTANCE THE FIRST HOLE IS FROM 3 O'CLOCK, THE FIRST HOLE IS COLOURED RED ON DIAGRAM."
  end
  
  scrollView:insert(helpText)
    
end


function scene:enterScene( event )
   local group = self.view
   
   storyboard.isOverlay = true
   
end

scene:addEventListener( "createScene", scene )

scene:addEventListener( "enterScene", scene )

return scene