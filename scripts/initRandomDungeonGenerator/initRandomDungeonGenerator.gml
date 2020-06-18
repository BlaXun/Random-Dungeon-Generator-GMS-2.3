function initRandomDungeonGenerator() {
	global.__debugging = true;	//	Enables / Disables debugging output on console

	//	TODO: This must be calculated
	global.__initialDungeonDimensions = 2000;	//	TODO: Add comment

	var _startTime = current_time;

	//	Define the meaning of colors that are used
	enum ColorAssignment {
		ChamberGround,
		Connector,
		Padding,
		Hallway
	}

	colorAssignments = newMap();
	colorAssignments[? make_color_rgb(255,255,255)] = ColorAssignment.ChamberGround;
	colorAssignments[? make_color_rgb(238,28,36)] = ColorAssignment.Connector;
	colorAssignments[? make_color_rgb(20,20,20)] = ColorAssignment.Padding;
	colorAssignments[? make_color_rgb(0,0,255)] = ColorAssignment.Hallway;

	chamberSprites = [];
	var _chamberSpriteAssetIndices = tag_get_assets("ChamberSprite");
	for (var _i=0;_i<array_length(_chamberSpriteAssetIndices);_i++) {
		chamberSprites[array_length(chamberSprites)] = asset_get_index(_chamberSpriteAssetIndices[_i]);
	}
	
	dungeonWasCreated = false;	//	Wether the dungeon generating is done
	chamberPresetPadding = 4;
	amountOfChambersToPlace = 10;
	//amountOfChambersToPlace = 10+ceil(random(5));	//	The amount of chambers to be placed when creating the dungeon
	chamberPresets = newList();

	var chamber = noone;
	var _i;
	for (_i=0;_i<array_length_1d(chamberSprites);_i++) {
		chamber = createChamberPresetFromChamberSprite(chamberSprites[_i], colorAssignments, chamberPresetPadding);
		ds_list_add(chamberPresets, chamber);
	}

	dungeonPreset = emptyDungeonPreset();
	dungeonPreset[? DungeonPresetProps.ColorAssignments] = colorAssignments;

	createNewDungeonOnPreset(dungeonPreset, chamberPresets, amountOfChambersToPlace);

	dungeonSurface = surface_create(dungeonPreset[? DungeonPresetProps.WidthInPixel], dungeonPreset[? DungeonPresetProps.HeightInPixel]);	//	Surface on which the complete dungeon will be drawn*/
	surface_set_target(dungeonSurface);
	draw_clear(c_black);

	drawDungeonFromDungeonPreset(dungeonPreset,0,0);

	surface_reset_target();

	dungeonWasCreated = true;

	debug("Done in " + string((current_time-_startTime)/1000) + "s");


}
