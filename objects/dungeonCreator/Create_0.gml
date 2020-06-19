/// @description Insert description here
// You can write your code in this editor
self.colorAssignment = new ColorAssignment();
self.colorAssignment.backgroundColor = c_black;
self.colorAssignment.addChamberGroundColor(make_color_rgb(255,255,255));
self.colorAssignment.addConnectorColor(make_color_rgb(238,28,36));
self.colorAssignment.setPaddingDrawColor(make_color_rgb(0,255,0));

var _chamberSprites = [];
var _chamberSpriteAssetIndices = tag_get_assets("ChamberSprite");
for (var _i=0;_i<array_length(_chamberSpriteAssetIndices);_i++) {
	_chamberSprites[array_length(_chamberSprites)] = asset_get_index(_chamberSpriteAssetIndices[_i]);
}
	
self.rdg = new RandomDungonGenerator(self.colorAssignment,_chamberSprites);
self.rdg.generateDungeon();
self.rdg.drawDungeon();