require "SpriteHelper.Helpers.LHHelpers"
require "SpriteHelper.Nodes.LHSettings"
require "SpriteHelper.Nodes.LHAnimationNode"
require "SpriteHelper.Nodes.SHDocumentLoader"
require "SpriteHelper.Nodes.LHFixture"

require "SpriteHelper.Nodes.LHAnimationNode"
--------------------------------------------------------------------------------
--forward declaration of local functions
local createAnimatedSpriteFromDictioary; 
local createSingleSpriteFromTextureDictionary;
local createPhysicObjectForSprite;
local recreatePhysicObjectForSprite; --in case scale is issued
local setTexturePropertiesOnSprite;

local untitledSpritesCount = 0;

local LHSprite = {}
function LHSprite.spriteWithDictionary(selfSprite, spriteInfo) --returns a display object

	texDict = spriteInfo:dictForKey("TextureProperties");	
	
	local coronaSprite = createAnimatedSpriteFromDictioary(spriteInfo)
	
	if(coronaSprite == nil) then
		coronaSprite = createSingleSpriteFromTextureDictionary(texDict, spriteInfo);
	end
	if(coronaSprite == nil)then
		return nil;
	end
	
	setTexturePropertiesOnSprite(coronaSprite, texDict);	
	
	--LevelHelper sprite properties assigned to a Corona sprite
	----------------------------------------------------------------------------
	
	if(spriteInfo:objectForKey("SHSceneName"))then	
		coronaSprite.shSceneName = spriteInfo:stringForKey("SHSceneName")
	end
	
	if(spriteInfo:objectForKey("SHSheetName"))then	
		coronaSprite.shSheetName = spriteInfo:stringForKey("SHSheetName");
	end
	if(spriteInfo:objectForKey("SHSpriteName"))then
		coronaSprite.shSpriteName= spriteInfo:stringForKey("SHSpriteName");	
	end
	
	if(spriteInfo:objectForKey("UniqueName"))then
		coronaSprite.lhUniqueName = spriteInfo:stringForKey("UniqueName");		
	else
		coronaSprite.lhUniqueName = "UntitledSprite_" .. tostring(untitledSpritesCount);
		untitledSpritesCount = untitledSpritesCount + 1;
	end
	
	coronaSprite.lhZOrder = texDict:intForKey("ZOrder");
	coronaSprite.lhTag = texDict:intForKey("Tag");
	coronaSprite.lhAttachedJoint = {}
	coronaSprite.lhFixtures = nil
	coronaSprite.lhNodeType = "LHSprite"

	--overloaded functions
	----------------------------------------------------------------------------
	coronaSprite.originalCoronaRemoveSelf 	= coronaSprite.removeSelf;
	coronaSprite.removeSelf 				= sprite_removeSelf;
	----------------------------------------------------------------------------
	
	--LevelHelper functions - transformations
	----------------------------------------------------------------------------
	coronaSprite.transformScaleX 		= transformScaleX;
	coronaSprite.transformScaleY 		= transformScaleY;
	coronaSprite.transformScale 		= transformScale;
	
	coronaSprite.removeBodyFromWorld    = removeBodyFromWorld;
	--LevelHelper functions	- animations
	----------------------------------------------------------------------------
	coronaSprite.prepareAnimationNamed 	= prepareAnimationNamed;
	coronaSprite.playAnimation 			= playAnimation;
	coronaSprite.pauseAnimation 		= pauseAnimation;
	coronaSprite.currentAnimationFrame 	= currentAnimationFrame;
	coronaSprite.setAnimationFrame 		= setAnimationFrame;
	coronaSprite.restartAnimation 		= restartAnimation;
	coronaSprite.isAnimationPaused		= isAnimationPaused
	coronaSprite.animationName			= animationName
	coronaSprite.numberOfFrames			= numberOfFrames
	coronaSprite.nextFrame				= nextFrame
	coronaSprite.prevFrame 				= prevFrame
	coronaSprite.nextFrameAndRepeat 	= nextFrameAndRepeat
	coronaSprite.prevFrameAndRepeat 	= prevFrameAndRepeat
	coronaSprite.isAnimationAtLastFrame = isAnimationAtLastFrame;
		
	----------------------------------------------------------------------------
	----------------------------------------------------------------------------
	createPhysicObjectForSprite(coronaSprite, spriteInfo);
	
	
