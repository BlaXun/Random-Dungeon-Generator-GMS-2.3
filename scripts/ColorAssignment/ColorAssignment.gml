// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

enum ColorMeaning {
	Connector,
	Hallway,
	HallwayCorner,
	ChamberGround,
	Padding,
	Unknown
}

function ColorAssignment() constructor {

	self.colorsDetectedAsConnector = createList();
	self.colorsDetectedAsChamberGround = createList();
	self.colorUsedToDrawHallways = make_color_rgb(0,0,255);
	self.colorUsedToDrawPadding = undefined;
	self.colorUsedToDrawConnectors = undefined;
	self.colorUsedToDrawHallwayCorners = undefined;
	self.backgroundColor = c_black;	
	
	self._colorMeanings = createMap();
	
	static addConnectorColor = function(color) {
		self.colorsDetectedAsConnector[| ds_list_size(self.colorsDetectedAsConnector)] = color; 
		self._colorMeanings[? self.uniformIdentifierForColor(color)] = ColorMeaning.Connector;
	}
	
	static addChamberGroundColor = function(color) {
		self.colorsDetectedAsChamberGround[| ds_list_size(self.colorsDetectedAsConnector)] = color;
		self._colorMeanings[? self.uniformIdentifierForColor(color)] = ColorMeaning.ChamberGround;
	}
		
	static setHallwayCornerColor = function(color) {
		self.colorUsedToDrawHallwayCorners = color;
		self._colorMeanings[? self.uniformIdentifierForColor(color)] = ColorMeaning.HallwayCorner;
	}
	
	static setHallwayDrawColor = function(color) {
		self.colorUsedToDrawHallways = color;
		self._colorMeanings[? self.uniformIdentifierForColor(color)] = ColorMeaning.Hallway;
	}
	
	static setPaddingDrawColor = function(color) {
		self.colorUsedToDrawPadding = color;
		self._colorMeanings[? self.uniformIdentifierForColor(color)] = ColorMeaning.Padding;
	}

	static meaningForColor = function(color) {
		
		if (color == undefined) {
			throw ("Passed undefined on color parameter in meaningForColor");
		}
		
		var _meaning = self._colorMeanings[? self.uniformIdentifierForColor(color)];
		return _meaning == undefined ? ColorMeaning.Unknown : _meaning;
	}
	
	static uniformIdentifierForColor = function(color) {
		return string(color_get_red(color))+","+string(color_get_green(color))+","+string(color_get_blue(color));
	}
	
	static uninit = function() {
		destroyList(self.colorsDetectedAsConnector);
		destroyList(self.colorsDetectedAsChamberGround);
		destroyMap(self._colorMeanings);
	}	
}