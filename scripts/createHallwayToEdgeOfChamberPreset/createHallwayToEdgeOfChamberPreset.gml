///	@function createHallwayToEdgeOfChamberPreset(dungeonPreset,placedChamber,connector);
///	@description				Creates a hallway for the given connector that moves to the outside of the PlacedChamber using the connectors facing direction
/// @param {DungeonPreset}		The dungeon in which the hallway shall be created
///	@param {PlacedChamber}		The chamber from which the hallway shall be created
///	@param {ConnectorPreset}	The connector for which the hallway shall be created
///
///	@return Returns an array with entries for each value in the Coordinate-Enum
function createHallwayToEdgeOfChamberPreset() {
	var _dungeonPreset, _placedChamber, _connectorPreset;
	_dungeonPreset = argument[0];
	_placedChamber = argument[1];
	_connectorPreset = argument[2];

	var _placedChamberXPosition, _placedChamberYPosition, _placedChamberWidth, _placedChamberHeight, _chamberPreset;
	_placedChamberXPosition = _placedChamber[? PlacedChamberProps.xPositionInDungeon];
	_placedChamberYPosition = _placedChamber[? PlacedChamberProps.yPositionInDungeon];

	_chamberPreset = _placedChamber[? PlacedChamberProps.ChamberPreset];
	_placedChamberWidth = _chamberPreset.totalWidth;
	_placedChamberHeight = _chamberPreset.totalHeight;

	var _Direction, _connectorWidth, _connectorHeight;
	_Direction = _connectorPreset.facingDirection;
	_connectorWidth = _connectorPreset.width;
	_connectorHeight = _connectorPreset.height;

	var _startX = 0, _startY = 0, _endX = 0, _endY = 0;
	switch (_Direction) {
	
		case Direction.Right: {
			_startX = _placedChamberXPosition+_connectorPreset.xStart+1;
			_startY = _placedChamberYPosition+_connectorPreset.yStart;
			_endX = _placedChamberXPosition+_placedChamberWidth+_connectorHeight-1;
			_endY = _startY+_connectorHeight-1;
		}
		break;
	
		case Direction.Up: {
			_startX = _placedChamberXPosition+_connectorPreset.xStart;
			_startY = _placedChamberYPosition+_connectorPreset.yStart-1;
			_endX = _startX+_connectorWidth-1;
			_endY = _placedChamberYPosition-_connectorWidth;
		}
		break;
	
		case Direction.Down: {
			_startX = _placedChamberXPosition+_connectorPreset.xStart;
			_startY = _placedChamberYPosition+_connectorPreset.yStart+1;
			_endX = _startX+_connectorWidth-1;
			_endY = _placedChamberYPosition+_placedChamberHeight+_connectorWidth-1;
		}
		break;
	
		case Direction.Left: {
			_startX = _placedChamberXPosition+_connectorPreset.xStart-1;
			_startY = _placedChamberYPosition+_connectorPreset.yStart;
			_endX = _placedChamberXPosition-_connectorHeight;
			_endY = _startY+_connectorHeight-1;
		}
		break;
	}

	//	Create the hallway
	createHallwayPartOnDungeonPreset(_dungeonPreset,_startX,_startY,_endX,_endY);

	//	Create the destination coordinates. This is where we stopped drawing. A Rectangular area with the dimensions of the connector
	var coordinates = [];
	switch (_Direction) {
	
		case Direction.Right: {
			coordinates[Coordinate.xStart] = _endX-_connectorHeight-1;
			coordinates[Coordinate.yStart] = _startY;
			coordinates[Coordinate.xEnd] = _endX;
			coordinates[Coordinate.yEnd] = _endY;
		}
		break;
	
		case Direction.Up: {
			coordinates[Coordinate.xStart] = _startX;
			coordinates[Coordinate.yStart] = _endY;
			coordinates[Coordinate.xEnd] = _endX;
			coordinates[Coordinate.yEnd] = _endY+_connectorWidth-1;
		}
		break;
	
		case Direction.Down: {
			coordinates[Coordinate.xStart] = _startX;
			coordinates[Coordinate.yStart] = _endY-_connectorWidth-1;
			coordinates[Coordinate.xEnd] = _endX;
			coordinates[Coordinate.yEnd] = _endY;		
		}
		break;
	
		case Direction.Left: {
			coordinates[Coordinate.xStart] = _endX;
			coordinates[Coordinate.xEnd] = _endX+_connectorHeight-1;
			coordinates[Coordinate.yStart] = _startY;
			coordinates[Coordinate.yEnd] = _endY;
		}
		break;
	}

	return coordinates;


}