--	if(coronaSprite.lhActiveAnimNode) then	
--		Runtime:addEventListener( "enterFrame", coronaSprite )
--		coronaSprite.oldEnterFrame = coronaSprite.enterFrame;
--		coronaSprite.enterFrame = lhSpriteEnterFrame
--	end

	
	if(coronaSprite.lhActiveAnimNode and coronaSprite.lhActiveAnimNode.lhAnimAtStart)then
		Runtime:addEventListener( "enterFrame", coronaSprite.lhActiveAnimNode )
		coronaSprite:playAnimation();
	end
	
	return coronaSprite;
end
--------------------------------------------------------------------------------
--function lhSpriteEnterFrame(selfSprite, event )
--
--	print("sprite enter frame");
--	
--	if(selfSprite.lhActiveAnimNode)then
--		selfSprite.lhActiveAnimNode:enterFrame(event)
--	end
--
--	if(selfSprite.oldEnterFrame)then
--		selfSprite.oldEnterFrame()
--	end
--end
--------------------------------------------------------------------------------
function sprite_removeSelf(selfSprite)
--	print("calling LHSprite removeSelf ");
	--remove all properties of this sprite here
	
--	Runtime:removeEventListener( "enterFrame", selfSprite )
	
	if(selfSprite.lhAnimationNodes)then --maybe the sprite does not have animations
		for i=1, #selfSprite.lhAnimationNodes do
			local node = selfSprite.lhAnimationNodes[i];
			if(node ~= nil)then
				node:removeSelf();
			end
			node = nil
			selfSprite.lhAnimationNodes[i] = nil
		end
	end
	selfSprite.lhAnimationNodes = nil;

		
	selfSprite.lhScaleHeight = nil
	selfSprite.lhScaleWidth = nil;
	selfSprite.lhUniqueName = nil;
	selfSprite.shSceneName = nil;
	selfSprite.shSheetName = nil;
	selfSprite.lhNodeType = nil;
	selfSprite.shSpriteName = nil;

	if(selfSprite.lhFixtures)then --it may be that sprite has no physics 
		for i = 1, #selfSprite.lhFixtures do
			selfSprite.lhFixtures[i]:removeSelf()
			selfSprite.lhFixtures[i] = nil;
		end
		selfSprite.lhFixtures = nil;
	end
		
	selfSprite:originalCoronaRemoveSelf();
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--Tranformation methods
function transformScaleX(selfSprite, newScaleX)
	selfSprite.xScale = newScaleX;
	recreatePhysicObjectForSprite(selfSprite, selfSprite.lhPhysicalInfo);
end
function transformScaleY(selfSprite, newScaleY)
	selfSprite.yScale = newScaleY;
	recreatePhysicObjectForSprite(selfSprite, selfSprite.lhPhysicalInfo);
end
function transformScale(selfSprite, newScale)
	selfSprite.xScale = newScale;
	selfSprite.yScale = newScale;
	recreatePhysicObjectForSprite(selfSprite, selfSprite.lhPhysicalInfo);
end

function removeBodyFromWorld(selfSprite)

	if(selfSprite.lhFixtures~= nil)then --it may be that sprite has no physics 
		physics.removeBody(selfSprite);
		for i = 1, #selfSprite.lhFixtures do
			selfSprite.lhFixtures[i]:removeSelf()
			selfSprite.lhFixtures[i] = nil;
		end
		selfSprite.lhFixtures = nil;
	end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--ANIMATION METHODS
