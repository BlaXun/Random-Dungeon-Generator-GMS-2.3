///	@function emptyConnectorPreset()
///	@description	Creates an empty connector-preset (ds_map) and returns it
function emptyConnectorPreset() {

	enum ConnectorPresetProps {
		XStart,
		XEnd,
		YStart,
		YEnd,
		Width,
		Height,
		FacingDirection,
		IsConnected,
	}

	enum Direction {
		None,
		Up, 
		Right,
		Down,
		Left
	}

	var _connectorPreset = newMap();
	_connectorPreset[? ConnectorPresetProps.XStart] = 0;
	_connectorPreset[? ConnectorPresetProps.XEnd] = 0;
	_connectorPreset[? ConnectorPresetProps.YStart] = 0;
	_connectorPreset[? ConnectorPresetProps.YEnd] = 0;
	_connectorPreset[? ConnectorPresetProps.Width] = 0;
	_connectorPreset[? ConnectorPresetProps.Height] = 0;
	_connectorPreset[? ConnectorPresetProps.FacingDirection] = Direction.None;
	_connectorPreset[? ConnectorPresetProps.IsConnected] = false;

	return _connectorPreset;


}
