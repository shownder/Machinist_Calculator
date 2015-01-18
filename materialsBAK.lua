local composer = require( "composer" )
local scene = composer.newScene()
local widget = require ( "widget" )
local myData = require("myData")
display.setStatusBar(display.HiddenStatusBar)

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

local matTable, matContent, matAnswer, matList
local counter, goNext, counter2
local searchBox, mask, placeHolder
local finalRows, matchRow, fullRows, fullRows2
local matTable2, matContent2, matAnswer2
local deleteTables, back, topText, topBox
local goBack2

---------------------------------------------------------------------------------
local function onKeyEvent( event )

  local phase = event.phase
  local keyName = event.keyName
   
  if ( "back" == keyName and phase == "up" ) and not myData.isOverlay then
    timer.performWithDelay(100,goBack2,1)
  end
  return true
end

local function goTop(event)
  local phase = event.phase
  
  if "ended" == phase then
    matList:scrollToY({ y = 0})  
  end
end

goBack2 = function()

  local effect1
  if myData.isOverlay then
    effect1 = "fromBottom"
  else
    effect1 = "slideUp"
  end
  
	composer.gotoScene( "menu", { effect=effect1, time=800})
		
end

local function placeHolder(event)
  local phase = event.phase
  
  if "began" == phase then
   native.setKeyboardFocus(nil)
   mask.isHitTestable = false
  end
end

local function textListener(event)
  local phase = event.phase
  
  if "began" == phase then
    mask.isHitTestable = true
  elseif "ended" == phase or "submitted" == phase then
    native.setKeyboardFocus(nil)
  elseif "editing" == phase then
    local tempLen = string.len(event.text)
    if tempLen > 0 then
      local length = string.len(event.text)
      local word = event.text
      
      deleteTables()
    
      matchRow(length, word)
      
      if #matTable2 > 2 then    
        matList:deleteAllRows()
        fullRows2()
      else
        matList:deleteAllRows()
        fullRows2()
      end
    else
      matList:deleteAllRows()
      fullRows()
    end
        
  end
end

local function onRowTouch( event )
  local phase = event.phase
  local row = event.target
  
  if "press" == phase then

  elseif "release" == phase then
    if row.index == 2 then
     if myData.isOverlay then
       myData.number = "Tap Me"
       composer.hideOverlay(true, "slideUp", 500 )
     else
        timer.performWithDelay(100, goBack2)
      end
    else
      if myData.isOverlay then
        if string.len(searchBox.text) > 0 then
          local temp = string.find(matAnswer2[row.index], "%d")
          myData.number = string.sub(matAnswer2[row.index], temp)
        else
          local temp = string.find(matAnswer[row.index], "%d")
          myData.number = string.sub(matAnswer[row.index], temp)
        end
      end
      composer.hideOverlay(true, "slideUp", 500 )
    end
  end
end

