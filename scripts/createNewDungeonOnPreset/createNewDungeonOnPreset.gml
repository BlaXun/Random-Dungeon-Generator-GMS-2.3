function createNewDungeonOnPreset() {
	var _dungeonPreset, _chamberPresets, _amountOfChambersToPlace;
	_dungeonPreset = argument[0];
	_chamberPresets = argument[1];
	_amountOfChambersToPlace = argument[2];

	populateDungeonPresetWithChamberPresets(_dungeonPreset, _chamberPresets, _amountOfChambersToPlace);
	createHallwaysForDungeonPreset(_dungeonPreset);

	var valueTypeGridOnDungeonPreset, valueGridFromDungeonPresetValueTypeGrid, typeGridFromDungeonPresetValueTypeGrid;
	valueTypeGridOnDungeonPreset = _dungeonPreset[? DungeonPresetProps.ValueTypeGrid];
	valueGridFromDungeonPresetValueTypeGrid = valueGridFromValueTypeGrid(valueTypeGridOnDungeonPreset);
	typeGridFromDungeonPresetValueTypeGrid = typeGridFromValueTypeGrid(valueTypeGridOnDungeonPreset);

	var cropResultForDungeonTypeGrid, croppedTypeGrid, croppedPositions;
	cropResultForDungeonTypeGrid = croppedGridFromGrid(typeGridFromDungeonPresetValueTypeGrid);
	croppedTypeGrid = cropResultForDungeonTypeGrid[0];
	croppedPositions = cropResultForDungeonTypeGrid[1];

	var _newWidth, _newHeight;
	_newWidth = ds_grid_width(croppedTypeGrid);
	_newHeight = ds_grid_height(croppedTypeGrid);

	replaceTypeGridOnValueTypeGrid(croppedTypeGrid, valueTypeGridOnDungeonPreset);
	correctPlacedChamberPositionsOnDungeonPreset(_dungeonPreset,croppedPositions);

	_dungeonPreset[? DungeonPresetProps.WidthInPixel] = _newWidth;
	_dungeonPreset[? DungeonPresetProps.HeightInPixel] = _newHeight;

	var _resizedValueGrid = newGrid(_newWidth,_newHeight);
	ds_grid_set_grid_region(_resizedValueGrid,valueGridFromDungeonPresetValueTypeGrid,croppedPositions[Position.Left],croppedPositions[Position.Top],croppedPositions[Position.Left]+_newWidth+1,croppedPositions[Position.Top]+_newHeight+1,0,0);
	replaceValueGridOnValueTypeGrid(_resizedValueGrid, valueTypeGridOnDungeonPreset);

	show_debug_message("Size: " + string(ds_list_size(_dungeonPreset[? DungeonPresetProps.PlacedChambers])));	
}