function prepareAnimationNamed(selfSprite, animName) --this overloads setSequence()

	if(selfSprite.lhActiveAnimNode ~= nil)then
		Runtime:removeEventListener( "enterFrame", selfSprite.lhActiveAnimNode )
	end
	
	selfSprite.lhActiveAnimNode = nil;
	if(selfSprite.lhAnimationNodes)then
		for i=1, #selfSprite.lhAnimationNodes do
			local node = selfSprite.lhAnimationNodes[i];
			if(node.lhUniqueName == animName)then
				selfSprite.lhActiveAnimNode = node;
				selfSprite:setSequence(animName);	
				
				selfSprite.lhActiveAnimNode.paused = true;
				Runtime:addEventListener( "enterFrame", selfSprite.lhActiveAnimNode )
			
				return;
			end
		end
	end
end
--------------------------------------------------------------------------------
function playAnimation(selfSprite) --this overloads play()
	if(selfSprite.lhActiveAnimNode)then
		selfSprite.lhActiveAnimNode.paused = false;
	end
end
--------------------------------------------------------------------------------
function pauseAnimation(selfSprite) --this overloads pause()
	selfSprite:pause();
	if(selfSprite.lhActiveAnimNode)then
		selfSprite.lhActiveAnimNode.paused = true;
	end
end
--------------------------------------------------------------------------------
function currentAnimationFrame(selfSprite) --this overloads currentFrame()
	if(selfSprite.lhActiveAnimNode)then
		return selfSprite.lhActiveAnimNode.currentFrame;
	end
	return -1;
end
--------------------------------------------------------------------------------
function restartAnimation(selfSprite)
	selfSprite:setAnimationFrame(1);
	selfSprite:playAnimation();
end
--------------------------------------------------------------------------------
function isAnimationPaused(selfSprite)
	if(selfSprite.lhActiveAnimNode)then
		return selfSprite.lhActiveAnimNode.paused;
	end
	return true;
end
--------------------------------------------------------------------------------
function animationName(selfSprite)
	if(selfSprite.lhActiveAnimNode)then
		return selfSprite.lhActiveAnimNode.lhUniqueName;
	end
	return ""
end
--------------------------------------------------------------------------------
function numberOfFrames(selfSprite)
	if(selfSprite.lhActiveAnimNode)then
		return #selfSprite.lhActiveAnimNode.lhFrames;
	end
	return 0;
end
--------------------------------------------------------------------------------
function setAnimationFrame(selfSprite, frmNo)
	
	if(selfSprite.lhActiveAnimNode)then
		if(frmNo > 0 and frmNo <=  selfSprite:numberOfFrames())then
			selfSprite.lhActiveAnimNode.currentFrame = frmNo;
		end
	end
end
--------------------------------------------------------------------------------
function setNextFrame(selfSprite)
	selfSprite:setAnimationFrame(selfSprite:currentAnimationFrame()+1)
end
--------------------------------------------------------------------------------
function setPreviousFrame(selfSprite)
	selfSprite:setAnimationFrame(selfSprite:currentAnimationFrame()-1)
end
--------------------------------------------------------------------------------
function setNextFrameAndLoop(selfSprite)
	
	if(selfSprite.lhActiveAnimNode)then
		local nextFrm = selfSprite:currentAnimationFrame()+1;
		
		if(nextFrm > selfSprite:numberOfFrames())then
			nextFrm = 1;
		end
		selfSprite:setAnimationFrame(nextFrm);
	end
end
--------------------------------------------------------------------------------
function setPreviousFrameAndLoop(selfSprite)

	if(selfSprite.lhActiveAnimNode)then
		local prevFrm = selfSprite:currentAnimationFrame()-1;
		
		if(prevFrm <= 0)then
			prevFrm = selfSprite:numberOfFrames();
		end
		selfSprite:setAnimationFrame(prevFrm);
	end


