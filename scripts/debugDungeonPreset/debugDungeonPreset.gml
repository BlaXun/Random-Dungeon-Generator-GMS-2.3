function debugDungeonPreset() {
	var _dungeonPreset = argument[0];

	debug("DUNGEON PRESET");
	debug("==============");
	debug("WidthInPixel: " +string(_dungeonPreset[? DungeonPresetProps.WidthInPixel]));
	debug("HeightInPixel: " + string(_dungeonPreset[? DungeonPresetProps.HeightInPixel]));
	debug("PlacedChambers (count): " + string(ds_list_size(_dungeonPreset[? DungeonPresetProps.PlacedChambers])));
	debug("");



}
