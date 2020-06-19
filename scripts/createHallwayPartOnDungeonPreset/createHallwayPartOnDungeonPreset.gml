///	@function createHallwayPartOnDungeonPreset(dungeonPreset, xStart, yStart, xEnd, yEnd);
///	@description Creates a path on the given dungeon preset with the given positions
///	@param {DungeonPreset} dungeonPreset	The dungeon preset on which the hallway should be created
///	@param {real} xStart					Starting x position of the area to mark as hallway
///	@param {real} yStart					Starting y position of the area to mark as hallway
///	@param {real} xEnd						Ending x position of the area to mark as hallway
///	@param {real} yEnd						Ending y position of the area to mark as hallway
function createHallwayPartOnDungeonPreset() {

	var _dungeonPreset, _xStart, _yStart, _xEnd, _yEnd;
	_dungeonPreset = argument[0];
	_xStart = argument[1];
	_yStart = argument[2];
	_xEnd = argument[3];
	_yEnd = argument[4];

	var _hallwayColor = _dungeonPreset.colorAssignments.colorUsedToDrawHallways;
	_dungeonPreset.valueTypeGrid.setValueAndTypeForArea(_hallwayColor, ColorMeaning.Hallway, _xStart, _yStart, _xEnd, _yEnd);
}
