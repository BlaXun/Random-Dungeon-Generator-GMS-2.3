///	@function placeHallwaysOnDungeonPresetWithConnectors(dungeonPreset,startingConnector,targetConnector,startingPlacedChamber,targetPlacedChamber);
///	@description	Tries to connect the assigned connector on the given dungeonPreset
///	@param {DungeonPreset} dungeonPreset			The DungeonPreset on which the hallway should be created
///	@param {ConnectorPreset} startingConnector		The connector on which path drawing should start
///	@param {ConnectorPreset} targetConnector		The connector on which path drawing should end
///	@param {PlacedChamber} startingPlacedChamber	The PlacedChamber on which the starting connector resides
///	@param {PlacedChamber} targetPlacedChamber		The PlacedChamber on which the target connector resides
function placeHallwaysOnDungeonPresetWithConnectors() {

	var _dungeonPreset, _chosenStartConnector, _chosenTargetConnector, _startingPlacedChamber, _targetPlacedChamber;
	_dungeonPreset = argument[0];
	_chosenStartConnector = argument[1];
	_chosenTargetConnector = argument[2];
	_startingPlacedChamber = argument[3];
	_targetPlacedChamber = argument[4];

	var _startX, _startY, _targetX, _targetY;
	_startX = _chosenStartConnector.xStart+_startingPlacedChamber.xPositionInDungeon;
	_startY = _chosenStartConnector.yStart+_startingPlacedChamber.yPositionInDungeon;

	_targetX = _chosenTargetConnector.xStart+_targetPlacedChamber.xPositionInDungeon;
	_targetY = _chosenTargetConnector.yStart+_targetPlacedChamber.yPositionInDungeon;

	var _startConnectorWidth, _startConnectorHeight;
	_startConnectorWidth = _chosenStartConnector.width;
	_startConnectorHeight = _chosenStartConnector.height;

	var _targetConnectorWidth, _targetConnectorHeight;
	_targetConnectorWidth = _chosenTargetConnector.width;
	_targetConnectorHeight = _chosenTargetConnector.height;

	var _endX, _endY;
	_endX = _startX + _startConnectorWidth-1;
	_endY = _startingPlacedChamber.yPositionInDungeon-(_startConnectorWidth);

	//	Start by creating a path to outside of the chamber in the direction the connector is facing towards
	//	TODO: Depending on the connectors facing direction the end-coordinates must be changed!
	var _currentHallwayCoordinates = createHallwayToEdgeOfChamberPreset(_dungeonPreset,_startingPlacedChamber,_chosenStartConnector);
	var _targetCoordinates = createHallwayToEdgeOfChamberPreset(_dungeonPreset,_targetPlacedChamber,_chosenTargetConnector);

	var _didReachDestination = false;
	//while (_didReachDestination = false) {
		_didReachDestination = connectHallwayToTargetPosition(_dungeonPreset,_currentHallwayCoordinates,_targetCoordinates,_chosenStartConnector,_chosenTargetConnector,_startingPlacedChamber,_targetPlacedChamber);
	//}

	//createHallwayPartOnDungeonPreset(dungeonPreset,_startX, _startY, _endX, _endY);

	//	Next, start moving to the outside of the targetChamber
	/*_startX = _endX;
	_startY = _endY;

	_endX = _targetPlacedChamber[? PlacedChamberProps.xPositionInDungeon]-1;
	_endY = _startY + _startConnectorWidth-1;

	createHallwayPartOnDungeonPreset(dungeonPreset,_startX, _startY, _endX, _endY);

	var _targetChamberXStart, _targetChamberXEnd, _targetChamberYStart, _targetChamberYEnd;
	var _targetChamberChamberPreset = _targetPlacedChamber[? PlacedChamberProps.ChamberPreset]
	_targetChamberXStart = _targetPlacedChamber[? PlacedChamberProps.xPositionInDungeon];
	_targetChamberXEnd = _targetPlacedChamber[? PlacedChamberProps.xPositionInDungeon]+_targetChamberChamberPreset[? ChamberPresetProps.TotalWidth];
	_targetChamberYStart = _targetPlacedChamber[? PlacedChamberProps.yPositionInDungeon];
	_targetChamberYEnd = _targetPlacedChamber[? PlacedChamberProps.yPositionInDungeon]+_targetChamberChamberPreset[? ChamberPresetProps.TotalHeight];

	if (_chosenTargetConnector[? ConnectorPresetProps.FacingDirection] == Direction.Up) {

		if (_endY<_targetChamberYStart) {
			_endX = _targetX+(_targetConnectorWidth-1);
			createHallwayPartOnDungeonPreset(dungeonPreset,_startX, _startY, _endX, _endY);	
		}
	
		//	Now just drill-down :)
		_startX = _targetX;
		_endY = _targetY;
		createHallwayPartOnDungeonPreset(dungeonPreset,_startX, _startY, _endX, _endY);	
	}*/

	/*	Depending on the targetConnectors facing direction we need to

	Facing-Direction: Top -> Draw a path to above it
	Facing-Direction: Left -> Draw a path down to the connectors y
	Facing-Direction: Right -> Draw a path to behind the connectors position
	Facing-Direction: Down -> Draw a path to below the connectors position
	*/


}
