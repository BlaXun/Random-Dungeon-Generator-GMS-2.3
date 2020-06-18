///	@function destroyAllLists()
///	@description Destroys all lists that were created using the "newList"-function
function destroyAllLists() {

	if (variable_global_exists("__lists")) {
	
		var listReference = noone;
		var _i;
		for (_i=0;_i<ds_list_size(global.__lists);_i++) {		
			listReference = global.__lists[| _i];
		
			if (ds_exists(listReference,ds_type_list)) {
				ds_list_destroy(listReference);
			}		
		}
	
		ds_list_clear(global.__lists);
	}


}
