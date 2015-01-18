local composer = require( "composer" )
local scene = composer.newScene()
local widget = require ( "widget" )
local myData = require("myData")

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

local chartChoice, decEqui, uniTap, taperTap, isoMetric, goBack2
local back, isOverlay, backEdgeX, backEdgeY
local moveIntro
local choiceTable, decEquiTable, uniTapTable, taperTapTable, isoTable
local decEquiAnswer, uniTapAnswer, taperTapAnswer, isoAnswer
local counter
local menuHidden, topText, showing, topFade, topBox

local menuHide, menuShow, goBack, openDecEqui, openUniTap, openTaperTap, openIso

local function onKeyEvent( event )

  local phase = event.phase
  local keyName = event.keyName
   
  if ( "back" == keyName and phase == "up" ) and not myData.isOverlay then
    if menuHidden then
      timer.performWithDelay(500, menuShow)
      if showing == 1 then
        openDecEqui()
      elseif showing == 2 then
        openUniTap()
      elseif showing == 3 then
        openTaperTap()
      elseif showing == 4 then
        openIso()  
      end
    else
      timer.performWithDelay(100,goBack2,1)
    end
  end
  return true
end

goBack2 = function()

  if (myData.isOverlay) then
    myData.number = "Tap Me"
    composer.hideOverlay("slideUp", 500)
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

local function goTop(event)
  local phase = event.phase
  
  if "ended" == phase then
    if showing == 1 then
      decEqui:scrollToY({ y = 0})
    elseif showing == 2 then
      uniTap:scrollToY({ y = 0})
    elseif showing == 3 then
      taperTap:scrollToY({ y = 0})
    elseif showing == 4 then
      isoTap:scrollToY({ y = 0})
    end
  end
end

local function onRowRender( event )

    -- Get reference to the row group
    local row = event.row
    local chart = event.row.params.chart
    local answer = event.row.params.answer

    -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth

    local rowTitle = display.newText( { parent = row, text = chart[row.index], x = 0, y = 0, font = "BerlinSansFB-Reg", fontSize = 20} )
    if row.index > 2 then
      local rowAnswer = display.newText( { parent = row, text = answer[row.index], x = 0, y = 0, font = "BerlinSansFB-Reg", fontSize = 22} )
      rowAnswer:setFillColor(0.757, 0, 0)
      rowAnswer.anchorX = 0
      rowAnswer.x = rowTitle.contentWidth + 15
      rowAnswer.y = rowHeight * 0.5
    end
    
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
    return true
end

local function onRowRender2( event )

    -- Get reference to the row group
    local row = event.row
    local chart = event.row.params.chart

    -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth

    local rowTitle = display.newText( { parent = row, text = choiceTable[row.index], x = 0, y = 0, font = "BerlinSansFB-Reg", fontSize = 20} )
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
    return true
end

local function onRowTouch( event )
  local phase = event.phase
  local row = event.target
  
  if "press" == phase then
    print(row.index)  
  elseif "release" == phase then
    if row.index == 2 then
      if myData.isOverlay then
        myData.number = "Tap Me"
        composer.hideOverlay(true, "slideRight", 500 )
      else
      timer.performWithDelay(500, goBack)
      transition.to(chartChoice, {x = chartChoice.contentWidth - chartChoice.contentWidth * 2})
      end
    elseif row.index == 3 then
      menuHide()
      timer.performWithDelay(500, openDecEqui)
    elseif row.index == 4 then
      menuHide()
      timer.performWithDelay(500, openUniTap)
    elseif row.index == 5 then
      menuHide()
      timer.performWithDelay(500, openTaperTap)
    elseif row.index == 6 then
      menuHide()
      timer.performWithDelay(500, openIso)
    end
  end
end

local function onRowTouch2( event )
  local phase = event.phase
  local row = event.target
  local answer = event.target.params.answer
  local id = event.target.params.table
  
  if "release" == phase then
    if row.index == 2 then
      timer.performWithDelay(500, menuShow)
      if id == "decEqui" then
        openDecEqui()
      elseif id == "uniTap" then
        openUniTap()
      elseif id == "taperTap" then
        openTaperTap()
      elseif id == "isoTap" then
        openIso()  
      end
    else
      if myData.isOverlay then
        local answer = answer[row.index]
        myData.number = answer
        composer.hideOverlay(true, "slideLeft", 500 )
      end
    end
  end
