/// @description Insert description here
// You can write your code in this editor
var _cam = camera_create_view(0,0,320,240,0,objPlayer,5,5,-1,-1);
view_set_camera(0, _cam);
view_set_visible(0, true);

room_set_viewport(room,0,true,0,0,320,240);