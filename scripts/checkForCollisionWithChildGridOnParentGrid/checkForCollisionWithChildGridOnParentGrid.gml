///	@function checkForCollisionWithChildGridOnParentGrid(childGrid,parentGrid)
///	@description	Checks wether the childGrid would collide with any column/row on the parentGrid that has a value other than noone
///	@param {ds_grid} childGrid	The grid that will be placed on the parentGrid
///	@param {ds_grid} parentGrid	The grid that gets the childGrid placed on it
///	@param {real} xOffset		An offset on the x-axis defining where the childGrid shall be placed on the parentGrid
///	@param {real} yOffset		An offset on the y-axis defining where the childGrid shall be placed on the parentGrid
///	@returns {boolean}			Wether a collision was detected
function checkForCollisionWithChildGridOnParentGrid() {

	var _childGrid, _parentGrid, _xOffset, _yOffset;
	_childGrid = argument[0];
	_parentGrid = argument[1];
	_xOffset = argument[2];
	_yOffset = argument[3];

	var didFindCollision = false;

	for (var _yPos=_yOffset;_yPos<_yOffset+ds_grid_height(_childGrid);_yPos+=1) {
		for (var _xPos=_xOffset;_xPos<_xOffset+ds_grid_width(_childGrid);_xPos+=1) {
	
			if (ds_grid_get(_parentGrid,_xPos,_yPos) != noone) {
				didFindCollision = true;
				break;
			}
		}
	}

	return didFindCollision;



}
