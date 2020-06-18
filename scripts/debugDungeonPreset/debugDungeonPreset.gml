function debugDungeonPreset() {
	var _dungeonPreset = argument[0];

	debug("DUNGEON PRESET");
	debug("==============");
	debug("WidthInPixel: " +string(_dungeonPreset.widthInPixel));
	debug("HeightInPixel: " + string(_dungeonPreset.heightInPixel));
	debug("PlacedChambers (count): " + string(ds_list_size(_dungeonPreset.placedChambers)));
	debug("");
}
