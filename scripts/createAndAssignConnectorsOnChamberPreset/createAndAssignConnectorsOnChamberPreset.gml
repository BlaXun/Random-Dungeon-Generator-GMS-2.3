///	@function		createAndAssignConnectorsOnChamberPreset(chamberPreset,connectorColor,chamberColor);
///	@description	Searches for connectors on the given chamber preset and assigns them to the given chamberPreset
///	@param chamberPreset {ds_map}	The chamber preset to analyze
///	@param connectorColor {color}	The color used to detect connectors
///	@param chamberColor {color}	The color used to detect chamber ground
function createAndAssignConnectorsOnChamberPreset() {

	var _chamberPreset = argument[0];
	var _connectorColor = argument[1];
	var _chamberColor = argument[2];

	var _upFacingConnectors, _downFacingConnectors, _rightFacingConnectors, _leftFacingConnectors, _allConnectors;
	_upFacingConnectors = [];
	_leftFacingConnectors = [];
	_downFacingConnectors = [];
	_rightFacingConnectors = [];
	_allConnectors = [];

	if (_chamberPreset != undefined && _connectorColor != undefined) {
	
		var _pixelGrid = valueGridFromValueTypeGrid(_chamberPreset[? ChamberPresetProps.ValueTypeGrid]);
	
		var _gridWidth, _gridHeight, _xPos, _yPos;
		_gridWidth = ds_grid_width(_pixelGrid);
		_gridHeight = ds_grid_height(_pixelGrid);
	
		var _pixelGridCopy = newGrid(_gridWidth,_gridHeight); 
		ds_grid_copy(_pixelGridCopy, _pixelGrid);	
	
		var _pixel, _connectorDirection, _neighborPixelRight, _neighborPixelBottom, _neighborPixelTop, _neighborPixelLeft;	
		for (_yPos=0;_yPos<_gridHeight;_yPos++) {
				
			for (_xPos=0;_xPos<_gridWidth;_xPos++) {
				_connectorDirection = Direction.None;
			
				_pixel = _pixelGridCopy[# _xPos,_yPos];
			
				if (_pixel == _connectorColor) {
				
					_neighborPixelRight = _xPos < _gridWidth-1 ? _pixelGridCopy[# _xPos+1,_yPos] : noone;
					_neighborPixelBottom = _yPos < _gridHeight-1 ? _pixelGridCopy[# _xPos,_yPos+1] : noone;
				
					if !(_neighborPixelRight == _connectorColor || _neighborPixelBottom == _connectorColor) {					
						continue;
					}
				
					_neighborPixelLeft = _xPos == 0 ? noone : _pixelGridCopy[# _xPos-1, _yPos];
					_neighborPixelTop = _yPos == 0 ? noone : _pixelGridCopy[# _xPos, _yPos-1];
				
					//	New Connector found
					var _newConnector = emptyConnectorPreset();
					_newConnector[? ConnectorPresetProps.XStart] = _xPos;
					_newConnector[? ConnectorPresetProps.XEnd] = _xPos;
					_newConnector[? ConnectorPresetProps.YStart] = _yPos;
					_newConnector[? ConnectorPresetProps.YEnd] = _yPos;
					
					//	Detecting wether its a horizontal or vertical connector				
					if (_neighborPixelRight == _connectorColor) {				
					
						//	Vertical Connector										
						var _connectorDirection = Direction.None;
						if (_neighborPixelBottom == noone && _neighborPixelTop == _chamberColor) {
							_connectorDirection = Direction.Down;
						} else if (_neighborPixelTop == noone && _neighborPixelBottom == _chamberColor) {
							_connectorDirection = Direction.Up;
						}
					
						if (_connectorDirection == Direction.None) {						
						
							//	Broken Connector Detected. Skipping
							destroyMap(_newConnector);
							continue;
						}
					 
						_newConnector[? ConnectorPresetProps.Height] = 1;		
						_newConnector[? ConnectorPresetProps.FacingDirection] = _connectorDirection;
					
						var _neighborIsBlankOrGround = false;
						var _width = 1;
						while(_neighborIsBlankOrGround == false) {
						
							_neighborPixelRight = (_xPos+_width > _gridWidth-1) ? noone : _pixelGridCopy[# _xPos+_width,_yPos];
						
							if (_neighborPixelRight == noone || _neighborPixelRight == _chamberColor) {
								_neighborIsBlankOrGround = true;
							} else {
								//	Mask neighbor with chamber color to prevent duplicate detection
								_pixelGridCopy[# _xPos+_width,_yPos] = _chamberColor;
								_width +=1;
							}
						}
					
						_newConnector[? ConnectorPresetProps.XEnd] = _xPos+_width-1;
						_newConnector[? ConnectorPresetProps.Width] = _width;
					
						if (_connectorDirection == Direction.Up) {
							_upFacingConnectors[array_length_1d(_upFacingConnectors)] = _newConnector;		
						} else if (_connectorDirection == Direction.Down) {
							_downFacingConnectors[array_length_1d(_downFacingConnectors)] = _newConnector;		
						}
					
						_allConnectors[array_length_1d(_allConnectors)] = _newConnector;
					} else {
					
						//	Horizontal Connector
						var _connectorDirection = Direction.None;
						if (_neighborPixelRight == noone && _neighborPixelLeft == _chamberColor) {
							_connectorDirection = Direction.Right;
						} else if (_neighborPixelLeft == noone && _neighborPixelRight == _chamberColor) {
							_connectorDirection = Direction.Left;
						}
					
						if (_connectorDirection == Direction.None) {						
						
							//	Broken Connector Detected. Skipping
							destroyMap(_newConnector);
							continue;
						}
					 
						_newConnector[? ConnectorPresetProps.Width] = 1;		
						_newConnector[? ConnectorPresetProps.FacingDirection] = _connectorDirection;
					
						var _neighborIsBlankOrGround = false;
						var _height = 1;
						while(_neighborIsBlankOrGround == false) {
						
							_neighborPixelBottom = (_yPos+_height > _gridHeight-1) ? noone : _pixelGridCopy[# _xPos,_yPos+_height];
						
							if (_neighborPixelBottom == noone || _neighborPixelBottom == _chamberColor) {
								_neighborIsBlankOrGround = true;
							} else {										
								//	Mask neighbor with chamber color to prevent duplicate detection
								ds_grid_set(_pixelGridCopy,_xPos,_yPos+_height,_chamberColor);						
								_height +=1;
							}
						}
					
						_newConnector[? ConnectorPresetProps.YEnd] = _yPos+_height-1;
						_newConnector[? ConnectorPresetProps.Height] = _height;
					
						if (_connectorDirection == Direction.Left) {
							_leftFacingConnectors[array_length_1d(_leftFacingConnectors)] = _newConnector;		
						} else if (_connectorDirection == Direction.Right) {
							_rightFacingConnectors[array_length_1d(_rightFacingConnectors)] = _newConnector;		
						}
					
						_allConnectors[array_length_1d(_allConnectors)] = _newConnector;
					}
				}
			}
		}
	
		_chamberPreset[? ChamberPresetProps.UpFacingConnectors] = _upFacingConnectors;
		_chamberPreset[? ChamberPresetProps.LeftFacingConnectors] = _leftFacingConnectors;
		_chamberPreset[? ChamberPresetProps.DownFacingConnectors] = _downFacingConnectors;
		_chamberPreset[? ChamberPresetProps.RightFacingConnectors] = _rightFacingConnectors;
	
		_chamberPreset[? ChamberPresetProps.AllConnectors] = _allConnectors;
	
		destroyGrid(_pixelGridCopy);
	}


}
