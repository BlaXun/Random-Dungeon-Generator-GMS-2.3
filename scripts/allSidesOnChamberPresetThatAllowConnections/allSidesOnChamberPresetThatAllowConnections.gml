///	@function allSidesOnChamberPresetThatAllowConnections(chamberPreset,listToPopulate);
///	@description	Populates the given list with all sides (Direction) on which the given ChamberPreset allows a connection
///	@param {ChamberPreset} chamberPreset	The chamber preset for which the sides should be returned
/// @param {ds_list} listToPopulate			The list which will get all the sides (Direction) assigned
function allSidesOnChamberPresetThatAllowConnections() {

	var _chamberPreset, _listToPopulate;
	_chamberPreset = argument[0];
	_listToPopulate = argument[1];

	if (_chamberPreset[? ChamberPresetProps.AllowsConnectionOnAndFromLeftSide]) {
		_listToPopulate[| ds_list_size(_listToPopulate)] = Direction.Left;
	}

	if (_chamberPreset[? ChamberPresetProps.AllowsConnectionOnAndFromRightSide]) {
		_listToPopulate[| ds_list_size(_listToPopulate)] = Direction.Right;
	}

	if (_chamberPreset[? ChamberPresetProps.AllowsConnectionOnAndFromTopSide]) {
		_listToPopulate[| ds_list_size(_listToPopulate)] = Direction.Up;
	}

	if (_chamberPreset[? ChamberPresetProps.AllowsConnectionOnAndFromBottomSide]) {
		_listToPopulate[| ds_list_size(_listToPopulate)] = Direction.Down;
	}


}
