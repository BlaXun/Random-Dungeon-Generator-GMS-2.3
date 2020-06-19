// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

/*
	Add comment
*/
function RandomDungonGenerator(colorAssignment, spritesToUseForChambers) constructor {

	self._didCreateChambers = false;
	
	global.__debugging = true;	//	Enables / Disables debugging output on console
	global.__initialDungeonDimensions = 2000;	//	TODO: Add comment //	TODO: This must be calculated

	self.paddingToApplyToChamberPresets = 4;
	self.colorAssignments = colorAssignment; //new ColorAssignment(); //newMap();
	
	self.dungeonWasCreated = false;	//	Wether the dungeon generating is done	
	self.amountOfChambersToPlace = 10;
	self.chamberPresets = newList();
	self.chamberSprites = spritesToUseForChambers;
	
	self.dungeonPreset = undefined;
	self.dungeonSurface = undefined;
	
	/// @function createChamberPresetsFromSprites();
	///	@description	Creates ChamberPresets from the assigned sprites populating the chamberPresets variable	
	static _createChamberPresetsFromSprites = function() {
		
		if (self._didCreateChambers == true) {
			exit;
		}
		
		var _chamber = noone;		
		for (var _i=0;_i<array_length(self.chamberSprites);_i++) {
			_chamber = createChamberPresetFromChamberSprite(self.chamberSprites[_i], self.colorAssignments, self.paddingToApplyToChamberPresets);
			debug(_chamber);
			self.chamberPresets[| ds_list_size(self.chamberPresets)] = _chamber;
		}
		
		self._didCreateChambers = true;
	}
		
	static generateDungeon = function() {
		self.dungeonWasCreated = false;
		
		self._createChamberPresetsFromSprites();
		
		if (self.dungeonPreset != undefined) {
			delete self.dungeonPreset;
		}
		
		self.dungeonPreset = new DungeonPreset(self.colorAssignments,global.__initialDungeonDimensions,global.__initialDungeonDimensions);
		self.dungeonPreset.createNewDungeon(self.chamberPresets, self.amountOfChambersToPlace);
		self.dungeonWasCreated = true;
	}
	
	static drawDungeon = function() {
		
		if (self.dungeonSurface == undefined) {
			self.dungeonSurface = surface_create(self.dungeonPreset.widthInPixel, self.dungeonPreset.heightInPixel);	//	Surface on which the complete dungeon will be drawn*/
		} else {
			surface_resize(self.dungeonSurface,self.dungeonPreset.widthInPixel,self.dungeonPreset.heightInPixel);
		}
		
		surface_set_target(self.dungeonSurface);
		draw_clear(self.colorAssignments.backgroundColor);

		self.dungeonPreset.drawDungeon(0,0);

		surface_reset_target();
	}
}