dungeonWasCreated = false;

dungeonPreset = new DungeonPreset(colorAssignments, global.__initialDungeonDimensions,global.__initialDungeonDimensions);
dungeonPreset.createNewDungeon(chamberPresets, amountOfChambersToPlace);

surface_resize(dungeonSurface,dungeonPreset.widthInPixel,dungeonPreset.heightInPixel);
surface_set_target(dungeonSurface);
draw_clear(c_black);
dungeonPreset.drawDungeon(0,0);

surface_reset_target();

dungeonWasCreated = true;