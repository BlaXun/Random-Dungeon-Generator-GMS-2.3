///	@function newValueTypeGrid(width,height,prePopulate);
///	@description Creates a new Value-Type Grid
///
///	A Value-Type grid encapsulates both a grid for whatever content and a second grid that holds information about the
///	Datatype that is stored at the same place as the value. The Datatype conforms to the GridContentType-Enum.
///	Default type for all positions is noone
///
///	@param {real} width				Width of the grid
/// @param {real} height			Height of the grid
/// @param {boolean} prePopulate	Wether the ValueTypeGrid should initialize both its' Value and Type Grid
function ValueTypeGrid(width,height,generateGrids) constructor {

	self.width = width;
	self.height = height;
	
	self.values = generateGrids == true ? createGrid(width,height) : undefined;
	self.types = generateGrids == true ? createGrid(width,height) : undefined;
	
	///	@function replaceTypeGridOnValueTypeGrid(gridToReplaceWith,valueTypeGrid);
	///	@description	Replaces the existing Types-Grid on the given ValueTypeGrid with the gridToReplaceWith
	///	@param {ds_grid} gridToReplaceWith		The grid that should replace the existing grid
	///	@param {ValueTypeGrid} valueTypeGrid	The ValueTypeGrid that should have its Types-Grid replaced
	static replaceValueAndTypeGrid = function(newValueGrid, newTypeGrid) {

		if (is_undefined(self.types) == false) {
			destroyGrid(self.types);
		}
		
		self.types = newTypeGrid;
		
		if (is_undefined(self.values) == false) {
			destroyGrid(self.values);
		}

		self.values = newValueGrid;
		
		self.width = ds_grid_width(self.types);
		self.height = ds_grid_height(self.types);
	}

	///	@function setValueAndTypeForAreaOnValueTypeGrid(value,type,xStart,yStart,xEnd,yEnd,valueTypeGrid);
	///	@description							Sets the given value and type on the given area on the given valueTypeGrid
	/// @param value {any}						The value to set
	/// @param {ValueTypeGridProps}	type		The type of the value that was set
	///	@param {real} xStart					The starting x-position on the grid
	///	@param {real} yStart					The starting y-position on the grid
	///	@param {real} xEnd						The end x-position on the grid
	///	@param {real} yEnd						The end y-position on the grid
	///	@param {ValueTypeGrid} valueTypeGrid	The ValueTypeGrid on which the value and type should be set
	static setValueAndTypeForArea = function(value,type,xStart,yStart,xEnd,yEnd) {
		ds_grid_set_region(self.values,xStart,yStart,xEnd,yEnd,value);
		ds_grid_set_region(self.types,xStart,yStart,xEnd,yEnd,type);
	}
	
	///	@function setValueAndTypeOnValueTypeGrid(value,type,x,y,valueTypeGrid);
	///	@description	Sets the given value and type on the given position on the given valueTypeGrid
	/// @param value {any}						The value to set
	/// @param {ValueTypeGridProps}	type		The type of the value that was set
	///	@param {real} x							The x-position on the grid
	///	@param {real} y							The y-position on the grid
	///	@param {ValueTypeGrid} valueTypeGrid	The ValueTypeGrid on which the value and type should be set
	static setValueAndType = function(value,type,x,y) {
		self.values[# x, y] = value;
		self.types[# x, y] = type;
	}
}
