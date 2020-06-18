///	@function replaceTypeGridOnValueTypeGrid(gridToReplaceWith,valueTypeGrid);
///	@description	Replaces the existing Types-Grid on the given ValueTypeGrid with the gridToReplaceWith
///	@param {ds_grid} gridToReplaceWith		The grid that should replace the existing grid
///	@param {ValueTypeGrid} valueTypeGrid	The ValueTypeGrid that should have its Types-Grid replaced
function replaceTypeGridOnValueTypeGrid() {

	var _gridToReplaceWith = argument[0];
	var _valueTypeGrid = argument[1];

	var _existingTypesGrid = typeGridFromValueTypeGrid(_valueTypeGrid);
	if (_existingTypesGrid != noone) {
		destroyGrid(_existingTypesGrid);
	}

	_valueTypeGrid[? ValueTypeGridProps.Types] = _gridToReplaceWith;


}
