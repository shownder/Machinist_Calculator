require "config"
require "SpriteHelper.Helpers.LHHelpers"
require "SpriteHelper.Helpers.LHObject"
require "SpriteHelper.Helpers.LHArray"
require "SpriteHelper.Helpers.LHDictionary"

require "SpriteHelper.Nodes.LHSprite"
require "SpriteHelper.Nodes.LHSettings"
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local SpriteHelperLoader = {}

function SpriteHelperLoader.createSpriteWithName(selfLoader, spriteName, sheetName, SHDocumentFile)

	if(	SHDocumentFile ~= nil and
	   	sheetName ~= nil and
	    spriteName~= nil)then
		   		    
	   local SHLoaded = SHDocumentLoader:sharedInstance();
	   local spriteDict = SHLoaded:dictionaryForSpriteNamed(spriteName, 
	   														sheetName,
	   														SHDocumentFile)												
	   if(spriteDict ~= nil)then
	   		
		   LHSprite = require("SpriteHelper.Nodes.LHSprite");
		   spriteDict:setObjectForKey(LHObject:init(SHDocumentFile, LH_OBJECT_TYPE.STRING_TYPE), 
               					   	"SHSceneName");
               					   				   
			return LHSprite:spriteWithDictionary(spriteDict);
	   	end
	end	
	return nil;		
end
--------------------------------------------------------------------------------
function SpriteHelperLoader.createAnimatedSpriteWithName(selfLoader, spriteName, sheetName, SHDocumentFile, mainAnimName, ...)

	if(	SHDocumentFile ~= nil and
	   	sheetName ~= nil and
	    spriteName~= nil)then
		   		    
	   local SHLoader = SHDocumentLoader:sharedInstance();
	   local spriteDict = SHLoader:dictionaryForSpriteNamed(spriteName, 
	   														sheetName,
	   														SHDocumentFile)		
	   														
	   														
  		local otherAnimArray = LHArray:emptyArray()													
	  	for i,v in ipairs(arg) do
  			local otherAnimName = v;  			
  			local otherAnimDict = SHLoader:dictionaryForAnimationNamed(otherAnimName, SHDocumentFile)

			otherAnimDict = LHDictionary:initWithDictionary(otherAnimDict);

			otherAnimDict:setObjectForKey(LHObject:init(SHDocumentFile, LH_OBJECT_TYPE.STRING_TYPE), "SHScene");
			  			
  			otherAnimArray:addObject(LHObject:init(otherAnimDict, 
  									 LH_OBJECT_TYPE.LH_DICT_TYPE));  									 
		end
	
	   																								
	   if(spriteDict ~= nil)then
	   		
	   	   local animDict = SHLoader:dictionaryForAnimationNamed(mainAnimName, SHDocumentFile)
	   	   
	   	   if(animDict)then
	   	   
		   	   local newSpriteDict = LHDictionary:initWithDictionary(spriteDict)
	   	   		if(newSpriteDict)then
		   	   		local tempDict = LHDictionary:initWithDictionary(animDict);
		   	   		if(tempDict)then	   	  
		   	   		
		   	   			tempDict:setObjectForKey(LHObject:init(otherAnimArray, LH_OBJECT_TYPE.LH_ARRAY_TYPE), "OtherAnimations");
		   	   		 
			   		   	newSpriteDict:setObjectForKey(LHObject:init(tempDict, LH_OBJECT_TYPE.LH_DICT_TYPE), 
            	   						   	"AnimationsProperties");
		     		end
		     	
			        LHSprite = require("SpriteHelper.Nodes.LHSprite");
				    newSpriteDict:setObjectForKey(LHObject:init(SHDocumentFile, LH_OBJECT_TYPE.STRING_TYPE), 
        	       					   	"SHSceneName");
               					   				   
					local newCreatedSprite = LHSprite:spriteWithDictionary(newSpriteDict);
				
					newSpriteDict:removeSelf();
				
					return newCreatedSprite;
				end
	   	   end	   	   
	   	end
	end	
	return nil;		
end
--------------------------------------------------------------------------------
function SpriteHelperLoader.useSpriteHelperCollisionHandling(selfLoader)
	LHSettings:sharedInstance():useSpriteHelperCollisionHandling()
end
--------------------------------------------------------------------------------
function SpriteHelperLoader.cancelSpriteHelperCollisionHandling(selfLoader)
	LHSettings:sharedInstance():cancelCollisionHandling()
end
--------------------------------------------------------------------------------
function SpriteHelperLoader.registerBeginOrEndCollisionCallbackBetweenTags(selfLoader, tagA, tagB, callbackFunction)
	LHSettings:sharedInstance():registerBeginOrEndCollisionCallbackBetweenTags(tagA, tagB, callbackFunction)
end
--------------------------------------------------------------------------------
function SpriteHelperLoader.cancelBeginOrEndCollisionCallbackBetweenTags(selfLoader, tagA, tagB)
	LHSettings:sharedInstance():cancelBeginOrEndCollisionCallbackBetweenTags(tagA, tagB)
end
--------------------------------------------------------------------------------
function SpriteHelperLoader.registerPreColisionCallbackBetweenTags(selfLoader, tagA, tagB, callbackFunction)
	print("SpriteHelper WARNING: registerPreColisionCallbackBetweenTags is deprecated please use registerPreCollisionCallbackBetweenTags (2 ll's)");
	LHSettings:sharedInstance():registerPreColisionCallbackBetweenTags(tagA, tagB, callbackFunction)
end
function SpriteHelperLoader.registerPreCollisionCallbackBetweenTags(selfLoader, tagA, tagB, callbackFunction)
	LHSettings:sharedInstance():registerPreColisionCallbackBetweenTags(tagA, tagB, callbackFunction)
end
--------------------------------------------------------------------------------
function SpriteHelperLoader.cancelPreCollisionCallbackBetweenTags(selfLoader, tagA, tagB)
	LHSettings:sharedInstance():cancelPreCollisionCallbackBetweenTags(tagA, tagB)
end
--------------------------------------------------------------------------------
function SpriteHelperLoader.registerPostColisionCallbackBetweenTags(selfLoader, tagA, tagB, callbackFunction)
	print("SpriteHelper WARNING: registerPostColisionCallbackBetweenTags is deprecated please use registerPostCollisionCallbackBetweenTags (2 ll's)");
	LHSettings:sharedInstance():registerPostColisionCallbackBetweenTags(tagA, tagB, callbackFunction)
end
function SpriteHelperLoader.registerPostCollisionCallbackBetweenTags(selfLoader, tagA, tagB, callbackFunction)
	LHSettings:sharedInstance():registerPostColisionCallbackBetweenTags(tagA, tagB, callbackFunction)
end
--------------------------------------------------------------------------------
function SpriteHelperLoader.cancelPostCollisionCallbackBetweenTags(selfLoader, tagA, tagB)
	LHSettings:sharedInstance():cancelPostCollisionCallbackBetweenTags(tagA, tagB)
end


return SpriteHelperLoader;