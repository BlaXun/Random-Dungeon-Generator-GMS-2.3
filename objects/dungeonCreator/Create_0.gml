/// @description Insert description here
// You can write your code in this editor
self.colorAssignment = new ColorAssignment();
self.colorAssignment.addChamberGroundColor(make_color_rgb(255,255,255));
self.colorAssignment.addConnectorColor(make_color_rgb(238,28,36));

self.colorAssignment.backgroundColor = make_color_rgb(149,125,173);
self.colorAssignment.colorUsedToDrawConnectors = make_color_rgb(224,187,228);
self.colorAssignment.colorUsedToDrawChamberGround = make_color_rgb(255,223,211);
self.colorAssignment.colorUsedToDrawHallways = make_color_rgb(254,200,216);
self.colorAssignment.colorUsedToDrawPadding = make_color_rgb(210,145,188);


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
_options.minimumRandomOffsetBetweenPlacedChambers = 5;
_options.maximumRandomOffsetBetweenPlacedChambers = 20;

self.rdg = new RandomDungonGenerator(_options);
self.rdg.generateDungeon();
self.rdg.drawDungeon();