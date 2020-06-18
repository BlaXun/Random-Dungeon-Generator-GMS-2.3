///	@function destroyAllMaps()
///	@description Destroys all maps that were created using the "newMap"-function
function destroyAllMaps() {

	if (variable_global_exists("__maps")) {
	
		var mapReference = noone;	
		var _i;
		for (_i=0;_i<ds_list_size(global.__maps);_i++) {		
			mapReference = global.__maps[| _i];
		
			if (ds_exists(mapReference,ds_type_map)) {
				ds_map_destroy(mapReference);
			}		
		}
	
		ds_list_clear(global.__maps);
	}


}
