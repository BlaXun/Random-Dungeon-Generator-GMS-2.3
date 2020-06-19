///	@function croppedGridFromGrid(grid);
///	@description				Returns a cropped grid from the given grid. 
///								Please make sure to delete the provided grid if it would be replaced by the cropped grid
///
///	@param {ds_grid} grid	The grid for which a cropped grid should be returned
///	@return	An array with two values. 0=The cropped Grid, 1=Array with amount of pixel that were cut on each side
function croppedGridFromGrid() {

	var _sourceGrid = argument[0];
	var _xStart = 0, _yStart = 0, _xEnd = 0, _yEnd = 0;
	var _cutPixelsOnSides = [];
	_cutPixelsOnSides[Position.Top] = 0;
	_cutPixelsOnSides[Position.Right] = 0;
	_cutPixelsOnSides[Position.Bottom] = 0;
	_cutPixelsOnSides[Position.Left] = 0;

	var _gridWidth, _gridHeight;
	_gridWidth = ds_grid_width(_sourceGrid);
	_gridHeight = ds_grid_height(_sourceGrid);

	for (var _yPos=0;_yPos<_gridHeight;_yPos+=1) {
		if (ds_grid_get_max(_sourceGrid,0,_yPos,_gridWidth-1,_yPos) != noone) {		
			_yStart = _yPos;
			break;
		}
	}

	for (var _yPos=_gridHeight-1;_yPos>=0;_yPos-=1) {
		if (ds_grid_get_max(_sourceGrid,0,_yPos,_gridWidth-1,_yPos) != noone) {
			_yEnd = _yPos+1;
			break;
		}
	}

	for (var _xPos=0;_xPos<_gridWidth;_xPos+=1) {
		if (ds_grid_get_max(_sourceGrid,_xPos,0,_xPos,_gridHeight-1) != noone) {
			_xStart = _xPos;
			break;
		}
	}

	for (var _xPos=_gridWidth-1;_xPos>=0;_xPos-=1) {
		if (ds_grid_get_max(_sourceGrid,_xPos,0,_xPos,_gridHeight-1) != noone) {
			_xEnd = _xPos+1;
			break;
		}
	}

	var _resultGrid = newGrid(_xEnd-_xStart,_yEnd-_yStart);
	ds_grid_set_grid_region(_resultGrid,_sourceGrid,_xStart,_yStart,_xEnd,_yEnd,0,0);

	debug("Did crop " + string(_gridWidth)+ " * " + string(_gridHeight)+" grid down to " + string(_xEnd-_xStart) + " * " + string(_yEnd-_yStart));

	_cutPixelsOnSides[Position.Top] = _yStart;
	_cutPixelsOnSides[Position.Bottom] = _gridHeight-_yEnd;
	_cutPixelsOnSides[Position.Left] = _xStart;
	_cutPixelsOnSides[Position.Right] = _gridWidth-_xEnd;

	debug("Left: " + string(_cutPixelsOnSides[Position.Left]));
	debug("Top: " + string(_cutPixelsOnSides[Position.Top]));
	debug("Right: " + string(_cutPixelsOnSides[Position.Right]));
	debug("Bottom: " + string(_cutPixelsOnSides[Position.Bottom]));

	return [_resultGrid, _cutPixelsOnSides];



}
