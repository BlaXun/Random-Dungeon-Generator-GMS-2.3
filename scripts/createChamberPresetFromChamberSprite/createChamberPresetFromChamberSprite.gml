///	@function createChamberPresetFromChamberSprite(chamberSprite,colorAssignments,padding);
///	@description Cretes a chamber preset from the given sprite using the given colors
///	@param {real} chamberSprite The index of the sprite to use
/// @param {color} colorAssignments A map that defines the meaning of the encountered colors
///	@param {real} padding A padding to apply around the pixel grid
function createChamberPresetFromChamberSprite() {

	var _chamberSprite = argument[0];
	var _colorAssignments = argument[1];
	var _padding = argument[2];

	//	Find chamber content -> output to 2d array or map
	//	Find chamber vertical connectors -> output coordinates and dimensions to 2d array or map
	//	Find chamber horizontal connectors -> output coordinars and dimensions to 2d array or map

	var _chamberPreset = new ChamberPreset();
	_chamberPreset.sprite = _chamberSprite;

	var _chamberSpriteWidth, _chamberSpriteHeight;
	_chamberSpriteWidth = sprite_get_width(_chamberSprite);
	_chamberSpriteHeight = sprite_get_height(_chamberSprite);

	_chamberPreset.totalWidth = _chamberSpriteWidth+(_padding*2);
	_chamberPreset.totalHeight = _chamberSpriteHeight+(_padding*2);

	var _grids = createPixelGridAndDatatypeGridFromSprite(_chamberSprite, _colorAssignments, _padding);
	var _valueTypeGrid = newValueTypeGrid(_chamberSpriteWidth+(_padding*2), _chamberSpriteHeight+(_padding*2),false);
	_valueTypeGrid[? ValueTypeGridProps.Values] = _grids[0];
	_valueTypeGrid[? ValueTypeGridProps.Types] = _grids[1];
	_chamberPreset.valueTypeGrid = _valueTypeGrid;
	_chamberPreset.padding = _padding;

	var _connectorColor, _chamberColor;
	_chamberColor = findColorForColorAssignment(_colorAssignments, ColorAssignment.ChamberGround);
	_connectorColor = findColorForColorAssignment(_colorAssignments, ColorAssignment.Connector);

	_chamberPreset.createAndAssignConnectorsOnChamberPreset(_connectorColor, _chamberColor);
	_chamberPreset.assignDirectionsToConnectToOnChamberPreset();
	
	return _chamberPreset;
}
