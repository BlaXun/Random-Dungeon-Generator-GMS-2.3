// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function DungeonPreset(colorAssignments,maximumWidth,maximumHeight) constructor {
	
	self.valueTypeGrid = new ValueTypeGrid(maximumWidth,maximumHeight,true);
	
	self.widthInPixel = maximumWidth;
	self.heightInPixel = maximumHeight;
	self.colorAssignments = colorAssignments;
	self.placedChambers = createList();
	
	static createNewDungeon = function(chamberPresets,amountOfChambersToPlace, minimumRandomOffset, maximumRandomOffset) {

		self.populateWithChamberPresets(chamberPresets, amountOfChambersToPlace, minimumRandomOffset, maximumRandomOffset);
		createHallwaysForDungeonPreset(self);

		var cropResultForDungeonTypeGrid, croppedTypeGrid, croppedPositions;
		cropResultForDungeonTypeGrid = croppedGridFromGrid(self.valueTypeGrid.types);
		croppedTypeGrid = cropResultForDungeonTypeGrid[0];
		croppedPositions = cropResultForDungeonTypeGrid[1];

		var _newWidth, _newHeight;
		_newWidth = ds_grid_width(croppedTypeGrid);
		_newHeight = ds_grid_height(croppedTypeGrid);

		self.widthInPixel = _newWidth;		
		self.heightInPixel = _newHeight;
		
		var _resizedValueGrid = createGrid(_newWidth,_newHeight);
		ds_grid_set_grid_region(_resizedValueGrid,self.valueTypeGrid.values,croppedPositions[Position.Left],croppedPositions[Position.Top],croppedPositions[Position.Left]+_newWidth+1,croppedPositions[Position.Top]+_newHeight+1,0,0);
		
		self.valueTypeGrid.replaceValueAndTypeGrid(_resizedValueGrid, croppedTypeGrid);
		
		self.updatePositionsOfAllPlacedChambersFromCroppedSpaces(croppedPositions);
		show_debug_message("Size: " + string(ds_list_size(self.placedChambers)));	
	}
	
	///	@function drawDungeon(x,y);
	///	@description	Draws the dungeon to screen from the given preset using the given coordinates
	///	@param {real} x	The x-coordinate where to draw the dungeon
	///	@param {real} y	The y-coordinate where to draw the dungeon
	static drawDungeon = function(x,y) {

		var _content = undefined;
		var _colorToDraw = noone;
		
		var _drawnConnectors = 0;
		for (var _yPos=0;_yPos<self.valueTypeGrid.height;_yPos++) {
	
			for (var _xPos=0;_xPos<self.valueTypeGrid.width;_xPos++) {
		
				_content = self.valueTypeGrid.types[# _xPos, _yPos];		
				_colorToDraw = undefined;
		
				if (_content != ColorMeaning.Unknown) {
					switch (_content) {
				
						case ColorMeaning.ChamberGround: 					
							_colorToDraw = self.valueTypeGrid.values[# _xPos, _yPos];
						break;			
				
						case ColorMeaning.Connector: 
						_drawnConnectors++;
						if (self.colorAssignments.colorUsedToDrawConnectors == undefined) {							
							show_debug_message(self.colorAssignments);
							_colorToDraw = self.valueTypeGrid.values[# _xPos, _yPos];
						} else {
							_colorToDraw = self.colorAssignments.colorUsedToDrawConnectors;
						}
							
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
	
	///	@function	populateDungeonPresetWithChamberPresets(dungeonPreset,chamberPresets,amountOfChambersToPlace)
	///	@param {ds_list} chamberPresets			A list of chamber presets that are available to be used for populating
	///	@param {real} amountOfChambersToPlace	The amount of chambers that the dungeon should consist of
	static populateWithChamberPresets = function(chamberPresets,amountOfChambersToPlace,minimumRandomOffset, maximumRandomOffset) {

		randomize();

		debug("Placing " + string(amountOfChambersToPlace) +" chambers.");

		var _chosenColumn, _chosenRow, _chosenChamberPreset, _placedChambers;
		_chosenChamberPreset = undefined;
		_placedChambers = 0;

		var _startX, _startY;
		_startX = floor(self.valueTypeGrid.width/2);
		_startY = floor(self.valueTypeGrid.height/2);

		//	We need to prevent at least one ChamberFlow on all PlacedChambers that are created after the first one. This is to prevent collisons
		var _directionToPreventOnAllFollowingPlacedChambers = Direction.None;
		var _firstChamberDirection = Direction.None;

		var _previouslyPlacedChamber = undefined;

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
				_previousChamberPresetTotalWidth = _previousPlacedChamberChamberPreset.totalWidth;
				_previousChamberPresetTotalHeight = _previousPlacedChamberChamberPreset.totalHeight;
	
				var _thisChamberWidth, _thisChamberHeight;
				_thisChamberWidth = _chosenChamberPreset.totalWidth;
				_thisChamberHeight = _chosenChamberPreset.totalHeight;
		
				switch (_directionToMoveToNext) {
		
					//	TODO: Der Random-Faktor darf NICHT mit der direction to prevent kollidieren
					case Direction.Right:			
						_chosenColumn += _previousChamberPresetTotalWidth + _randomizedOffset;
						//_chosenRow+=_randomizedOffset;				
					break;
		
					case Direction.Left:
						_chosenColumn -= _thisChamberWidth+_randomizedOffset;
						//_chosenRow-=_randomizedOffset;				
					break;
		
					case Direction.Down:
						_chosenRow += _previousChamberPresetTotalHeight+_randomizedOffset;
							//_chosenColumn+=_randomizedOffset;
					break;
		
					case Direction.Up:					
						_chosenRow -= _thisChamberHeight+_randomizedOffset;					
						//_chosenColumn-=_randomizedOffset;
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
			while (checkForCollisionWithChildGridOnParentGrid(_chosenChamberPreset.valueTypeGrid.types, self.valueTypeGrid.types,_chosenColumn,_chosenRow) == true) {
		
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
			_directionToMoveToNext = _placedChamber.randomDirectionFromAvailableDirections();		
			_placedChamber.desiredDirectionToConnectTo = _directionToMoveToNext;
	
			var _chamberPresetTotalWidth, _chamberPresetTotalHeight;
			_chamberPresetTotalWidth = _chosenChamberPreset.totalWidth;
			_chamberPresetTotalHeight = _chosenChamberPreset.totalHeight;
			ds_grid_set_grid_region(self.valueTypeGrid.values,_chosenChamberPreset.valueTypeGrid.values,0,0,_chamberPresetTotalWidth,_chamberPresetTotalHeight,_chosenColumn,_chosenRow);
			ds_grid_set_grid_region(self.valueTypeGrid.types, _chosenChamberPreset.valueTypeGrid.types,0,0,_chamberPresetTotalWidth,_chamberPresetTotalHeight,_chosenColumn,_chosenRow);


			_previouslyPlacedChamber = _placedChamber;
			ds_list_add(self.placedChambers,_placedChamber);
			_placedChambers+=1;
		}

		debug("Done placing chambers (" + string(_placedChambers)+"/"+string(amountOfChambersToPlace)+")");
	}
	
	static updatePositionsOfAllPlacedChambersFromCroppedSpaces = function(croppedSpaces) {
		
		var _currentPlacedChamber = undefined;
		for (var _i=0;_i<ds_list_size(self.placedChambers);_i++) {
			_currentPlacedChamber = self.placedChambers[| _i];
			_currentPlacedChamber.correctPositions(croppedSpaces);		
		}
	}
	
	static toString = function() {
		var _debugString = "============================= DUNGEON PRESET ==============================\n";
		_debugString += "widthInPixel: " +string(self.widthInPixel) + "\n";
		_debugString += "heightInPixel: " +string(self.heightInPixel) + "\n";
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