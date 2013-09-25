require "SpriteHelper.Helpers.LHHelpers"


SHSceneNode = {}
function SHSceneNode:SHSceneNodeWithContentOfFile(sceneFile)
		
	local object = {sheets = {}, --key sheetName -- object LHDictionary
					animations = {} -- key animName -- object LHDictionary
					}
	setmetatable(object, { __index = SHSceneNode })  -- Inheritance	
	
	object:initWithContentOfFile(sceneFile);
	
	return object
end
--------------------------------------------------------------------------------
function SHSceneNode:infoForSpriteNamed(spriteName, sheetName)

	local sheetsInfo = self.sheets[sheetName];
	
	if(sheetsInfo)then
	
		local spritesInfo = sheetsInfo:dictForKey("Sheet_Sprites_Info");
		local sprInfo = spritesInfo:dictForKey(spriteName);
		
		if(sprInfo)then
			return sprInfo;
		end
		
		print("Info for sprite named " .. spriteName .. " could not be found in sheet named " .. sheetName);
		return nil;
	end
	
	print("Could not find sheet named " .. sheetName);
	return nil;
end
--------------------------------------------------------------------------------
function SHSceneNode:frameTableForSheetNamed(sheetName)

	local sheetsInfo = self.sheets[sheetName];
	
	
	if(sheetsInfo)then
	
		local lhSettings = LHSettings:sharedInstance();
		
		local imageFile = imageFileWithFolder(sheetsInfo:stringForKey("SheetImage"));
		local batch = lhSettings:sizeForImageFile(imageFile);

		local options = { 
				frames = {	
    			},
    		
	    	sheetContentWidth = batch.width,
    		sheetContentHeight = batch.height
		}

		local spritesInfo = sheetsInfo:dictForKey("Sheet_Sprites_Info");
		
		if(spritesInfo ~= nil)then
			local keys = spritesInfo:allKeys();
			for i = 1, #keys do
			
				local sprInfo = spritesInfo:dictForKey(keys[i])
				
				if(sprInfo ~= nil)then
				
					local texProp = sprInfo:dictForKey("TextureProperties");
					
					if(texProp ~= nil)then
					
						local rect = texProp:rectForKey("Frame");
						local sprName = texProp:stringForKey("Name");
						options.frames[#options.frames + 1] = {	x = rect.origin.x, 
																y = rect.origin.y,
																width = rect.size.width,
																height= rect.size.height,
																spriteName = sprName
															   };
					end
				end
			end
			return options;
		end
	end
	
	print("Could not find sheet named " .. sheetName);
	return nil;
end
--------------------------------------------------------------------------------
function SHSceneNode:infoForSheetNamed(sheetName)
	return self.sheets[sheetName];
end
--------------------------------------------------------------------------------
function SHSceneNode:infoForAnimationNamed(animName)
	return self.animations[animName];
end
--------------------------------------------------------------------------------
function SHSceneNode:availableAnimations()
	return self.animations;
end
--------------------------------------------------------------------------------
function SHSceneNode:removeSelf()

--remove sheets
--remove animations
--remove self
end
--------------------------------------------------------------------------------
function SHSceneNode:initWithContentOfFile(sceneFile)

	path = nil;

	if(nil ~= application.SpriteHelperSettings)then
		if(nil ~= application.SpriteHelperSettings.imagesSubfolder)then
		
			local finalPath = application.SpriteHelperSettings.imagesSubfolder .. "/" .. sceneFile;
			path = system.pathForFile(finalPath, resourceDirectory);
		end
	end
	
	if(nil == path)then
		path = system.pathForFile(sceneFile, resourceDirectory)
	end
	
	if(nil == path)then
		print("SpriteHelper ERROR: Document " .. sceneFile .. " was not found.");
		return;
	end

	local file = io.open(path, "r")

	local dictionary = LHDictionary:initWithContentOfFile(file, nil);

	local sheetsList = dictionary:arrayForKey("SHEETS_INFO");
	
	if(sheetsList)then
		for i=1,sheetsList:count() do
			local dic = sheetsList:dictAtIndex(i);
			self.sheets[dic:stringForKey("SheetName")] = LHDictionary:initWithDictionary(dic);
		end
	end
	
	local animList = dictionary:arrayForKey("SH_ANIMATIONS_LIST");
	if(animList)then
		for j=1,animList:count() do
			local dic = animList:dictAtIndex(j);			
			self.animations[dic:stringForKey("UniqueName")] = LHDictionary:initWithDictionary(dic);
		end
	end

	dictionary:removeSelf()
	dictionary = nil;

	io.close(file)
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
SHDocumentLoader = {}
lh_sh_documentLoader_sharedInstance = nil;
function SHDocumentLoader:init()

	local object = {scenes = {} --key sceneName object SHSceneNode    
					}
	setmetatable(object, { __index = SHDocumentLoader })  -- Inheritance	
	
	lh_sh_documentLoader_sharedInstance = object;
	return object
