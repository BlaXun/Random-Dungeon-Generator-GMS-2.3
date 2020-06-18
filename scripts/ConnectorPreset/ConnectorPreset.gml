///	@function ConnectorPreset()
///	@description Constructor for ConnectorPreset
function ConnectorPreset(xStart,yStart) constructor {

	self.xStart = xStart;
	self.xEnd = xStart;
	self.yStart = yStart;
	self.yEnd = yStart;
	self.width = 0;
	self.height = 0;
	self.facingDirection = Direction.None;
	self.isConnected = false;
	
	static toString = function() {
		
		var _debugString = "============================= CONNECTOR PRESET ==============================\n";
		_debugString +="facingDirection: " +string(self.facingDirection) +"\n";
		_debugString +="width: " + string(self.width)+"\n";
		_debugString +="height: " + string(self.height)+"\n";
		_debugString +="xStart: " + string(self.xStart)+"\n";
		_debugString +="xEnd: " + string(self.xEnd)+"\n";
		_debugString +="yStart: " + string(self.yStart)+"\n";
		_debugString +="YEnd: " + string(self.yEnd)+"\n";
		_debugString +="IsConnected: " + string(self.isConnected);
		
		return _debugString;
	}
}
