///	@function emptyPlacedChamber();
///	@description Creates and returns a new PlacedChamber instance
function PlacedChamber(chamberPreset) constructor {

	/*
		A placed chamber is a container for a ChamberPreset that is actually placed within a dungeon.
		The placed chamber holds information about its location and the placed chambers docking chambers (which is the previous and next chambers)	
	*/

	self.chamberPreset = chamberPreset;
	self.index = -1;
	self.nextChambers = createList();
	self.previousChambers = createList();
	self.xPositionInDungeon = -1;
	self.yPositionInDungeon = -1;
	self.desiredDirectionToConnectTo = Direction.None;
	self.allowsConnectionOnAndFromRightSide = chamberPreset.allowsConnectionOnAndFromRightSide;
	self.allowsConnectionOnAndFromLeftSide = chamberPreset.allowsConnectionOnAndFromLeftSide;
	self.allowsConnectionOnAndFromTopSide = chamberPreset.allowsConnectionOnAndFromTopSide;
	self.allowsConnectionOnAndFromBottomSide = chamberPreset.allowsConnectionOnAndFromBottomSide;
	
	self.connectors = createPlacedConnectorsFromConnectorPresets(self, chamberPreset.allConnectors);
	self.placedConnectorForOutgoingConnection = undefined;
	self.placedConnectorForIncomingConnection = undefined;
	
	///	@function deactivateDirection(directionToDeactivate);
	///	@description	Based on previously placed chambers this chamber is not allowed to conenct to the given direction
	///				
	///	@param {Direction} directionToDeactivate	A Direction that is not allowed for this PlacedChamber
	static deactivateDirection = function(directionToDeactivate) {

		switch (directionToDeactivate) {
	
			case Direction.Down:
				self.allowsConnectionOnAndFromBottomSide = false;
			break;
	
			case Direction.Up:
				self.allowsConnectionOnAndFromTopSide = false;
			break;
	
			case Direction.Left:
				self.allowsConnectionOnAndFromLeftSide = false;
			break;
	
			case Direction.Right:
				self.allowsConnectionOnAndFromRightSide = false;
			break;
		}
	}
	
	
	///	@function randomDirectionFromAvailableDirections();
	///	@description	Returns a direction out of the available directions to connect to that are active on this PlacedChamber
	/// @return {Direction}
	static randomDirectionFromAvailableDirections = function() {

		var _availableDirections = [];

		if (self.allowsConnectionOnAndFromBottomSide) {	
			_availableDirections[array_length(_availableDirections)] = Direction.Down;
		}

		if (self.allowsConnectionOnAndFromTopSide) {
			_availableDirections[array_length(_availableDirections)] = Direction.Up;
		}

		if (self.allowsConnectionOnAndFromRightSide) {
			_availableDirections[array_length(_availableDirections)] = Direction.Right;
		}

		if (self.allowsConnectionOnAndFromLeftSide) {
			_availableDirections[array_length(_availableDirections)] = Direction.Left;
		}

		var _size = array_length(_availableDirections);
		var _directionToReturn = undefined;
		_directionToReturn = _size != 0 ? _availableDirections[floor(random(array_length(_availableDirections)))] : Direction.None; 

		return _directionToReturn;
	}

	///	@function correctPlacedChamberPositionsOnDungeonPreset(dungeonPreset,croppedSpaces);
	/// @description							Corrects the starting x and y position for all PlacedChambers on the given DungeonPreset using the given croppedSpaces-Array
	///	@param {ds_map}			dungeonPreset	The dungeonPreset that holds the PlacedChambers
	///	@param {array<real>}	croppedSpaces	A array with Position-Enum entries as key and pixels as value
	static correctPositions = function(croppedSpaces) {

		var _cropLeft = croppedSpaces[Position.Left];
		var _cropTop = croppedSpaces[Position.Top];

		self.xPositionInDungeon -= _cropLeft;
		self.yPositionInDungeon -= _cropTop;
	}
	
	static toString = function() {
		var _debugString = "============================= PLACED CHAMBER ==============================\n";
		_debugString +="chambePreset: " +string(self.chamberPreset) +"\n";
		_debugString +="NextChambers (size): " + string(ds_list_size(self.nextChambers))+"\n";
		_debugString +="PreviousChambers (size): " + string(ds_list_size(self.previousChambers))+"\n";
		_debugString +="xPositionInDungeon: " + string(self.xPositionInDungeon)+"\n";
		_debugString +="yPositionInDungeon: " + string(self.yPositionInDungeon)+"\n";
		_debugString +="Sprite: " + sprite_get_name(self.chamberPreset.sprite)+"\n";
		_debugString +="Index: " + string(self.index);
		
		return _debugString;
	}

	/*	@function selectConnectorOnSideForNextConnection(side);
		@description	Selects a connector on the given side to be the connector that will establish the conenction to the next PlacedChamber
		@param {Direction} side	The side to which the outgoing connection should be established */
	static selectConnectorOnSideForNextConnection = function(side) {
		var _availableConnectors = self.connectorsForSide(side);
		var _chosenConnector = _availableConnectors[floor(random(array_length(_availableConnectors)))];
		_chosenConnector.isStartingConnector = true;

		self.placedConnectorForOutgoingConnection = _chosenConnector;
	}
	
	/*	@function selectConnectorOnSideForPreviousConnection(side, connectorThatWantsToConnectToThisOne);
		@description	Selects onne of the available conenctors for the given side that will accept a connection
						with the given connector. The chosen connector is the receiver for the connection
		@param {Direction} side	The side on which a connector will be chosen
		@param {PlacedConnector} connectorThatWantsToConnectToThisOne A PlacedConnector that wants to connect to the chosen PlacedConnector */
	static selectConnectorOnSideForPreviousConnection = function(side, connectorThatWantsToConnectToThisOne) {
		var _availableConnectors = self.connectorsForSide(side);
		var _chosenConnector = _availableConnectors[floor(random(array_length(_availableConnectors)))];
		_chosenConnector.isReceivingConnector = true;
		_chosenConnector.targetPlacedConnector = connectorThatWantsToConnectToThisOne;
		self.placedConnectorForIncomingConnection = _chosenConnector;
	}
	
	/*	@function connectorsForSide(side);
		@description Returns all connectors that can establish a connection to the given side
		@param {Direction} side The side to which the connector should be facing */
	static connectorsForSide = function(side) {
		var _connectors = [];
		var _currentConnector = undefined;
		for (var _i=0;_i<array_length(self.connectors);_i++) {
			_currentConnector = self.connectors[_i];
			
			if (_currentConnector.facingDirection == side) {
				_connectors[array_length(_connectors)] = _currentConnector;
			}
		}
		
		return _connectors;
	}
}

/*	@function createPlacedConnectorsFromConnectorPresets(connectorPresets);
	@description Creates a PlacedConnector-Instance for each ConnectorPreset in the given collection and returns it
	@param {PlacedChamber} placedChamber	The placed chamber to be assigned as parent placed chamber for all created PlacedConnectors 
	@param {array<ConnectorPreset>} connectorPresets	A array filled with ConnectorPreset-Instances
	@return {array<PlacedConnector>}
*/
function createPlacedConnectorsFromConnectorPresets(placedChamber, connectorPresets) {
	var _placedConnectors = [];
	var _currentConnector = undefined;
	for (var _i=0;_i<array_length(connectorPresets);_i++) {
		_currentConnector = connectorPresets[_i];
		_placedConnectors[array_length(_placedConnectors)] = new PlacedConnector(placedChamber, _currentConnector);
	}
	
	return _placedConnectors;
}
