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
local deleteTables

---------------------------------------------------------------------------------
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
        rowAnswerRow = display.newText( { parent = row, text = answer[row.index], x = 0, y = 0, font = "BerlinSansFB-Reg", fontSize = 20} )
        rowAnswerRow:setFillColor(0.757, 0, 0)
        rowAnswerRow.anchorX = 0
        rowAnswerRow.anchorY = 0
        rowAnswerRow.x = 10
        if (row.index > 216) and (row.index < 226) then
          rowAnswerRow.y = rowTitle.contentHeight - 5
        else
          rowAnswerRow.y = rowTitle.y + 20
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
    title[i] = string.sub(title[i], 1, temp - 1)
    temp = string.find(content[i], ":")
    if (math.fmod(i, 2)) == 0 then
      answer[i] = string.sub(content[i], temp - 7)
      content[i] = string.sub(content[i], 1, temp - 10)
    else
      answer[i] = string.sub(content[i], temp - 3)
      content[i] = string.sub(content[i], 1, temp - 6)
    end
  end
end

matchRow = function(length, word)
  
  local length1 = length
  local word1 = word
  
  for i = 3, #matTable, 1 do
    local temp = string.lower(string.sub(matTable[i], 1, length1))
    if temp:lower() == word1:lower() then
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
   
   mask = display.newRect( sceneGroup, 0, 0, display.contentWidth, display.contentHeight)
   mask:setFillColor(1)
   
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
  
  local path = system.pathForFile( "charts/materialsList.txt")
  local file = io.open( path, "r")
  for line in file:lines() do
    matTable[counter] = line
    counter = counter + 1    
  end
    
  finalRows(matTable, matContent, matAnswer)
  
--  for i = 3, #matTable, 1 do
--    local temp = string.find( matTable[i], ",")
--    matContent[i] = string.sub(matTable[i], temp + 2)
--    matTable[i] = string.sub(matTable[i], 1, temp - 1)
--    temp = string.find(matContent[i], ":")
--    if (math.fmod(i, 2)) == 0 then
--      matAnswer[i] = string.sub(matContent[i], temp - 7)
--      matContent[i] = string.sub(matContent[i], 1, temp - 10)
--    else
--      matAnswer[i] = string.sub(matContent[i], temp - 3)
--      matContent[i] = string.sub(matContent[i], 1, temp - 6)
--    end
--  end
    fullRows()
--  for i = 1, #matTable, 1 do
--       
--    local isCategory = false
--    local rowHeight = display.contentHeight / 4 + 15
--    if (i > 201) and (i < 213) then
--      rowHeight = display.contentHeight / 4 + 25
--    end
--    if (i == 321 or i == 322) then
--      rowHeight = display.contentHeight / 4 + 30
--    end
--    if (i == 307 or i == 308) then
--      rowHeight = display.contentHeight / 4 + 42
--    end
--    local rowColor = { default={ 1, 1, 1 }, over={ 1, 0.5, 0, 0.2 } }
--    local lineColor = { 0.15, 0.4, 0.729 }
--           
--    if ( i == 1 ) then
--      isCategory = true
--      rowColor = { default={ 0.15, 0.4, 0.729, 0.95 } }
--      --lineColor = { 1, 0, 0 }
--      rowHeight = display.contentHeight / 6
--    elseif (i == 2 ) then
--      rowColor = { default={ 0.8, 0.885, 1, 0.95 } }
--      lineColor = { 0.15, 0.4, 0.729 }
--      rowHeight = display.contentHeight / 6
--    end       
--       
--    matList:insertRow(
--    {
--      isCategory = isCategory,
--      rowHeight = rowHeight,
--      rowColor = rowColor,
--      lineColor = lineColor,
--      params = { }
--      }
--    )
--  end
  
  mask = display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
  mask:setFillColor(1)
  mask.alpha = 0
  mask:addEventListener("touch", placeHolder)
  mask.isHitTestable = true
   
  searchBox = native.newTextField(display.contentWidth - 110, 30, 200, 30)
  searchBox:addEventListener( "userInput", textListener)
  searchBox.placeholder = "Search"


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