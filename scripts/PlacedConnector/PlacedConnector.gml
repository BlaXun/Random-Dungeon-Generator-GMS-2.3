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
		
		//	Start drawing from connector to border
		var _x, _y, _xEnd, _yEnd, _startingCoordinates, _borderTargetCoordinates;
		_startingCoordinates = startingCoordinatesForConnector(self);
		_borderTargetCoordinates = borderCoordinatesForConnector(self);		
		
		_x = _startingCoordinates.x;
		_y = _startingCoordinates.y;
		_xEnd = _borderTargetCoordinates.xEnd;
		_yEnd = _borderTargetCoordinates.yEnd;
		ds_grid_set_region(_typeGrid,_x,_y,_xEnd,_yEnd,ColorMeaning.Hallway);
		
		//	Draw connecting hallway
		var _connectingCoordinates = connectingHallwayCoordinatesForConnector(self);		
		_x = _connectingCoordinates.x;
		_y = _connectingCoordinates.y;
		_xEnd = _connectingCoordinates.xEnd;
		_yEnd = _connectingCoordinates.yEnd;
		
		ds_grid_set_region(_typeGrid,_x,_y,_xEnd,_yEnd,ColorMeaning.ChamberGround);
		
		//	Draw from connecting hallway to target connector
		var _finalCoordinates = endingCoordinatesForConnector(self);
		if (_finalCoordinates == undefined) {
			exit;
		}
		
		_x = _finalCoordinates.x;
		_y = _finalCoordinates.y;
		_xEnd = _finalCoordinates.xEnd;
		_yEnd = _finalCoordinates.yEnd;
		ds_grid_set_region(_typeGrid,_x,_y,_xEnd,_yEnd,ColorMeaning.HallwayEnd);
		
		
		//	Das hier muss alles noch je nach direction angepasst werden
		//	Außerdem sind es min. 3 schritte um einen hallway zu zeichen
		/*
			1. Bis zum rand zeichnen
			2. In Richtung des Ziels zeichnen
			3. Ins Ziel zeichnen (also direkt bis davor)
		*/
		
		self.didCreateHallway = true;
	}
}

/*	@function startingCoordinatesForConnector(connector);
	@description Returns a Coordinates-Instance used for starting to draw a hallway.
				 Depending on the PlacedConnectors facing direction the coordinates will change.
	@param {PlacedConnector} connector The PlacedConnector for which the starting coordinates should be returned */
