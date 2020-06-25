enum ColorMeaning {
	Connector,
	Hallway,
	ChamberGround,
	Padding,
	Unknown
}

function ColorAssignment() constructor {

	self.colorsDetectedAsConnector = createList();
	self.colorsDetectedAsChamberGround = createList();
	self.colorsDetectedAsUserDefined = createList();
	self._userDefinedColorsMeanings = createMap();
	self.colorUsedToDrawHallways = make_color_rgb(0,0,255);
	self.colorUsedToDrawPadding = undefined;
	self.colorUsedToDrawConnectors = undefined;
	self.colorUsedToDrawChamberGround = undefined;
	self.backgroundColor = c_black;	
	
	static addConnectorColor = function(color) {
		self.colorsDetectedAsConnector[| ds_list_size(self.colorsDetectedAsConnector)] = color; 
	}
	
	static addUserDefinedColorWithValue = function(color, value) {
		self.colorsDetectedAsUserDefined[| ds_list_size(self.colorsDetectedAsUserDefined)] = color; 
		_userDefinedColorsMeanings[? color] = value;
	}
	
	static addChamberGroundColor = function(color) {
		self.colorsDetectedAsChamberGround[| ds_list_size(self.colorsDetectedAsConnector)] = color;
	}
	
	static meaningForColor = function(color) {
		
		var _meaning = undefined;
		if (ds_list_find_index(self.colorsDetectedAsConnector, color) > -1) {
			_meaning = ColorMeaning.Connector;
		} else if (ds_list_find_index(self.colorsDetectedAsChamberGround, color) > -1) {
			_meaning = ColorMeaning.ChamberGround;
		} else if (ds_list_find_index(self.colorsDetectedAsUserDefined, color) > -1) {
			_meaning = self._userDefinedColorsMeanings[? color];
		}
		
		if (color == undefined) {
			throw ("Passed undefined on color parameter in meaningForColor");
		}
		
		return _meaning == undefined ? ColorMeaning.Unknown : _meaning;
	}
	
	static uninit = function() {
		destroyList(self.colorsDetectedAsConnector);
		destroyList(self.colorsDetectedAsChamberGround);
		destroyList(self.colorsDetectedAsUserDefined);
		destroyMap(self._userDefinedColorsMeanings);
		destroyMap(self._colorMeanings);
	}	
}