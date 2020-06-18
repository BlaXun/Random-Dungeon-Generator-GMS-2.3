///	@function drawDungeonGrid(dungeonGrid,dungeonWidthInPixel,dungeonHeightInPixel)
///	@description Draws the given dungeon grid onto the currently set target
///	@param {ds_grid} dungeonGrid			The dungeon grid to draw
///	@param {real}	dungeonWidthInPixel		The width of the drawing area reserved for drawing the dungeon
///	@param {real}	dungeonHeightInPixel	The height of the drawing area reserved for drawing the dungeon
function drawDungeonGrid() {

	var _dungeonGrid = argument[0];
	var _dungeonWidthInPixel = argument[1];
	var _dungeonHeightInPixel = argument[2];

	var _gridWidth, _gridHeight;
	_gridWidth = ds_grid_width(_dungeonGrid);
	_gridHeight = ds_grid_height(_dungeonGrid);

	var _columnWidth, _columnHeight;
	_columnWidth = floor(_dungeonWidthInPixel/_gridWidth);
	_columnHeight = floor(_dungeonHeightInPixel/_gridHeight);

	debug("Proceeding to draw dungeon grid with size " + string(_gridWidth) + " * " + string(_gridHeight) + " with each column having a size of " + string(_columnWidth) + " * " + string(_columnHeight));

	var _chamberToPlace = noone;
	var _yPos, _xPos;
	for (_yPos=0;_yPos<_gridHeight;_yPos++) {
	
		for (_xPos=0;_xPos<_gridWidth;_xPos++) {
			_chamberToPlace = _dungeonGrid[# _xPos,_yPos];
		
			if (_chamberToPlace == noone) {
				continue;
			}
		
			debug("Found pixel grid to draw at x: " + string(_columnWidth*_xPos) + " y: " + string(_columnHeight*_yPos));
			var _chamberPixelGrid = valueGridFromValueTypeGrid(_chamberToPlace[? ChamberPresetProps.ValueTypeGrid]);
			drawPixelGrid(_chamberPixelGrid,_columnWidth*_xPos,_columnHeight*_yPos);
		}
	}


}
