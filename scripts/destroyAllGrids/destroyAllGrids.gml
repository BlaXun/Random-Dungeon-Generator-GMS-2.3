///	@function destroyAllGrids()
///	@description Destroys all grids that were created using the "newGrid"-function
function destroyAllGrids() {

	if (variable_global_exists("__grids")) {
	
		var gridReference = noone;	
		var _i;
		for (_i=0;_i<ds_list_size(global.__grids);_i++) {		
			gridReference = global.__grids[| _i];
		
			if (ds_exists(gridReference,ds_type_grid)) {
				ds_grid_destroy(gridReference);
			}		
		}
	
		ds_list_clear(global.__grids);
	}


}