local function onRowRender( event )

    -- Get reference to the row group
    local row = event.row
    local chart = event.row.params.chart
    local title = event.row.params.title
    local content = event.row.params.content
    local answer = event.row.params.answer

    -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth
    local rowContentRow, rowAnswerRow, rowTitle

    
    if row.index < 3 then
      rowTitle = display.newText( { parent = row, text = title[row.index], x = 0, y = 0, font = "BerlinSansFB-Reg", fontSize = 24} )
      rowTitle:setFillColor(0.15, 0.4, 0.729)
      rowTitle.anchorX = 0
      rowTitle.x = 10
      rowTitle.y = row.contentHeight / 2 - 15
      if row.index == 1 then
        rowTitle:setFillColor( 1 )
      elseif row.index == 2 then
        rowTitle:setFillColor( 0.15, 0.4, 0.729 )
      end
    end
    
    if row.index > 2 then
        rowTitle = display.newText( { parent = row, text = title[row.index], x = 0, y = 0, width = display.contentWidth - 10, font = "BerlinSansFB-Reg", fontSize = 20} )
        rowTitle:setFillColor(0.15, 0.4, 0.729)
        rowTitle.anchorX = 0
        rowTitle.anchorY = 0
        rowTitle.x = 10
        rowTitle.y = 0
        if row.index == 1 then
          rowTitle:setFillColor( 1 )
        elseif row.index == 2 then
          rowTitle:setFillColor( 0.15, 0.4, 0.729 )
        end
    end    
    
    if row.index > 2 then
      local temp = string.find(answer[row.index], "%s")
      temp = string.sub(answer[row.index], temp + 1)
      temp = math.round((temp / 3.2808) * math.pow(10, 2)) / math.pow(10, 2)
        rowAnswerRow = display.newText( { parent = row, text = answer[row.index], x = 0, y = 0, font = "BerlinSansFB-Reg", fontSize = 20} )
        local display1 = display.newText( { parent = row, text = "ft/min", x = 0, y = 0, font = "BerlinSansFB-Reg", fontSize = 16} )
        local display2 = display.newText( { parent = row, text = temp, x = 0, y = 0, font = "BerlinSansFB-Reg", fontSize = 20} )
        local display3 = display.newText( { parent = row, text = "meters/min", x = 0, y = 0, font = "BerlinSansFB-Reg", fontSize = 16} )
        rowAnswerRow:setFillColor(0.757, 0, 0)
        display1:setFillColor(0.757, 0, 0, 0.8)
        display2:setFillColor(0.757, 0, 0)
        display3:setFillColor(0.757, 0, 0, 0.8)
        rowAnswerRow.anchorX = 1
        display1.anchorX = 1
        display2.anchorX = 1
        display3.anchorX = 1
        rowAnswerRow.anchorY = 0
        display1.anchorY = 0
        display2.anchorY = 0
        display3.anchorY = 0
        rowAnswerRow.x = rowAnswerRow.contentWidth + 10
        display1.x = rowAnswerRow.contentWidth + display1.contentWidth + 10
        display2.x = rowAnswerRow.contentWidth + display1.contentWidth + display2.contentWidth + 10
        display3.x = rowAnswerRow.contentWidth + display1.contentWidth + display2.contentWidth + display3.contentWidth + 10
        if rowTitle.contentHeight > 20 then
          rowAnswerRow.y = rowTitle.contentHeight - 5
          display1.y = rowTitle.contentHeight - 5
          display2.y = rowTitle.contentHeight - 5
          display3.y = rowTitle.contentHeight - 5
        else
          rowAnswerRow.y = rowTitle.y + 20
          display1.y = rowTitle.y + 20
          display2.y = rowTitle.y + 20
          display3.y = rowTitle.y + 20
        end
        
        rowContentRow = display.newText( { parent = row, text = content[row.index], x = 0, y = 0, width = display.contentWidth - 10, font = "BerlinSansFB-Reg", fontSize = 16} )
        rowContentRow:setFillColor(0)
        rowContentRow.anchorX = 0
        rowContentRow.anchorY = 0
        rowContentRow.y = rowAnswerRow.y + 20
        rowContentRow.x = 10
    end
            
    return true
end

finalRows = function(title, content, answer)
  
  for i = 3, #title, 1 do
    local temp = string.find( title[i], ",")
    content[i] = string.sub(title[i], temp + 2)
    title[i] = string.sub(title[i], 1, temp - 1) .. " "
    temp = string.find(content[i], ":")
    if (math.fmod(i, 2)) == 0 then
      answer[i] = string.sub(content[i], temp - 7)
      --local temp = string.find(answer[i], "%s")
--      temp = string.sub(answer[i], temp + 1)
--      answer[i] = answer[i] .. " ft/min" .. " - " .. " " .. math.round((temp / 3.2808) * math.pow(10, 2)) / math.pow(10, 2) .. " meters/min"
      content[i] = string.sub(content[i], 1, temp - 10)
    else
      answer[i] = string.sub(content[i], temp - 3)
      local temp = string.find(answer[i], "%s")
      --temp = string.sub(answer[i], temp + 1)
--      answer[i] = answer[i] .. " ft/min" .. " - " .. " " .. math.round((temp / 3.2808) * math.pow(10, 2)) / math.pow(10, 2) .. " meters/min"
      content[i] = string.sub(content[i], 1, temp - 6)
    end
  end
end

