require "SpriteHelper.Helpers.LHHelpers"
require "config"
LHSettings = {}
lh_settings_sharedInstance = nil;
function LHSettings:init()

	local object = {spritesEvents = {},
					enableRetina = true,
					levelDeviceWidth = 480,
					levelDeviceHeight = 320,
					newSpriteCreated = 0,
					batchNodesSizes = {},

					hasCollisionHandlingActive = false,
					beginOrEndCollisionMap = {}, --dictionary
					preCollisionMap = {}, --dictionary
					postCollisionMap = {}, --dictionary
					}
	setmetatable(object, { __index = LHSettings })  -- Inheritance	
	
	lh_settings_sharedInstance = object;
	return object
end
--------------------------------------------------------------------------------
function removeLHSettings()
lh_settings_sharedInstance.spritesEvents = nil;
lh_settings_sharedInstance.enableRetina = nil
lh_settings_sharedInstance.levelDeviceWidth = nil
lh_settings_sharedInstance.levelDeviceHeight = nil;
lh_settings_sharedInstance.newSpritesCreated = nil;
lh_settings_sharedInstance:cancelCollisionHandling()
lh_settings_sharedInstance = nil;
end
--------------------------------------------------------------------------------
function LHSettings:sharedInstance()

	if(lh_settings_sharedInstance == nil) then
		return self:init();
	end
	
	return lh_settings_sharedInstance;
end
--------------------------------------------------------------------------------
function LHSettings:useSpriteHelperCollisionHandling()

	if(self.hasCollisionHandlingActive == false)then
		Runtime:addEventListener( "collision", self);
		Runtime:addEventListener( "postCollision", self );
		Runtime:addEventListener( "preCollision", self );
		self.hasCollisionHandlingActive = true;
	end
end
--------------------------------------------------------------------------------
function LHSettings:cancelCollisionHandling()
	if(self.hasCollisionHandlingActive)then
		self.preCollisionMap = nil;
		self.postCollisionMap = nil;
		self.beginOrEndCollisionMap = nil;

		Runtime:removeEventListener("collision", self)
		Runtime:removeEventListener("postCollision", self)
		Runtime:removeEventListener("preCollision", self)
	end
end
--------------------------------------------------------------------------------
function LHSettings:registerBeginOrEndCollisionCallbackBetweenTags(tagA, tagB, callbackFunction)
	local tableA = self.beginOrEndCollisionMap[tagA];
	if(nil == tableA)then
		local myMap = {}
		myMap[tagB] = callbackFunction;
		self.beginOrEndCollisionMap[tagA] = myMap
	else
		tableA[tagB] = callbackFunction;
	end
end
--------------------------------------------------------------------------------
function LHSettings:cancelBeginOrEndCollisionCallbackBetweenTags(tagA, tagB)
	local callbackA = self.beginOrEndCollisionMap[tagA];
	if(nil ~= callbackA)then
	  	callbackA[tagB] = nil;
	end	
end
--------------------------------------------------------------------------------
function LHSettings:registerPreColisionCallbackBetweenTags(tagA, tagB, callbackFunction)
	local tableA = self.preCollisionMap[tagA];
	if(nil == tableA)then
		local myMap = {}
		myMap[tagB] = callbackFunction;
		self.preCollisionMap[tagA] = myMap
	else
		tableA[tagB] = callbackFunction;
	end
end
--------------------------------------------------------------------------------
function LHSettings:cancelPreCollisionCallbackBetweenTags(tagA, tagB)
	local callbackA = self.preCollisionMap[tagA];
	if(nil ~= callbackA)then
	  	callbackA[tagB] = nil;
	end	
end
--------------------------------------------------------------------------------
function LHSettings:registerPostColisionCallbackBetweenTags(tagA, tagB, callbackFunction)
	local tableA = self.postCollisionMap[tagA];
	if(nil == tableA)then
		local myMap = {}
		myMap[tagB] = callbackFunction;
		self.postCollisionMap[tagA] = myMap
	else
		tableA[tagB] = callbackFunction;
	end
end
--------------------------------------------------------------------------------
function LHSettings:cancelPostCollisionCallbackBetweenTags(tagA, tagB)
	local callbackA = self.postCollisionMap[tagA];
	if(nil ~= callbackA)then
	  	callbackA[tagB] = nil;
	end	
end


