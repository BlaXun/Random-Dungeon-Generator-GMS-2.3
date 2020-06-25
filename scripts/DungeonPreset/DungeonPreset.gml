/*	
	The DungeonPreset is the struct that creates a dungeon
*/
function DungeonPreset(colorAssignments,maximumWidth,maximumHeight) constructor {
	
	//	The grid that contains metadata information for whatever is placed in the dungeon
	self.metadata = createGrid(maximumWidth, maximumHeight);
	
	self.width = maximumWidth;
	self.height = maximumHeight;
	self.colorAssignments = colorAssignments;
	self.placedChambers = createList();
	
	/*	@function createNewDungeon(chamberPresets,amountOfChambersToPlace, minimumRandomOffset, maximumRandomOffset);
		
		@description Creates a new dungeon from the given chamber prests while trying to place the given amount of chambers	
		
		@param {ds_list<ChamberPreset>} chamberPresets	A list of available ChamberPresets to be used when creating the dungeon
		@param {real} amountOfChambersToPlace	The amount of chambers to place that make up the dungeon
		@param {real} minimumRandomOffset	A minimum offset to be applied between chambers
		@param {real} maximumRandomOffset	A maximum offset to be applied between chambers	*/
	static createNewDungeon = function(chamberPresets,amountOfChambersToPlace, minimumRandomOffset, maximumRandomOffset) {

		self._populateWithPlacedChambersUsingChamberPresets(chamberPresets, amountOfChambersToPlace, minimumRandomOffset, maximumRandomOffset);
		
		var cropResultForDungeonTypeGrid = croppedGridFromGrid(self.metadata);		
		destroyGrid(self.metadata);
		
		self.metadata = cropResultForDungeonTypeGrid[0];
		
		self.width = ds_grid_width(self.metadata);		
		self.height = ds_grid_height(self.metadata);
		
		self._updatePositionsOfAllPlacedChambersFromCroppedSpaces(cropResultForDungeonTypeGrid[1]);
	}
	
	/*	@function drawDungeon(x,y);
	
		@description	Draws the dungeon to screen from the given preset using the given coordinates
	
		@param {real} x	The x-coordinate where to draw the dungeon
		@param {real} y	The y-coordinate where to draw the dungeon	*/
	static drawDungeon = function(x,y) {

		var _content = undefined;
		var _colorToDraw = noone;
		
		for (var _yPos=0;_yPos<ds_grid_height(self.metadata);_yPos++) {
			
			for (var _xPos=0;_xPos<ds_grid_width(self.metadata);_xPos++) {
			
				_content = self.metadata[# _xPos, _yPos];		
				_colorToDraw = undefined;
		
				if (_content != ColorMeaning.Unknown) {
					
					switch (_content) {
				
						case ColorMeaning.ChamberGround: 														
							_colorToDraw = self.colorAssignments.colorUsedToDrawChamberGround;
						break;			
				
						case ColorMeaning.Connector: 							
							_colorToDraw = self.colorAssignments.colorUsedToDrawConnectors;
						break;
				
						case ColorMeaning.Padding: 
							_colorToDraw = self.colorAssignments.colorUsedToDrawPadding;
						break;
				
						case ColorMeaning.Hallway: 
							_colorToDraw = self.colorAssignments.colorUsedToDrawHallways;
						break;
						
						default:
							_colorToDraw = undefined;
						break;
					}
				}
		
				if (_colorToDraw != undefined) {
					draw_point_color(x+_xPos,y+_yPos, _colorToDraw);
				}
			}
		}
	}
	
	/*	@function _populateWithPlacedChambersUsingChamberPresets(chamberPresets,amountOfChambersToPlace,minimumRandomOffset,maximumRandomOffset);
		
		@description	FOR INTERNAL USE
						This the logic that populates the dungeon with chambers and hallways
						
		@param {ds_list} chamberPresets			A list of chamber presets that are available to be used for populating
		@param {real} amountOfChambersToPlace	The amount of chambers that the dungeon should consist of
		@param {real} minimumRandomOffset		A minimum offset to be applied between chambers
		@param {real} maximumRandomOffset		A maximum offset to be applied between chambers	*/
	static _populateWithPlacedChambersUsingChamberPresets = function(chamberPresets,amountOfChambersToPlace,minimumRandomOffset, maximumRandomOffset) {

		randomize();
		
		debug("Placing " + string(amountOfChambersToPlace) +" chambers.");

		var _chosenColumn, _chosenRow, _chosenChamberPreset, _placedChambers;
		_chosenChamberPreset = undefined;
		_placedChambers = 0;

		var _startX, _startY;
		_startX = floor(ds_grid_width(self.metadata)/2);
		_startY = floor(ds_grid_height(self.metadata)/2);

		//	We need to prevent at least one ChamberFlow on all PlacedChambers that are created after the first one. This is to prevent collisons
		var _directionToPreventOnAllFollowingPlacedChambers = Direction.None;
		var _firstChamberDirection = Direction.None;

		var _previouslyPlacedChamber = undefined, _previouslyChosenPlacedConnectorForConnection = undefined;
		
		_chosenColumn = _startX;
		_chosenRow = _startY;

		var _availableDirectionsFromAllChamberPresets = allAvailableDirectionsOutOfChambers(chamberPresets);
		var _directionToMoveToNext = _availableDirectionsFromAllChamberPresets[floor(random(array_length(_availableDirectionsFromAllChamberPresets)))];		
		_firstChamberDirection = _directionToMoveToNext;

		while (_placedChambers != amountOfChambersToPlace) {
				
			_chosenChamberPreset = chamberThatAllowsConnectionOnSide(chamberPresets, oppositeDirectionForDirection(_directionToMoveToNext), _directionToPreventOnAllFollowingPlacedChambers);	
	
			if (_chosenChamberPreset == undefined) {
				//	Could not find a matching chamber to place next
				show_debug_message("EXITING BECAUSE I DIDNT FIND A MATCHING CHAMBER PRESET");
				break;
			}
	
			if (_previouslyPlacedChamber == undefined) {
				_directionToPreventOnAllFollowingPlacedChambers = oppositeDirectionForDirection(_firstChamberDirection);
				debug("Direction to move to next -> " + nameForDirection(_firstChamberDirection) + ", direction to move to prevent -> " + nameForDirection(_directionToPreventOnAllFollowingPlacedChambers));
			} else {
		
				//	Set the x and y positions for this next PlacedChamber
				var _randomizedOffset = 0;
				_randomizedOffset = floor(random(maximumRandomOffset-minimumRandomOffset));
	
				var _previousPlacedChamberChamberPreset, _previousChamberPresetTotalWidth, _previousChamberPresetTotalHeight;
				_previousPlacedChamberChamberPreset = _previouslyPlacedChamber.chamberPreset;
				_previousChamberPresetTotalWidth = _previousPlacedChamberChamberPreset.width;
				_previousChamberPresetTotalHeight = _previousPlacedChamberChamberPreset.height;
	
				var _thisChamberWidth, _thisChamberHeight;
				_thisChamberWidth = _chosenChamberPreset.width;
				_thisChamberHeight = _chosenChamberPreset.height;
		
				switch (_directionToMoveToNext) {
		
					case Direction.Right:			
						_chosenColumn += 1;
						_chosenColumn += _previousChamberPresetTotalWidth + _randomizedOffset;
					break;
		
					case Direction.Left:
						_chosenColumn -=1;
						_chosenColumn -= _thisChamberWidth+_randomizedOffset;
					break;
		
					case Direction.Down:
						_chosenRow +=1;
						_chosenRow += _previousChamberPresetTotalHeight+_randomizedOffset;
					break;
		
					case Direction.Up:
						_chosenRow -=1;
						_chosenRow -= _thisChamberHeight+_randomizedOffset;					
					break;
		
					case Direction.None:
						show_message("Direction.None in populateDungeonPresetWithChamberPresets 2");
					break;

				}
		
				// Apply randomization on row / column
				if (_directionToMoveToNext == Direction.Left || _directionToMoveToNext == Direction.Right) {
			
					if (_directionToPreventOnAllFollowingPlacedChambers==Direction.Down) {
						_chosenRow -= _randomizedOffset;
					} else if (_directionToPreventOnAllFollowingPlacedChambers==Direction.Up) {
						_chosenRow += _randomizedOffset;
					} else {
						_chosenRow += _randomizedOffset*choose(1,-1);
					}
			
				} else if (_directionToMoveToNext == Direction.Up || _directionToMoveToNext == Direction.Down) {
			
					if (_directionToPreventOnAllFollowingPlacedChambers==Direction.Right) {
						_chosenColumn -= _randomizedOffset;
					} else if (_directionToPreventOnAllFollowingPlacedChambers==Direction.Left) {
						_chosenColumn += _randomizedOffset;
					} else {
						_chosenColumn += _randomizedOffset*choose(1,-1);
					}
				}
			}
	
			//	Move the chamber a bit if a collision is detected. Main axis to move on is defined by direction of the first chamber 
			while (checkForCollisionWithChildGridOnParentGrid(_chosenChamberPreset.valueTypeGrid.types, self.metadata,_chosenColumn,_chosenRow) == true) {
				switch (_firstChamberDirection) {
			
					case Direction.Right:			
						_chosenColumn += 1;
					break;
		
					case Direction.Left:
						_chosenColumn -= 1;
					break;
		
					case Direction.Down:
						_chosenRow += 1;
					break;
		
					case Direction.Up:
						_chosenRow -= 1;
					break;
			
					case Direction.None:
						show_message("ChamberFlow.None in populateDungeonPresetWithChamberPresets");
					break;
				}		
			}
	
			debug("Placing chamber ("+ string(_chosenChamberPreset) +") on x: " + string(_chosenColumn) +" y: " + string(_chosenRow));
	
			var _placedChamber = new PlacedChamber(_chosenChamberPreset);	
			_placedChamber.index = _placedChambers;
			_placedChamber.xPositionInDungeon = _chosenColumn;
			_placedChamber.yPositionInDungeon = _chosenRow;	
	
			if (_previouslyPlacedChamber != undefined) {			
				ds_list_add(_previouslyPlacedChamber.nextChambers, _placedChamber);
				ds_list_add(_placedChamber.previousChambers, _previouslyPlacedChamber);
			}
	
			_placedChamber.deactivateDirection(_directionToPreventOnAllFollowingPlacedChambers);
			_placedChamber.deactivateDirection(oppositeDirectionForDirection(_directionToMoveToNext));
			
			var _chamberPresetTotalWidth, _chamberPresetTotalHeight;
			_chamberPresetTotalWidth = _chosenChamberPreset.width;
			_chamberPresetTotalHeight = _chosenChamberPreset.height;
			ds_grid_set_grid_region(self.metadata, _chosenChamberPreset.valueTypeGrid.types,0,0,_chamberPresetTotalWidth,_chamberPresetTotalHeight,_chosenColumn,_chosenRow);
			
			//	Connect previous PlacedChamber with this one
			if (_previouslyPlacedChamber != undefined) {				
				_placedChamber.selectConnectorOnSideForPreviousConnection(oppositeDirectionForDirection(_directionToMoveToNext), _previouslyChosenPlacedConnectorForConnection);
				_placedChamber.placedConnectorForIncomingConnection.targetPlacedConnector = _previouslyChosenPlacedConnectorForConnection;
				_previouslyChosenPlacedConnectorForConnection.targetPlacedConnector = _placedChamber.placedConnectorForIncomingConnection;
				
				_previouslyChosenPlacedConnectorForConnection.createHallwayOnDungeonPreset(self);
			}
			
			//	Prepare for next connection unless this is the final iteration
			if (_placedChambers<(amountOfChambersToPlace-1)) {
				_directionToMoveToNext = _placedChamber.randomDirectionFromAvailableDirections();
				_placedChamber.desiredDirectionToConnectTo = _directionToMoveToNext;		
			
				_placedChamber.selectConnectorOnSideForNextConnection(_directionToMoveToNext);
				_previouslyChosenPlacedConnectorForConnection = _placedChamber.placedConnectorForOutgoingConnection;			
			}
			
			_previouslyPlacedChamber = _placedChamber;
			ds_list_add(self.placedChambers,_placedChamber);
			_placedChambers+=1;
		}

		debug("Done placing chambers (" + string(_placedChambers)+"/"+string(amountOfChambersToPlace)+")");
	}
	
	/*	@function _updatePositionsOfAllPlacedChambersFromCroppedSpaces(croppedSpaves);
		
		@description	FOR INTERNAL USE
						Updates the positions of all placedChambeers on this dungeon based on the given cropped spaces
		
		@param {Array<Position>} croppedSpaces	A array with amount of cropped spaces on each side	*/
	static _updatePositionsOfAllPlacedChambersFromCroppedSpaces = function(croppedSpaces) {
		
		var _currentPlacedChamber = undefined;
		for (var _i=0;_i<ds_list_size(self.placedChambers);_i++) {
			_currentPlacedChamber = self.placedChambers[| _i];
			_currentPlacedChamber.correctPositions(croppedSpaces);		
		}
	}
	
	static toString = function() {
		var _debugString = "============================= DUNGEON PRESET ==============================\n";
		_debugString += "width: " +string(self.width) + "\n";
		_debugString += "height: " +string(self.height) + "\n";
		_debugString += "PlacedChambers (count): " +string(ds_list_size(self.placedChambers)) + "\n";
		return _debugString;
	}
}

/*	@function allAvailableDirectionsOutOfChambers(chambers);
	
	@description	Returns all possible directions by summarizing the directions of the given chambers
	
	@param {ds_list} chambers	A list of ChamberPresets
	@return A array with Direction-Enum entries	*/
function allAvailableDirectionsOutOfChambers(chambers) {
	
	var _didFindUp = false, _didFindDown = false, _didFindLeft = false, _didFindRight = false, _availableDirections;
	_availableDirections = [];
	
	var _chamber;
	for (var _i=0;_i<ds_list_size(chambers);_i++) {
		_chamber = chambers[| _i];
		
		if (_chamber.allowsConnectionOnAndFromRightSide == true) {
			_availableDirections[array_length(_availableDirections)] = Direction.Right;
			_didFindRight = true;
		}
		
		if (_chamber.allowsConnectionOnAndFromLeftSide == true) {
			_availableDirections[array_length(_availableDirections)] = Direction.Left;
			_didFindLeft = true;
		}
		
		if (_chamber.allowsConnectionOnAndFromTopSide == true) {
			_availableDirections[array_length(_availableDirections)] = Direction.Up;
			_didFindUp = true;
		}
		
		if (_chamber.allowsConnectionOnAndFromBottomSide == true) {
			_availableDirections[array_length(_availableDirections)] = Direction.Down;
			_didFindDown = true;
		}
		
		if (_didFindRight == true && _didFindLeft == true && _didFindUp == true && _didFindDown == true) {
			break;
		}
	}
	
	return _availableDirections;
}