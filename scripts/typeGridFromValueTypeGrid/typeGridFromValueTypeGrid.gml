/// @function typeGridFromValueTypeGrid(valueTypeGrid);
///	@description Returns the Types grid from the given valueTypeGrid
///	@param {ValueTypeGrid} valueTypeGrid	The ValueTypeGrid from which the Types grid should be returned
function typeGridFromValueTypeGrid() {

	var _valueTypeGrid = argument[0];
	return _valueTypeGrid[? ValueTypeGridProps.Types];
}
