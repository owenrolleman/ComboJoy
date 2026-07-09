class_name Direction
extends RefCounted

enum Value{
	UP,
	RIGHT,
	DOWN,
	LEFT
}

static func to_vector(direction: Direction.Value) -> Vector2i:
	var output_vector: Vector2i = Vector2i.ZERO
	match direction:
		Direction.Value.UP:
			output_vector = Vector2i(0,-1)
		Direction.Value.DOWN:
			output_vector = Vector2i(0, 1)
		Direction.Value.LEFT:
			output_vector = Vector2i(-1, 0)
		Direction.Value.RIGHT:
			output_vector = Vector2i(1, 0)
	return output_vector

static func opposite(direction: Direction.Value) -> Direction.Value:
	var opposite: Direction.Value
	match direction:
		Direction.Value.UP:
			opposite = Direction.Value.DOWN
		Direction.Value.DOWN:
			opposite = Direction.Value.UP
		Direction.Value.LEFT:
			opposite = Direction.Value.RIGHT
		Direction.Value.RIGHT:
			opposite = Direction.Value.LEFT
	return opposite
