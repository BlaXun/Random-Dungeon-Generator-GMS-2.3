/// @description Insert description here
// You can write your code in this editor
if (keyboard_check_direct(ord("A"))) {
	x-=2;
} else if (keyboard_check_direct(ord("D"))) {
	x+=2;
}

if (keyboard_check_direct(ord("W"))) {
	y-=2;	
} else if (keyboard_check_direct(ord("S"))) {
	y+=2;
}