class_name Duplicator
extends Plugin

func process_internal(traversal):
	var left = traversal.duplicate()
	left.direction = Direction.Value .LEFT
	
	var right = traversal.duplicate()
	right.direction = Direction.Value.RIGHT
	
	return [left, right]
