///	@function newMap()
///	@description Creates a new map and stores it in a global list
function createMap() {

	if (!variable_global_exists("__maps")) {
		global.__maps = ds_list_create();
	}

	var _map = ds_map_create();
	ds_list_add(global.__maps, _map);

	return _map;
}

///	@function destroyMap(map);
///	@description			Destroys the given map
///	@param {ds_map} map		The map to destory
function destroyMap(mapToDestroy) {

	if (!variable_global_exists("__maps")) {
		show_message("DEBUG: Could not delete given map. global.__maps was never initialized.");
		exit;
	}

	var _pos = ds_list_find_index(global.__maps, mapToDestroy);
	ds_map_destroy(mapToDestroy);

	if (_pos != -1) {
		ds_list_delete(global.__maps,_pos);	
	}
}

///	@function destroyAllMaps()
///	@description Destroys all maps that were created using the "createMap"-function
function destroyAllMaps() {

	if (variable_global_exists("__maps")) {
	
		var mapReference = noone;	
		for (var _i=0;_i<ds_list_size(global.__maps);_i++) {		
			mapReference = global.__maps[| _i];
		
			if (ds_exists(mapReference,ds_type_map)) {
				ds_map_destroy(mapReference);
			}		
		}
	
		ds_list_clear(global.__maps);
	}
}