function startingCoordinatesForConnector(connector) {
	
	var _x,_y,_xEnd,_yEnd;
	switch(connector.facingDirection) {
		
		case Direction.Left: {
			_x=connector.parentPlacedChamber.xPositionInDungeon+connector.x-1;
			_xEnd=_x;
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
	
/*	@function borderCoordinatesForConnector(connector);
	@description Returns a Coordinates-Instance which describes the coordinates where the border of the conenctors "PlacedChamber"-Parent
				 is reached. This can be used on creating hallways for the first step (which is drawing a hallway to the border of the PlacedChamber)
	@param {PlacedConnector} connector	The PlacedConnector for which the coorinates should be returned	*/
function borderCoordinatesForConnector(connector) {
	
	var _x,_y,_xEnd,_yEnd;

	var placedChamberWidth, placedChamberHeight;
	placedChamberWidth = connector.parentPlacedChamber.chamberPreset.totalWidth;
	placedChamberHeight = connector.parentPlacedChamber.chamberPreset.totalHeight;
	
	switch (connector.facingDirection) {
		
		case Direction.Left: {
			_x=connector.parentPlacedChamber.xPositionInDungeon+1;
			_y=connector.parentPlacedChamber.yPositionInDungeon + connector.y;
			_xEnd = _x;
			_yEnd = _y+connector.height-1;
		}
		break;
		
		case Direction.Up: {
			_x=connector.parentPlacedChamber.xPositionInDungeon + connector.x;
			_y=connector.parentPlacedChamber.yPositionInDungeon+1;
			_xEnd = _x+connector.width-1;
			_yEnd = _y;
		}
		break;
		
		case Direction.Right: {
			_x=connector.parentPlacedChamber.xPositionInDungeon+placedChamberWidth-2;
			_y=connector.parentPlacedChamber.yPositionInDungeon + connector.y;
			_xEnd = _x;
			_yEnd = _y+connector.height-1;
		}
		break;
		
		case Direction.Down: {
			_x=connector.parentPlacedChamber.xPositionInDungeon + connector.x;
			_y=connector.parentPlacedChamber.yPositionInDungeon + placedChamberHeight-2;
			_xEnd = _x+connector.width-1;
			_yEnd = _y;
		}
		break;
	}
	
	return new Coordinates(_x,_y,_xEnd,_yEnd);
}

/*	@function connectingHallwayCoordinatesForConnector(connector);
	@description Returns the coordinates used to draw a hallway from the given connector to its targetConnector.
				 The coordinates returned will connect the hallway-parts of each connector with each other.
				 The coorinates will be located on the PlacedChamber of the given connector (not the PlacedChamber of the given connectors targetConnector!)
	@param {PlacedConnector} connector	The PlacedConnector for which the connecting coordinates should be returned;
*/
function connectingHallwayCoordinatesForConnector(connector) {
	
	var _x, _y, _xEnd, _yEnd;
	var _borderCoordinates = borderCoordinatesForConnector(connector);
	var _targetBorderCoordinates = borderCoordinatesForConnector(connector.targetPlacedConnector);
	
	switch (connector.facingDirection) {
		
		case Direction.Left: {			
			_y=min(_borderCoordinates.y,_targetBorderCoordinates.y);
			_x = _borderCoordinates.x;
			_xEnd = _x+(connector.height-1);
			
			_yEnd = max(_borderCoordinates.yEnd,_targetBorderCoordinates.yEnd);
		}
		break;
		
		case Direction.Up: {
			_x=min(_borderCoordinates.x,_targetBorderCoordinates.x);
			_y=_borderCoordinates.y-1;
			_xEnd = max(_borderCoordinates.xEnd,_targetBorderCoordinates.xEnd);
			_yEnd = _y+connector.width-1;
		}
		break;
		
		case Direction.Right: {
			_x=_borderCoordinates.x-connector.height-1;
			_y=min(_borderCoordinates.y,_targetBorderCoordinates.y);
			_xEnd = _borderCoordinates.xEnd+1;
			_yEnd = max(_borderCoordinates.yEnd,_targetBorderCoordinates.yEnd);
		}
		break;
		
		case Direction.Down: {
			_x=min(_borderCoordinates.x,_targetBorderCoordinates.x);
			_y=_borderCoordinates.yEnd+1-connector.width-1;
			_xEnd = max(_borderCoordinates.xEnd,_targetBorderCoordinates.xEnd);
			_yEnd = _borderCoordinates.y;
		}
		break;
	}
	
	return new Coordinates(_x,_y,_xEnd,_yEnd);
}

/*	@function endingCoordinatesForConnector(connector);
	@descrption	Returns the coordinates that connect the connecting hallway and the target PlacedConnector for the given connector
	@param {PlacedConnector} connector	The PlacedConnector that needs to be connected */
function endingCoordinatesForConnector(connector) {
	
	var _connectingHallwayCoordinates = connectingHallwayCoordinatesForConnector(self);
	var _startingCoordinates = startingCoordinatesForConnector(self);
	var _targetStartingCoordinates = startingCoordinatesForConnector(self.targetPlacedConnector);
	var _x, _y, _xEnd, _yEnd;
	
	switch (connector.facingDirection) {
		
		case Direction.Left: {
			
			_x=_targetStartingCoordinates.x;
			_y=_targetStartingCoordinates.y;
			
			_xEnd = _connectingHallwayCoordinates.x-1;
			_yEnd = _targetStartingCoordinates.yEnd;
			
		}
		break;
		
		case Direction.Up: {
			_x=_targetStartingCoordinates.x;
			_xEnd = _targetStartingCoordinates.xEnd;
				
			_y=_targetStartingCoordinates.y;
			_yEnd = _connectingHallwayCoordinates.yEnd;
		}
		break;
		
		case Direction.Right: {
			
			_x=_connectingHallwayCoordinates.x;
			_xEnd = _targetStartingCoordinates.x;
				
			if (_startingCoordinates.y > _targetStartingCoordinates.y) {			
				_y=_targetStartingCoordinates.y;
				_yEnd = _connectingHallwayCoordinates.y+connector.height;
			} else {
				_y=_targetStartingCoordinates.y;
				_yEnd=_targetStartingCoordinates.yEnd;
			}
		}
		break;
		
		case Direction.Down: {			
			_x=_targetStartingCoordinates.x;
			_xEnd = _targetStartingCoordinates.xEnd;
				
			_y=_connectingHallwayCoordinates.yEnd+1;
			_yEnd = _targetStartingCoordinates.yEnd;			
		}
		break;
	}
	
	return new Coordinates(_x,_y,_xEnd,_yEnd);
	
}