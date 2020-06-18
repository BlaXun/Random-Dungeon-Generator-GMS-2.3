///	@function setValueAndTypeOnValueTypeGrid(value,type,x,y,valueTypeGrid);
///	@description	Sets the given value and type on the given position on the given valueTypeGrid
/// @param value {any}						The value to set
/// @param {ValueTypeGridProps}	type		The type of the value that was set
///	@param {real} x							The x-position on the grid
///	@param {real} y							The y-position on the grid
///	@param {ValueTypeGrid} valueTypeGrid	The ValueTypeGrid on which the value and type should be set
function setValueAndTypeOnValueTypeGrid() {

	var _valueTypeGrid, _valueToSet, _typeOfTheValue, _xPos, _yPos;
	_valueToSet = argument[0];
	_typeOfTheValue = argument[1];
	_xPos = argument[2];
	_yPos = argument[3];
	_valueTypeGrid = argument[4];

	var _values = _valueTypeGrid[? ValueTypeGridProps.Values];
	_values[# _xPos, _yPos] = _valueToSet;

	var _types = _valueTypeGrid[? ValueTypeGridProps.Types];
	_types[# _xPos, _yPos] = _typeOfTheValue;


}
