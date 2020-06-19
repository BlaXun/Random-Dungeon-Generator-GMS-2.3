function GeneratorOptions(colorAssignment, spritesToUseForChambers) constructor {
	
	self.colorAssignments = colorAssignment;
	self.chamberSprites = spritesToUseForChambers
	self.paddingToApplyToChamberPresets = 0;
	self.amountOfChambersToPlace = 0;
	self.minimumRandomOffsetBetweenPlacedChambers = 0;
	self.maximumRandomOffsetBetweenPlacedChambers = 0;
}


/*
	This is the entry point for creating new random dungeons.
	The RandomDungeonGenerator will take care of everything using the given values
	
	As soon as the "dungeonWasCreated" variable is set to true
	you can use the "dungeonSurface" to check the created dungeon
*/
function RandomDungonGenerator(options) constructor {

	self.options = options;
	self._didCreateChambers = false;
	
	global.__debugging = true;	//	Enables / Disables debugging output on console
	
	self.dungeonWasCreated = false;	//	Wether the dungeon generating is done
	self.chamberPresets = createList();
	
	self.dungeonPreset = undefined;
	self.dungeonSurface = undefined;
	
	self._requiredMaximumGridDimensions = 0;
	
	static calculateRequiredMaximumGridSpace = function() {
		var _maxSpriteDimension = maximumDimensionFromSprites(self.options.chamberSprites);
		_maxSpriteDimension += self.options.paddingToApplyToChamberPresets*2;	
		_neededMaximumSpace = ((_maxSpriteDimension+self.options.maximumRandomOffsetBetweenPlacedChambers)*self.options.amountOfChambersToPlace)*2;
		debug("Needs a " + string(_neededMaximumSpace) + " * " + string(_neededMaximumSpace) + " grid");
		
		self._requiredMaximumGridDimensions = _neededMaximumSpace;
	}
	
	/// @function createChamberPresetsFromSprites();
	///	@description	Creates ChamberPresets from the assigned sprites populating the chamberPresets variable	
	static _createChamberPresetsFromSprites = function() {
		
		if (self._didCreateChambers == true) {
			exit;
		}
		
		var _chamber = noone;		
		for (var _i=0;_i<array_length(self.options.chamberSprites);_i++) {
			_chamber = createChamberPresetFromChamberSprite(self.options.chamberSprites[_i], self.options.colorAssignments, self.options.paddingToApplyToChamberPresets);
			debug(_chamber);
			self.chamberPresets[| ds_list_size(self.chamberPresets)] = _chamber;
		}
		
		self._didCreateChambers = true;
	}
		
	static generateDungeon = function() {
		self.dungeonWasCreated = false;
		
		self._createChamberPresetsFromSprites();
		self.calculateRequiredMaximumGridSpace();	
		
		if (self.dungeonPreset != undefined) {
			delete self.dungeonPreset;
		}
		
		self.dungeonPreset = new DungeonPreset(self.options.colorAssignments,self._requiredMaximumGridDimensions,self._requiredMaximumGridDimensions);
		self.dungeonPreset.createNewDungeon(self.chamberPresets, self.options.amountOfChambersToPlace,self.options.minimumRandomOffsetBetweenPlacedChambers,self.options.maximumRandomOffsetBetweenPlacedChambers);
		self.dungeonWasCreated = true;
	}
	
	static drawDungeon = function() {
		
		if (self.dungeonSurface == undefined) {
			self.dungeonSurface = surface_create(self.dungeonPreset.widthInPixel, self.dungeonPreset.heightInPixel);	//	Surface on which the complete dungeon will be drawn*/
		} else {
			surface_resize(self.dungeonSurface,self.dungeonPreset.widthInPixel,self.dungeonPreset.heightInPixel);
		}
		
		surface_set_target(self.dungeonSurface);
		draw_clear(self.options.colorAssignments.backgroundColor);

		self.dungeonPreset.drawDungeon(0,0);

		surface_reset_target();
	}
}