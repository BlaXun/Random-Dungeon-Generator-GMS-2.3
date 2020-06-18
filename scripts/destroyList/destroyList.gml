///	@function	destroyList(list);
///	@description			Destroys the given list
///	@param {ds_list} list	The list to destory
function destroyList() {

	var _list = argument[0];

	if (!variable_global_exists("__lists")) {
		show_message("DEBUG: Could not delete given list. global.__listswas never initialized.");
		exit;
	}

	var _pos = ds_list_find_index(global.__lists, _list);
	ds_list_destroy(_list);

	if (_pos != -1) {
		ds_list_delete(global.__lists,_pos);	
	}




}
