// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

/*	@function PlacedConnector(placedChamber, connectorPreset);
	@description	Creates a new PlacedConnector with the given parent PlacedChamber and using the
					values of the given ConnectorPreset as starting values (copied)
*/
function PlacedConnector(placedChamber, connectorPreset) constructor {

	self.x = connectorPreset.x;
	self.y = connectorPreset.y;	
	self.width = connectorPreset.width;
	self.height = connectorPreset.height;
	self.parentPlacedChamber = placedChamber;
	self.facingDirection = connectorPreset.facingDirection;
	
	self.didCreateHallway = false;	//	Set to true once the hallway was created
	self.isStartingConnector = false;
	self.isReceivingConnector = false;
	
	self.targetPlacedConnector = undefined;
	
	/*	@function createHallwayOnDungeonPreset(dungeonPreset);
		@description	Creates a hallway from this connector (the starting connector) to another connector (the receiving connector)
						using the given DungeonPreset.
		@param {DungeonPreset} dungeonPreset	The DungeonPreset to use for creating the hallway
	*/
	static createHallwayOnDungeonPreset = function(dungeonPreset) {
		
		var _typeGrid = dungeonPreset.valueTypeGrid.types;
		
		var _selfStartingCoordinates, _selfCornerCoordinates, _proximityCoordinates;
		_selfStartingCoordinates = outsideCoordinatesForConnector(self);
		
		ds_grid_set_region(_typeGrid,_selfStartingCoordinates.x,_selfStartingCoordinates.y,_selfStartingCoordinates.xEnd,_selfStartingCoordinates.yEnd,ColorMeaning.Hallway);
		
		_selfCornerCoordinates = cornerCoordinatesForConnector(self);		
		ds_grid_set_region(_typeGrid,_selfCornerCoordinates.x,_selfCornerCoordinates.y,_selfCornerCoordinates.xEnd,_selfCornerCoordinates.yEnd,ColorMeaning.HallwayCorner);
		
		_proximityCoordinates = proximityCoordinatesForConnector(self);
		ds_grid_set_region(_typeGrid,_proximityCoordinates.x,_proximityCoordinates.y,_proximityCoordinates.xEnd,_proximityCoordinates.yEnd,ColorMeaning.HallwayCorner);
		
		var _targetStartingCoordinates, _targetCornerCoordinates;
		_targetStartingCoordinates = outsideCoordinatesForConnector(self.targetPlacedConnector);
		ds_grid_set_region(_typeGrid,_targetStartingCoordinates.x,_targetStartingCoordinates.y,_targetStartingCoordinates.xEnd,_targetStartingCoordinates.yEnd,ColorMeaning.Hallway);
		
		
		//	First corner
		_targetCornerCoordinates = cornerCoordinatesForConnector(self.targetPlacedConnector);		
		ds_grid_set_region(_typeGrid,_targetCornerCoordinates.x,_targetCornerCoordinates.y,_targetCornerCoordinates.xEnd,_targetCornerCoordinates.yEnd,ColorMeaning.HallwayCorner);
		
		
		var _connectingHallwayCoordinates = connectingHallwayCoordinatesForConnector(self);
		ds_grid_set_region(_typeGrid,_connectingHallwayCoordinates.x,_connectingHallwayCoordinates.y,_connectingHallwayCoordinates.xEnd,_connectingHallwayCoordinates.yEnd,ColorMeaning.Hallway);
		
		self.didCreateHallway = true;
	}
}

function startingCoordinatesForConnector(connector) {

	var _x,_y,_xEnd,_yEnd;
	switch(connector.facingDirection) {
		
		case Direction.Left: {
			_x=connector.parentPlacedChamber.xPositionInDungeon+connector.x-1;
			_xEnd=_x
			_y=connector.parentPlacedChamber.yPositionInDungeon+connector.y;
			_yEnd=_y+connector.height-1;
		}
		break;
		
		case Direction.Right: {
			_x=connector.parentPlacedChamber.xPositionInDungeon+connector.x+1;
			_xEnd=_x;
			_y=connector.parentPlacedChamber.yPositionInDungeon+connector.y;
			_yEnd=_y+connector.height-1;
		}
		break;
		
		case Direction.Up: {
			_x=connector.parentPlacedChamber.xPositionInDungeon+connector.x;
			_xEnd=_x+connector.width-1;
			_y=connector.parentPlacedChamber.yPositionInDungeon+connector.y-1;
			_yEnd=_y;
		}
		break;
		
		case Direction.Down: {
			_x=connector.parentPlacedChamber.xPositionInDungeon+connector.x;
			_xEnd=_x+connector.width-1;
			_y=connector.parentPlacedChamber.yPositionInDungeon+connector.y+1;
			_yEnd=_y;
		}
		break;
	}
	
	return new Coordinates(_x,_y,_xEnd,_yEnd);
}

function outsideCoordinatesForConnector(connector) {

	var _startingCoordinates = startingCoordinatesForConnector(connector);
	var _cornerCoordinates = cornerCoordinatesForConnector(connector);
	
	var _x,_y,_xEnd,_yEnd;
	switch(connector.facingDirection) {
		
		case Direction.Left: {
			_x=_cornerCoordinates.x;
			_xEnd=_startingCoordinates.x;
			_y=_startingCoordinates.y;
			_yEnd=_startingCoordinates.yEnd;
		}
		break;
		
		case Direction.Right: {
			_x=_startingCoordinates.x;
			_xEnd=_cornerCoordinates.xEnd;
			_y=_startingCoordinates.y;
			_yEnd=_startingCoordinates.yEnd;
		}
		break;
		
		case Direction.Up: {
			_x=_startingCoordinates.x;
			_xEnd=_startingCoordinates.xEnd;
			_y=_cornerCoordinates.y
			_yEnd=_startingCoordinates.yEnd;
		}
		break;
		
		case Direction.Down: {
			_x=_startingCoordinates.x;
			_xEnd=_startingCoordinates.xEnd
			_y=_startingCoordinates.y;
			_yEnd=_cornerCoordinates.yEnd;
		}
		break;
	}
	
	return new Coordinates(_x,_y,_xEnd,_yEnd);
}
	
