function defineGenericEnums() {
	/*
		Define some generic enums
	*/

	enum Dimension {
		Width = 0,
		Height = 1
	}

	enum Position {
		Top,
		Right,
		Bottom,
		Left
	}

	enum Coordinate {
		xStart,
		yStart,
		xEnd,
		yEnd
	}

	enum Direction {
		None,
		Up, 
		Right,
		Down,
		Left
	}
}
