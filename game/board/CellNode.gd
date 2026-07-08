class_name CellNode
extends Node2D

signal cell_hovered(cell)
signal cell_unhovered(cell)
signal cell_clicked(cell)

@export var cell_size: int = 48
@export var valid_target_color: Color = Color(Color.ORANGE, .6)
@export var hovering_color: Color = Color(Color.CYAN, .6)
@export var selected_color: Color = Color(Color.WHITE, .6)
@export var targetted_scale: Vector2 = Vector2(1.4, 1.4)
@export var default_scale: Vector2 = Vector2(1.2, 1.2)
@onready var highlight_sprite: Sprite2D = $HighlightSprite

var grid_position: Vector2i
var tile: Tile
var effects: Array = []

# State
var is_hovered: bool = false
var is_valid_target: bool = false
var is_selected: bool = false

# INPUT DETECTION
func _on_area_2d_mouse_entered():
	cell_hovered.emit(self) 

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				cell_clicked.emit(self)

func _on_area_2d_mouse_exited():
	cell_unhovered.emit(self)

# VISUAL CONTROL
func update_visuals():
	highlight_sprite.visible = is_hovered or is_valid_target or is_selected
	if is_selected:
		highlight_sprite.scale = targetted_scale
		highlight_sprite.modulate = selected_color
	elif is_hovered:
		highlight_sprite.scale = targetted_scale
		highlight_sprite.modulate = hovering_color
	else:
		highlight_sprite.scale = default_scale
		highlight_sprite.modulate = valid_target_color

# HELPERS
func set_tile(new_tile: Tile):
	if tile:
		remove_child(tile)
		
	tile = new_tile
	
	if tile:
		add_child(tile)
		tile.position = Vector2.ZERO

func clear_tile():
	if tile:
		remove_child(tile)
	
	tile = null

func has_tile():
	return tile != null

func get_cost() -> int:
	return tile.cost
	
func set_selected(value: bool):
	is_selected = value
	if tile: tile.set_selected(value)
	update_visuals()

func set_hovered(value: bool):
	is_hovered = value
	if tile: tile.set_hovered(value)
	update_visuals()

func set_valid_target(value: bool):
	is_valid_target = value
	update_visuals()
