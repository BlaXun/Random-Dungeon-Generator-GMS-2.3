///	@function drawDungeonFromDungeonPreset(dungeonPreset,x,y);
///	@description	Draws the dungeon to screen from the given preset using the given coordinates
///	@param {ds_map}	dungeonPreset	The dungeon preset that should be drawn
///	@param {real} x	The x-coordinate where to draw the dungeon
///	@param {real} y	The y-coordinate where to draw the dungeon
function drawDungeonFromDungeonPreset() {

	var _dungeonPreset = argument[0];
	var _x = argument[1];
	var _y = argument[2];

	var _dungeonPixelGrid = valueGridFromValueTypeGrid(_dungeonPreset[? DungeonPresetProps.ValueTypeGrid]);
	var _dungeonTypeGrid = typeGridFromValueTypeGrid(_dungeonPreset[? DungeonPresetProps.ValueTypeGrid]);

	var _gridWidth, _gridHeight;
	_gridWidth = ds_grid_width(_dungeonPixelGrid);
	_gridHeight = ds_grid_height(_dungeonPixelGrid);

	var _chamberColor, _connectorColor, _paddingColor, _hallwayColor;
	_chamberColor = findColorForColorAssignment(_dungeonPreset[? DungeonPresetProps.ColorAssignments],ColorAssignment.ChamberGround);
	_connectorColor = findColorForColorAssignment(_dungeonPreset[? DungeonPresetProps.ColorAssignments],ColorAssignment.Connector);
	_paddingColor = findColorForColorAssignment(_dungeonPreset[? DungeonPresetProps.ColorAssignments],ColorAssignment.Padding);
	_hallwayColor = findColorForColorAssignment(_dungeonPreset[? DungeonPresetProps.ColorAssignments],ColorAssignment.Hallway);

	var _contents = undefined;
	var _colorToDraw = noone;
	for (var _yPos=0;_yPos<_gridHeight;_yPos++) {
	
		for (var _xPos=0;_xPos<_gridWidth;_xPos++) {
		
			_contents = _dungeonTypeGrid[# _xPos, _yPos];		
			_colorToDraw = noone;
		
			if (_contents != noone) {
				switch (_contents) {
				
					case GridContentType.ChamberGround: 					
						_colorToDraw = _chamberColor;
					break;			
				
					case GridContentType.Connector: 
						_colorToDraw = _connectorColor;
					break;
				
					case GridContentType.Padding: 
						_colorToDraw = _paddingColor;
					break;
				
					case GridContentType.Hallway: 
						_colorToDraw = _hallwayColor;
					break;
				}
			}
		
		
			if (_colorToDraw != noone) {
				draw_point_color(_x+_xPos,_y+_yPos, _colorToDraw);
			}
		}
	}


}
