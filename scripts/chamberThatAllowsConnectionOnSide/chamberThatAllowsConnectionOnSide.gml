///	@function chamberThatAllowsConnectionOnSide(availableChamberPresets,sideToConnectOn,directionToExclude);
///	@description	Returns a ChamberPreset from the given available chamber presets that is compatible with the given chamber flow
///	@param {ds_list<ChamberPreset>}				availableChamberPresets	The list of available chamber presets to choose from
///	@param {Direction} sideToConnectOn			The side on which a connection must be possible
/// @param {ChamberFlow} directionToExclude		Do not return ChamberPresets that offer only this other direction beside the needed direction
///	@return	A ChamberPreset
function chamberThatAllowsConnectionOnSide() {

	var _availableChamberPresets, _direction, _directionToExclude;
	_availableChamberPresets = argument[0];
	_direction = argument[1];
	_directionToExclude = argument[2];

	var _neededFaceDirection = Direction.None;
	_neededFaceDirection = oppositeDirectionForDirection(_direction);

	var _compatibleChamberPresets = newList();
	var _currentPreset = undefined;
	var _sidesOnWhichConnectionsAreAllowed = newList();
	for (var _i=0;_i<ds_list_size(_availableChamberPresets);_i++) {	
	
		_currentPreset = _availableChamberPresets[| _i];
		_currentPreset.allSidesThatAllowConnections(_sidesOnWhichConnectionsAreAllowed);
	
		//	Check if the needed direction exists (this is where we want to connect to)
		if (ds_list_find_index(_sidesOnWhichConnectionsAreAllowed,_direction) != -1) {
		
			//	What sides remain after this one?
			ds_list_delete(_sidesOnWhichConnectionsAreAllowed, ds_list_find_index(_sidesOnWhichConnectionsAreAllowed,_direction));
			if (ds_list_size(_sidesOnWhichConnectionsAreAllowed) == 1 && ds_list_find_index(_sidesOnWhichConnectionsAreAllowed, _directionToExclude) != -1) {
				//	This chamber is not compatible because it offers no remaining sides from which it can build new conenctions
			} else {
				//	Found a compatible chamber
				_compatibleChamberPresets[| ds_list_size(_compatibleChamberPresets)] = _currentPreset;	
			}		
		}
	
		ds_list_clear(_sidesOnWhichConnectionsAreAllowed);
	}

	destroyList(_sidesOnWhichConnectionsAreAllowed);
	ds_list_shuffle(_compatibleChamberPresets);

	var _chamberPresetToReturn = _compatibleChamberPresets[| 0];
	destroyList(_compatibleChamberPresets);

	return _chamberPresetToReturn;


}
