///	@function emptyChamberPreset()
///	@description	Creates an empty chamber-preset (ds_map) and returns it
function ChamberPreset() constructor {

	self.leftFacingConnectors = [];
	self.rightFacingConnectors = [];
	self.upFacingConnectors = [];
	self.downFacingConenctors = [];
	self.allConnectors = [];
	self.valueTypeGrid = undefined;
	self.sprite = undefined;
	self.totalWidth = 0;
	self.totalHeight = 0;
	self.padding = 0;
	self.allowsConnectionOnAndFromRightSide = false;
	self.allowsConnectionOnAndFromLeftSide = false;
	self.allowsConnectionOnAndFromTopSide = false;
	self.allowsConnectionOnAndFromBottomSide = false;
	
	///	@function allSidesOnChamberPresetThatAllowConnections(chamberPreset,listToPopulate);
	///	@description	Populates the given list with all sides (Direction) on which the given ChamberPreset allows a connection
	///	@param {ChamberPreset} chamberPreset	The chamber preset for which the sides should be returned
	/// @param {ds_list} listToPopulate			The list which will get all the sides (Direction) assigned
	static allSidesThatAllowConnections = function(listToPopulate) {

		if (self.allowsConnectionOnAndFromBottomSide == true) {
			listToPopulate[| ds_list_size(listToPopulate)] = Direction.Left;
		}

		if (self.allowsConnectionOnAndFromRightSide == true) {
			listToPopulate[| ds_list_size(listToPopulate)] = Direction.Right;
		}

		if (self.allowsConnectionOnAndFromTopSide == true) {
			listToPopulate[| ds_list_size(listToPopulate)] = Direction.Up;
		}

		if (self.allowsConnectionOnAndFromBottomSide == true) {
			listToPopulate[| ds_list_size(listToPopulate)] = Direction.Down;
		}
	}
	
	///	@function assignDirectionsToConnectToOnChamberPreset(chamberPreset);
	///	@description	Depending on the connectors on the chamber preset we will set the directions the chamber could connect to
	///	@param {ChamberPreset} chamberPreset	The chamber preset for which the directions should be set
	static assignDirectionsToConnectToOnChamberPreset = function() {

		self.allowsConnectionOnAndFromLeftSide = array_length(self.leftFacingConnectors) > 0;
		self.allowsConnectionOnAndFromRightSide = array_length(self.rightFacingConnectors) > 0;
		self.allowsConnectionOnAndFromTopSide = array_length(self.upFacingConnectors) > 0;
		self.allowsConnectionOnAndFromBottomSide = array_length(self.downFacingConnectors) > 0;
	}
	
	/// @function chamberPresetHasConnectorsWithDirection(chamberPreset,Direction);
	///	@description	Checks if the given ChamberPreset contains at least one Connector with the given Direction
	/// @param {ChamberPreset} chamberPreset						The ChamberPreset that will be checked
	///	@param {Direction} Direction	The Direction we are looking for
	///	@return ture/false
	static chamberPresetHasConnectorsWithDirection = function(requestedDirection) {
	
		var _didFindRequestedFacingDirection = false;
		var _connector = undefined;
		for (var _i=0;_i<array_length(self.allConnectors);_i++) {
			_connector = self.allConnectors[_i];
	
			if (_connector[? ConnectorPresetProps.FacingDirection] == requestedDirection) {
				_didFindRequestedFacingDirection = true;
				break;
			}
		}

		return _didFindRequestedFacingDirection;
	}
	
	///	@function		createAndAssignConnectorsOnChamberPreset(chamberPreset,connectorColor,chamberColor);
	///	@description	Searches for connectors on the given chamber preset and assigns them to the given chamberPreset
	///	@param chamberPreset {ds_map}	The chamber preset to analyze
	///	@param connectorColor {color}	The color used to detect connectors
	///	@param chamberColor {color}	The color used to detect chamber ground
	static createAndAssignConnectorsOnChamberPreset = function(connectorColor, chamberColor) {

		var _upFacingConnectors, _downFacingConnectors, _rightFacingConnectors, _leftFacingConnectors, _allConnectors;
		_upFacingConnectors = [];
		_leftFacingConnectors = [];
		_downFacingConnectors = [];
		_rightFacingConnectors = [];
		_allConnectors = [];

		if (connectorColor != undefined) {
	
			var _pixelGrid = valueGridFromValueTypeGrid(self.valueTypeGrid);
	
			var _gridWidth, _gridHeight, _xPos, _yPos;
			_gridWidth = ds_grid_width(_pixelGrid);
			_gridHeight = ds_grid_height(_pixelGrid);
	
			var _pixelGridCopy = newGrid(_gridWidth,_gridHeight); 
			ds_grid_copy(_pixelGridCopy, _pixelGrid);	
	
			var _pixel, _connectorDirection, _neighborPixelRight, _neighborPixelBottom, _neighborPixelTop, _neighborPixelLeft;	
			for (_yPos=0;_yPos<_gridHeight;_yPos++) {
				
				for (_xPos=0;_xPos<_gridWidth;_xPos++) {
					_connectorDirection = Direction.None;
			
					_pixel = _pixelGridCopy[# _xPos,_yPos];
			
					if (_pixel == connectorColor) {
				
						_neighborPixelRight = _xPos < _gridWidth-1 ? _pixelGridCopy[# _xPos+1,_yPos] : noone;
						_neighborPixelBottom = _yPos < _gridHeight-1 ? _pixelGridCopy[# _xPos,_yPos+1] : noone;
				
						if !(_neighborPixelRight == connectorColor || _neighborPixelBottom == connectorColor) {					
							continue;
						}
				
						_neighborPixelLeft = _xPos == 0 ? noone : _pixelGridCopy[# _xPos-1, _yPos];
						_neighborPixelTop = _yPos == 0 ? noone : _pixelGridCopy[# _xPos, _yPos-1];
				
						//	New Connector found
						var _newConnector = emptyConnectorPreset();
						_newConnector[? ConnectorPresetProps.XStart] = _xPos;
						_newConnector[? ConnectorPresetProps.XEnd] = _xPos;
						_newConnector[? ConnectorPresetProps.YStart] = _yPos;
						_newConnector[? ConnectorPresetProps.YEnd] = _yPos;
					
						//	Detecting wether its a horizontal or vertical connector				
						if (_neighborPixelRight == connectorColor) {				
					
							//	Vertical Connector										
							var _connectorDirection = Direction.None;
							if (_neighborPixelBottom == noone && _neighborPixelTop == chamberColor) {
								_connectorDirection = Direction.Down;
							} else if (_neighborPixelTop == noone && _neighborPixelBottom == chamberColor) {
								_connectorDirection = Direction.Up;
							}
					
							if (_connectorDirection == Direction.None) {						
						
								//	Broken Connector Detected. Skipping
								destroyMap(_newConnector);
								continue;
							}
					 
							_newConnector[? ConnectorPresetProps.Height] = 1;		
							_newConnector[? ConnectorPresetProps.FacingDirection] = _connectorDirection;
					
							var _neighborIsBlankOrGround = false;
							var _width = 1;
							while(_neighborIsBlankOrGround == false) {
						
								_neighborPixelRight = (_xPos+_width > _gridWidth-1) ? noone : _pixelGridCopy[# _xPos+_width,_yPos];
						
								if (_neighborPixelRight == noone || _neighborPixelRight == chamberColor) {
									_neighborIsBlankOrGround = true;
								} else {
									//	Mask neighbor with chamber color to prevent duplicate detection
									_pixelGridCopy[# _xPos+_width,_yPos] = chamberColor;
									_width +=1;
								}
							}
					
							_newConnector[? ConnectorPresetProps.XEnd] = _xPos+_width-1;
							_newConnector[? ConnectorPresetProps.Width] = _width;
					
							if (_connectorDirection == Direction.Up) {
								_upFacingConnectors[array_length(_upFacingConnectors)] = _newConnector;		
							} else if (_connectorDirection == Direction.Down) {
								_downFacingConnectors[array_length(_downFacingConnectors)] = _newConnector;		
							}
					
							_allConnectors[array_length(_allConnectors)] = _newConnector;
						} else {
					
							//	Horizontal Connector
							var _connectorDirection = Direction.None;
							if (_neighborPixelRight == noone && _neighborPixelLeft == chamberColor) {
								_connectorDirection = Direction.Right;
							} else if (_neighborPixelLeft == noone && _neighborPixelRight == chamberColor) {
								_connectorDirection = Direction.Left;
							}
					
							if (_connectorDirection == Direction.None) {						
						
								//	Broken Connector Detected. Skipping
								destroyMap(_newConnector);
								continue;
							}
					 
							_newConnector[? ConnectorPresetProps.Width] = 1;		
							_newConnector[? ConnectorPresetProps.FacingDirection] = _connectorDirection;
					
							var _neighborIsBlankOrGround = false;
							var _height = 1;
							while(_neighborIsBlankOrGround == false) {
						
								_neighborPixelBottom = (_yPos+_height > _gridHeight-1) ? noone : _pixelGridCopy[# _xPos,_yPos+_height];
						
								if (_neighborPixelBottom == noone || _neighborPixelBottom == chamberColor) {
									_neighborIsBlankOrGround = true;
								} else {										
									//	Mask neighbor with chamber color to prevent duplicate detection
									ds_grid_set(_pixelGridCopy,_xPos,_yPos+_height,chamberColor);						
									_height +=1;
								}
							}
					
							_newConnector[? ConnectorPresetProps.YEnd] = _yPos+_height-1;
							_newConnector[? ConnectorPresetProps.Height] = _height;
					
							if (_connectorDirection == Direction.Left) {
								_leftFacingConnectors[array_length(_leftFacingConnectors)] = _newConnector;		
							} else if (_connectorDirection == Direction.Right) {
								_rightFacingConnectors[array_length(_rightFacingConnectors)] = _newConnector;		
							}
					
							_allConnectors[array_length(_allConnectors)] = _newConnector;
						}
					}
				}
			}
	
			self.upFacingConnectors = _upFacingConnectors;
			self.leftFacingConnectors = _leftFacingConnectors;
			self.downFacingConnectors = _downFacingConnectors;
			self.rightFacingConnectors = _rightFacingConnectors;
	
			self.allConnectors = _allConnectors;
	
			destroyGrid(_pixelGridCopy);
		}
	}
}