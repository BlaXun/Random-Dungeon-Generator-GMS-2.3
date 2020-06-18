///	@function emptyPlacedChamber();
///	@description Creates and returns a new PlacedChamber instance
function emptyPlacedChamber() {

	/*
		A placed chamber is a container for a ChamberPreset that is actually placed within a dungeon.
		The placed chamber holds information about its location and the placed chambers docking chambers (which is the previous and next chambers)	
	*/

	enum PlacedChamberProps {
		NextChambers,
		PreviousChambers,
		xPositionInDungeon,
		yPositionInDungeon,
		ChamberPreset,
		DesiredDirectionToConnectTo,
		AllowsConnectionOnAndFromRightSide,
		AllowsConnectionOnAndFromLeftSide,
		AllowsConnectionOnAndFromTopSide,
		AllowsConnectionOnAndFromBottomSide,
		Index
	}

	var _emptyPlacedChamber = newMap();
	_emptyPlacedChamber[? PlacedChamberProps.ChamberPreset] = undefined;
	_emptyPlacedChamber[? PlacedChamberProps.Index] = -1;
	_emptyPlacedChamber[? PlacedChamberProps.NextChambers] = newList();
	_emptyPlacedChamber[? PlacedChamberProps.PreviousChambers] = newList();
	_emptyPlacedChamber[? PlacedChamberProps.xPositionInDungeon] = -1;
	_emptyPlacedChamber[? PlacedChamberProps.yPositionInDungeon] = -1;
	_emptyPlacedChamber[? PlacedChamberProps.yPositionInDungeon] = -1;
	_emptyPlacedChamber[? PlacedChamberProps.DesiredDirectionToConnectTo] = Direction.None;
	_emptyPlacedChamber[? PlacedChamberProps.AllowsConnectionOnAndFromRightSide] = false;
	_emptyPlacedChamber[? PlacedChamberProps.AllowsConnectionOnAndFromLeftSide] = false;
	_emptyPlacedChamber[? PlacedChamberProps.AllowsConnectionOnAndFromTopSide] = false;
	_emptyPlacedChamber[? PlacedChamberProps.AllowsConnectionOnAndFromBottomSide] = false;


	return _emptyPlacedChamber;


}
