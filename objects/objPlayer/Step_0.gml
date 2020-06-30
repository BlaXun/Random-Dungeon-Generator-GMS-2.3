var _hSpd = 0, _vSpd = 0;

if (keyboard_check_direct(ord("A"))) {
	_hSpd=-2;
} else if (keyboard_check_direct(ord("D"))) {
	_hSpd=2;
}

if (keyboard_check_direct(ord("W"))) {
	_vSpd=-2;	
} else if (keyboard_check_direct(ord("S"))) {
	_vSpd=2;
}

repeat(abs(_hSpd)) {

	if (collision_rectangle(id.x+sign(_hSpd),id.y,id.bbox_right+sign(_hSpd),id.bbox_bottom,objBlock,false,false) == noone) {
		id.x += sign(_hSpd);
	} else {
		break;
	}
}

repeat(abs(_vSpd)) {

	if (collision_rectangle(id.x,id.y+sign(_vSpd),id.bbox_right,id.bbox_bottom+sign(_vSpd),objBlock,false,false) == noone) {
		id.y += sign(_vSpd);
	} else {
		break;
	}
}