local setLevelHelperInfoToCollisionEvent = function(event)
		
 	if(event.spriteA)then
 	
 	  	event.lhFixtureNameA = event.spriteA.lhUniqueName
	  	event.lhFixtureIdA = 0

 		if(event.spriteA.lhFixtures)then
 			for i = 1, #event.spriteA.lhFixtures do
  				local fixture = event.spriteA.lhFixtures[i];	
  				if(fixture)then	
  					if(	event.element1 >= fixture.coronaMinFixtureIdForThisObject and 
 						event.element1 <= fixture.coronaMaxFixtureIdForThisObject)then

					   	event.lhFixtureNameA = fixture.lhFixtureName;
		   				event.lhFixtureIdA = fixture.lhFixtureID;
	   					break;
 					end
 				end
 			end
 		end
 	end

 	if(event.spriteB)then
 	
	 	event.lhFixtureNameB = event.spriteB.lhUniqueName
  		event.lhFixtureIdB = 0

 		if(event.spriteB.lhFixtures)then
 			for i = 1, #event.spriteB.lhFixtures do
  				local fixture = event.spriteB.lhFixtures[i];	
  				if(fixture)then	
  					if(	event.element2 >= fixture.coronaMinFixtureIdForThisObject and 
 						event.element2 <= fixture.coronaMaxFixtureIdForThisObject)then

				   		event.lhFixtureNameB = fixture.lhFixtureName;
	   					event.lhFixtureIdB = fixture.lhFixtureID;
	   					break;
 					end
 				end
 			end
 		end
 	end
end
--------------------------------------------------------------------------------
function LHSettings:collision(event)

	if ( event.phase == "began" ) then	
	
		local foundEvent = false;
		local callbackA = self.beginOrEndCollisionMap[event.object1.lhTag];
		if(nil ~= callbackA)then
	   		if(nil ~= callbackA[event.object2.lhTag])then
		   		foundEvent = true;
		   		event.spriteA = event.object1;
		  		event.spriteB = event.object2;
		   		setLevelHelperInfoToCollisionEvent(event)
		   		callbackA[event.object2.lhTag](event)
	   		end
	   	end

		if(foundEvent == false)then
		   	local callbackB = self.beginOrEndCollisionMap[event.object2.lhTag];
		   	if(nil ~= callbackB)then
	   			if(nil ~= callbackB[event.object1.lhTag])then
		   			event.spriteA = event.object2;
			  		event.spriteB = event.object1;
	   				setLevelHelperInfoToCollisionEvent(event)
					callbackB[event.object1.lhTag](event)
				end
	   		end
	   	end
    elseif ( event.phase == "ended" ) then
    	local foundEvent = false
		local callbackA = self.beginOrEndCollisionMap[event.object1.lhTag];
		if(nil ~= callbackA)then
	   		if(nil ~= callbackA[event.object2.lhTag])then
		   		foundEvent = true;		   	
		   		event.spriteA = event.object1;
			  	event.spriteB = event.object2;	
		   		setLevelHelperInfoToCollisionEvent(event)
	   			callbackA[event.object2.lhTag](event)
	   		end
	   	end

		if(foundEvent == false)then
		   	local callbackB = self.beginOrEndCollisionMap[event.object2.lhTag];
		   	if(nil ~= callbackB)then
	   			if(nil ~= callbackB[event.object1.lhTag])then
		   			event.spriteA = event.object2;
			  		event.spriteB = event.object1;
	   				setLevelHelperInfoToCollisionEvent(event)
	   				callbackB[event.object1.lhTag](event)
	   			end
			end
		end
    end
end
--------------------------------------------------------------------------------
function LHSettings:postCollision(event)

	local foundEvent = false;
	local callbackA = self.postCollisionMap[event.object1.lhTag];
	if(nil ~= callbackA)then
  		if(nil ~= callbackA[event.object2.lhTag])then
	  		foundEvent = true;
	  		event.spriteA = event.object1;
	  		event.spriteB = event.object2;
	  		setLevelHelperInfoToCollisionEvent(event)
 			callbackA[event.object2.lhTag](event)
 		end
	end

	if(foundEvent == false)then
		local callbackB = self.postCollisionMap[event.object2.lhTag];
	   	if(nil ~= callbackB)then
	   		if(nil ~= callbackB[event.object1.lhTag])then
		   		event.spriteA = event.object2;
			  	event.spriteB = event.object1;
		   		setLevelHelperInfoToCollisionEvent(event)
	   			callbackB[event.object1.lhTag](event)
	   		end
		end
	end
