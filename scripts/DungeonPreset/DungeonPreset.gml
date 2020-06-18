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
		correctPlacedChamberPositionsOnDungeonPreset(self,croppedPositions);

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

		var _chamberColor, _connectorColor, _paddingColor, _hallwayColor;
		_chamberColor = findColorForColorAssignment(self.colorAssignments,ColorAssignment.ChamberGround);
		_connectorColor = findColorForColorAssignment(self.colorAssignments,ColorAssignment.Connector);
		_paddingColor = findColorForColorAssignment(self.colorAssignments,ColorAssignment.Padding);
		_hallwayColor = findColorForColorAssignment(self.colorAssignments,ColorAssignment.Hallway);

		var _contents = undefined;
		var _colorToDraw = noone;
		for (var _yPos=0;_yPos<_gridHeight;_yPos++) {
	
			for (var _xPos=0;_xPos<_gridWidth;_xPos++) {
		
				_contents = _dungeonTypeGrid[# _xPos, _yPos];		
				_colorToDraw = noone;
		
				if (_contents != noone) {
					switch (_contents) {
				
						case GridContentType.ChamberGround: 					
							_colorToDraw = _chamberColor;
						break;			
				
						case GridContentType.Connector: 
							_colorToDraw = _connectorColor;
						break;
				
						case GridContentType.Padding: 
							_colorToDraw = _paddingColor;
						break;
				
						case GridContentType.Hallway: 
							_colorToDraw = _hallwayColor;
						break;
					}
				}
		
				if (_colorToDraw != noone) {
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
				_previousPlacedChamberChamberPreset = _previouslyPlacedChamber[? PlacedChamberProps.ChamberPreset];
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
	
			var _placedChamber = placedChamberFromChamberPreset(_chosenChamberPreset);	
			_placedChamber[? PlacedChamberProps.Index] = _placedChambers;
			_placedChamber[? PlacedChamberProps.xPositionInDungeon] = _chosenColumn;
			_placedChamber[? PlacedChamberProps.yPositionInDungeon] = _chosenRow;	
	
			if (_previouslyPlacedChamber != undefined) {			
				ds_list_add(_previouslyPlacedChamber[? PlacedChamberProps.NextChambers], _placedChamber);
				ds_list_add(_placedChamber[? PlacedChamberProps.PreviousChambers], _previouslyPlacedChamber);
			}
	
			deactivateDirectionOnPlacedChamber(_placedChamber,_directionToPreventOnAllFollowingPlacedChambers);
			deactivateDirectionOnPlacedChamber(_placedChamber,oppositeDirectionForDirection(_directionToMoveToNext));
			_directionToMoveToNext = randomDirectionFromPlacedChamberDirections(_placedChamber);		
			_placedChamber[? PlacedChamberProps.DesiredDirectionToConnectTo] = _directionToMoveToNext;
	
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
	
	static toString = function() {
		var _debugString = "============================= DUNGEON PRESET ==============================\n";
		_debugString += "widthInPixel: " +string(self.widthInPixel) + "\n";
		_debugString += "heightInPixel: " +string(self.heightInPixel) + "\n";
		_debugString += "PlacedChambers (count): " +string(ds_list_size(self.placedChambers)) + "\n";
		return _debugString;
	}
}