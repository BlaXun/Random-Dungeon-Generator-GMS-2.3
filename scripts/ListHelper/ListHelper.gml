///	@function createList()
///	@description Creates a new list with the given dimension and stores it in a global list
function createList() {

	if (!variable_global_exists("__lists")) {
		global.__lists = ds_list_create();
	}

	var _list = ds_list_create();
	ds_list_add(global.__lists, _list);

	return _list;
}

///	@function	destroyList(list);
///	@description			Destroys the given list
///	@param {ds_list} list	The list to destory
function destroyList(listToDestroy) {

	if (!variable_global_exists("__lists")) {
		show_message("DEBUG: Could not delete given list. global.__listswas never initialized.");
		exit;
	}

	var _pos = ds_list_find_index(global.__lists, listToDestroy);
	ds_list_destroy(listToDestroy);

	if (_pos != -1) {
		ds_list_delete(global.__lists,_pos);	
	}
}

///	@function destroyAllLists()
///	@description Destroys all lists that were created using the "createList"-function
function destroyAllLists() {

	if (variable_global_exists("__lists")) {
	
		var listReference = noone;
		for (var _i=0;_i<ds_list_size(global.__lists);_i++) {		
			listReference = global.__lists[| _i];
		
			if (ds_exists(listReference,ds_type_list)) {
				ds_list_destroy(listReference);
			}		
		}
	
		ds_list_clear(global.__lists);
	}
}