end
--------------------------------------------------------------------------------
function LHSettings:preCollision(event)

	local foundEvent = false;
	local callbackA = self.preCollisionMap[event.object1.lhTag];
	if(nil ~= callbackA)then
	  	if(nil ~= callbackA[event.object2.lhTag])then
		  	foundEvent = true;
		  	event.spriteA = event.object1;
		  	event.spriteB = event.object2;
		  	setLevelHelperInfoToCollisionEvent(event)
	   		callbackA[event.object2.lhTag](event)
	   	end
	end

	if(foundEvent == false) then
	   	local callbackB = self.preCollisionMap[event.object2.lhTag];
	   	if(nil ~= callbackB)then
	   		if(nil ~= callbackB[event.object1.lhTag])then
		   		event.spriteA = event.object2;
		  		event.spriteB = event.object1;
		   		setLevelHelperInfoToCollisionEvent(event)
				callbackB[event.object1.lhTag](event)
			end
	   	end	
	end
end




--------------------------------------------------------------------------------
function LHSettings:sizeForImageFile(imageFile)

	local batchSize = self.batchNodesSizes[imageFile];
	
	if(batchSize == nil)then
	
		local findSizeFromThisObject = display.newImage(imageFile, system.ResourceDirectory,  0, 0,  true);
		
		batchSize = {width = findSizeFromThisObject.width, height = findSizeFromThisObject.height};
		self.batchNodesSizes[imageFile] = batchSize;
		findSizeFromThisObject:removeSelf();
	end

	return batchSize;
end


function LHSettings:newSpriteNumber()
	self.newSpriteCreated = self.newSpriteCreated+1;
	return self.newSpriteCreated;
end
--------------------------------------------------------------------------------
function LHSettings:convertRatio()
	return {x = 1.0, y = 1.0}
end
--------------------------------------------------------------------------------
--function LHSettings:correctedImageFileAndTextureRect(imageFile)
--
--	local imagesFolder = "";
--	if(nil ~= application.SpriteHelperSettings.imagesSubfolder)then
--		imagesFolder = application.SpriteHelperSettings.imagesSubfolder;
--		imagesFolder = imagesFolder .. "/"
--	end
--	
--	local rectMultiplier = 1.0;
--	
--	local isIphone1 = false
--	
--	if(system.getInfo("model") == "iPhone" or
--	   system.getInfo("model") == "iPod touch") then
--		if	system.getInfo("architectureInfo") == "iPhone1,1" or
--			system.getInfo("architectureInfo") == "iPhone1,2" or
--			system.getInfo("architectureInfo") == "iPhone2,1" or
--			system.getInfo("architectureInfo") == "iPod1,1" or
--			system.getInfo("architectureInfo") == "iPod2,1" then
--			isIphone1 = true
--		end
--	end
--	
--	
--	if(isIphone1 or
--	   system.getInfo("model") == "myTouch")then
--	   
--	   	local correctFile = imageFile;
--	   	local correctStrWithSubFolder = imagesFolder ..  imageFile;
--	  	if(true == lh_fileExists(correctStrWithSubFolder))then
--			correctFile = correctStrWithSubFolder
--		end
--		
--		return correctFile, rectMultiplier
--	end
--
--	local correctStr = imageFile;
--	local correctStrWithSubFolder = imagesFolder  .. imageFile;
--	
--	local img = string.sub(imageFile, 1, -5)
--	local ext = string.sub(imageFile, -3)
--	
--	if self.enableRetina then
--		correctStr = img .. "-hd" .. "." .. ext;
--		rectMultiplier = 2.0
--		correctStrWithSubFolder = imagesFolder  .. img .. "-hd" .. ".".. ext;
--	end
--
--	local correctFile = correctStr;
--	
--	if(true == lh_fileExists(correctStrWithSubFolder))then
--		correctFile = correctStrWithSubFolder
--	else
--		correctStrWithSubFolder = imagesFolder .. img .. "."..ext;
--		if(true == lh_fileExists(correctStrWithSubFolder))then
--			correctFile = correctStrWithSubFolder
--			rectMultiplier = 1.0
--		else
--			correctFile = correctStrWithSubFolder
--			--if(false == lh_fileExists(correctFile))then
--			--	correctFile = imageFile;
--			--	rectMultiplier = 1.0
--			--end
--		end
--	end
--	
--	return correctFile, rectMultiplier;
--end
----------------------------------------------------------------------------------