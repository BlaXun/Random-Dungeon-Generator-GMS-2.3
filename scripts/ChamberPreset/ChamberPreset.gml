/*	The Padding-Struct holds information about padding for all sides */
function Padding(left, top, right, bottom) constructor {
	
	self.left = left;
	self.top = top;
	self.right = right;
	self.bottom = bottom;
}


/*	@function					ChamerPreset();
	@description				ChamberPreset-Constructor
	@param {real} chamberSprite	Index of the sprite to use for this chamber preset */
function ChamberPreset(chamberSprite) constructor {

	self.leftFacingConnectors = [];
	self.rightFacingConnectors = [];
	self.upFacingConnectors = [];
	self.downFacingConnectors = [];
	self.allConnectors = [];
	self.valueTypeGrid = undefined;
	self.sprite = chamberSprite;
	self.padding = new Padding(0,0,0,0);
	
	self.totalWidth = sprite_get_width(self.sprite);
	self.totalHeight = sprite_get_height(self.sprite);
	
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
	
		var _typeGridCopy = createGrid(self.valueTypeGrid.width, self.valueTypeGrid.height); 
		ds_grid_copy(_typeGridCopy, self.valueTypeGrid.types);	
	
		var _maximumDimensionForAllConnectors = 0;
		var _content, _connectorDirection, _neighborContentRight, _neighborContentBottom, _neighborContentTop, _neighborContentLeft;	
		for (var _yPos=0;_yPos<self.valueTypeGrid.height;_yPos++) {
				
			for (var _xPos=0;_xPos<self.valueTypeGrid.width;_xPos++) {
				_connectorDirection = Direction.None;
				_content = _typeGridCopy[# _xPos,_yPos];
			
				if (_content == ColorMeaning.Unknown) {
					continue;
				}
				
				if (_content == ColorMeaning.Connector) {
								
					_neighborContentRight = _xPos < self.valueTypeGrid.width-1 ? _typeGridCopy[# _xPos+1,_yPos] : ColorMeaning.Unknown;
					_neighborContentBottom = _yPos < self.valueTypeGrid.height-1 ? _typeGridCopy[# _xPos,_yPos+1] : ColorMeaning.Unknown;
				
					if (_neighborContentRight != ColorMeaning.Connector && _neighborContentBottom != ColorMeaning.Connector) {
						continue;
					}
				
					_neighborContentLeft = _xPos == 0 ? ColorMeaning.Unknown : _typeGridCopy[# _xPos-1, _yPos];
					_neighborContentTop = _yPos == 0 ? ColorMeaning.Unknown : _typeGridCopy[# _xPos, _yPos-1];
				
					//	New Connector found
					var _newConnector = new ConnectorPreset(_xPos,_yPos); 
					
					//	Detecting wether its a horizontal or vertical connector				
					if (_neighborContentRight == ColorMeaning.Connector) {				
					
						//	Vertical Connector										
						var _connectorDirection = Direction.None;
						if ((_neighborContentBottom == ColorMeaning.Unknown || _neighborContentBottom == ColorMeaning.Padding) && _neighborContentTop == ColorMeaning.ChamberGround) {
							_connectorDirection = Direction.Down;
						} else if ((_neighborContentTop == ColorMeaning.Unknown || _neighborContentTop == ColorMeaning.Padding) && _neighborContentBottom == ColorMeaning.ChamberGround) {
							_connectorDirection = Direction.Up;
						}
					
						if (_connectorDirection == Direction.None) {						
							delete _newConnector;
							continue;
						}
					 
						_newConnector.height = 1;
						_newConnector.facingDirection = _connectorDirection;
					
						var _neighborIsBlankOrGround = false;
						var _width = 1;
						while(_neighborIsBlankOrGround == false) {
						
							_neighborContentRight = (_xPos+_width > self.valueTypeGrid.width-1) ? ColorMeaning.Unknown : _typeGridCopy[# _xPos+_width,_yPos];
						
							if (_neighborContentRight == ColorMeaning.Unknown || _neighborContentRight == ColorMeaning.ChamberGround) {
								_neighborIsBlankOrGround = true;
							} else if (_neighborContentRight == ColorMeaning.Connector) {
								//	Mask neighbor with ChamberGround to prevent duplicate detection
								_typeGridCopy[# _xPos+_width,_yPos] = ColorMeaning.ChamberGround;
								_width +=1;
							}
						}
					
						_newConnector.width = _width;
						_maximumDimensionForAllConnectors = max(_maximumDimensionForAllConnectors, _width);
						
						if (_connectorDirection == Direction.Up) {
							_upFacingConnectors[array_length(_upFacingConnectors)] = _newConnector;		
						} else if (_connectorDirection == Direction.Down) {
							_downFacingConnectors[array_length(_downFacingConnectors)] = _newConnector;		
						}
					
						_allConnectors[array_length(_allConnectors)] = _newConnector;
					} else {
					
						//	Horizontal Connector
						var _connectorDirection = Direction.None;
						if ((_neighborContentRight == ColorMeaning.Unknown || _neighborContentRight == ColorMeaning.Padding) && _neighborContentLeft == ColorMeaning.ChamberGround) {
							_connectorDirection = Direction.Right;
						} else if ((_neighborContentLeft == ColorMeaning.Unknown || _neighborContentLeft == ColorMeaning.Padding) && _neighborContentRight == ColorMeaning.ChamberGround) {
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
						
							_neighborContentBottom = (_yPos+_height > self.valueTypeGrid.height-1) ? ColorMeaning.Unknown : _typeGridCopy[# _xPos,_yPos+_height];
						
							if (_neighborContentBottom == ColorMeaning.Unknown || _neighborContentBottom == ColorMeaning.ChamberGround) {
								_neighborIsBlankOrGround = true;
							} else if (_neighborContentBottom == ColorMeaning.Connector) {										
								//	Mask neighbor with ChamberGround to prevent duplicate detection
								ds_grid_set(_typeGridCopy,_xPos,_yPos+_height, ColorMeaning.ChamberGround);						
								_height +=1;
							}
						}
					
						_newConnector.height = _height;
						_maximumDimensionForAllConnectors = max(_maximumDimensionForAllConnectors, _height);
					
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
	
		show_debug_message("Did find connectors \n up: " + string(array_length(self.upFacingConnectors)) +"\nleft: " + string(array_length(self.leftFacingConnectors))+"\ndown: " + string(array_length(self.downFacingConnectors)) + "\nright: " + string(array_length(self.rightFacingConnectors)));
	
		self.allConnectors = _allConnectors;
		self._assignDirectionsToConnectTo();
		
		//	The padding should be 1 + maximum main dimension across all connectors!
		_maximumDimensionForAllConnectors +=1;
		self.padding = new Padding(_maximumDimensionForAllConnectors,_maximumDimensionForAllConnectors,_maximumDimensionForAllConnectors,_maximumDimensionForAllConnectors);
		self._applyPadding();
		
		destroyGrid(_typeGridCopy);
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

	/*	@function		_assignDirectionsToConnectTo();
		@description	RESERVED FOR INTERNAL USE
						Sets the allowed connection sides depending on the currently assigned connectors */
	static _assignDirectionsToConnectTo = function() {

		self.allowsConnectionOnAndFromLeftSide = array_length(self.leftFacingConnectors) > 0;
		self.allowsConnectionOnAndFromRightSide = array_length(self.rightFacingConnectors) > 0;
		self.allowsConnectionOnAndFromTopSide = array_length(self.upFacingConnectors) > 0;
		self.allowsConnectionOnAndFromBottomSide = array_length(self.downFacingConnectors) > 0;
	}
	
	/*	@function _createAndAssignPaddingFromConnectors();
		@description	RESERVED FOR INTERNAL USE
						Sets the padding for all sides depending on the connectors on this ChamberPreset	
						The padding we are looking for is twice the size of the maximum connector on each side.
						Having such a padding applied to each side we easily reserve enough space to draw connecting hallways! */
	static _applyPadding = function() {
		
		/*var _maximumConnectorDimensionLeft = 0, _maximumConnectorDimensionTop = 0, _maximumConnectorDimensionRight = 0, _maximumConnectorDimensionBottom = 0;
		_maximumConnectorDimensionLeft = self._largestConnectorDimensionOnSide(Direction.Left);
		_maximumConnectorDimensionTop = self._largestConnectorDimensionOnSide(Direction.Up);
		_maximumConnectorDimensionRight = self._largestConnectorDimensionOnSide(Direction.Right);
		_maximumConnectorDimensionBottom = self._largestConnectorDimensionOnSide(Direction.Down);
	
		self.padding = new Padding(max(1,_maximumConnectorDimensionLeft*2),max(1,_maximumConnectorDimensionTop*2),max(1,_maximumConnectorDimensionRight*2),max(1,_maximumConnectorDimensionBottom*2));
		*/
		
		self.valueTypeGrid.applyPadding(self.padding,noone,ColorMeaning.Padding);
		
		self.totalWidth = self.valueTypeGrid.width;
		self.totalHeight = self.valueTypeGrid.height;
		
		self._correctConnectorPositionsUsingPadding(self.padding);
	}
	
	/*  @function _correctConnectorPositionsUsingPadding(padding);
		@description	RESERVED FOR INTERNAL USE
						Changes each connectors start and end positions depending on the given padding
		@param {Padding} padding	A Padding-Struct that holds the values to be used (only left and top are relevant) to change the connectors coordinates */
	static _correctConnectorPositionsUsingPadding = function(padding) {
		var _connector = undefined;
		for (var _i=0;_i<array_length(self.allConnectors);_i++) {
			_connector = self.allConnectors[_i];
			_connector.x += padding.left;			
			_connector.y += padding.top;
		}
	}
	
	/*	@function _largestConnectorDimensionOnSide(side);
		@description	RESERVED FOR INTERNAL USE
						Returns the largest (height or width) dimension of all connectors on the given side
		@param {Direction} side	The side for which the maximum connector dimension should be returned
		@return {Real}	The largest dimension of all connectors on the given side	*/
	static _largestConnectorDimensionOnSide = function(side) {
		
		var _maximumDimension = 0;
		var _connectors = [];
		switch (side) {
			
			case (Direction.Left): {
				_connectors = self.leftFacingConnectors;
			}
			break;
			
			case (Direction.Up): {
				_connectors = self.upFacingConnectors;
			}
			break;
			
			case (Direction.Right): {
				_connectors = self.rightFacingConnectors;
			}
			break;
			
			case (Direction.Down): {
				_connectors = self.downFacingConnectors;
			}		
			break;
		}
		
		var _currentConnector = undefined;
		for (var _i=0;_i<array_length(_connectors);_i++) {
			_currentConnector = _connectors[_i];
			_maximumDimension = max(_maximumDimension,_currentConnector.maximumDimensionDependingOnFacingDirection());			
		}
		
		return _maximumDimension;
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
	@param {color} colorAssignments A ColorAssignment-Instance that holds information regarding color and meaning */
function createChamberPresetFromChamberSprite(chamberSprite,colorAssignments) {

	var _chamberPreset = new ChamberPreset(chamberSprite);

	var _grids = createPixelGridAndDatatypeGridFromSprite(chamberSprite, colorAssignments);
	var _valueTypeGrid = new ValueTypeGrid(_chamberPreset.totalWidth, _chamberPreset.totalHeight,false);
	_valueTypeGrid.replaceValueAndTypeGrid(_grids[0],_grids[1]);
	_chamberPreset.valueTypeGrid = _valueTypeGrid;	
	_chamberPreset.createAndAssignConnectors(colorAssignments);	
	//_chamberPreset.createAndAssignPaddingFromConnectors();
	
	return _chamberPreset;
}
