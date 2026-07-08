class_name MotherboardCell
extends Node2D

var grid_position: Vector2i

var plugin: Plugin

# Position relative to plugin origin
var local_position: Vector2i

func has_plugin() -> bool:
	return plugin != null
