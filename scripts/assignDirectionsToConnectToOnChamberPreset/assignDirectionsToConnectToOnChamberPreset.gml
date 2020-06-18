///	@function assignDirectionsToConnectToOnChamberPreset(chamberPreset);
///	@description	Depending on the connectors on the chamber preset we will set the directions the chamber could connect to
///	@param {ChamberPreset} chamberPreset	The chamber preset for which the directions should be set
function assignDirectionsToConnectToOnChamberPreset() {

	var _chamberPreset;
	_chamberPreset = argument[0];
	_chamberPreset[? ChamberPresetProps.AllowsConnectionOnAndFromLeftSide] = array_length_1d(_chamberPreset[? ChamberPresetProps.LeftFacingConnectors]) > 0;
	_chamberPreset[? ChamberPresetProps.AllowsConnectionOnAndFromRightSide] = array_length_1d(_chamberPreset[? ChamberPresetProps.RightFacingConnectors]) > 0;
	_chamberPreset[? ChamberPresetProps.AllowsConnectionOnAndFromTopSide] = array_length_1d(_chamberPreset[? ChamberPresetProps.UpFacingConnectors]) > 0;
	_chamberPreset[? ChamberPresetProps.AllowsConnectionOnAndFromBottomSide] = array_length_1d(_chamberPreset[? ChamberPresetProps.DownFacingConnectors]) > 0;


}
