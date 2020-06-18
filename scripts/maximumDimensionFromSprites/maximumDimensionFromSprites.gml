///	@function maximumDimensionFromSprites(sprites)
///	@description 
function maximumDimensionFromSprites() {
	var _sprites = argument[0];

	var _currentMax = 0;
	var _dimensionSize;

	var _width, _height;
	for (i=0;i<array_length_1d(_sprites);i++) {

		_width = _dimensionSize = sprite_get_width(_sprites[i]);
		_height = _dimensionSize = sprite_get_height(_sprites[i]);

		_currentMax = max(_currentMax, _width, _height);	
	}

	return _currentMax; 


}
