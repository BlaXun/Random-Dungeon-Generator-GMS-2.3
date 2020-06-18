///	@function emptyDungeonPreset()
///	@description	Creates an empty dungeon preset (ds_map)
function emptyDungeonPreset() {

	enum DungeonPresetProps {
		ValueTypeGrid,
		WidthInPixel,
		HeightInPixel,
		ColorAssignments,
		PlacedChambers
	}

	var _dungeonPreset = newMap();
	_dungeonPreset[? DungeonPresetProps.ValueTypeGrid] = newValueTypeGrid(global.__initialDungeonDimensions, global.__initialDungeonDimensions,true);
	_dungeonPreset[? DungeonPresetProps.WidthInPixel] = global.__initialDungeonDimensions;
	_dungeonPreset[? DungeonPresetProps.HeightInPixel] = global.__initialDungeonDimensions;
	_dungeonPreset[? DungeonPresetProps.ColorAssignments] = undefined;
	_dungeonPreset[? DungeonPresetProps.PlacedChambers] = newList();

	return _dungeonPreset;


}
