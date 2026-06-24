class_name ResourceManager
extends Node2D

signal resources_changed

var red_res := 0
var blue_res := 0
var green_res := 0
var yellow_res := 0
var purple_res := 0

var generated_output := 0

func _ready():
	pass

func add_resources(counts: Dictionary):

	red_res += counts.get(Tile.TileType.RED, 0)
	blue_res += counts.get(Tile.TileType.BLUE, 0)
	green_res += counts.get(Tile.TileType.GREEN, 0)
	yellow_res += counts.get(Tile.TileType.YELLOW, 0)
	purple_res += counts.get(Tile.TileType.PURPLE, 0)
	calculate_output()
	resources_changed.emit()

func calculate_output():
	generated_output = red_res + blue_res + green_res + yellow_res + purple_res
