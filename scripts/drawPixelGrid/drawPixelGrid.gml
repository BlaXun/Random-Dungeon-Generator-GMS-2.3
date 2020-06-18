///	@function drawPixelGrid(pixelGrid,x,y)
///	@description	Draws the given pixel grid at the given position
///	@param	{ds_grid} pixelGrid		The pixel grid to draw
///	@param	{real}	x				X-Position to start drawing
///	@param	{real}	y				Y-Position to start drawing
function drawPixelGrid() {

	var _pixelGrid = argument[0];
	var _xOffset = argument[1];
	var _yOffset = argument[2];

	var _gridWidth, _gridHeight;
	_gridWidth = ds_grid_width(_pixelGrid);
	_gridHeight = ds_grid_height(_pixelGrid);

	var _pixelColor = noone;
	for (var _yPos=0;_yPos<_gridHeight;_yPos++) {
	
		for (var _xPos=0;_xPos<_gridWidth;_xPos++) {
			_pixelColor = _pixelGrid[# _xPos,_yPos];
		
			if (_pixelColor != noone) {
				draw_point_color(_xOffset+_xPos,_yOffset+_yPos, _pixelColor);
			}
		}
	}



}