end
--------------------------------------------------------------------------------
function isAnimationAtLastFrame(selfSprite)
	if(selfSprite:numberOfFrames() == selfSprite:currentAnimationFrame())then
		return true;
	end
	return false;
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--PRIVATE METHODS - USER SHOULD NOT CARE ABOUT THIS METHODS
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
createSingleSpriteFromTextureDictionary = function(texDict, spriteInfo)

	local spr_uvRect = texDict:rectForKey("Frame");
	
	local spriteName = spriteInfo:stringForKey("SHSpriteName");
	local sheetName = spriteInfo:stringForKey("SHSheetName");
	local sceneName = spriteInfo:stringForKey("SHSceneName");

	local shTexDict = texDict;
    if(nil == spriteInfo:objectForKey("IsSHSprite"))then--we may be loading directly from a sh dictionary
    
        local shDict = SHDocumentLoader:sharedInstance():dictionaryForSpriteNamed(	spriteName,
        																			sheetName,
	        																		sceneName)
        
        if(shDict)then
       		shTexDict = shDict:dictForKey("TextureProperties");
       		
       		spr_uvRect = shTexDict:rectForKey("Frame");
        end
    end
    
    

	local imageFile = imageFileWithFolder(spriteInfo:stringForKey("SheetImage"));

	local options = SHDocumentLoader:sharedInstance():sheetOptionsForSheetInDocument(sheetName, 
																					sceneName)
	
	local spriteIdx = 1;
	
	for i= 1, #options.frames do
		local optionName = options.frames[i].spriteName;	
		if(spriteName == optionName)then
			spriteIdx = i;
			break;
		end
	end
			
	local imageSheet = graphics.newImageSheet( imageFile, options )		
	return display.newImage( imageSheet, spriteIdx)
