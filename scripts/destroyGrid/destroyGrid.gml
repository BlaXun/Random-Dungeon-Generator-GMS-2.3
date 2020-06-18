///	@function	destroyGrid(grid);
///	@description			Destroys the given grid
///	@param grid {ds_grid}	The grid to destory
function destroyGrid() {

	var _grid = argument[0];

	if (!variable_global_exists("__grids")) {
		show_message("DEBUG: Could not delete given grid. global.__grids was never initialized.");
		exit;
	}

	var _pos = ds_list_find_index(global.__grids, _grid);
	ds_grid_destroy(_grid);

	if (_pos != -1) {
		ds_list_delete(global.__grids,_pos);	
	}




}
