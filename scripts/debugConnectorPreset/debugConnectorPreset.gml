function debugConnectorPreset() {
	var _connectorPreset = argument[0];

	debug("CONNECTOR PRESET");
	debug("=================");
	debug("FacingDirection: " +string(_connectorPreset[? ConnectorPresetProps.FacingDirection]));
	debug("Width: " + string(_connectorPreset[? ConnectorPresetProps.Width]));
	debug("Height: " + string(_connectorPreset[? ConnectorPresetProps.Height]));
	debug("XStart: " + string(_connectorPreset[? ConnectorPresetProps.XStart]));
	debug("XEnd: " + string(_connectorPreset[? ConnectorPresetProps.XEnd]));
	debug("YStart: " + string(_connectorPreset[? ConnectorPresetProps.YStart]));
	debug("YEnd: " + string(_connectorPreset[? ConnectorPresetProps.YEnd]));
	debug("IsConnected: " + string(_connectorPreset[? ConnectorPresetProps.IsConnected]));
	debug("");



}
