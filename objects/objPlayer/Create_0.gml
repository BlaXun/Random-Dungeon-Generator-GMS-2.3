/// @description Insert description here
// You can write your code in this editor
var _cam = camera_create_view(0,0,320,240,0,objPlayer,2,2,100,100);
camera_set_default(_cam);
camera_set_view_target(_cam,objPlayer);
camera_set_view_size(_cam,320,240);

view_set_camera(view_current, _cam);
room_set_view_enabled(room,0);