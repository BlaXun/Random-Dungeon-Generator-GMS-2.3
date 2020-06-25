# Random Dungeon Generator (Game Maker Studio 2.3)

**Introduction**<br/>
This Random Dungeon Generator combines user-defined chambers to create a dungeon.<br/>
The user-defined chambers are simple sprites that use color coding (user can customize the color detection).<br/>
<br/>
**Requirements**
* At least Game Maker Studio 2.3
* Some sprites

**Creating chamber sprites** <br/>
Without chamber sprites there can be no dungeon. 
Each chamber sprite needs some ground and connectors. At least one connector on two different sides need to be placed on a chamber.

**How Connectors work** <br/>
Connectors come in two variations: **Vertical** and **horizontal**. Depending on how the pixel of a connector are placed on the chamber sprite the connector will either be detected as a horizontal or vertical connector. Vertical connectors have a height of 1 and a width of > 1. Horizontal connectors have a width of 1 and a height of > 1. 
In addition to the connectors orientation it also has a **facing direction**. This facing direction is dependend of the pixels surrounding the connector. For a horizontal connector the facing direction is **left** when the pixel to the right of the connector are chamber ground. The facing direction is **right** when the pixel to the left of the connector are chamber ground. For a vertical connector the facing direction is **up** when the pixel below the connector are chamber ground. The facing direction is **down** when the pixel above the connector are chamber ground.<br/>
<br/>
**Hallways**<br/>
Chambers are connected to each other by hallways. A hallway will be created from one connector to another. Only connectors with the same orientation can be connected (horizontal to horizontal, vertical to vertical). Even with the same orientatin (vertical/horizontal) only connectors with a **opposite facing direction** are able to connect (left to right, right to left, up to down, down to up). The width of a hallway depens on the dimension of the used connector.<br/>
<br/>
**Limitations** <br/>
* Can not limit how many times each chamber is used
* Builts one long dungeon from start to end but does NOT create branches
* Depending on the chamber layout crossing hallways could appear
