///	@function correctPlacedChamberPositionsOnDungeonPreset(dungeonPreset,croppedSpaces);
/// @description							Corrects the starting x and y position for all PlacedChambers on the given DungeonPreset using the given croppedSpaces-Array
///	@param {ds_map}			dungeonPreset	The dungeonPreset that holds the PlacedChambers
///	@param {array<real>}	croppedSpaces	A array with Position-Enum entries as key and pixels as value
function correctPlacedChamberPositionsOnDungeonPreset() {

	var _dungeonPreset = argument[0];
	var _croppedSpaces = argument[1];

	var _cropLeft = _croppedSpaces[Position.Left];
	var _cropTop = _croppedSpaces[Position.Top];
	var _placedChamber = undefined;

	var _placedChambersList = _dungeonPreset[? DungeonPresetProps.PlacedChambers];
	for (var _i=0;_i<ds_list_size(_placedChambersList);_i++) {
		_placedChamber = _placedChambersList[| _i];
		_placedChamber[? PlacedChamberProps.xPositionInDungeon] = _placedChamber[? PlacedChamberProps.xPositionInDungeon]-_cropLeft;
	
		//show_debug_message("Cropping from " + string(_placedChamber[? PlacedChamberProps.yPositionInDungeon]) + " to " + string(_placedChamber[? PlacedChamberProps.yPositionInDungeon]-_cropTop) + ". So we removed " + string(_cropTop));
	
		_placedChamber[? PlacedChamberProps.yPositionInDungeon] = _placedChamber[? PlacedChamberProps.yPositionInDungeon]-_cropTop;
	}




}
