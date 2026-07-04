class_name ResourceManager
extends Node2D

signal resources_changed

var red_res := 0
var blue_res := 0
var green_res := 0
var yellow_res := 0
var purple_res := 0

func _ready():
	pass

func add_resources(packets: Array[Packet]):
	
	var counts = score_packets(packets)
	red_res += counts.get(Tile.TileType.RED, 0)
	blue_res += counts.get(Tile.TileType.BLUE, 0)
	green_res += counts.get(Tile.TileType.GREEN, 0)
	yellow_res += counts.get(Tile.TileType.YELLOW, 0)
	purple_res += counts.get(Tile.TileType.PURPLE, 0)
	resources_changed.emit()

func score_packets(packets):
	
	var counts = {
		Tile.TileType.RED: 0,
		Tile.TileType.BLUE: 0,
		Tile.TileType.YELLOW: 0,
		Tile.TileType.GREEN: 0,
		Tile.TileType.PURPLE: 0
	}
	
	for packet in packets:
		counts[packet.color] += packet.output
	return counts
