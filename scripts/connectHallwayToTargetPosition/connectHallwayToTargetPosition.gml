///	@function connectHallwayToTargetPosition(dungeonPreset,lastCoordinates,targetCoordinates,sourceConnector,targetConnector,sourcePlacedChamber,targetPlacedChamber);
///	@description	Creates a single hallway path with the goal to reach the given targetCoordinates
///	@param {DungeonPreset} dungeonPreset			The dungeon on which all this hallway placing takes place
/// @param {Array<Coordinate>} lastCoordinates		The coordinates where hallway drawing last stopped
/// @param {Array<Coordinate>} targetCoordinates	The coordinates we want to reach
/// @param {ConnectorPreset} sourceConnector		The connector for which the hallway is being created
/// @param {ConnectorPreset} targetConnector		The connector to which the hallway shall be connected
/// @param {PlacedChamber} sourcePlacedChamber		The placed chamber the sourceConnector belongs to
/// @param {PlacedChamber} targetPlacedChamber		The placed chamber the targetConnector belongs to
function connectHallwayToTargetPosition() {

	var _dungeonPreset, _lastCoordinates, _targetCoordinates, _sourceConnector, _targetConnector, _sourcePlacedChamber, _targetPlacedChamber;
	_dungeonPreset = argument[0];
	_lastCoordinates = argument[1];
	_targetCoordinates = argument[2];
	_sourceConnector = argument[3];
	_targetConnector = argument[4];
	_sourcePlacedChamber = argument[5];
	_targetPlacedChamber = argument[6];

	var _sourcePlacedChamberXPosition, _sourcePlacedChamberYPosition;
	_sourcePlacedChamberXPosition = _sourcePlacedChamber[? PlacedChamberProps.xPositionInDungeon];
	_sourcePlacedChamberYPosition = _sourcePlacedChamber[? PlacedChamberProps.yPositionInDungeon];

	var _chamberPresetOnSourcePlacedChamber, _sourcePlacedChamberXEnd, _sourcePlacedChamberYEnd;
	_chamberPresetOnSourcePlacedChamber = _sourcePlacedChamber[? PlacedChamberProps.ChamberPreset];
	_sourcePlacedChamberXEnd = _sourcePlacedChamber[? PlacedChamberProps.xPositionInDungeon]+_chamberPresetOnSourcePlacedChamber.totalWidth;
	_sourcePlacedChamberYEnd = _sourcePlacedChamber[? PlacedChamberProps.yPositionInDungeon]+_chamberPresetOnSourcePlacedChamber.totalHeight;


	var _newLastCoordinates = [];
	/*var _dungeonFlow = _dungeonPreset[? DungeonPresetProps.DungeonFlow];
	if (_dungeonFlow == DungeonFlow.LeftToRight) {

		var _targetPlacedChamberYPosition, _targetPlacedChamberXPosition;
		_targetPlacedChamberYPosition = _targetPlacedChamber[? PlacedChamberProps.yPositionInDungeon];
		_targetPlacedChamberXPosition = _targetPlacedChamber[? PlacedChamberProps.xPositionInDungeon];

		var _sourceConnectorWidth, _sourceConnectorHeight, _sourceConnectorLargestDimension;
		_sourceConnectorWidth = _sourceConnector[? ConnectorPresetProps.Width];
		_sourceConnectorHeight = _sourceConnector[? ConnectorPresetProps.Height];
		_sourceConnectorLargestDimension = max(_sourceConnectorWidth, _sourceConnectorHeight);
	
		//	Maybe snake around the sourcePlacedChamber first
		if (_lastCoordinates[Coordinate.xEnd] < _sourcePlacedChamberXPosition) {
		
			//	We are at the left of the chamber, draw either up or down
			if (_targetPlacedChamberYPosition < _sourcePlacedChamberYPosition) {
			
				//	Draw up
				var _startX, _startY, _endX, _endY;
				_startX = _lastCoordinates[Coordinate.xStart];
				_startY = _lastCoordinates[Coordinate.yStart];
				_endX = _startX+_sourceConnectorLargestDimension-1;
				_endY = _sourcePlacedChamberYPosition-_sourceConnectorLargestDimension;			
				createHallwayPartOnDungeonPreset(_dungeonPreset,_startX,_startY,_endX,_endY);	
			
				//	Draw right
				_startX = _endX
				_startY = _endY
				_endX = _targetPlacedChamberXPosition-1;
				_endY = _startY+_sourceConnectorLargestDimension-1;
			
			} else {
			
				//	Draw down
				var _startX, _startY, _endX, _endY;
				_startX = _lastCoordinates[Coordinate.xStart];
				_startY = _lastCoordinates[Coordinate.yStart];
				_endX = _startX+_sourceConnectorLargestDimension-1;
				_endY = _sourcePlacedChamberYEnd+_sourceConnectorLargestDimension-1;
				createHallwayPartOnDungeonPreset(_dungeonPreset,_startX,_startY,_endX,_endY);
			
				//	Draw right			
				_startY = _sourcePlacedChamberYEnd;			
				_endX = _targetPlacedChamberXPosition-1;			
			}		
				
			createHallwayPartOnDungeonPreset(_dungeonPreset,_startX,_startY,_endX,_endY);
		
			_newLastCoordinates[Coordinate.xStart] = _startX;
			_newLastCoordinates[Coordinate.yStart] = _endY;
			_newLastCoordinates[Coordinate.xEnd] = _endX;
			_newLastCoordinates[Coordinate.yEnd] = _endY+_sourceConnectorLargestDimension-1;
		}
	}*/

	return _newLastCoordinates;
	/*
		Ab hier kenne ich dann die Positionen wo ich zuletzt was gezeichnet habe (_createdPathCoordinatesForStartingConnector)
		und die position meines Ziels (_createdPathCoordinatesForTargetConnector)
	
		Nun muss geprüft werden ob das letzte Zeichnen zB links oder unterhalb, oberhalb oder rechts von der chamber liegt
		Je nachdem wo man sich befindet kommt es dann darauf an wo das ziel ist. Weiter recht? Oben, unten oder links?
	
		>>>
		Wenn ich zB zuletzt links neben die chamber gezeichnet habe und das ziel weiter rechts ist dann muss ich nach rechts,
		aber erst wäre noch wichtig ob das ziel über oder unter mir liegt.
	
		Sobald ich dass weiß zeichne ich als nächstes am Rand der Chamber entlang entweder nach unten oder oben.
	
		Dort angekommen muss das gleiche spiel erneut erfolgen.
		Wo, ist das Ziel? Bin ich außerhalb meiner chamber? -> Am Rand entlang zeichnen bis an den Rand der Target chamber
	*/


}
