/// @function valueGridFromValueTypeGrid(valueTypeGrid);
///	@description Returns the Values grid from the given valueTypeGrid
///	@param {ValueTypeGrid} valueTypeGrid	The ValueTypeGrid from which the Values grid should be returned
function valueGridFromValueTypeGrid() {

	var _valueTypeGrid = argument[0];
	return _valueTypeGrid[? ValueTypeGridProps.Values];


}