matchRow = function(length, word)
  
  local length1 = length
  local word1 = word
  
  if word1 == "aluminum" then
      word1 = "aluminium"
      length1 = length1 + 1
    elseif word1 == "aluminu" then
      word1 = "aluminiu"
      length1 = length1 + 1
    end
    
  for i = 3, #matTable, 1 do
    local pos1, pos2, pos3, pos4, pos5, pos6, pos7
          
    local title1 = ""
    local title2 = ""
    local title3 = ""
    local title4 = ""
    local title5 = ""
    local title6 = ""
    local title7 = ""
    pos1 = string.find(matTable[i], "%s")
    if pos1 then
      title1 = string.sub(matTable[i], 1, pos1 - 1)
      pos2 = string.find(matTable[i], " ", pos1 + 1)
    end
  
    if pos2 then
      title2 = string.sub(matTable[i], pos1 + 1, pos2 - 1)
      pos3 = string.find(matTable[i], "%s", pos2 + 1)
    end
    
    if pos3 then
      title3 = string.sub(matTable[i], pos2 + 1, pos3 - 1)
      pos4 = string.find(matTable[i], "%s", pos3 + 1)
    end
    
    if pos4 then
      title4 = string.sub(matTable[i], pos3 + 1, pos4 - 1)
      pos5 = string.find(matTable[i], "%s", pos4 + 1)
    end
    
    if pos5 then
      title5 = string.sub(matTable[i], pos4 + 1, pos5 - 1)
      pos6 = string.find(matTable[i], "%s", pos5 + 1)
    end
    
    if pos6 then
      title6 = string.sub(matTable[i], pos5 + 1, pos6 - 1)
      pos7 = string.find(matTable[i], "%s", pos6 + 1)
    end
    
    if pos7 then
      title7 = string.sub(matTable[i], pos6 + 1, pos7 - 1)
    end
    
    local tempWord = string.lower(string.sub(matTable[i], 1, length1))
    local temp2 = string.lower(string.sub(title2, 1, length1))
    local temp3 = string.lower(string.sub(title3, 1, length1))
    local temp4 = string.lower(string.sub(title4, 1, length1))
    local temp5 = string.lower(string.sub(title5, 1, length1))
    local temp6 = string.lower(string.sub(title6, 1, length1))
    local temp7 = string.lower(string.sub(title7, 1, length1))
    if (tempWord:lower() == word1:lower()) or (temp2:lower() == word1:lower()) or (temp3:lower() == word1:lower()) or (temp4:lower() == word1:lower()) or (temp5:lower() == word1:lower()) or (temp6:lower() == word1:lower()) or (temp7:lower() == word1:lower()) then
      table.insert( matTable2, matTable[i])
      table.insert( matContent2, matContent[i])
      table.insert( matAnswer2, matAnswer[i])
    end
  end
end

fullRows = function()
  
    for i = 1, #matTable, 1 do
       
    local isCategory = false
    local rowHeight = display.contentHeight / 4 + 15
    if (i > 201) and (i < 213) then
      rowHeight = display.contentHeight / 4 + 25
    end
    if (i == 321 or i == 322) then
      rowHeight = display.contentHeight / 4 + 30
    end
    if (i == 307 or i == 308) then
      rowHeight = display.contentHeight / 4 + 42
    end
    local rowColor = { default={ 1, 1, 1 }, over={ 1, 0.5, 0, 0.2 } }
    local lineColor = { 0.15, 0.4, 0.729 }
           
    if ( i == 1 ) then
      isCategory = true
      rowColor = { default={ 0.15, 0.4, 0.729, 0.95 } }
      --lineColor = { 1, 0, 0 }
      rowHeight = display.contentHeight / 6
    elseif (i == 2 ) then
      rowColor = { default={ 0.8, 0.885, 1, 0.95 } }
      lineColor = { 0.15, 0.4, 0.729 }
      rowHeight = display.contentHeight / 6
    end       
       
    matList:insertRow(
    {
      isCategory = isCategory,
      rowHeight = rowHeight,
      rowColor = rowColor,
      lineColor = lineColor,
      params = { title = matTable, content = matContent, answer = matAnswer }
      }
    )
  end
end

