///	@function placedChamberFromChamberPreset(chamberPreset);
///	@description Creates a PlacedChamber based on the given ChamberPreset
///	@param {ChamberPreset} chamberPreset	The chamberPreset used by the PlacedChamber
function placedChamberFromChamberPreset() {
	var _chamberPreset, _placedChamber;
	_chamberPreset = argument[0];

	_placedChamber = emptyPlacedChamber();
	_placedChamber[? PlacedChamberProps.ChamberPreset] = _chamberPreset;
	_placedChamber[? PlacedChamberProps.AllowsConnectionOnAndFromBottomSide] = _chamberPreset.allowsConnectionOnAndFromBottomSide;
	_placedChamber[? PlacedChamberProps.AllowsConnectionOnAndFromTopSide] = _chamberPreset.allowsConnectionOnAndFromTopSide;
	_placedChamber[? PlacedChamberProps.AllowsConnectionOnAndFromLeftSide] = _chamberPreset.allowsConnectionOnAndFromLeftSide;
	_placedChamber[? PlacedChamberProps.AllowsConnectionOnAndFromRightSide] = _chamberPreset.allowsConnectionOnAndFromRightSide;

	return _placedChamber;
}
