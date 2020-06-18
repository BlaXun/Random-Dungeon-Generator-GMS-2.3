function compatibleChamberPresetForDirection() {
	//	TODO: KANN VERMUTLICH WEG!!!!!
	// WURDE ERSTZT DURCH chamberThatAllowsConnectionOnSide

	///	@function compatibleChamberPresetForDirection(availableChamberPresets,direction,directionToExclude);
	///	@description	Returns a ChamberPreset from the given available chamber presets that is compatible with the given chamber flow
	///	@param {ds_list<ChamberPreset>}				availableChamberPresets	The list of available chamber presets to choose from
	///	@param {Direction} direction				The Direction for which the ChamberPreset should offer a connection
	/// @param {ChamberFlow} directionToExclude		Do not return ChamberPresets that offer only this other direction beside the needed direction
	///	@return	A ChamberPreset

	var _availableChamberPresets, _direction, _directionToExclude;
	_availableChamberPresets = argument[0];
	_direction = argument[1];
	_directionToExclude = argument[2];

	var _neededFaceDirection = Direction.None;
	_neededFaceDirection = oppositeDirectionForDirection(_direction);

	var _compatibleChamberPresets = newList();
	var _currentPreset = undefined;
	for (var _i=0;_i<ds_list_size(_availableChamberPresets);_i++) {	
		_currentPreset = _availableChamberPresets[| _i];
	
		if (chamberPresetHasConnectorsWithDirection(_currentPreset,_neededFaceDirection) == true) {
			_compatibleChamberPresets[| ds_list_size(_compatibleChamberPresets)] = _currentPreset;
		}
	}

	//	TODO: What to do if there is no compatible chamber!?
	ds_list_shuffle(_compatibleChamberPresets);

	var _chamberPresetToReturn = _compatibleChamberPresets[| 0];
	destroyList(_compatibleChamberPresets);

	return _chamberPresetToReturn;


}
