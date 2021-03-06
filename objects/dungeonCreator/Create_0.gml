/*	Defining the colors used to analyze chamber sprites */
self.colorAssignment = new ColorAssignment();

//	Defining (at least one) color to be detected as ground
self.colorAssignment.addChamberGroundColor(make_color_rgb(255,255,255));

//	Defining (at least one) color to be detected as connectors
self.colorAssignment.addConnectorColor(make_color_rgb(238,28,36));

//	(Optional) Defining custom colors with custom meaning
self.colorAssignment.addUserDefinedColorWithValue(make_color_rgb(160,65,13), "Treasure Chest");
self.colorAssignment.addUserDefinedColorWithValue(make_color_rgb(241,110,170), "Wall");

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
	
	show_message_async("Done creating a dungeon.\nYour dungeon will be drawn using tiles and also drawn at the upper-left corner as pixel-representation.\n\nPress space to create another or 'D' to move to a demo room withg the generated dungeon.");
	show_message_async(string(dungeonGenerator));
	
	//	In here you would now use the dungeonGenerator.dungeonPreset.metadata ds_grid, cycle through it and create your dungeon.
	//	If you somehow need a list of all placed chambers you can use dungeonGenerator.dungeonPreset.placedChambers (ds_list).	
	var _gridWidth, _gridHeight;
	_gridHeight = ds_grid_height(self.dungeonGenerator.dungeonPreset.metadata)
	_gridWidth = ds_grid_width(self.dungeonGenerator.dungeonPreset.metadata)
	
	global.demoRoom = room_add();
	layer_set_target_room(global.demoRoom);
	var layerId = layer_create(100, "Tiles_1");
	var tilemapId = layer_tilemap_create(layerId,TileSet1,0,0,_gridWidth,_gridHeight);
	
	tilemap_clear(tilemapId,0);
	
	room_set_width(global.demoRoom, _gridWidth*16);
	room_set_height(global.demoRoom, _gridHeight*16);
	
	room_set_background_color(global.demoRoom,c_black,true);
	
	var _playerInstance = undefined;
	var _didPlacePlayer = false;	
	for (var _yPos=0;_yPos<_gridHeight;_yPos++) {
		
		for (var _xPos=0;_xPos<_gridWidth;_xPos++) {
		
			var _content = self.dungeonGenerator.dungeonPreset.metadata[# _xPos, _yPos];			
			
			switch (_content) {
				
				case ColorMeaning.AutoWall:
					room_instance_add(global.demoRoom,_xPos*16,_yPos*16,objBlock);				
				break;
				
				case ColorMeaning.ChamberGround:
				
					if (_didPlacePlayer == false) {
						_playerInstance = room_instance_add(global.demoRoom,_xPos*16,_yPos*16,objPlayer);
						_didPlacePlayer = true;
					}
					tilemap_set(tilemapId,1,_xPos,_yPos);
				break;
				
				case ColorMeaning.Hallway:
					tilemap_set(tilemapId,48,_xPos,_yPos);
				break;
				
				case ColorMeaning.Connector:
					tilemap_set(tilemapId,49,_xPos,_yPos);
				break;
			}
		}
	}
	
	layer_reset_target_room();
	
	//	Also draw a pixel-representation of the generated map
	self.dungeonGenerator.drawDungeon();
};

var _options = new GeneratorOptions(self.colorAssignment,_chamberSprites);
_options.setCallbackFunction(_callback);

/*	Define how many chambers should be placed.
	Be cautious with this. The amount of chambers will define the initial height / width of the ds_grid
	to be created. Depending on the size of your chamber-sprites this can be a quite huge grid in the end
	and could potentially crash your game!	*/
_options.amountOfChambersToPlace = 20;

//	(Optional)	Define a minimum and maxmimum offset to be applied when placing chambers. This will result
//				in somewhat random placement. Values assigned here are on a pixel-level.
_options.minimumRandomOffsetBetweenPlacedChambers = 0;
_options.maximumRandomOffsetBetweenPlacedChambers = 0;
_options.surroundWithWalls = true;
_options.closeWallCorners = true;

self.rdg = new RandomDungonGenerator(_options);

//	Start generating the dungeon
self.rdg.generateDungeon();
