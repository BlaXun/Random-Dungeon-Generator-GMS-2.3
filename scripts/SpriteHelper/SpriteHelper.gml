///	@function maximumDimensionFromSprites(sprites)
///	@description 
function maximumDimensionFromSprites(sprites) {
	var _currentMax = 0;
	var _width, _height;
	for (var _i=0;_i<array_length(sprites);_i++) {

		_width = sprite_get_width(sprites[_i]);
		_height = sprite_get_height(sprites[_i]);

		_currentMax = max(_currentMax, _width, _height);	
	}

	return _currentMax; 
}
