///	@function replaceValueGridOnValueTypeGrid(gridToReplaceWith,valueTypeGrid);
///	@description	Replaces the existing Values-Grid on the given ValueTypeGrid with the gridToReplaceWith
///	@param {ds_grid} gridToReplaceWith		The grid that should replace the existing grid
///	@param {ValueTypeGrid} valueTypeGrid	The ValueTypeGrid that should have its Values-Grid replaced
function replaceValueGridOnValueTypeGrid() {

	var _gridToReplaceWith = argument[0];
	var _valueTypeGrid = argument[1];

	var _existingValueGrid = valueGridFromValueTypeGrid(_valueTypeGrid);
	if (_existingValueGrid != noone) {
		destroyGrid(_existingValueGrid);
	}

	_valueTypeGrid[? ValueTypeGridProps.Values] = _gridToReplaceWith;


}
