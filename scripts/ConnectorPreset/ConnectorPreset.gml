///	@function ConnectorPreset()
///	@description Constructor for ConnectorPreset
function ConnectorPreset(x,y) constructor {

	self.x = x;
	self.y = y;
	self.width = 0;
	self.height = 0;
	self.facingDirection = Direction.None;
	
	static toString = function() {
		
		var _debugString = "============================= CONNECTOR PRESET ==============================\n";
		_debugString +="facingDirection: " +string(self.facingDirection) +"\n";
		_debugString +="width: " + string(self.width)+"\n";
		_debugString +="height: " + string(self.height)+"\n";
		_debugString +="x: " + string(self.x)+"\n";
		_debugString +="y: " + string(self.y)+"\n";
		
		return _debugString;
	}
	
	/*	@function maximumDimensionDependingOnFacingDirection();
		@description Returns the maximum dimension of this connector (either height or width) depending on the connectors facing direction
		
					 Connectors that face left or right will return their height while connectors that are facing up or down will return their width.
					 
		@return {real} Either the height or widht depending on the connectors facing direction */
	static maximumDimensionDependingOnFacingDirection = function() {
		
		var _dimension = 0;
		if (self.facingDirection == Direction.Left || self.facingDirection == Direction.Right) {
			_dimension = self.height;
		} else if (self.facingDirection == Direction.Up || self.facingDirection == Direction.Down) {
			_dimension = self.width;
		}
		
		return _dimension;
	}
}
