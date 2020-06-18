///	@function randomDirectionFromPlacedChamberDirections(placedChamber);
///	@description	Returns a direction out of the available directions to connect to that are active on this PlacedChamber
///	@param {PlacedChamber} placedChamber	The placed chamber from which a direction should be returned
/// @return {Direction}
function randomDirectionFromPlacedChamberDirections() {

	var _placedChamber;
	_placedChamber = argument[0];

	var _availableDirections = [];

	if (_placedChamber[? PlacedChamberProps.AllowsConnectionOnAndFromBottomSide]) {	
		_availableDirections[array_length_1d(_availableDirections)] = Direction.Down;
	}

	if (_placedChamber[? PlacedChamberProps.AllowsConnectionOnAndFromTopSide]) {
		_availableDirections[array_length_1d(_availableDirections)] = Direction.Up;
	}

	if (_placedChamber[? PlacedChamberProps.AllowsConnectionOnAndFromRightSide]) {
		_availableDirections[array_length_1d(_availableDirections)] = Direction.Right;
	}

	if (_placedChamber[? PlacedChamberProps.AllowsConnectionOnAndFromLeftSide]) {
		_availableDirections[array_length_1d(_availableDirections)] = Direction.Left;
	}

	var _size = array_length_1d(_availableDirections);
	var _directionToReturn = undefined;
	_directionToReturn = _size != 0 ? _availableDirections[floor(random(array_length_1d(_availableDirections)))] : Direction.None; 

	return _directionToReturn;


}
