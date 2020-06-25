enum GridContent {
	Empty = -1
}

/*	@function createGrid(width, height);

	@description			Creates a new grid with the given dimension and stores it in a global list
	
	@param {real} width		The width of the grid that will be created
	@param {real} height	The height of the grid that will be created	*/
function createGrid(width,height) {

	if (!variable_global_exists("__grids")) {
		global.__grids = ds_list_create();
	}

	var _grid = ds_grid_create(width, height);
	ds_grid_clear(_grid,GridContent.Empty);
	
	ds_list_add(global.__grids, _grid);

	return _grid;
}

/*	@function	destroyGrid(grid);
	@description			Destroys the given grid	
	@param {ds_grid} grid	The grid to destory	*/
function destroyGrid(gridToDestroy) {

	if (!variable_global_exists("__grids")) {
		show_message("DEBUG: Could not delete given grid. global.__grids was never initialized.");
		exit;
	}

	var _pos = ds_list_find_index(global.__grids, gridToDestroy);
	ds_grid_destroy(gridToDestroy);

	if (_pos != -1) {
		ds_list_delete(global.__grids,_pos);	
	}
}

/*	@function destroyAllGrids();
	@description Destroys all grids that were created using the "createGrid"-function	*/
function destroyAllGrids() {

	if (variable_global_exists("__grids")) {
	
		var gridReference = noone;	
		for (var _i=0;_i<ds_list_size(global.__grids);_i++) {		
			gridReference = global.__grids[| _i];
		
			if (ds_exists(gridReference,ds_type_grid)) {
				ds_grid_destroy(gridReference);
			}		
		}
	
		ds_list_clear(global.__grids);
	}
}

/*	@function croppedGridFromGrid(grid);
	@description				Returns a cropped grid from the given grid. 
								Make sure to delete the provided grid if it would be replaced by the cropped grid

	@param {ds_grid} grid	The grid for which a cropped grid should be returned
	@return	An array with two values. 0=The cropped Grid, 1=Array with amount of pixel that were cut on each side	*/
