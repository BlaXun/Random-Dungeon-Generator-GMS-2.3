///	@function		createPixelGridAndDatatypeGridFromSprite(sprite,colorAssignments,padding)
///	@description	Creates a pixel grid from the given sprite while only populating the grid with colors that
///					exist in the given list of colors. Padding can be applied.
///
///					Additionally a grid with datatype info is returned.
///
///	@param {real}	sprite					The index of the sprite that should get converted to pixel grid
/// @param {ds_map} colorAssignments		A map holding information about the colors that may be encountered
///	@param {real}	padding					Padding to add to the grid. This basicly adds a invisible border around the sprite on the grid
function createPixelGridAndDatatypeGridFromSprite() {

	var _sprite = argument[0];
	var _colorAssignments = argument[1];
	var _padding = argument[2];

	var _chamberSpriteWidth, _chamberSpriteHeight;
	_chamberSpriteWidth = sprite_get_width(_sprite);
	_chamberSpriteHeight = sprite_get_height(_sprite);

	var _pixelGrid = newGrid(_chamberSpriteWidth+(_padding*2),_chamberSpriteHeight+(_padding*2));
	var _pixelGridContents = newGrid(_chamberSpriteWidth+(_padding*2),_chamberSpriteHeight+(_padding*2));

	var _surf = surface_create(_chamberSpriteWidth, _chamberSpriteHeight);
	surface_set_target(_surf);
	draw_clear_alpha(c_black,0);
	draw_sprite(_sprite,0,0,0);

	//	As soon as padding is in use we do not populate the grid starting at 0,0 but we always have an offset
	//	that is equal for both x and y
	var _equalOffset = _padding;

	if (_padding != 0) {
	
		var _pixelGridWidth, _pixelGridHeight;
		_pixelGridWidth = ds_grid_width(_pixelGrid);
		_pixelGridHeight = ds_grid_height(_pixelGrid);
	
		ds_grid_set_region(_pixelGridContents,0,0,_pixelGridWidth,_padding-1,GridContentType.Padding);	//	Top-Left to Top-Right
		ds_grid_set_region(_pixelGridContents,0,0,_padding-1,_pixelGridHeight,GridContentType.Padding);	//	Top-Left to Bottom-Left
		ds_grid_set_region(_pixelGridContents,0,_pixelGridHeight-_padding,_pixelGridWidth-1,_pixelGridHeight-1,GridContentType.Padding);	//	Bottom-Left to Bottom-Right	
		ds_grid_set_region(_pixelGridContents,_pixelGridWidth-_padding,0,_pixelGridWidth+1,_pixelGridHeight,GridContentType.Padding);	//	Top-Right to Bottom-Right
	}

	var _pixelColor = noone;
	var _yPos, _xPos;
	for (_yPos=0;_yPos<_chamberSpriteHeight;_yPos++) {	
		for (_xPos=0;_xPos<_chamberSpriteWidth;_xPos++) {
		
			_pixelColor = surface_getpixel(_surf,_xPos,_yPos);
		
			var _colorMeaning = ds_map_find_value(_colorAssignments,_pixelColor);
			if (is_undefined(_colorMeaning) == false) {
				_pixelGrid[# _equalOffset+_xPos, _equalOffset+_yPos] = _pixelColor;
				_pixelGridContents[# _equalOffset+_xPos, _equalOffset+_yPos] = _colorMeaning;
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