end
--------------------------------------------------------------------------------
function SHDocumentLoader:sharedInstance()

	if(lh_sh_documentLoader_sharedInstance == nil) then
		return self:init();
	end
	
	return lh_sh_documentLoader_sharedInstance;
end
--------------------------------------------------------------------------------
function SHDocumentLoader:sceneNodeForSHDocument(shDocument)

	local sceneNode = self.scenes[shDocument];
	
	if(sceneNode == nil)then
		sceneNode = SHSceneNode:SHSceneNodeWithContentOfFile(shDocument);
		self.scenes[shDocument] = sceneNode; 
	end
	return sceneNode;
end
--------------------------------------------------------------------------------
--this method will also create the appropriate info if the info is not already loaded
function SHDocumentLoader:dictionaryForSpriteNamed(spriteName, sheetName, spriteHelperDocument)

	local shNode = self:sceneNodeForSHDocument(spriteHelperDocument);

	if(nil ~= shNode)then
	
		local info = shNode:infoForSpriteNamed(spriteName, sheetName);
		
		if(info)then
			return info;
		end				
	end

	print("Could not find info for sprite named " .. spriteName .. " in sheet name " .. sheetName .. " in document name " .. spriteHelperDocument);
    return nil;
end
--------------------------------------------------------------------------------
function SHDocumentLoader:dictionaryForSheetNamed(sheetName, spriteHelperDocument)

	local shNode = self:sceneNodeForSHDocument(spriteHelperDocument);
	
	if(nil ~= shNode)then
	
		info = shNode:infoForSheetNamed(sheetName);
		
		if(info)then
			return info
		end
	end

	print("Could not find info for sheet named " .. sheetName .. " in document named " .. spriteHelperDocument);
	return nil;
end
--------------------------------------------------------------------------------
function SHDocumentLoader:sheetOptionsForSheetInDocument(sheetName, spriteHelperDocument)

	local shNode = self:sceneNodeForSHDocument(spriteHelperDocument);
	
	if(nil ~= shNode)then
	
		local options = shNode:frameTableForSheetNamed(sheetName);
		
		if(options)then
			return options
		end
	end

	print("Could not find option table for sheet named " .. sheetName .. " in document named " .. spriteHelperDocument);
	return nil;
end
--------------------------------------------------------------------------------
function SHDocumentLoader:dictionaryForAnimationNamed(animName, spriteHelperDocument)

	local shNode = self:sceneNodeForSHDocument(spriteHelperDocument);
	
	if(nil ~= shNode)then
	
		info = shNode:infoForAnimationNamed(animName);
		
		if(info)then
			return info
		end
	end

	print("Could not find info for animation named " .. animName .. " in document named " .. spriteHelperDocument);
	return nil;
end
--------------------------------------------------------------------------------
function SHDocumentLoader:availableAnimationsInDocument(spriteHelperDocument)

	local shNode = self:sceneNodeForSHDocument(spriteHelperDocument);
	
	if(nil ~= shNode)then
	
		info = shNode:availableAnimations();
		
		if(info)then
			return info
		end
	end

	print("Could not find animations in document named " .. spriteHelperDocument);
	return nil;
end


--------------------------------------------------------------------------------
