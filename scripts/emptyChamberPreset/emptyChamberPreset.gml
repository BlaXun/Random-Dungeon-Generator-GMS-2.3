///	@function emptyChamberPreset()
///	@description	Creates an empty chamber-preset (ds_map) and returns it
function emptyChamberPreset() {

	enum ChamberPresetProps {
		ValueTypeGrid,
		LeftFacingConnectors,
		RightFacingConnectors,
		UpFacingConnectors,
		DownFacingConnectors,
		AllConnectors,
		Sprite,
		TotalWidth,
		TotalHeight,
		Padding,
		AllowsConnectionOnAndFromRightSide,
		AllowsConnectionOnAndFromLeftSide,
		AllowsConnectionOnAndFromTopSide,
		AllowsConnectionOnAndFromBottomSide
	}

	var _chamberPreset = newMap();
	_chamberPreset[? ChamberPresetProps.LeftFacingConnectors] = [];
	_chamberPreset[? ChamberPresetProps.RightFacingConnectors] = [];
	_chamberPreset[? ChamberPresetProps.UpFacingConnectors] = [];
	_chamberPreset[? ChamberPresetProps.DownFacingConnectors] = [];
	_chamberPreset[? ChamberPresetProps.AllConnectors] = [];
	_chamberPreset[? ChamberPresetProps.ValueTypeGrid] = noone;
	_chamberPreset[? ChamberPresetProps.Sprite] = noone;
	_chamberPreset[? ChamberPresetProps.TotalWidth] = 0;
	_chamberPreset[? ChamberPresetProps.TotalHeight] = 0;
	_chamberPreset[? ChamberPresetProps.Padding] = 0;
	_chamberPreset[? ChamberPresetProps.AllowsConnectionOnAndFromRightSide] = false;
	_chamberPreset[? ChamberPresetProps.AllowsConnectionOnAndFromLeftSide] = false;
	_chamberPreset[? ChamberPresetProps.AllowsConnectionOnAndFromTopSide] = false;
	_chamberPreset[? ChamberPresetProps.AllowsConnectionOnAndFromBottomSide] = false;

	return _chamberPreset;


}