end
--------------------------------------------------------------------------------
createAnimatedSpriteFromDictioary = function(spriteInfo)

	if(spriteInfo == nil)then
		return nil
	end

	local sprAnimInfo = spriteInfo:dictForKey("AnimationsProperties");

	if(sprAnimInfo == nil)then
		return nil;
	end
	
	local otherAnimationsInfo =	sprAnimInfo:arrayForKey("OtherAnimations");

	if(nil == sprAnimInfo:objectForKey("UniqueName"))then 
		return nil;
	end

	local shSceneName = spriteInfo:stringForKey("SHSceneName");
    local animDict = SHDocumentLoader:sharedInstance():dictionaryForAnimationNamed(sprAnimInfo:stringForKey("UniqueName"), 
																				   shSceneName);

	local animNode = LHAnimationNode:animationWithDictionary(animDict);
	if(animNode == nil)then
	return nil
	end
	
	--now set anim properties from the settings inside the level file
	animNode.lhRepetitions = sprAnimInfo:intForKey("Repetitions")
	animNode.lhLoop = sprAnimInfo:boolForKey("Loop")
	animNode.lhRestoreOriginalFrame = sprAnimInfo:boolForKey("RestoreOriginalFrame")
	animNode.lhDelayPerUnit = sprAnimInfo:floatForKey("DelayPerUnit")
	animNode.lhAnimAtStart = sprAnimInfo:boolForKey("StartAtLaunch")
				
	local imageFile = imageFileWithFolder(animNode.lhSheetImage);
	local options = SHDocumentLoader:sharedInstance():sheetOptionsForSheetInDocument(animNode.lhSheetName, 
																					shSceneName)
		
	----------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------
	
	
	local otherOptions = {};
	
	for a = 1, otherAnimationsInfo:count() do

		local otherInfo = otherAnimationsInfo:dictAtIndex(a);
	
		local otherAnimName = otherInfo:objectForKey("AnimName")
	
		if(nil == otherAnimName)then
			otherAnimName = otherInfo:objectForKey("UniqueName");
		end
		
		local otherSceneName = otherInfo:objectForKey("SHScene");
	
		local otherAnimDict = SHDocumentLoader:sharedInstance():dictionaryForAnimationNamed(otherAnimName:stringValue(), 
																							otherSceneName:stringValue());

		local otherAnimNode = LHAnimationNode:animationWithDictionary(otherAnimDict);
		if(otherAnimNode == nil)then
			return nil
		end
			
		--now set anim properties from the settings inside the level file
		if(otherInfo:objectForKey("AnimRepetitions"))then
			otherAnimNode.lhRepetitions = otherInfo:intForKey("AnimRepetitions")
		else
			otherAnimNode.lhRepetitions = otherInfo:intForKey("Repetitions") --from SH
		end
		
		if(otherInfo:objectForKey("AnimLoop"))then
			otherAnimNode.lhLoop = otherInfo:boolForKey("AnimLoop")
		else
			otherAnimNode.lhLoop = otherInfo:boolForKey("Loop")--from SH
		end
			
		if(otherInfo:objectForKey("AnimRestoreOriginalFrame"))then
			otherAnimNode.lhRestoreOriginalFrame = otherInfo:boolForKey("AnimRestoreOriginalFrame")
		else
			otherAnimNode.lhRestoreOriginalFrame = otherInfo:boolForKey("RestoreOriginalFrame")
		end
			
		if(otherInfo:objectForKey("AnimSpeed"))then
			otherAnimNode.lhDelayPerUnit = otherInfo:floatForKey("AnimSpeed")
		else
			otherAnimNode.lhDelayPerUnit = otherInfo:floatForKey("DelayPerUnit")
		end
			
		if(otherInfo:objectForKey("AnimAtStart"))then
			otherAnimNode.lhAnimAtStart = otherInfo:boolForKey("AnimAtStart")
		else
			otherAnimNode.lhAnimAtStart = otherInfo:boolForKey("StartAtLaunch")
		end
				
		
		local OtherOpt = SHDocumentLoader:sharedInstance():sheetOptionsForSheetInDocument(otherAnimNode.lhSheetName, 
																						otherSceneName:stringValue())


		local otherImageFile = imageFileWithFolder(otherAnimNode.lhSheetImage);

		local otherImageSheet = graphics.newImageSheet( otherImageFile, OtherOpt )				
		
		otherOptions[#otherOptions + 1] = {	sheetOptions = OtherOpt,
											imageSheet = otherImageSheet, 
											animNode = otherAnimNode};
	end
	

	----------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------
	
	local loop = 0;
	if false == animNode.lhLoop then
		loop = animNode.lhRepetitions
	end
			
	local speed = animNode:animationTime();
	if(speed < 0.001)then
		speed = 0.001
	end
	speed = speed*1000;

	local imageSheet = graphics.newImageSheet( imageFile, options )		

	local sequenceData = {
	    
	    {
	    name=animNode.lhUniqueName,
		frames = animNode:frameTableFromSheetImageOptionsBasedOnNames(options),
    	time=speed,       
	    loopCount = loop,
	    sheet = imageSheet
	    }
	}
	
	for i = 1, #otherOptions do
		
		local otherOptions = otherOptions[i];
		
		local otherAnimNode = otherOptions.animNode;
		
		local otherLoop = 0;
		if false == otherAnimNode.lhLoop then
			otherLoop = otherAnimNode.lhRepetitions
		end
			
		local otherSpeed = otherAnimNode:animationTime();
		if(otherSpeed < 0.001)then
			otherSpeed = 0.001
		end
		otherSpeed = otherSpeed*1000;
			
		sequenceData[#sequenceData+1] = {name = otherAnimNode.lhUniqueName,		
										frames = otherAnimNode:frameTableFromSheetImageOptionsBasedOnNames(otherOptions.sheetOptions),
										time  = otherSpeed,
										loopCount = otherLoop,
										sheet = otherOptions.imageSheet
										}
	end
	
	local animSprite = display.newSprite( imageSheet, sequenceData )
	
	animSprite.lhAnimationNodes = {};
	
	for i = 1, #otherOptions do
		local otherOptions = otherOptions[i];
		local otherAnimNode = otherOptions.animNode;
		otherAnimNode.coronaSprite = animSprite;
		animSprite.lhAnimationNodes[#animSprite.lhAnimationNodes + 1] = otherAnimNode;										
	end
	
	animSprite.lhAnimationNodes[#animSprite.lhAnimationNodes + 1] = animNode;
	animSprite.lhActiveAnimNode = animNode;
	animNode.coronaSprite = animSprite;
	animSprite:setSequence(animNode.lhUniqueName);
	
	return animSprite;
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
setTexturePropertiesOnSprite = function(coronaSprite, texDict)
	
	local scale = texDict:sizeForKey("Scale");
	local flipX = texDict:boolForKey("FlipX")
	local flipY = texDict:boolForKey("FlipY");

	coronaSprite.xScale = coronaSprite.xScale*scale.width
	coronaSprite.yScale = coronaSprite.yScale*scale.height
	coronaSprite.lhScaleWidth = scale.width;
	coronaSprite.lhScaleHeight= scale.height;
	
	if(flipX)then
		coronaSprite.xScale = -1.0*coronaSprite.xScale;
		coronaSprite.lhScaleWidth = -1.0*coronaSprite.lhScaleWidth
	end
	
	if(flipY)then
		coronaSprite.yScale = -1.0*coronaSprite.yScale;
		coronaSprite.lhScaleHeight= -1.0*coronaSprite.lhScaleHeight;
	end
						

	coronaSprite.rotation = texDict:intForKey("Angle")
	coronaSprite.alpha 	  = texDict:floatForKey("Opacity")
	coronaSprite.isVisible = texDict:boolForKey("IsDrawable")

	local position = texDict:pointForKey("Position");
	coronaSprite.x = position.x
	coronaSprite.y = position.y
		
	local color = texDict:rectForKey("Color");
	coronaSprite:setFillColor(color.origin.x*255,color.origin.y*255,color.size.width*255)	
	
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

recreatePhysicObjectForSprite = function(coronaSprite, phyDict)

--first remove the previously created body - if any

	coronaSprite:removeBodyFromWorld();

	local pType = phyDict:intForKey("Type");							
	if(pType == 3) then
		return
	end

	local physicType = "static"	
	if(pType == 1)then
		physicType = "kinematic";
	elseif(pType == 2)then
		physicType = "dynamic";
	end

	local fixturesInfo = phyDict:arrayForKey("SH_ComplexShapes");
	
	if(nil == fixturesInfo)then
		return
	end
	
	local completeBodyFixtures = {};
	
	coronaSprite.lhFixtures = {};
	
 	for i=1, fixturesInfo:count() do
 		local fixInfo = fixturesInfo:dictAtIndex(i);
		local previousFixSize = #completeBodyFixtures
 		local fixture = LHFixture:fixtureWithDictionary(fixInfo, coronaSprite, physics, completeBodyFixtures);

		fixture.coronaMinFixtureIdForThisObject = previousFixSize +1;
 		fixture.coronaMaxFixtureIdForThisObject = #completeBodyFixtures;
 		 		
		coronaSprite.lhFixtures[#coronaSprite.lhFixtures +1] = fixture;		
 	end
 	 	
 	physics.addBody(coronaSprite, 
					physicType,
					unpack(completeBodyFixtures))

	coronaSprite.isFixedRotation = phyDict:boolForKey("FixedRot")	
	coronaSprite.isBullet = phyDict:boolForKey("IsBullet")
	coronaSprite.isSleepingAllowed = phyDict:boolForKey("CanSleep")
	coronaSprite.linearDamping = phyDict:floatForKey("LinearDamping")
	coronaSprite.angularDamping = phyDict:floatForKey("AngularDamping");
	coronaSprite.angularVelocity =  phyDict:floatForKey("AngularVelocity")
	
	local velocity = phyDict:pointForKey("LinearVelocity")
	coronaSprite:setLinearVelocity( velocity.x, velocity.y)

end
--------------------------------------------------------------------------------
createPhysicObjectForSprite = function(coronaSprite, spriteInfo)

	local physics = require("physics")
	
	if(nil == physics)then
		return
	end

	phyDict = spriteInfo:dictForKey("PhysicProperties");
	coronaSprite.lhPhysicalInfo = phyDict;	
	recreatePhysicObjectForSprite(coronaSprite, coronaSprite.lhPhysicalInfo)
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
return LHSprite;
	