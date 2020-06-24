/*	@function ValueTypeGrid(width,height,generateGrids);
	@description Creates a new Value-Type Grid

	A Value-Type grid encapsulates both a grid for whatever content and a second grid that holds information about the
	Datatype that is stored at the same place as the value.
	
	Default type for all positions is GridContent.Empty

	@param {real} width				Width of the grid
	@param {real} height			Height of the grid
	@param {boolean} generateGrids	Wether the ValueTypeGrid should initialize both its' Value and Type Grid	*/
function ValueTypeGrid(width,height,generateGrids) constructor {

	self.width = width;
	self.height = height;
	
	self.values = generateGrids == true ? createGrid(width,height) : undefined;
	self.types = generateGrids == true ? createGrid(width,height) : undefined;
	
	/*	@function replaceValueAndTypeGrid(newValueGrid,newTypeGrid);
		@description Replaces the existing Types-Grid on the given ValueTypeGrid with the gridToReplaceWith
		@param {ds_grid} newValueGrid		The ds_grid to replace the existing value grid
		@param {ds_grid} newTypeGrid		The ds_grid to replace the existing type grid */
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

	/*	@function applyPadding(paddingToApply);
		@description	Applies the given padding to the current version of both the value and type grid
						and fills the new fields with the given values
						
		@param {Padding} paddingToApply A Padding-Struct which contains the padding for each side
		@param {any} valueGridValue	The value to be applied for the new fields on the value grid
		@param {any} typeGridValue	The value to be applied for the new fields on the type grid
	*/
	static applyPadding = function(paddingToApply,valueGridValue,typeGridValue) {
		
		applyPaddingToGridWithValue(self.values,paddingToApply,valueGridValue);
		applyPaddingToGridWithValue(self.types,paddingToApply,typeGridValue);
		
		self.width = ds_grid_width(self.types);
		self.height = ds_grid_height(self.types);
	}
}
