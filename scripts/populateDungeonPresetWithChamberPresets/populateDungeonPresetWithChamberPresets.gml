///	@function	populateDungeonPresetWithChamberPresets(dungeonPreset,chamberPresets,amountOfChambersToPlace)
///	@param {ds_grid} dungeonPreset			The dungeon preset to populate
///	@param {ds_list} chamberPresets			A list of chamber presets that are available to be used for populating
///	@param {real} amountOfChambersToPlace	The amount of chambers that the dungeon should consist of
function populateDungeonPresetWithChamberPresets() {

	var _dungeonPreset = argument[0];
	var _chamberPresets = argument[1];
	var _amountOfChambersToPlace = argument[2];
	randomize();

	var _dungeonPixelGrid = valueGridFromValueTypeGrid(_dungeonPreset[? DungeonPresetProps.ValueTypeGrid]);
	var _dungeonTypeGrid = typeGridFromValueTypeGrid(_dungeonPreset[? DungeonPresetProps.ValueTypeGrid]);

	var _dungeonGridWidth, _dungeonGridHeight;
	_dungeonGridWidth = ds_grid_width(_dungeonPixelGrid);
	_dungeonGridHeight = ds_grid_height(_dungeonPixelGrid);

	debug("Placing " + string(_amountOfChambersToPlace) +" chambers.");

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

	while (_placedChambers != _amountOfChambersToPlace) {
				
		_chosenChamberPreset = chamberThatAllowsConnectionOnSide(_chamberPresets, oppositeDirectionForDirection(_directionToMoveToNext), _directionToPreventOnAllFollowingPlacedChambers);	
	
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
			_previousChamberPresetTotalWidth = _previousPlacedChamberChamberPreset[? ChamberPresetProps.TotalWidth];
			_previousChamberPresetTotalHeight = _previousPlacedChamberChamberPreset[? ChamberPresetProps.TotalHeight];
	
			var _thisChamberWidth, _thisChamberHeight;
			_thisChamberWidth = _chosenChamberPreset[? ChamberPresetProps.TotalWidth];
			_thisChamberHeight = _chosenChamberPreset[? ChamberPresetProps.TotalHeight];
		
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
	
		var _typeGridOnChosenChamber = typeGridFromValueTypeGrid(_chosenChamberPreset[? ChamberPresetProps.ValueTypeGrid]);
	
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
	
		var _valueGridOnChamberPreset = valueGridFromValueTypeGrid(_chosenChamberPreset[? ChamberPresetProps.ValueTypeGrid]);
		var _typeGridOnChamberPreset = typeGridFromValueTypeGrid(_chosenChamberPreset[? ChamberPresetProps.ValueTypeGrid]);
	
		var _chamberPresetTotalWidth, _chamberPresetTotalHeight;
		_chamberPresetTotalWidth = _chosenChamberPreset[? ChamberPresetProps.TotalWidth];
		_chamberPresetTotalHeight = _chosenChamberPreset[? ChamberPresetProps.TotalHeight];
		ds_grid_set_grid_region(_dungeonPixelGrid,_valueGridOnChamberPreset,0,0,_chamberPresetTotalWidth,_chamberPresetTotalHeight,_chosenColumn,_chosenRow);
		ds_grid_set_grid_region(_dungeonTypeGrid, _typeGridOnChamberPreset,0,0,_chamberPresetTotalWidth,_chamberPresetTotalHeight,_chosenColumn,_chosenRow);
	

		_previouslyPlacedChamber = _placedChamber;
		ds_list_add(_dungeonPreset[? DungeonPresetProps.PlacedChambers],_placedChamber);
		_placedChambers+=1;
	}

	debug("Done placing chambers (" + string(_placedChambers)+"/"+string(_amountOfChambersToPlace)+")");


}