end


moveIntro = function()
  
  transition.to(chartChoice, {x = chartChoice.contentWidth / 2, time = 500})
  myData.inch = "none"
  
end

openDecEqui = function()
  
  if not menuHidden then
    decEqui.alpha = 0.7
    transition.to(decEqui, {y = display.contentCenterY, time = 500})
    menuHidden = true
    showing = 1
    myData.inch = true
  else
    transition.to(decEqui, {y = display.contentHeight * 2 + 10, time = 500})
    menuHidden = false
  end
end

openUniTap = function()
  
  if not menuHidden then
    uniTap.alpha = 0.7
    transition.to(uniTap, {y = display.contentCenterY, time = 500})
    menuHidden = true
    showing = 2
    myData.inch = true
  else
    transition.to(uniTap, {y = display.contentHeight * 2 + 10, time = 500})
    menuHidden = false
  end
end

openTaperTap = function()
  
  if not menuHidden then
    taperTap.alpha = 0.7
    transition.to(taperTap, {y = display.contentCenterY, time = 500})
    menuHidden = true
    showing = 3
    myData.inch = true
  else
    transition.to(taperTap, {y = display.contentHeight * 2 + 10, time = 500})
    menuHidden = false
  end
end

openIso = function()
  
  if not menuHidden then
    isoTap.alpha = 0.7
    transition.to(isoTap, {y = display.contentCenterY, time = 500})
    menuHidden = true
    showing = 4
    myData.inch = false
  else
    transition.to(isoTap, {y = display.contentHeight * 2 + 10, time = 500})
    menuHidden = false
  end
end

menuHide = function()
  
   transition.to(chartChoice, {x = chartChoice.contentWidth - chartChoice.contentWidth * 2, time = 500})
   transition.fadeIn( topText, {time = 1200})
   transition.fadeIn( topBox, {time = 1200})

end

menuShow = function()
  
   transition.fadeOut( topText, {time = 50})
   transition.fadeOut( topBox, {time = 50})
   transition.to(chartChoice, {x = chartChoice.contentWidth / 2, time = 500})
   myData.inch = "none"

end


goBack = function()
  composer.gotoScene( "menu", { effect="fromBottom", time=800})
end

---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )

   local sceneGroup = self.view
   
  if not myData.isOverlay then
    Runtime:addEventListener( "key", onKeyEvent )
  end
   
   if myData.isOverlay then
     print("true")
   else
     print("false")
   end   
   
   choiceTable = {}
   decEquiTable = {}
   uniTapTable = {}
   taperTapTable = {}
   isoTable = {}
   
   decEquiAnswer = {}
   uniTapAnswer = {}
   taperTapAnswer = {}
   isoAnswer = {}
   
   counter = 1
   
   menuHidden = false
   
  if not myData.isOverlay then
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
  
  chartChoice = widget.newTableView
     {
       left = 0,
       top = 0,
       width = display.contentWidth,
       height = display.contentHeight,
       onRowTouch = onRowTouch,
       onRowRender = onRowRender2,
       hideScrollBar = false,
     }
  sceneGroup:insert(chartChoice)
  chartChoice.alpha = 0
  chartChoice.x = chartChoice.contentWidth - chartChoice.contentWidth * 2
  
  transition.to(chartChoice, {alpha = 0.7, time = 500})

  timer.performWithDelay(300, moveIntro)
  
     
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
       
    chartChoice:insertRow
    {
      isCategory = isCategory,
      rowHeight = rowHeight,
      rowColor = rowColor,
      lineColor = lineColor,
      params = { chart =  choiceTable}
    }
    
  end
     
-- --Start Decimal Equivalents
--     
  decEqui = widget.newTableView
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
    decEquiTable[i] = string.sub(decEquiTable[i], 1, temp - 2 )
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
      params = { chart = decEquiTable, answer = decEquiAnswer, table = "decEqui"}
      }
    )
  end    
     
  counter = 1
