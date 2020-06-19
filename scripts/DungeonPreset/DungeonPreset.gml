// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function DungeonPreset(colorAssignments,maximumWidth,maximumHeight) constructor {
	
	self.valueTypeGrid = newValueTypeGrid(maximumWidth,maximumHeight,true);
	self.widthInPixel = maximumWidth;
	self.heightInPixel = maximumHeight;
	self.colorAssignments = colorAssignments;
	self.placedChambers = newList();
	
	static createNewDungeon = function(chamberPresets,amountOfChambersToPlace) {

		self.populateWithChamberPresets(chamberPresets, amountOfChambersToPlace);
		createHallwaysForDungeonPreset(self);

		var valueTypeGridOnDungeonPreset, valueGridFromDungeonPresetValueTypeGrid, typeGridFromDungeonPresetValueTypeGrid;
		valueTypeGridOnDungeonPreset = self.valueTypeGrid;
		valueGridFromDungeonPresetValueTypeGrid = valueGridFromValueTypeGrid(valueTypeGridOnDungeonPreset);
		typeGridFromDungeonPresetValueTypeGrid = typeGridFromValueTypeGrid(valueTypeGridOnDungeonPreset);

		var cropResultForDungeonTypeGrid, croppedTypeGrid, croppedPositions;
		cropResultForDungeonTypeGrid = croppedGridFromGrid(typeGridFromDungeonPresetValueTypeGrid);
		croppedTypeGrid = cropResultForDungeonTypeGrid[0];
		croppedPositions = cropResultForDungeonTypeGrid[1];

		var _newWidth, _newHeight;
		_newWidth = ds_grid_width(croppedTypeGrid);
		_newHeight = ds_grid_height(croppedTypeGrid);

		replaceTypeGridOnValueTypeGrid(croppedTypeGrid, valueTypeGridOnDungeonPreset);
		
		self.updatePositionsOfAllPlacedChambersFromCroppedSpaces(croppedPositions);

		self.widthInPixel = _newWidth;
		self.heightInPixel = _newHeight;

		var _resizedValueGrid = newGrid(_newWidth,_newHeight);
		ds_grid_set_grid_region(_resizedValueGrid,valueGridFromDungeonPresetValueTypeGrid,croppedPositions[Position.Left],croppedPositions[Position.Top],croppedPositions[Position.Left]+_newWidth+1,croppedPositions[Position.Top]+_newHeight+1,0,0);
		replaceValueGridOnValueTypeGrid(_resizedValueGrid, valueTypeGridOnDungeonPreset);

		show_debug_message("Size: " + string(ds_list_size(self.placedChambers)));	
	}
	
	///	@function drawDungeon(x,y);
	///	@description	Draws the dungeon to screen from the given preset using the given coordinates
	///	@param {real} x	The x-coordinate where to draw the dungeon
	///	@param {real} y	The y-coordinate where to draw the dungeon
	static drawDungeon = function(x,y) {

		var _dungeonPixelGrid = valueGridFromValueTypeGrid(self.valueTypeGrid);
		var _dungeonTypeGrid = typeGridFromValueTypeGrid(self.valueTypeGrid);

		var _gridWidth, _gridHeight;
		_gridWidth = ds_grid_width(_dungeonPixelGrid);
		_gridHeight = ds_grid_height(_dungeonPixelGrid);

		var _content = undefined;
		var _colorToDraw = noone;
		for (var _yPos=0;_yPos<_gridHeight;_yPos++) {
	
			for (var _xPos=0;_xPos<_gridWidth;_xPos++) {
		
				_content = _dungeonTypeGrid[# _xPos, _yPos];		
				_colorToDraw = undefined;
		
				if (_content != noone) {
					switch (_content) {
				
						case ColorMeaning.ChamberGround: 					
							_colorToDraw = _dungeonPixelGrid[# _xPos, _yPos];
						break;			
				
						case ColorMeaning.Connector: 
						if (self.colorAssignments.colorUsedToDrawConnectors == undefined) {
							_colorToDraw = _dungeonPixelGrid[# _xPos, _yPos];
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
	static populateWithChamberPresets = function(chamberPresets,amountOfChambersToPlace) {

		randomize();

		var _dungeonPixelGrid = valueGridFromValueTypeGrid(self.valueTypeGrid);
		var _dungeonTypeGrid = typeGridFromValueTypeGrid(self.valueTypeGrid);

		var _dungeonGridWidth, _dungeonGridHeight;
		_dungeonGridWidth = ds_grid_width(_dungeonPixelGrid);
		_dungeonGridHeight = ds_grid_height(_dungeonPixelGrid);

		debug("Placing " + string(amountOfChambersToPlace) +" chambers.");

		var _chosenColumn, _chosenRow, _chosenChamberPreset, _placedChambers;
		_chosenChamberPreset = undefined;
		_placedChambers = 0;

		var _startX, _startY;
		_startX = floor(_dungeonGridWidth/2);
		_startY = floor(_dungeonGridHeight/2);

		var _minimumRandomOffsetOnAxis, _maximumRandomOffsetOnAxis;
		_minimumRandomOffsetOnAxis = 2;
		_maximumRandomOffsetOnAxis = 20;

		//	We need to prevent at least one ChamberFlow on all PlacedChambers that are created after the first one. This is to prevent collisons
		var _directionToPreventOnAllFollowingPlacedChambers = Direction.None;
		var _firstChamberDirection = Direction.None;

		var _previouslyPlacedChamber = undefined;

		_chosenColumn = _startX;
		_chosenRow = _startY;

		var _directionToMoveToNext = choose(Direction.Left, Direction.Up, Direction.Right, Direction.Down);
		_firstChamberDirection = _directionToMoveToNext;

		while (_placedChambers != amountOfChambersToPlace) {
				
			_chosenChamberPreset = chamberThatAllowsConnectionOnSide(chamberPresets, oppositeDirectionForDirection(_directionToMoveToNext), _directionToPreventOnAllFollowingPlacedChambers);	
	
			if (_chosenChamberPreset == undefined) {
				//	Could not find a matching chamber to place next
				break;
			}
	
			if (_previouslyPlacedChamber == undefined) {
				_directionToPreventOnAllFollowingPlacedChambers = oppositeDirectionForDirection(_firstChamberDirection);
				debug("Direction to move to next -> " + nameForDirection(_firstChamberDirection) + ", direction to move to prevent -> " + nameForDirection(_directionToPreventOnAllFollowingPlacedChambers));
			} else {
		
				//	Set the x and y positions for this next PlacedChamber
				var _randomizedOffset = 0;
				_randomizedOffset = floor(random(_maximumRandomOffsetOnAxis-_minimumRandomOffsetOnAxis));
	
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
	
			var _typeGridOnChosenChamber = typeGridFromValueTypeGrid(_chosenChamberPreset.valueTypeGrid);
	
			//	Move the chamber a bit if a collision is detected. Main axis to move on is defined by direction of the first chamber 
			while (checkForCollisionWithChildGridOnParentGrid(_typeGridOnChosenChamber, _dungeonTypeGrid,_chosenColumn,_chosenRow) == true) {
		
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
	
			var _valueGridOnChamberPreset = valueGridFromValueTypeGrid(_chosenChamberPreset.valueTypeGrid);
			var _typeGridOnChamberPreset = typeGridFromValueTypeGrid(_chosenChamberPreset.valueTypeGrid);
	
			var _chamberPresetTotalWidth, _chamberPresetTotalHeight;
			_chamberPresetTotalWidth = _chosenChamberPreset.totalWidth;
			_chamberPresetTotalHeight = _chosenChamberPreset.totalHeight;
			ds_grid_set_grid_region(_dungeonPixelGrid,_valueGridOnChamberPreset,0,0,_chamberPresetTotalWidth,_chamberPresetTotalHeight,_chosenColumn,_chosenRow);
			ds_grid_set_grid_region(_dungeonTypeGrid, _typeGridOnChamberPreset,0,0,_chamberPresetTotalWidth,_chamberPresetTotalHeight,_chosenColumn,_chosenRow);
	

			_previouslyPlacedChamber = _placedChamber;
			ds_list_add(self.placedChambers,_placedChamber);
			_placedChambers+=1;
		}

		debug("Done placing chambers (" + string(_placedChambers)+"/"+string(amountOfChambersToPlace)+")");
	}
	
	///	@function correctPlacedChamberPositionsOnDungeonPreset(dungeonPreset,croppedSpaces);
	/// @description							Corrects the starting x and y position for all PlacedChambers on the given DungeonPreset using the given croppedSpaces-Array
	///	@param {array<real>}	croppedSpaces	A array with Position-Enum entries as key and pixels as value
	static correctPlacedChamberPositionsOnDungeonPreset = function(croppedSpaces) {

		var _cropLeft = croppedSpaces[Position.Left];
		var _cropTop = croppedSpaces[Position.Top];
		var _placedChamber = undefined;

		var _placedChambersList = self.placedChambers;
		for (var _i=0;_i<ds_list_size(_placedChambersList);_i++) {
			_placedChamber = _placedChambersList[| _i];
			_placedChamber.xPositionInDungeon = _placedChamber.xPositionInDungeon-_cropLeft;
			_placedChamber.yPositionInDungeon = _placedChamber.yPositionInDungeon-_cropTop;
		}
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