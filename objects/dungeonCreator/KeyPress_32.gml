dungeonWasCreated = false;

dungeonPreset = emptyDungeonPreset();
dungeonPreset[? DungeonPresetProps.ColorAssignments] = colorAssignments;

createNewDungeonOnPreset(dungeonPreset, chamberPresets, amountOfChambersToPlace);

surface_resize(dungeonSurface,dungeonPreset[? DungeonPresetProps.WidthInPixel],dungeonPreset[? DungeonPresetProps.HeightInPixel]);
surface_set_target(dungeonSurface);
draw_clear(c_black);
drawDungeonFromDungeonPreset(dungeonPreset,0,0);

surface_reset_target();

dungeonWasCreated = true;