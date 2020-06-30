/// @description Insert description here
// You can write your code in this editor
#macro view view_camera[0]
camera_set_view_size(view,view_width,view_height);

var _x, _y;
_x = id.x - view_width/2;
_y = id.y - view_height/2;

camera_set_view_pos(view,clamp(_x,0,room_width-view_width), clamp(_y,0,room_height-view_height));