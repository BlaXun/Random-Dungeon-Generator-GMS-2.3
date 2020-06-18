/// @function chamberPresetHasConnectorsWithDirection(chamberPreset,Direction);
///	@description	Checks if the given ChamberPreset contains at least one Connector with the given Direction
/// @param {ChamberPreset} chamberPreset						The ChamberPreset that will be checked
///	@param {Direction} Direction	The Direction we are looking for
///	@return ture/false
function chamberPresetHasConnectorsWithDirection() {

	var _chamberPreset, _requestedDirection;
	_chamberPreset = argument[0];
	_requestedDirection = argument[1];

	var _didFindRequestedFacingDirection = false;

	//	TODO: Would it be faste to check the size of the ChamberPresetProps.LeftConnectors etc. lists?
	var _allConnectors = _chamberPreset[? ChamberPresetProps.AllConnectors];
	var _connector = undefined;
	for (var _i=0;_i<array_length_1d(_allConnectors);_i++) {
		_connector = _allConnectors[_i];
	
		if (_connector[? ConnectorPresetProps.FacingDirection] == _requestedDirection) {
			_didFindRequestedFacingDirection = true;
			break;
		}
	}

	return _didFindRequestedFacingDirection;


}
