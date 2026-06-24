class_name Tile
extends Node2D

enum TileType {
	RED,
	BLUE,
	YELLOW,
	GREEN,
	PURPLE
}

var tile_type: TileType
var is_hovered: bool = false
var is_selected: bool = false

func setup(type: TileType):
	tile_type = type
	var sprite = $Sprite2D
	
	match tile_type:
		TileType.RED:
			sprite.modulate = Color.DARK_RED
		
		TileType.BLUE:
			sprite.modulate = Color.CADET_BLUE
			
		TileType.YELLOW:
			sprite.modulate = Color.LEMON_CHIFFON
			
		TileType.GREEN:
			sprite.modulate = Color.FOREST_GREEN
			
		TileType.PURPLE:
			sprite.modulate = Color.MEDIUM_PURPLE

func update_visuals():
	if is_hovered or is_selected:
		scale = Vector2(1.2, 1.2)
	else:
		scale = Vector2.ONE

# HELPER
func set_selected(value):
	is_selected = value
	update_visuals()

func set_hovered(value):
	is_hovered = value
	update_visuals()
