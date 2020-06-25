/// @description Insert description here
// You can write your code in this editor
if (self.rdg.dungeonWasCreated == true && is_undefined(self.rdg.dungeonSurface) == false && surface_exists(self.rdg.dungeonSurface) == true) {
	draw_surface(self.rdg.dungeonSurface,0,0);
}