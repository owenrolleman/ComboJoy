class_name Packet
extends RefCounted

var color: Tile.TileType
var output: int
var modifiers := []

func _init(tile: Tile):
	color = tile.tile_type
	output = tile.value
