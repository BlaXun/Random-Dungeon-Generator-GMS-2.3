/// @description Insert description here
// You can write your code in this editor

if (keyboard_check(ord("W"))) {
	y-=spd;
}

if (keyboard_check(ord("S"))) {
	y+=spd;
}

if (keyboard_check(ord("A"))) {
	x-=spd;
}

if (keyboard_check(ord("D"))) {
	x+=spd;
}