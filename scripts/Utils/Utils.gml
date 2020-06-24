/*	@function oppositeDirectionForDirection(direction);
	@description	Returns the opposite Direction for the given Direction
	@param {Direction} direction	The Direction for which the opposite should be returned 
	@return	The opposite Direction for the given Direction	*/
function oppositeDirectionForDirection(direction) {

	var _oppositeDirection = Direction.None;

	switch (direction) {
		
		case Direction.Up:
			_oppositeDirection = Direction.Down;
		break;
		
		case Direction.Right:
			_oppositeDirection = Direction.Left;
		break;
		
		case Direction.Down:
			_oppositeDirection = Direction.Up;
		break;
		
		case Direction.Left:
			_oppositeDirection = Direction.Right;
		break;
	}
	
	return _oppositeDirection;
}