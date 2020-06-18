///	@function ChamerPreset()
///	@description ChamberPreset-Constructor
function ChamberPreset() constructor {

	self.leftFacingConnectors = [];
	self.rightFacingConnectors = [];
	self.upFacingConnectors = [];
	self.downFacingConnectors = [];
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
	
	///	@function allSidesOnThatAllowConnections(listToPopulate);
	///	@description	Populates the given list with all sides (Direction) on the current ChamberPreset allows a connection
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
	
	///	@function assignDirectionsToConnectTo();
	///	@description	Depending on the connectors on the chamber preset we will set the directions the chamber could connect to
	static assignDirectionsToConnectTo = function() {

		self.allowsConnectionOnAndFromLeftSide = array_length(self.leftFacingConnectors) > 0;
		self.allowsConnectionOnAndFromRightSide = array_length(self.rightFacingConnectors) > 0;
		self.allowsConnectionOnAndFromTopSide = array_length(self.upFacingConnectors) > 0;
		self.allowsConnectionOnAndFromBottomSide = array_length(self.downFacingConnectors) > 0;
	}
	
	///	@function		createAndAssignConnectors(connectorColor,chamberColor);
	///	@description	Searches for connectors on the chamber preset and assigns them
	///	@param connectorColor {color}	The color used to detect connectors
	///	@param chamberColor {color}	The color used to detect chamber ground
	static createAndAssignConnectors = function(connectorColor, chamberColor) {

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
						var _newConnector = new ConnectorPreset(_xPos,_yPos); 
					
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
					 
							_newConnector.height = 1;		
							_newConnector.facingDirection = _connectorDirection;
					
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
					
							_newConnector.xEnd = _xPos+_width-1;
							_newConnector.width = _width;
					
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
					 
							_newConnector.width = 1;		
							_newConnector.facingDirection = _connectorDirection;
					
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
					
							_newConnector.yEnd = _yPos+_height-1;
							_newConnector.height = _height;
					
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

	static toString = function() {
		var _debugString = "============================= CHAMBER PRESET ==============================\n";
		_debugString += "leftFacingConnectors: " +string(self.leftFacingConnectors) + "\n";
		_debugString += "upFacingConnectors: " +string(self.upFacingConnectors) + "\n";
		_debugString += "rightFacingConnectors: " +string(self.rightFacingConnectors) + "\n";
		_debugString += "downFacingConnectors: " +string(self.downFacingConnectors) + "\n";
		_debugString += "allowsConnectionOnAndFromLeftSide: " +string(self.allowsConnectionOnAndFromLeftSide) + "\n";
		_debugString += "allowsConnectionOnAndFromTopSide: " +string(self.allowsConnectionOnAndFromTopSide) + "\n";
		_debugString += "allowsConnectionOnAndFromRightSide: " +string(self.allowsConnectionOnAndFromRightSide) + "\n";
		_debugString += "allowsConnectionOnAndFromBottomSide: " +string(self.allowsConnectionOnAndFromBottomSide) + "\n";
		return _debugString;
	}
}

///	@function chamberThatAllowsConnectionOnSide(availableChamberPresets,sideToConnectOn,directionToExclude);
///	@description	Returns a ChamberPreset from the given available chamber presets that is compatible with the given chamber flow
///	@param {ds_list<ChamberPreset>}				availableChamberPresets	The list of available chamber presets to choose from
///	@param {Direction} sideToConnectOn			The side on which a connection must be possible
/// @param {ChamberFlow} directionToExclude		Do not return ChamberPresets that offer only this other direction beside the needed direction
///	@return	A ChamberPreset
function chamberThatAllowsConnectionOnSide(availableChamberPresets, sideToConnectOn, directionToExclude) {

	var _neededFaceDirection = Direction.None;
	_neededFaceDirection = oppositeDirectionForDirection(sideToConnectOn);

	var _compatibleChamberPresets = newList();
	var _currentPreset = undefined;
	var _sidesOnWhichConnectionsAreAllowed = newList();
	for (var _i=0;_i<ds_list_size(availableChamberPresets);_i++) {	
	
		_currentPreset = availableChamberPresets[| _i];
		_currentPreset.allSidesThatAllowConnections(_sidesOnWhichConnectionsAreAllowed);
	
		//	Check if the needed direction exists (this is where we want to connect to)
		if (ds_list_find_index(_sidesOnWhichConnectionsAreAllowed,sideToConnectOn) != -1) {
		
			//	What sides remain after this one?
			ds_list_delete(_sidesOnWhichConnectionsAreAllowed, ds_list_find_index(_sidesOnWhichConnectionsAreAllowed,sideToConnectOn));
			if (ds_list_size(_sidesOnWhichConnectionsAreAllowed) == 1 && ds_list_find_index(_sidesOnWhichConnectionsAreAllowed, directionToExclude) != -1) {
				//	This chamber is not compatible because it offers no remaining sides from which it can build new conenctions
			} else {
				//	Found a compatible chamber
				_compatibleChamberPresets[| ds_list_size(_compatibleChamberPresets)] = _currentPreset;	
			}		
		}
	
		ds_list_clear(_sidesOnWhichConnectionsAreAllowed);
	}

	destroyList(_sidesOnWhichConnectionsAreAllowed);
	ds_list_shuffle(_compatibleChamberPresets);

	var _chamberPresetToReturn = _compatibleChamberPresets[| 0];
	destroyList(_compatibleChamberPresets);

	return _chamberPresetToReturn;
}

///	@function createChamberPresetFromChamberSprite(chamberSprite,colorAssignments,padding);
///	@description Cretes a chamber preset from the given sprite using the given colors
///	@param {real} chamberSprite The index of the sprite to use
/// @param {color} colorAssignments A map that defines the meaning of the encountered colors
///	@param {real} padding A padding to apply around the pixel grid
function createChamberPresetFromChamberSprite(chamberSprite,colorAssignments,padding) {

	//	Find chamber content -> output to 2d array or map
	//	Find chamber vertical connectors -> output coordinates and dimensions to 2d array or map
	//	Find chamber horizontal connectors -> output coordinars and dimensions to 2d array or map

	var _chamberPreset = new ChamberPreset();
	_chamberPreset.sprite = chamberSprite;

	var _chamberSpriteWidth, _chamberSpriteHeight;
	_chamberSpriteWidth = sprite_get_width(chamberSprite);
	_chamberSpriteHeight = sprite_get_height(chamberSprite);

	_chamberPreset.totalWidth = _chamberSpriteWidth+(padding*2);
	_chamberPreset.totalHeight = _chamberSpriteHeight+(padding*2);

	var _grids = createPixelGridAndDatatypeGridFromSprite(chamberSprite, colorAssignments, padding);
	var _valueTypeGrid = newValueTypeGrid(_chamberSpriteWidth+(padding*2), _chamberSpriteHeight+(padding*2),false);
	_valueTypeGrid[? ValueTypeGridProps.Values] = _grids[0];
	_valueTypeGrid[? ValueTypeGridProps.Types] = _grids[1];
	_chamberPreset.valueTypeGrid = _valueTypeGrid;
	_chamberPreset.padding = padding;

	var _connectorColor, _chamberColor;
	_chamberColor = findColorForColorAssignment(colorAssignments, ColorAssignment.ChamberGround);
	_connectorColor = findColorForColorAssignment(colorAssignments, ColorAssignment.Connector);

	_chamberPreset.createAndAssignConnectors(_connectorColor, _chamberColor);
	_chamberPreset.assignDirectionsToConnectTo();
	
	return _chamberPreset;
}