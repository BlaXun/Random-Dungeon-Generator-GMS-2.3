/// @function createHallwaysForDungeonPreset(dungeonPreset)
///	@description						Connects the placed chambers on the given dungeonPreset
///	@param {ds_map} dungeonPreset		The DungeonPreset that got PlacedChambers to connect
function createHallwaysForDungeonPreset() {

	var _dungeonPreset = argument[0];
	var _placedChambers  = _dungeonPreset.placedChambers;

	var _startingChamber, _targetChamber;
	
	if (ds_list_size(_placedChambers) == 0) {
		exit;
	}
	
	_startingChamber = _placedChambers[| 0];

	var _nextChambersList = _startingChamber.nextChambers;
	_targetChamber = _nextChambersList[| 0];

	var _startPreset, _targetPreset;
	_startPreset = _startingChamber.chamberPreset;
	_targetPreset = _targetChamber.chamberPreset;

	var _allConnectorsOnStart, _allConnectorsOnTarget;
	_allConnectorsOnStart = _startPreset.allConnectors;
	_allConnectorsOnTarget = _targetPreset.allConnectors;

	var _chosenStartConnector, _chosenTargetConnector;
	_chosenStartConnector = _allConnectorsOnStart[@ floor(random(array_length(_allConnectorsOnStart)))];
	_chosenTargetConnector = _allConnectorsOnTarget[@ floor(random(array_length(_allConnectorsOnTarget)))];

	placeHallwaysOnDungeonPresetWithConnectors(_dungeonPreset, _chosenStartConnector, _chosenTargetConnector, _startingChamber, _targetChamber);

	//	For each PlacedChamber
	//	Choose (lets start with only 1) a connector that is fitting for the given dungeonFlow
	//	Choose a connector on each PlacedChamber in this chambers NextChambers list
	//	Start by drawing the hallway from the starting chamber towards the outside of the chamber
	//	Next move that hallways near the connecting chamber (but not directly next to it!)
	//	Do the same for the connector to connect to so the hallways share their x-axis
	//	Connect the two hallways
	//	Mark hallways as connected to each other so we do not connect them twice

	//	TODO: Connect more than one connector for a chamber
	//	TODO: Connect a source chamber to all of it's NEXT chambers (if possible)
	//	TODO: Create branching hallways 
	//	TODO: Create rounded corners in hallways
	//	TODO: Prevent overlapping hallways
}
