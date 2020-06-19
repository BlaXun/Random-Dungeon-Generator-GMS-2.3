///	@function destroyMap(map);
///	@description			Destroys the given map
///	@param {ds_map} map		The map to destory
function destroyMap() {

	var _map = argument[0];

	if (!variable_global_exists("__maps")) {
		show_message("DEBUG: Could not delete given map. global.__maps was never initialized.");
		exit;
	}

	var _pos = ds_list_find_index(global.__maps, _map);
	ds_map_destroy(_map);

	if (_pos != -1) {
		ds_list_delete(global.__maps,_pos);	
	}
}
