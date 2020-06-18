///	@function newMap()
///	@description Creates a new map and stores it in a global list
function newMap() {

	if (!variable_global_exists("__maps")) {
		global.__maps = ds_list_create();
	}

	var _map = ds_map_create();
	ds_list_add(global.__maps, _map);

	return _map;


}
