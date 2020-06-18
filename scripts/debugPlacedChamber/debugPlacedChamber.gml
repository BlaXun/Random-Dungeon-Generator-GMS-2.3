function debugPlacedChamber() {
	var _placedChamber = argument[0];

	debug("PLACED CHAMBER");
	debug("===============");

	var _chamberPreset = _placedChamber[? PlacedChamberProps.ChamberPreset];
	debug("ChamberPreset: " +string(_chamberPreset));
	debug("NextChambers (size): " + string(ds_list_size(_placedChamber[? PlacedChamberProps.NextChambers])));
	debug("PreviousChambers (size): " + string(ds_list_size(_placedChamber[? PlacedChamberProps.PreviousChambers])));
	debug("xPositionInDungeon: " + string(_placedChamber[? PlacedChamberProps.xPositionInDungeon]));
	debug("yPositionInDungeon: " + string(_placedChamber[? PlacedChamberProps.yPositionInDungeon]));
	debug("Sprite: " + sprite_get_name(_chamberPreset.sprite));

	debug("");


}
