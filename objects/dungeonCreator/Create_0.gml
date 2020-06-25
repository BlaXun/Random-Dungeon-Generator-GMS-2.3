/*	Defining the colors used to analyze chamber sprites */
self.colorAssignment = new ColorAssignment();

//	Defining (at least one) color to be detected as ground
self.colorAssignment.addChamberGroundColor(make_color_rgb(255,255,255));

//	Defining (at least one) color to be detected as connectors
self.colorAssignment.addConnectorColor(make_color_rgb(238,28,36));

//	(Optional) Defining custom colors with custom meaning
self.colorAssignment.addUserDefinedColorWithValue(make_color_rgb(160,65,13), "Treasure Chest");

//	(Optional) Defining colors to be used for drawing the output
self.colorAssignment.backgroundColor = make_color_rgb(149,125,173);
self.colorAssignment.colorUsedToDrawConnectors = make_color_rgb(224,187,228);
self.colorAssignment.colorUsedToDrawChamberGround = make_color_rgb(255,223,211);
self.colorAssignment.colorUsedToDrawHallways = make_color_rgb(254,200,216);
self.colorAssignment.colorUsedToDrawPadding = make_color_rgb(210,145,188);

//	Creating an array with all sprites that should be used as chambers
var _chamberSprites = [];
var _chamberSpriteAssetIndices = tag_get_assets("ChamberSprite");
for (var _i=0;_i<array_length(_chamberSpriteAssetIndices);_i++) {
	_chamberSprites[array_length(_chamberSprites)] = asset_get_index(_chamberSpriteAssetIndices[_i]);
}
	
//	(Optional) Defining a callback-function so we know when the dungeon is ready
var _callback = function(dungeonGenerator) {
	show_message("Done creating a dungeon- Press space to create another");
	show_message(string(dungeonGenerator));
	
	//	In here you would now use the dungeonGenerator.dungeonPreset.metadata ds_grid, cycle through it and create your dungeon.
	//	If you somehow need a list of all placed chambers you can use dungeonGenerator.dungeonPreset.placedChambers (ds_list).
	
	//	As a fallback, so you can see the output, we are going to draw the dungeon to a surface and display it	
	self.dungeonGenerator.drawDungeon();
};

var _options = new GeneratorOptions(self.colorAssignment,_chamberSprites);
_options.setCallbackFunction(_callback);

/*	Define how many chambers should be placed.
	Be cautious with this. The amount of chambers will define the initial height / width of the ds_grid
	to be created. Depending on the size of your chamber-sprites this can be a quite huge grid in the end
	and could potentially crash your game!	*/
_options.amountOfChambersToPlace = 25;

//	(Optional)	Define a minimum and maxmimum offset to be applied when placing chambers. This will result
//				in somewhat random placement. Values assigned here are on a pixel-level.
_options.minimumRandomOffsetBetweenPlacedChambers = 5;
_options.maximumRandomOffsetBetweenPlacedChambers = 20;

self.rdg = new RandomDungonGenerator(_options);

//	Start generating the dungeon
self.rdg.generateDungeon();
