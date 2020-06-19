/*	
	@function				debug(message)
	@description			Posts a debug message to the console of debugging is active
	@param {string} message	The message to output to console
*/
function debug(message) {
	if (global.__debugging == true) {
		show_debug_message(message);
	}
}

/*
	@function						nameForDirection(direction);
	@description					Returns a human readable name for the given direction (Direction-Enum)
	@param {Direction} direction	The direction for which a human-readable string should be returned
*/
function nameForDirection(direction) {
	switch(direction) {
	
		case Direction.Up:
			return "Up";
			break;
		
			case Direction.Down:
			return "Down";
			break;
		
			case Direction.Right:
			return "Right";
			break;
		
			case Direction.Left:
			return "Left";
			break;
	}
}
