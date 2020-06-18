///	@function newValueTypeGrid(width,height,prePopulate);
///	@description Creates a new Value-Type Grid
///
///	A Value-Type grid encapsulates both a grid for whatever content and a second grid that holds information about the
///	Datatype that is stored at the same place as the value. The Datatype conforms to the GridContentType-Enum.
///	Default type for all positions is noone
///
///	@param {real} width				Width of the grid
/// @param {real} height			Height of the grid
/// @param {boolean} prePopulate	Wether the ValueTypeGrid should initialize both its' Value and Type Grid
function newValueTypeGrid() {

	var _width = argument[0];
	var _height = argument[1];
	var _prePopulate = argument[2];

	enum ValueTypeGridProps {
		Values,
		Types,
		Width,
		Height
	}

	enum GridContentType {
		ChamberGround,	//	The content is chamber ground (usually a color)
		Connector,		//	The content is a connector on a chamber (usually a color)
		Padding,		//	The content is padding around a chamber (Not a color, just metadata)
		Hallway,		//	The content is a hallway (usually a color)
		Other			//	The content is something else. Maybe a color :)
	}

	var _valueTypeGrid = newMap();
	_valueTypeGrid[? ValueTypeGridProps.Values] = _prePopulate ? newGrid(_width,_height) : noone;
	_valueTypeGrid[? ValueTypeGridProps.Types] = _prePopulate ? newGrid(_width,_height) : noone;
	_valueTypeGrid[? ValueTypeGridProps.Width] = _width;
	_valueTypeGrid[? ValueTypeGridProps.Height] = _height;

	return _valueTypeGrid;




}
