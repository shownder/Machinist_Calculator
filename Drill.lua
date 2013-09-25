--
-- Project: Trades Math Calculator
-- Description: 
--
-- Version: 1.0
-- Managed with http://CoronaProjectManager.com
--
-- Copyright 2013 . All Rights Reserved.
-- 
--Require
local widget = require ( "widget" )
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()--Local forward referenceslocal returnButt--Button Listeners

local function returnHomeEvent( event )
    local phase = event.phase 

    if "ended" == phase then
        storyboard.gotoScene( "menu" )
    end
endfunction scene:createScene( event )
	local screenGroup = self.view		returnButt = widget.newButton
	{
		left = 100,
		top = 411,
		width = 130,
		height = 40,
		id = "returnButt",
		label = "Menu",
		onRelease = returnHomeEvent,		
		}	end-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
        local group = self.view        		storyboard.purgeScene( "menu" )

endfunction scene:exitScene( event )
   local group = self.view
	display.remove( returnButt )   
endscene:addEventListener( "createScene", scene )scene:addEventListener( "enterScene", scene )scene:addEventListener( "exitScene", scene )



return scene