fullRows2 = function()
  
    for i = 1, #matTable2, 1 do
       
    local isCategory = false
    local rowHeight = display.contentHeight / 4 + 15
    if (i > 201) and (i < 213) then
      rowHeight = display.contentHeight / 4 + 25
    end
    if (i == 321 or i == 322) then
      rowHeight = display.contentHeight / 4 + 30
    end
    if (i == 307 or i == 308) then
      rowHeight = display.contentHeight / 4 + 42
    end
    local rowColor = { default={ 1, 1, 1 }, over={ 1, 0.5, 0, 0.2 } }
    local lineColor = { 0.15, 0.4, 0.729 }
           
    if ( i == 1 ) then
      isCategory = true
      rowColor = { default={ 0.15, 0.4, 0.729, 0.95 } }
      --lineColor = { 1, 0, 0 }
      rowHeight = display.contentHeight / 6
    elseif (i == 2 ) then
      rowColor = { default={ 0.8, 0.885, 1, 0.95 } }
      lineColor = { 0.15, 0.4, 0.729 }
      rowHeight = display.contentHeight / 6
    end       
       
    matList:insertRow(
    {
      isCategory = isCategory,
      rowHeight = rowHeight,
      rowColor = rowColor,
      lineColor = lineColor,
      params = { title = matTable2, content = matContent2, answer = matAnswer2 }
      }
    )
  end
end

deleteTables = function()
  
  for i = 3, #matTable2, 1 do
    matTable2[i] = nil
  end
  
  for i = 1, #matContent, 1 do
    matContent2[i] = nil
    matAnswer2[i] = nil
  end
  
  matContent2[1] = " "
  matContent2[2] = " "
  matAnswer2[1] = " "
  matAnswer2[2] = " "
end

-- "scene:create()"
function scene:create( event )

   local sceneGroup = self.view
   
  if not myData.isOverlay then
    Runtime:addEventListener( "key", onKeyEvent )
  end
     
   matTable = {}
   matContent = {}
   matAnswer = {}
   
   matTable2 = {}
   matContent2 = {}
   matAnswer2 = {}
   
   counter = 1
   counter2 = 1
   goNext = true
   
   matTable2[1] = "MATERIALS"
   matTable2[2] = "BACK"
   matContent2[1] = " "
   matContent2[2] = " "
   matAnswer2[1] = " "
   matAnswer2[2] = " "
   
   if not myData.isOverlay then
    back = display.newImageRect( sceneGroup, "backgrounds/background.png", 570, 360 )
    back.x = display.contentCenterX
    back.y = display.contentCenterY
    backEdgeX = back.contentBounds.xMin
    backEdgeY = back.contentBounds.yMin
  end
   
   matList = widget.newTableView
     {
       left = 0,
       top = 0,
       width = display.contentWidth,
       height = display.contentHeight,
       onRowTouch = onRowTouch,
       onRowRender = onRowRender,
       hideScrollBar = false,
     }
  sceneGroup:insert(matList)
  matList.alpha = 0.7
  
  local path = system.pathForFile( "charts/materialsList.txt")
  local file = io.open( path, "r")
  for line in file:lines() do
    matTable[counter] = line
    counter = counter + 1    
  end
    
  finalRows(matTable, matContent, matAnswer)
  
  fullRows()
  
  mask = display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
  mask:setFillColor(1)
  mask.alpha = 0
  mask:addEventListener("touch", placeHolder)
  mask.isHitTestable = true
   
  searchBox = native.newTextField(display.contentWidth - 110, 30, 200, 30)
  searchBox:addEventListener( "userInput", textListener)
  searchBox.placeholder = "Search by name..."
  searchBox.alpha = 0
  
  topText = display.newText( { parent = sceneGroup, text = "TOP", x = display.contentWidth - (searchBox.contentWidth + 40), y = 25, font = "BerlinSansFB-Reg", fontSize = 20} )
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


   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end

-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
   elseif ( phase == "did" ) then
     composer.removeScene( "menu", true)
     transition.to(searchBox, {alpha = 1, time = 300})
     transition.to(topText, {alpha = 1, time = 300})
     transition.to(topBox, {alpha = 1, time = 300})
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
      parent:switch()
     end
      searchBox:removeSelf()      
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