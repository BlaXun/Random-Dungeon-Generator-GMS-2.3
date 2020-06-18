///	@function	findColorForColorAssignment(colorAssignments,assignmentToFindColorFor);
/// @description	Returns the color for the given ColorAssignment as found in the given colorAssignments-Map
/// @param {ds_map} colorAssignments		A ds_map that uses colors as key and ColorAssignment as value
/// @param {ColorAssignment}				The ColorAssignment to find the color for
function findColorForColorAssignment() {

	var _colorAssignments = argument[0];
	var _assignmentToFindColorFor = argument[1];

	var _key, _foundColor = noone;
	var _size = ds_map_size(_colorAssignments) ;
	_key = ds_map_find_first(_colorAssignments);

	for (var _i = 0; _i < _size; _i++;) {
   
		if (_colorAssignments[? _key] == _assignmentToFindColorFor) {
			_foundColor = _key;
			break;
		} 
		
		_key = ds_map_find_next(_colorAssignments, _key);    
	}

	return _foundColor;


}
