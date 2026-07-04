class_name Board
extends Node2D

const WIDTH: int = 8
const HEIGHT: int = 8
const TILE_SIZE: int = 48
const NUM_TILE_TYPES: int = 5

signal cell_created

@export var tile_scene: PackedScene
@export var cell_scene: PackedScene

enum GravityDirection {
	DOWN,
	UP,
	LEFT,
	RIGHT
}

var gravity_direction := GravityDirection.DOWN
var grid := []

# Needs to be improved to allow different shaped board setups
func create_board():
	grid.clear()
	for x in WIDTH:
		
		grid.append([])
		
		for y in HEIGHT:
			
			var cell = cell_scene.instantiate()
			cell.grid_position = Vector2i(x, y)
			cell.position = grid_to_world(cell.grid_position)
			
			var tile = create_random_tile()
			cell.set_tile(tile)
			
			$CellContainer.add_child(cell)
			grid[x].append(cell)
			
			cell_created.emit(cell)


func create_random_tile() -> Tile:
	var tile_type = randi() % NUM_TILE_TYPES
	var tile = tile_scene.instantiate()
	tile.setup(tile_type)
	return tile
	

func grid_to_world(grid_pos: Vector2i) -> Vector2:
	return Vector2(
		grid_pos.x * TILE_SIZE,
		grid_pos.y * TILE_SIZE
	)

# HELPER FUNCTIONS
func get_cell(pos: Vector2i) -> CellNode:
	return grid[pos.x][pos.y]

func get_all_cells() -> Array[CellNode]:

	var cells: Array[CellNode] = []

	for column in grid:
		for cell in column:
			cells.append(cell)

	return cells
	
func is_in_bounds(pos: Vector2i) -> bool:
	if pos.x < 0 || pos.y < 0:
		return false
	
	if pos.x >= WIDTH || pos.y >= HEIGHT:
		return false
	
	return true

func get_neighbors(cell) -> Array[CellNode]:
	var offsets = [
		Vector2i(-1, 0),
		Vector2i(1, 0),
		Vector2i(0, -1),
		Vector2i(0, 1)
	]
	
	var neighbors: Array[CellNode] = []
	for offset in offsets:
		var target_pos = offset + cell.grid_position
		if !is_in_bounds(target_pos): 
			continue
		
		var neighbor = get_cell(target_pos)
		neighbors.append(neighbor)
	
	return neighbors

func move_tile(source: CellNode, target: CellNode):

	if !source.has_tile():
		return

	var tile = source.tile
	
	print(source.grid_position, " -> ", target.grid_position)
	source.clear_tile()
	target.set_tile(tile)

func clear_tiles(cells: Array[CellNode]):
	for cell in cells:
		cell.clear_tile()

func apply_gravity_down():
	for x in WIDTH:
		var write_y = HEIGHT - 1
		
		for y in range(HEIGHT - 1, -1, -1):
			
			var current_cell = get_cell(Vector2i(x, y))
			if !current_cell.has_tile():
				continue
			
			var target_cell = get_cell(Vector2i(x, write_y))
			
			if current_cell != target_cell:
				move_tile(current_cell, target_cell)
			
			write_y -= 1

func refill_board():
	for x in WIDTH:
		for y in HEIGHT:
			var cell = get_cell(Vector2i(x, y))
			if cell.has_tile():
				continue
			cell.set_tile(create_random_tile())

func create_packets(cells: Array[CellNode]) -> Array[Packet]:
	var packets: Array[Packet] = []
	
	for cell in cells:
		if !cell.has_tile():
			continue
		
		packets.append(Packet.new(cell.tile))
	
	return packets
