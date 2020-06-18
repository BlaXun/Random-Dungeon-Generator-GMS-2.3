function debugChamberPreset() {
	var _chamberPreset = argument[0];

	debug("CHAMBER PRESET");
	debug("===============");
	debug("TotalHeight: " +string(_chamberPreset[? ChamberPresetProps.TotalHeight]));
	debug("TotalWidth: " + string(_chamberPreset[? ChamberPresetProps.TotalWidth]));
	debug("LeftFacingConnectors: " + string(_chamberPreset[? ChamberPresetProps.LeftFacingConnectors]));
	debug("UpFacingConnectors: " + string(_chamberPreset[? ChamberPresetProps.UpFacingConnectors]));
	debug("RightFacingConnectors: " + string(_chamberPreset[? ChamberPresetProps.RightFacingConnectors]));
	debug("DownFacingConnectors: " + string(_chamberPreset[? ChamberPresetProps.DownFacingConnectors]));
	debug("AllConnectors: " + string(_chamberPreset[? ChamberPresetProps.AllConnectors]));
	debug("Sprite: " + sprite_get_name(_chamberPreset[? ChamberPresetProps.Sprite]));
	debug("Padding: " + string(_chamberPreset[? ChamberPresetProps.Padding]));
	debug("");



}
