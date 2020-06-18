///	@function placedChamberFromChamberPreset(chamberPreset);
///	@description Creates a PlacedChamber based on the given ChamberPreset
///	@param {ChamberPreset} chamberPreset	The chamberPreset used by the PlacedChamber
function placedChamberFromChamberPreset() {
	var _chamberPreset, _placedChamber;
	_chamberPreset = argument[0];

	_placedChamber = emptyPlacedChamber();
	_placedChamber[? PlacedChamberProps.ChamberPreset] = _chamberPreset;
	_placedChamber[? PlacedChamberProps.AllowsConnectionOnAndFromBottomSide] = _chamberPreset[? ChamberPresetProps.AllowsConnectionOnAndFromBottomSide];
	_placedChamber[? PlacedChamberProps.AllowsConnectionOnAndFromTopSide] = _chamberPreset[? ChamberPresetProps.AllowsConnectionOnAndFromTopSide];
	_placedChamber[? PlacedChamberProps.AllowsConnectionOnAndFromLeftSide] = _chamberPreset[? ChamberPresetProps.AllowsConnectionOnAndFromLeftSide];
	_placedChamber[? PlacedChamberProps.AllowsConnectionOnAndFromRightSide] = _chamberPreset[? ChamberPresetProps.AllowsConnectionOnAndFromRightSide];

	return _placedChamber;



}
