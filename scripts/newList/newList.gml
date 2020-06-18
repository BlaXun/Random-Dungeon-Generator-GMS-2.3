///	@function newList()
///	@description Creates a new list with the given dimension and stores it in a global list
function newList() {

	if (!variable_global_exists("__lists")) {
		global.__lists = ds_list_create();
	}

	var _list = ds_list_create();
	ds_list_add(global.__lists, _list);

	return _list;


}
