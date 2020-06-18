///	@function newGrid(width, height)
///	@description			Creates a new grid with the given dimension and stores it in a global list
///	@param {real} width		The width of the grid that will be created
///	@param {real} height	The height of the grid that will be created
function newGrid() {


	var _width, _height;
	_width = argument[0];
	_height = argument[1];

	if (!variable_global_exists("__grids")) {
		global.__grids = ds_list_create();
	}

	var _grid = ds_grid_create(_width, _height);
	ds_grid_clear(_grid,noone);
	ds_list_add(global.__grids, _grid);

	return _grid;


}
