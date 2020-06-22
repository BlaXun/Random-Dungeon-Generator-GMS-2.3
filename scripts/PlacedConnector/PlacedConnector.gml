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
		/*var _x, _y, _xEnd, _yEnd, _startingCoordinates, _borderTargetCoordinates;
		_startingCoordinates = startingCoordinatesForConnector(self);
		_borderTargetCoordinates = borderCoordinatesForConnector(self);		
		
		_x = min(_startingCoordinates.x,_borderTargetCoordinates.x);
		_y = min(_startingCoordinates.y, _borderTargetCoordinates.y);
		_xEnd = max(_startingCoordinates.xEnd, _borderTargetCoordinates.xEnd);
		_yEnd = max(_startingCoordinates.yEnd, _borderTargetCoordinates.yEnd);
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
		ds_grid_set_region(_typeGrid,_x,_y,_xEnd,_yEnd,ColorMeaning.HallwayEnd);*/
		
		
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
	return new Coordinates(0,0,0,0);
}

/*	@function borderCoordinatesForConnector(connector);
	@description Returns a Coordinates-Instance which describes the coordinates where the border of the conenctors "PlacedChamber"-Parent
				 is reached. This can be used on creating hallways for the first step (which is drawing a hallway to the border of the PlacedChamber)
	@param {PlacedConnector} connector	The PlacedConnector for which the coorinates should be returned	*/
function borderCoordinatesForConnector(connector) {
	return new Coordinates(0,0,0,0);
}

/*	@function connectingHallwayCoordinatesForConnector(connector);
	@description Returns the coordinates used to draw a hallway from the given connector to its targetConnector.
				 The coordinates returned will connect the hallway-parts of each connector with each other.
				 The coorinates will be located on the PlacedChamber of the given connector (not the PlacedChamber of the given connectors targetConnector!)
	@param {PlacedConnector} connector	The PlacedConnector for which the connecting coordinates should be returned;
*/
function connectingHallwayCoordinatesForConnector(connector) {
	return new Coordinates(0,0,0,0);
}

/*	@function endingCoordinatesForConnector(connector);
	@descrption	Returns the coordinates that connect the connecting hallway and the target PlacedConnector for the given connector
	@param {PlacedConnector} connector	The PlacedConnector that needs to be connected */
function endingCoordinatesForConnector(connector) {
	return new Coordinates(0,0,0,0);	
}