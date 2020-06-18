///	@function setValueAndTypeForAreaOnValueTypeGrid(value,type,xStart,yStart,xEnd,yEnd,valueTypeGrid);
///	@description							Sets the given value and type on the given area on the given valueTypeGrid
/// @param value {any}						The value to set
/// @param {ValueTypeGridProps}	type		The type of the value that was set
///	@param {real} xStart					The starting x-position on the grid
///	@param {real} yStart					The starting y-position on the grid
///	@param {real} xEnd						The end x-position on the grid
///	@param {real} yEnd						The end y-position on the grid
///	@param {ValueTypeGrid} valueTypeGrid	The ValueTypeGrid on which the value and type should be set
function setValueAndTypeForAreaOnValueTypeGrid() {

	var _valueToSet, _typeOfTheValue, _xStart, _yStart, _xEnd, _yEnd, _valueTypeGrid;
	_valueToSet = argument[0];
	_typeOfTheValue = argument[1];
	_xStart = argument[2];
	_yStart = argument[3];
	_xEnd = argument[4];
	_yEnd = argument[5];
	_valueTypeGrid = argument[6];

	var _values = _valueTypeGrid[? ValueTypeGridProps.Values];
	ds_grid_set_region(_values,_xStart,_yStart,_xEnd,_yEnd,_valueToSet);

	var _types = _valueTypeGrid[? ValueTypeGridProps.Types];
	ds_grid_set_region(_types,_xStart,_yStart,_xEnd,_yEnd,_typeOfTheValue);


}