function proximityCoordinatesForConnector(connector) {

	var _x, _y, _xEnd, _yEnd;
	
	if (connector.isStartingConnector == false) {
		return new Coordinates(0,0,0,0);
	}
	
	var cornerCoordinates = cornerCoordinatesForConnector(connector);
	var targetPlacedChamber = connector.targetPlacedConnector.parentPlacedChamber;
	var targetPlacedChamberCoordinates = new Coordinates(	targetPlacedChamber.xPositionInDungeon, 
															targetPlacedChamber.yPositionInDungeon, 
															targetPlacedChamber.xPositionInDungeon+targetPlacedChamber.chamberPreset.totalWidth, 
															targetPlacedChamber.yPositionInDungeon+targetPlacedChamber.chamberPreset.totalHeight);
	
	switch(connector.facingDirection) {
		
		case Direction.Left: {
			_x=targetPlacedChamberCoordinates.xEnd;
			_xEnd=cornerCoordinates.x-1;
			_y=cornerCoordinates.y;
			_yEnd=cornerCoordinates.yEnd;
		}
		break;
		
		case Direction.Right: {
			_x=cornerCoordinates.xEnd+1;			
			_xEnd=targetPlacedChamberCoordinates.x-1;
			_y=cornerCoordinates.y;
			_yEnd=cornerCoordinates.yEnd;
		}
		break;
		
		case Direction.Up: {
			_x=cornerCoordinates.x;
			_xEnd=cornerCoordinates.xEnd;
			_y=targetPlacedChamberCoordinates.yEnd;
			_yEnd=cornerCoordinates.y-1;
		}
		break;
		
		case Direction.Down: {
			_x=cornerCoordinates.x;
			_xEnd=cornerCoordinates.xEnd;
			_y = cornerCoordinates.y+1;
			_yEnd=targetPlacedChamberCoordinates.y-1;
		}
		break;
	}
	
	delete targetPlacedChamberCoordinates;
	return new Coordinates(_x,_y,_xEnd,_yEnd);
}

function cornerCoordinatesForConnector(connector) {
	
	var _startingCoordinates = startingCoordinatesForConnector(connector);
	var _x,_y,_xEnd,_yEnd;
	switch(connector.facingDirection) {
		
		case Direction.Left: {
			_x=connector.parentPlacedChamber.xPositionInDungeon;
			_xEnd=_x + connector.height-1;
			_y=_startingCoordinates.y;
			_yEnd=_y + connector.height-1;
		}
		break;
		
		case Direction.Right: {
			_x=connector.parentPlacedChamber.xPositionInDungeon+connector.parentPlacedChamber.chamberPreset.totalWidth;
			_x-=connector.height;			
			_xEnd=_x + connector.height-1;
			_y=_startingCoordinates.y;
			_yEnd=_y + connector.height-1;
		}
		break;
		
		case Direction.Up: {
			_x=_startingCoordinates.x;
			_xEnd=_startingCoordinates.xEnd;
			_y=connector.parentPlacedChamber.yPositionInDungeon;
			_yEnd=_y + connector.width-1;
		}
		break;
		
		case Direction.Down: {
			_x=_startingCoordinates.x;
			_xEnd=_startingCoordinates.xEnd;
			_y = connector.parentPlacedChamber.yPositionInDungeon+connector.parentPlacedChamber.chamberPreset.totalHeight;
			_y -= connector.width;
			_yEnd=_y + connector.width-1;
		}
		break;
	}
	
	return new Coordinates(_x,_y,_xEnd,_yEnd);
}
	
function connectingHallwayCoordinatesForConnector(connector) {

	var _targetCornerCoordinates =  cornerCoordinatesForConnector(connector.targetPlacedConnector);
	var _proximityCoordinates = proximityCoordinatesForConnector(connector);
	
	var _x,_y,_xEnd,_yEnd;
	switch(connector.facingDirection) {
		
		case Direction.Left: {
			_x=_targetCornerCoordinates.xEnd+1;
			_xEnd=_x + connector.height-1;
			_y=min(_targetCornerCoordinates.y, _proximityCoordinates.y);
			_yEnd=max(_targetCornerCoordinates.yEnd, _proximityCoordinates.yEnd);
		}
		break;
		
		case Direction.Right: {
			_x=_proximityCoordinates.xEnd-(connector.height-1);
			_xEnd=_proximityCoordinates.xEnd;
			_y=min(_targetCornerCoordinates.y, _proximityCoordinates.y);
			_yEnd=max(_targetCornerCoordinates.yEnd, _proximityCoordinates.yEnd);
		}
		break;
		
		case Direction.Up: {
			_x=min(_targetCornerCoordinates.x,_proximityCoordinates.x);
			_xEnd=max(_targetCornerCoordinates.xEnd,_proximityCoordinates.xEnd);
			_y=_targetCornerCoordinates.yEnd+1;
			_yEnd=_y + connector.width-1;
		}
		break;
		
		case Direction.Down: {
			_x=min(_targetCornerCoordinates.x,_proximityCoordinates.x);
			_xEnd=max(_targetCornerCoordinates.xEnd,_proximityCoordinates.xEnd);
			_y=_proximityCoordinates.yEnd-(connector.width-1);
			_yEnd=_proximityCoordinates.yEnd;
		}
		break;
	}
	
	return new Coordinates(_x,_y,_xEnd,_yEnd);
}