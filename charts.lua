local composer = require( "composer" )
local scene = composer.newScene()
local widget = require ( "widget" )
local myData = require("myData")

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

local chartChoice, taperPipe, decEqui, uniTap, isoMetric
local back, isOverlay, backEdgeX, backEdgeY
local moveIntro
local choiceTable, decEquiTable, uniTapTable
local decEquiAnswer, uniTapAnswer
local counter
local menuHidden

local menuHide, menuShow, goBack, openDecEqui, openUniTap

local function onRowRender( event )

    -- Get reference to the row group
    local row = event.row
    local chart = event.row.params.chart

    -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth

    local rowTitle = display.newText( { parent = row, text = chart[row.index], x = 0, y = 0, font = "BerlinSansFB-Reg", fontSize = 20, align = right} )
    if row.index == 1 then
      rowTitle:setFillColor( 1 )
    elseif row.index == 2 then
      rowTitle:setFillColor( 0.15, 0.4, 0.729 )
    else
      rowTitle:setFillColor( 0 )
    end
    
    -- Align the label left and vertically centered
    rowTitle.anchorX = 0
    rowTitle.x = 10
    rowTitle.y = rowHeight * 0.5
end

--local function onRowRender2( event )

--    -- Get reference to the row group
--    local row = event.row

--    -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
--    local rowHeight = row.contentHeight
--    local rowWidth = row.contentWidth
--    
--    local rowTitle = display.newText( { parent = row, text = decEquiTable[row.index], x = 0, y = 0, font = "BerlinSansFB-Reg", fontSize = 20} )
--    if row.index == 1 then
--      rowTitle:setFillColor( 1 )
--    elseif row.index == 2 then
--      rowTitle:setFillColor( 0.15, 0.4, 0.729 )
--    else
--      rowTitle:setFillColor( 0 )
--    end
--    
--    -- Align the label left and vertically centered
--    rowTitle.anchorX = 0
--    rowTitle.x = 10
--    rowTitle.y = rowHeight * 0.5
--    
--    --decEquiCounter = decEquiCounter + 1
--end

local function onRowTouch( event )
  local phase = event.phase
  local row = event.target
  
  if "press" == phase then
    print(row.index)  
  elseif "release" == phase then
    if row.index == 2 then
      transition.to(chartChoice, {x = chartChoice.contentWidth - chartChoice.contentWidth * 2})
      timer.performWithDelay(500, goBack)
    elseif row.index == 3 then
      menuHide()
      timer.performWithDelay(500, openDecEqui)
    elseif row.index == 4 then
      menuHide()
      timer.performWithDelay(500, openUniTap) 
    end
  end
end

local function onRowTouch2( event )
  local phase = event.phase
  local row = event.target
  local event = event.target
  
  if "release" == phase then
    if row.index == 2 then
      timer.performWithDelay(500, menuShow)
      if event._id == "decEqui" then
        openDecEqui()
      elseif event._id == "uniTap" then
        openUniTap()
      end
    else
      print(event.target.params.answer[row.index])
    end
  end
end


moveIntro = function()
  
  transition.to(chartChoice, {x = chartChoice.contentWidth / 2, time = 500})
  
end

openDecEqui = function()
  
  if not menuHidden then
    decEqui.alpha = 1
    transition.to(decEqui, {y = display.contentCenterY, time = 500})
    menuHidden = true
  else
    transition.to(decEqui, {y = display.contentHeight * 2 + 10, time = 500})
    menuHidden = false
  end
end

openUniTap = function()
  
  if not menuHidden then
    uniTap.alpha = 1
    transition.to(uniTap, {y = display.contentCenterY, time = 500})
    menuHidden = true
  else
    transition.to(uniTap, {y = display.contentHeight * 2 + 10, time = 500})
    menuHidden = false
  end
end

menuHide = function()
  
   transition.to(chartChoice, {x = chartChoice.contentWidth - chartChoice.contentWidth * 2, time = 500})

end

menuShow = function()
  
   transition.to(chartChoice, {x = chartChoice.contentWidth / 2, time = 500})

end


goBack = function()
  composer.gotoScene( "menu", { effect="fromBottom", time=800})
end

