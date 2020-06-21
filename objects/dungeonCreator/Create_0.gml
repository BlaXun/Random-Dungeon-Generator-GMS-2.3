/// @description Insert description here
// You can write your code in this editor
self.colorAssignment = new ColorAssignment();
self.colorAssignment.backgroundColor = c_black;
self.colorAssignment.addChamberGroundColor(make_color_rgb(255,255,255));
self.colorAssignment.addConnectorColor(make_color_rgb(238,28,36));
self.colorAssignment.setPaddingDrawColor(make_color_rgb(30,30,30));
self.colorAssignment.colorUsedToDrawConnectors = c_red;

var _chamberSprites = [];
var _chamberSpriteAssetIndices = tag_get_assets("ChamberSprite");
for (var _i=0;_i<array_length(_chamberSpriteAssetIndices);_i++) {
	_chamberSprites[array_length(_chamberSprites)] = asset_get_index(_chamberSpriteAssetIndices[_i]);
}
	
var _options = GeneratorOptions(self.colorAssignment,_chamberSprites);

//	Das padding muss autom. anhand des größten connectors gesetzt werden. Damit 
//	ein hallway gezeichnet werden kann MUSS das padding so gesetzt werden
//	padding = maxConnectorDimension+ceil(maxConnectorDimension/2)

_options.amountOfChambersToPlace = 25;
_options.minimumRandomOffsetBetweenPlacedChambers = 0;
_options.maximumRandomOffsetBetweenPlacedChambers = 0;

self.rdg = new RandomDungonGenerator(_options);
self.rdg.generateDungeon();
self.rdg.drawDungeon();