--     
--    --End Decimal Equivalents
--    
--    --Start Unified Tapping
--    
     uniTap = widget.newTableView
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
     sceneGroup:insert(uniTap)
     uniTap.alpha = 0
     
     local path = system.pathForFile( "charts/uniTapDrill.txt")
     local file = io.open( path, "r")
     for line in file:lines() do
       uniTapTable[counter] = line
       counter = counter + 1
     end
     
     for i = 3, 88, 1 do
       --local temp = string.find(uniTapTable[i], ".", 1, true)
       local temp = string.len( uniTapTable[i])
       uniTapAnswer[i] = string.sub(uniTapTable[i], temp - 6)
       uniTapTable[i] = string.sub(uniTapTable[i], 1, temp - 7 )
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
            params = { chart = uniTapTable, answer = uniTapAnswer, table = "uniTap" }
           }
         )
     end
     
     counter = 1
--     
--   --end unified tap
--   --start taper tap
--   
   taperTap = widget.newTableView
     {
       id = "taperTap",
       left = 0,
       top = display.contentHeight + 10,
       width = display.contentWidth,
       height = display.contentHeight,
       onRowTouch = onRowTouch2,
       onRowRender = onRowRender,
       hideScrollBar = false,
       }
     sceneGroup:insert(taperTap)
     taperTap.alpha = 0
     
     local path = system.pathForFile( "charts/taperPipeTap.txt")
     local file = io.open( path, "r")
     for line in file:lines() do
       taperTapTable[counter] = line
       counter = counter + 1
     end
     
     for i = 3, 14, 1 do
       --local temp = string.find(taperTapTable[i], ".", 1, true)
       local temp = string.len( taperTapTable[i])
       taperTapAnswer[i] = string.sub(taperTapTable[i], temp - 6)
       taperTapTable[i] = string.sub(taperTapTable[i], 1, temp - 7 )
     end
     
     for i = 1, 14, 1 do
       
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
       
       taperTap:insertRow(
           {
            isCategory = isCategory,
            rowHeight = rowHeight,
            rowColor = rowColor,
            lineColor = lineColor,
            params = { chart = taperTapTable, answer = taperTapAnswer, table = "taperTap" }
           }
         )
     end
     
     counter = 1
--     
--     --end Taper Tap
--     --Start ISO Metric
     
     isoTap = widget.newTableView
     {
       id = "taperTap",
       left = 0,
       top = display.contentHeight + 10,
       width = display.contentWidth,
       height = display.contentHeight,
       onRowTouch = onRowTouch2,
       onRowRender = onRowRender,
       hideScrollBar = false,
       }
     sceneGroup:insert(isoTap)
     isoTap.alpha = 0
     
     local path = system.pathForFile( "charts/ISOMetricTap.txt")
     local file = io.open( path, "r")
     for line in file:lines() do
       isoTable[counter] = line
       counter = counter + 1
     end
     
     for i = 3, 93, 1 do
       local temp = string.len( isoTable[i])
       isoAnswer[i] = string.sub(isoTable[i], temp - 5)
       isoTable[i] = string.sub(isoTable[i], 1, temp - 6 )
     end
     
     for i = 1, 93, 1 do
       
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
       
       isoTap:insertRow(
           {
            isCategory = isCategory,
            rowHeight = rowHeight,
            rowColor = rowColor,
            lineColor = lineColor,
            params = { chart = isoTable, answer = isoAnswer, table = "isoTap" }
           }
         )
     end
   
   
   topText = display.newText( { parent = sceneGroup, text = "TOP", x = display.contentWidth - 35, y = 25, font = "BerlinSansFB-Reg", fontSize = 20} )
   topText:setFillColor(1, 0.7)
   topText:addEventListener("touch", goTop)
   topText.alpha = 0
   
   topBox = display.newRect(sceneGroup, 0, 0, topText.contentWidth + 5, topText.contentHeight + 5)
   topBox:setFillColor(1, 0)
   topBox.stroke = {1, 0.7}
   topBox.strokeWidth = 2
   topBox.x = topText.x - 1
   topBox.y = topText.y
   topBox.alpha = 0

   
end

-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
   elseif ( phase == "did" ) then
     composer.removeScene( "menu", true)
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc.
   end
end

-- "scene:hide()"
function scene:hide( event )

   local sceneGroup = self.view
   local phase = event.phase
   local parent = event.parent
   
   if ( phase == "will" ) then
     if not myData.isOverlay then
      Runtime:removeEventListener( "key", onKeyEvent )
     end
     
      if myData.isOverlay then
        parent:switch2()
      end
            
   elseif ( phase == "did" ) then
      
      
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