---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )

   local sceneGroup = self.view
   
   isOverlay = event.params.isOverlay
   myData.isOverlay = isOverlay
   
   choiceTable = {}
   decEquiTable = {}
   uniTapTable = {}
   
   decEquiAnswer = {}
   uniTapAnswer = {}
   
   counter = 1
   
   menuHidden = false
   
  if not isOverlay then
    back = display.newImageRect( sceneGroup, "backgrounds/background.png", 570, 360 )
    back.x = display.contentCenterX
    back.y = display.contentCenterY
    backEdgeX = back.contentBounds.xMin
    backEdgeY = back.contentBounds.yMin
  end
  
  choiceTable[1] = "CHART MENU"
  choiceTable[2] = "BACK"
  choiceTable[3] = "Decimal Equivalents of Inch Drills (INCH)"
  choiceTable[4] = "Unified Tapping Drills (INCH)"
  choiceTable[5] = "Taper Pipe Tapping Drills (INCH)"
  choiceTable[6] = "ISO Metric Tapping Drills (MM)"

  
  
   chartChoice = widget.newTableView(
     {
       left = 0,
       top = 0,
       width = display.contentWidth,
       height = display.contentHeight,
       onRowTouch = onRowTouch,
       onRowRender = onRowRender,
       hideScrollBar = false,
       }
     )
     sceneGroup:insert(chartChoice)
     chartChoice.x = chartChoice.contentWidth - chartChoice.contentWidth * 2
     
     timer.performWithDelay(600, moveIntro)
     
     for i = 1, 6, 1 do
       
       local isCategory = false
       local rowHeight = display.contentHeight / 6
       local rowColor = { default={ 1, 1, 1 }, over={ 1, 0.5, 0, 0.2 } }
       local lineColor = { 0.15, 0.4, 0.729 }
       
       if ( i == 1 ) then
         isCategory = true
         rowColor = { default={ 0.15, 0.4, 0.729, 0.95 } }
         lineColor = { 1, 0, 0 }
       end
       
           chartChoice:insertRow(
           {
            isCategory = isCategory,
            rowHeight = rowHeight,
            rowColor = rowColor,
            lineColor = lineColor,
            params = { chart =  choiceTable}
           }
           )
     end
     
     --Start Decimal Equivalents
     
     decEqui = widget.newTableView(
     {
       id = "decEqui",
       left = 0,
       top = display.contentHeight + 10,
       width = display.contentWidth,
       height = display.contentHeight,
       onRowTouch = onRowTouch2,
       onRowRender = onRowRender,
       hideScrollBar = false,
       }
     )
     sceneGroup:insert(decEqui)
     decEqui.alpha = 0
     
     local path = system.pathForFile( "charts/DecEqui.txt")
     local file = io.open( path, "r")
     for line in file:lines() do
       decEquiTable[counter] = line
       counter = counter + 1
     end  
     
     for i = 3, 170, 1 do
       local temp = string.find(decEquiTable[i], ".", 1, true)
       decEquiAnswer[i] = string.sub(decEquiTable[i], temp - 1)
     end
     
     for i = 1, 170, 1 do
       
       local isCategory = false
       local rowHeight = display.contentHeight / 6
       local rowColor = { default={ 1, 1, 1 }, over={ 1, 0.5, 0, 0.2 } }
       local lineColor = { 0.15, 0.4, 0.729 }
       
       if ( i == 1 ) then
         isCategory = true
         rowColor = { default={ 0.15, 0.4, 0.729, 0.95 } }
         lineColor = { 1, 0, 0 }
       elseif (i == 2 ) then
         rowColor = { default={ 0.8, 0.885, 1, 0.95 } }
         lineColor = { 0.15, 0.4, 0.729 }
       end       
       
       decEqui:insertRow(
           {
            isCategory = isCategory,
            rowHeight = rowHeight,
            rowColor = rowColor,
            lineColor = lineColor,
            params = { chart = decEquiTable, answer = decEquiAnswer}
           }
         )
     end    
     
     counter = 1
     
    --End Decimal Equivalents
    
    --Start Unified Tapping
    
    uniTap = widget.newTableView(
     {
       id = "uniTap",
       left = 0,
       top = display.contentHeight + 10,
       width = display.contentWidth,
       height = display.contentHeight,
       onRowTouch = onRowTouch2,
       onRowRender = onRowRender,
       hideScrollBar = false,
       }
     )
     sceneGroup:insert(uniTap)
     uniTap.alpha = 0
     
     local path = system.pathForFile( "charts/uniTapDrill.txt")
     local file = io.open( path, "r")
     for line in file:lines() do
       uniTapTable[counter] = line
       counter = counter + 1
     end
     
     for i = 3, 88, 1 do
       local temp = string.find(uniTapTable[i], ".", 1, true)
       uniTapAnswer[i] = string.sub(uniTapTable[i], temp - 1)
     end
     
     for i = 1, 88, 1 do
       
       local isCategory = false
       local rowHeight = display.contentHeight / 6
       local rowColor = { default={ 1, 1, 1 }, over={ 1, 0.5, 0, 0.2 } }
       local lineColor = { 0.15, 0.4, 0.729 }
       
       if ( i == 1 ) then
         isCategory = true
         rowColor = { default={ 0.15, 0.4, 0.729, 0.95 } }
         lineColor = { 1, 0, 0 }
       elseif (i == 2 ) then
         rowColor = { default={ 0.8, 0.885, 1, 0.95 } }
         lineColor = { 0.15, 0.4, 0.729 }
       end       
       
       uniTap:insertRow(
           {
            isCategory = isCategory,
            rowHeight = rowHeight,
            rowColor = rowColor,
            lineColor = lineColor,
            params = { chart = uniTapTable, answer = uniTapAnswer }
           }
         )
     end
   
   
end

-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
   elseif ( phase == "did" ) then
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc.
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
   elseif ( phase == "did" ) then
      
      if isOverlay then isOverlay = false end
      
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