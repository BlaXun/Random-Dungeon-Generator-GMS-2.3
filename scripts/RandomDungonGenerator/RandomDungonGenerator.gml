function GeneratorOptions(colorAssignment, spritesToUseForChambers) constructor {
	
	self.colorAssignments = colorAssignment;
	self.chamberSprites = spritesToUseForChambers
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
	
	self._requiredMaximumGridWidth = 0;
	self._requiredMaximumGridHeight = 0;
	
	/*	
		@function		calculateRequiredMaximumGridSpace();
		@description	Calculates the maximum grid dimensions for the dungeon grid
						that would be needed if only the largest chamber would repeatedly be used.
		
						With this dimensions all further combinations should be possible.
						The grid will be cropped in the end anyway. Still, there seems to be a limit
						on how much memory can be allocated. */
	static calculateRequiredMaximumGridSpace = function() {
		var _maxChamberPresetWidth = 0;
		var _maxChamberPresetHeight = 0;
		
		var _currentChamberPreset = undefined;
		for (var _i=0;_i<ds_list_size(self.chamberPresets);_i++) {
			_currentChamberPreset = self.chamberPresets[| _i];
			_maxChamberPresetWidth = max(_maxChamberPresetWidth, _currentChamberPreset.width);
			_maxChamberPresetHeight = max(_maxChamberPresetHeight, _currentChamberPreset.height);
		}
		
		
		var _neededMaximumWidth = ((_maxChamberPresetWidth+self.options.maximumRandomOffsetBetweenPlacedChambers)*self.options.amountOfChambersToPlace)*2;
		var _neededMaximumHeight = ((_maxChamberPresetHeight+self.options.maximumRandomOffsetBetweenPlacedChambers)*self.options.amountOfChambersToPlace)*2;
		debug("Needs a " + string(_neededMaximumWidth) + " * " + string(_neededMaximumHeight) + " grid");		
		self._requiredMaximumGridWidth = _neededMaximumWidth;
		self._requiredMaximumGridHeight = _neededMaximumHeight;
	}
	
	/// @function createChamberPresetsFromSprites();
	///	@description	Creates ChamberPresets from the assigned sprites populating the chamberPresets variable	
	static _createChamberPresetsFromSprites = function() {
		
		if (self._didCreateChambers == true) {
			exit;
		}
		
		var _chamber = noone;		
		for (var _i=0;_i<array_length(self.options.chamberSprites);_i++) {
			_chamber = createChamberPresetFromChamberSprite(self.options.chamberSprites[_i], self.options.colorAssignments);
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
		
		self.dungeonPreset = new DungeonPreset(self.options.colorAssignments,self._requiredMaximumGridWidth,self._requiredMaximumGridHeight);
		self.dungeonPreset.createNewDungeon(self.chamberPresets, self.options.amountOfChambersToPlace,self.options.minimumRandomOffsetBetweenPlacedChambers,self.options.maximumRandomOffsetBetweenPlacedChambers);
		self.dungeonWasCreated = true;
	}
	
	static drawDungeon = function() {
		
		if (self.dungeonSurface == undefined) {
			self.dungeonSurface = surface_create(self.dungeonPreset.width, self.dungeonPreset.height);	//	Surface on which the complete dungeon will be drawn*/
		} else {
			surface_resize(self.dungeonSurface,self.dungeonPreset.width,self.dungeonPreset.height);
		}
		
		surface_set_target(self.dungeonSurface);
		draw_clear(self.options.colorAssignments.backgroundColor);

		self.dungeonPreset.drawDungeon(0,0);

		surface_reset_target();
	}
}