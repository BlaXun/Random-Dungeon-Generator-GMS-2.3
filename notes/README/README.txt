Created by Ingo Liebig
https://github.com/BlaXun/Random-Dungeon-Generator-GMS-2.3

HowTo:
All you need for this to work is create a bunch of sprites to be used as chambers.
Decide on a color to use as chamber ground and another color to be used as connectors.

A connector defines places on a chamber where the given chamber will create new outgoing or accept a incoming connection.
Check the dungeonCreator object on how to setup the system.

The final result will be a ds_grid which will only have contents of the ColorMeaning-Enum
and values as defined by the user.

Loop through that grid to create your dungeon. 
Check the drawDungeon-Method (RandomDungeonGenerator\DungeonPreset\drawDungeon)
for a quick example that simply draws the dungeon grid pixel-by-pixel.