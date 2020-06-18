///	@function deactivateDirectionOnPlacedChamber(placedChamber,directionToDeactivate);
///	@description	Based on previously placed chambers this chamber is not allowed to conenct to the given direction
///				
/// @param {PlacedChamber} placedChamber		The PlacedChamber on which the available ChamberFlows should be updated;
///	@param {Direction} directionToDeactivate	A Direction that is not allowed for this PlacedChamber
function deactivateDirectionOnPlacedChamber() {

	var _placedChamber = argument[0];
	var _directionToDeactivate = argument[1];

	switch (_directionToDeactivate) {
	
		case Direction.Down:
			_placedChamber[? PlacedChamberProps.AllowsConnectionOnAndFromBottomSide] = false;
		break;
	
		case Direction.Up:
			_placedChamber[? PlacedChamberProps.AllowsConnectionOnAndFromTopSide] = false;
		break;
	
		case Direction.Left:
			_placedChamber[? PlacedChamberProps.AllowsConnectionOnAndFromLeftSide] = false;
		break;
	
		case Direction.Right:
			_placedChamber[? PlacedChamberProps.AllowsConnectionOnAndFromRightSide] = false;
		break;
	}
	


}