function croppedGridFromGrid(gridToCrop) {

	var _xStart = 0, _yStart = 0, _xEnd = 0, _yEnd = 0;
	var _cutPixelsOnSides = [];
	_cutPixelsOnSides[Position.Top] = 0;
	_cutPixelsOnSides[Position.Right] = 0;
	_cutPixelsOnSides[Position.Bottom] = 0;
	_cutPixelsOnSides[Position.Left] = 0;

	var _gridWidth, _gridHeight;
	_gridWidth = ds_grid_width(gridToCrop);
	_gridHeight = ds_grid_height(gridToCrop);
	
	for (var _yPos=0;_yPos<_gridHeight;_yPos+=1) {
		if (ds_grid_get_max(gridToCrop,0,_yPos,_gridWidth-1,_yPos) != GridContent.Empty) {
			_yStart = _yPos;
			break;
		}
	}

	for (var _yPos=_gridHeight-1;_yPos>=0;_yPos-=1) {
		if (ds_grid_get_max(gridToCrop,0,_yPos,_gridWidth-1,_yPos) != GridContent.Empty) {
			_yEnd = _yPos+1;
			break;
		}
	}

	for (var _xPos=0;_xPos<_gridWidth;_xPos+=1) {
		if (ds_grid_get_max(gridToCrop,_xPos,0,_xPos,_gridHeight-1) != GridContent.Empty) {
			_xStart = _xPos;
			break;
		}
	}

	for (var _xPos=_gridWidth-1;_xPos>=0;_xPos-=1) {
		if (ds_grid_get_max(gridToCrop,_xPos,0,_xPos,_gridHeight-1) != GridContent.Empty) {
			_xEnd = _xPos+1;
			break;
		}
	}

	var _resultGrid = createGrid(_xEnd-_xStart,_yEnd-_yStart);
	ds_grid_set_grid_region(_resultGrid,gridToCrop,_xStart,_yStart,_xEnd,_yEnd,0,0);

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

/*	@function checkForCollisionWithChildGridOnParentGrid(childGrid,parentGrid)

	@description	Checks wether the childGrid would collide with any column/row on the parentGrid that has a value other than noone

	@param {ds_grid} childGrid	The grid that will be placed on the parentGrid
	@param {ds_grid} parentGrid	The grid that gets the childGrid placed on it
	@param {real} xOffset		An offset on the x-axis defining where the childGrid shall be placed on the parentGrid
	@param {real} yOffset		An offset on the y-axis defining where the childGrid shall be placed on the parentGrid
	@returns {boolean}			Wether a collision was detected	*/
function checkForCollisionWithChildGridOnParentGrid(childGrid, parentGrid, x, y) {

	var didFindCollision = false;

	for (var _yPos=y;_yPos<y+ds_grid_height(childGrid);_yPos+=1) {
		for (var _xPos=x;_xPos<x+ds_grid_width(childGrid);_xPos+=1) {
	
			if (ds_grid_get(parentGrid,_xPos,_yPos) != GridContent.Empty) {
				didFindCollision = true;
				break;
			}
		}
	}

	return didFindCollision;
}

/*	@function		createPixelGridAndDatatypeGridFromSprite(sprite,colorAssignments,padding)
	@description	Creates a pixel grid from the given sprite while only populating the grid with colors that
					exist in the given list of colors. Padding can be applied.

					Additionally a grid with datatype info is returned.

	@param {real} spriteIndex					The index of the sprite that should get converted to pixel grid
	@param {ColorAssignment} colorAssignments	A ColorAssignment-Struct that describes colors and their meaning	*/
function createPixelGridAndDatatypeGridFromSprite(spriteIndex, colorAssignments) {

	var _chamberSpriteWidth, _chamberSpriteHeight;
	_chamberSpriteWidth = sprite_get_width(spriteIndex);
	_chamberSpriteHeight = sprite_get_height(spriteIndex);

	var _pixelGrid = createGrid(_chamberSpriteWidth,_chamberSpriteHeight);	
	var _pixelGridContents = createGrid(_chamberSpriteWidth,_chamberSpriteHeight);
	ds_grid_clear(_pixelGridContents, ColorMeaning.Unknown);

	var _surf = surface_create(_chamberSpriteWidth, _chamberSpriteHeight);
	surface_set_target(_surf);
	draw_clear_alpha(c_black,0);
	draw_sprite(spriteIndex,0,0,0);
	
	var _pixelColor = noone;
	for (var _yPos=0;_yPos<_chamberSpriteHeight;_yPos++) {	
		for (var _xPos=0;_xPos<_chamberSpriteWidth;_xPos++) {
		
			_pixelColor = surface_getpixel(_surf,_xPos,_yPos);
		
			var _colorMeaning = colorAssignments.meaningForColor(_pixelColor);
			if (_colorMeaning != ColorMeaning.Unknown) {	
				_pixelGrid[# _xPos, _yPos] = _pixelColor;
				_pixelGridContents[# _xPos, _yPos] = _colorMeaning;			
			}
		}
	}

	surface_reset_target();
	surface_free(_surf);

	var _gridsToReturn = [];
	_gridsToReturn[0] = _pixelGrid;
	_gridsToReturn[1] = _pixelGridContents;

	return _gridsToReturn;
}

/*	@function applyPaddingToGridWithValue(grid,padding,valueToSet);
	
	@description	Applies a padding to the mentioned grid using the values on the given padding struct and populating the new fields with the given value
	
	@param {ds_grid} grid		The grid on which padding should be applied
	@param {Padding} padding	A Padding-Struct containing the amount of padding to be applied to each side
	@param {any} valueToSet		The value to be applied to the newly created fields on the grid	*/
function applyPaddingToGridWithValue(grid,padding,valueToSet) {
	var _currentWidth, _currentHeight;
	_currentWidth = ds_grid_width(grid);
	_currentHeight = ds_grid_height(grid);
	
	var _newWidth, _newHeight;
	_newWidth = _currentWidth+padding.left+padding.right;
	_newHeight = _currentHeight+padding.top+padding.bottom;
	
	var _tempGrid = createGrid(_newWidth,_newHeight);
	ds_grid_clear(_tempGrid,valueToSet);
	ds_grid_set_grid_region(_tempGrid,grid,0,0,_currentWidth-1,_currentHeight-1,padding.left,padding.top);
	
	ds_grid_resize(grid,_newWidth,_newHeight);
	ds_grid_copy(grid,_tempGrid);
	
	destroyGrid(_tempGrid);
}

/*	@function setValueForCoordinatesOnGrid(valueToSet, coordinates, grid);

	@description	Sets the given values on all areas as defined by the given coordinates on the given grid
	
	@param {any} valueToSet					The value to be set
	@param {Array<Coordinate>} coordinates	A array with Coordinate-Struct entries
	@param {ds_grid} grid					The grid on which the value should be set	*/
function setValueForCoordinatesOnGrid(valueToSet, coordinates, grid) {
	
	var _currentCoordinates = undefined;
	for (var _i=0;_i<array_length(coordinates);_i++) {
		_currentCoordinates = coordinates[_i];
		ds_grid_set_region(grid,_currentCoordinates.x,_currentCoordinates.y,_currentCoordinates.xEnd,_currentCoordinates.yEnd,valueToSet);
	}
}