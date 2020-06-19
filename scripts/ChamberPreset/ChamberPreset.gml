/*	@function					ChamerPreset();
	@description				ChamberPreset-Constructor
	@param {real} chamberSprite	Index of the sprite to use for this chamber preset
	@param {real} padding		Amount of padding to apply on each side of the chamber */
function ChamberPreset(chamberSprite, padding) constructor {

	self.leftFacingConnectors = [];
	self.rightFacingConnectors = [];
	self.upFacingConnectors = [];
	self.downFacingConnectors = [];
	self.allConnectors = [];
	self.valueTypeGrid = undefined;
	self.sprite = chamberSprite;
	self.padding = padding;
	
	self.totalWidth = sprite_get_width(self.sprite)+(self.padding*2);
	self.totalHeight = sprite_get_height(self.sprite)+(self.padding*2);
	
	self.allowsConnectionOnAndFromRightSide = false;
	self.allowsConnectionOnAndFromLeftSide = false;
	self.allowsConnectionOnAndFromTopSide = false;
	self.allowsConnectionOnAndFromBottomSide = false;
	
	
	/*	@function						allSidesOnThatAllowConnections(listToPopulate);
		@description					Populates the given list with all sides (Direction) on the current ChamberPreset that allow a connection
		@param {ds_list} listToPopulate	The list which will get all the sides (Direction) assigned */	
	static allSidesThatAllowConnections = function(listToPopulate) {

		if (self.allowsConnectionOnAndFromLeftSide == true) {
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
	
	/*	@function		assignDirectionsToConnectTo();
		@description	Sets the allowed connection sides depending on the currently assigned connectors */
	static assignDirectionsToConnectTo = function() {

		self.allowsConnectionOnAndFromLeftSide = array_length(self.leftFacingConnectors) > 0;
		self.allowsConnectionOnAndFromRightSide = array_length(self.rightFacingConnectors) > 0;
		self.allowsConnectionOnAndFromTopSide = array_length(self.upFacingConnectors) > 0;
		self.allowsConnectionOnAndFromBottomSide = array_length(self.downFacingConnectors) > 0;
	}
	
	/*	@function									createAndAssignConnectors(colorAssignments);
		@description								Searches for connectors on the chamber preset and assigns them
		@param colorAssignments {ColorAssignment}	Instance of ColorAssignment. These are the colors used to analyze the sprite */
	static createAndAssignConnectors = function(colorAssignments) {

		var _upFacingConnectors, _downFacingConnectors, _rightFacingConnectors, _leftFacingConnectors, _allConnectors;
		_upFacingConnectors = [];
		_leftFacingConnectors = [];
		_downFacingConnectors = [];
		_rightFacingConnectors = [];
		_allConnectors = [];
	
		var _pixelGridCopy = createGrid(self.valueTypeGrid.width,self.valueTypeGrid.height); 
		ds_grid_copy(_pixelGridCopy, self.valueTypeGrid.values);	
	
		show_debug_message("createAndAssignConnectors -> " + string(colorAssignments));
		var _pixel, _connectorDirection, _neighborPixelRight, _neighborPixelBottom, _neighborPixelTop, _neighborPixelLeft;	
		for (var _yPos=0;_yPos<self.valueTypeGrid.height;_yPos++) {
				
			for (var _xPos=0;_xPos<self.valueTypeGrid.width;_xPos++) {
				_connectorDirection = Direction.None;
				_pixel = _pixelGridCopy[# _xPos,_yPos];
			
				if (_pixel == 0) {
					continue;
				}
				
				if (colorAssignments.meaningForColor(_pixel) == ColorMeaning.Connector) {
				
					_neighborPixelRight = _xPos < self.valueTypeGrid.width-1 ? _pixelGridCopy[# _xPos+1,_yPos] : 0;
					_neighborPixelBottom = _yPos < self.valueTypeGrid.height-1 ? _pixelGridCopy[# _xPos,_yPos+1] : 0;
				
					if (colorAssignments.meaningForColor(_neighborPixelRight) != ColorMeaning.Connector && colorAssignments.meaningForColor(_neighborPixelBottom) != ColorMeaning.Connector) {					
						continue;
					}
				
					_neighborPixelLeft = _xPos == 0 ? 0 : _pixelGridCopy[# _xPos-1, _yPos];
					_neighborPixelTop = _yPos == 0 ? 0 : _pixelGridCopy[# _xPos, _yPos-1];
				
					//	New Connector found
					var _newConnector = new ConnectorPreset(_xPos,_yPos); 
					
					//	Detecting wether its a horizontal or vertical connector				
					if (colorAssignments.meaningForColor(_neighborPixelRight) == ColorMeaning.Connector) {				
					
						//	Vertical Connector										
						var _connectorDirection = Direction.None;
						if (_neighborPixelBottom == 0 && colorAssignments.meaningForColor(_neighborPixelTop) == ColorMeaning.ChamberGround) {
							_connectorDirection = Direction.Down;
						} else if (_neighborPixelTop == 0 && colorAssignments.meaningForColor(_neighborPixelBottom) == ColorMeaning.ChamberGround) {
							_connectorDirection = Direction.Up;
						}
					
						if (_connectorDirection == Direction.None) {						
						
							//	Broken Connector Detected. Skipping
							delete _newConnector;
							continue;
						}
					 
						_newConnector.height = 1;		
						_newConnector.facingDirection = _connectorDirection;
					
						var _neighborIsBlankOrGround = false;
						var _width = 1;
						while(_neighborIsBlankOrGround == false) {
						
							_neighborPixelRight = (_xPos+_width > self.valueTypeGrid.width-1) ? 0 : _pixelGridCopy[# _xPos+_width,_yPos];
						
							if (_neighborPixelRight == 0 || colorAssignments.meaningForColor(_neighborPixelRight) == ColorMeaning.ChamberGround) {
								_neighborIsBlankOrGround = true;
							} else {
								//	Mask neighbor with chamber color to prevent duplicate detection
								_pixelGridCopy[# _xPos+_width,_yPos] = colorAssignments.colorsDetectedAsChamberGround[| 0];
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
						if (_neighborPixelRight == 0 && colorAssignments.meaningForColor(_neighborPixelLeft) == ColorMeaning.ChamberGround) {
							_connectorDirection = Direction.Right;
						} else if (_neighborPixelLeft == 0 && colorAssignments.meaningForColor(_neighborPixelRight) == ColorMeaning.ChamberGround) {
							_connectorDirection = Direction.Left;
						}
					
						if (_connectorDirection == Direction.None) {						
						
							//	Broken Connector Detected. Skipping
							delete _newConnector;
							continue;
						}
					 
						_newConnector.width = 1;		
						_newConnector.facingDirection = _connectorDirection;
					
						var _neighborIsBlankOrGround = false;
						var _height = 1;
						while(_neighborIsBlankOrGround == false) {
						
							_neighborPixelBottom = (_yPos+_height > self.valueTypeGrid.height-1) ? 0 : _pixelGridCopy[# _xPos,_yPos+_height];
						
							if (_neighborPixelBottom == 0 || colorAssignments.meaningForColor(_neighborPixelBottom) == ColorMeaning.ChamberGround) {
								_neighborIsBlankOrGround = true;
							} else {										
								//	Mask neighbor with chamber color to prevent duplicate detection
								ds_grid_set(_pixelGridCopy,_xPos,_yPos+_height, colorAssignments.colorsDetectedAsChamberGround[| 0]);						
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
		self.assignDirectionsToConnectTo();

		destroyGrid(_pixelGridCopy);
	}

	static toString = function() {
		var _debugString = "============================= CHAMBER PRESET ==============================\n";
		_debugString += "sprite: " +sprite_get_name(self.sprite) + "\n";
		_debugString += "totalWidth: " +string(self.totalWidth) + "\n";
		_debugString += "totalHeight: " +string(self.totalHeight) + "\n";
		_debugString += "padding: " +string(self.padding) + "\n";
		_debugString += "leftFacingConnectors: " +string(self.leftFacingConnectors) + "\n";
		_debugString += "upFacingConnectors: " +string(self.upFacingConnectors) + "\n";
		_debugString += "rightFacingConnectors: " +string(self.rightFacingConnectors) + "\n";
		_debugString += "downFacingConnectors: " +string(self.downFacingConnectors) + "\n";
		_debugString += "allowsConnectionOnAndFromLeftSide: " +string(self.allowsConnectionOnAndFromLeftSide) + "\n";
		_debugString += "allowsConnectionOnAndFromTopSide: " +string(self.allowsConnectionOnAndFromTopSide) + "\n";
		_debugString += "allowsConnectionOnAndFromRightSide: " +string(self.allowsConnectionOnAndFromRightSide) + "\n";
		_debugString += "allowsConnectionOnAndFromBottomSide: " +string(self.allowsConnectionOnAndFromBottomSide) + "\n";
		_debugString += "=============================================================================";
		return _debugString;
	}

	static allowsConnectionOnSideAndAtLeastOneOtherSideButTheExcludedSide = function(requestedSideToConnectOn, sideToIgnore) {
		var _allowsConnectionOnRequestedSide = false;
		var _hasAnotherSideToConnectOnBesidesTheSideToIgnore = false;
		
		var _sidesThatAllowConnections = createList();
		self.allSidesThatAllowConnections(_sidesThatAllowConnections);
	
		//	Check if the needed direction exists (this is where we want to connect to)
		if (ds_list_find_index(_sidesThatAllowConnections,requestedSideToConnectOn) > -1) {
			_allowsConnectionOnRequestedSide = true;
			
			//	What sides remain after this one?
			ds_list_delete(_sidesThatAllowConnections, ds_list_find_index(_sidesThatAllowConnections,requestedSideToConnectOn));
			if (ds_list_size(_sidesThatAllowConnections) == 1 && ds_list_find_index(_sidesThatAllowConnections, sideToIgnore) > -1) {
				_hasAnotherSideToConnectOnBesidesTheSideToIgnore = false;
				//	This chamber is not compatible because it offers no remaining sides from which it can build new connections
			} else {
				_hasAnotherSideToConnectOnBesidesTheSideToIgnore = true;
			}		
		}
	
		destroyList(_sidesThatAllowConnections);
		return _allowsConnectionOnRequestedSide && _hasAnotherSideToConnectOnBesidesTheSideToIgnore;
	}
}

/*	@function chamberThatAllowsConnectionOnSide(availableChamberPresets,sideToConnectOn,directionToExclude);
	@description Returns a ChamberPreset from the given available chamber presets that allows for connection on the given side
	
	@param {ds_list<ChamberPreset>}	availableChamberPresets		The list of available chamber presets to choose from
	@param {Direction} sideToConnectOn							The side on which a connection must be possible
	@param {Direction} directionToExclude						Do not return ChamberPresets that offer only this other direction beside the requested side on which a connection must be possible
	
	@return	A ChamberPreset */
function chamberThatAllowsConnectionOnSide(availableChamberPresets, sideToConnectOn, directionToExclude) {

	var _neededFaceDirection = Direction.None;
	_neededFaceDirection = oppositeDirectionForDirection(sideToConnectOn);

	var _compatibleChamberPresets = createList();
	var _currentPreset = undefined;
	for (var _i=0;_i<ds_list_size(availableChamberPresets);_i++) {	
	
		_currentPreset = availableChamberPresets[| _i];
		if (_currentPreset.allowsConnectionOnSideAndAtLeastOneOtherSideButTheExcludedSide(sideToConnectOn, directionToExclude) == true) {
			_compatibleChamberPresets[| ds_list_size(_compatibleChamberPresets)] = _currentPreset;	
		}
	}

	ds_list_shuffle(_compatibleChamberPresets);

	var _chamberPresetToReturn = _compatibleChamberPresets[| 0];
	destroyList(_compatibleChamberPresets);

	return _chamberPresetToReturn;
}

/*	@function createChamberPresetFromChamberSprite(chamberSprite,colorAssignments,padding);
	@description Creates a chamber preset from the given sprite using the given colors and padding
	
	@param {real} chamberSprite		The index of the sprite to use
	@param {color} colorAssignments A ColorAssignment-Instance that holds information regarding color and meaning
	@param {real} padding			A padding to apply around the pixel grid */
function createChamberPresetFromChamberSprite(chamberSprite,colorAssignments,padding) {

	var _chamberPreset = new ChamberPreset(chamberSprite, padding);

	var _grids = createPixelGridAndDatatypeGridFromSprite(chamberSprite, colorAssignments, padding);
	var _valueTypeGrid = new ValueTypeGrid(_chamberPreset.totalWidth, _chamberPreset.totalHeight,false);
	_valueTypeGrid.replaceValueAndTypeGrid(_grids[0],_grids[1]);
	_chamberPreset.valueTypeGrid = _valueTypeGrid;
	_chamberPreset.createAndAssignConnectors(colorAssignments);	
	
	return _chamberPreset;
}
