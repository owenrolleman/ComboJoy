class_name Motherboard
extends Node2D

const MAX_SIZE := Vector2i(10, 10)
const CELL_SIZE := 64

var board_size := Vector2i(3, 3)

var grid := []
@export var motherboard_cell_scene: PackedScene

func get_cell(pos: Vector2i) -> MotherboardCell:
	return grid[pos.x][pos.y]

func create_motherboard():

	grid.clear()

	for x in board_size.x:

		grid.append([])

		for y in board_size.y:

			var cell = motherboard_cell_scene.instantiate()
			
			cell.grid_position = Vector2i(x,y)
			cell.position = grid_to_world(cell.grid_position)
			
			%CellContainer.add_child(cell)
			grid[x].append(cell)
# TODO: Abstract into Grid2D class (both this and game board inherit) - several duped funcs

func is_in_bounds(pos: Vector2i) -> bool:
	return pos.x >= 0 \
		and pos.y >= 0 \
		and pos.x < board_size.x \
		and pos.y < board_size.y

func grid_to_world(grid_pos: Vector2i) -> Vector2:
	return Vector2(
		grid_pos.x * CELL_SIZE,
		grid_pos.y * CELL_SIZE
	)

func get_neighbor(
	cell: MotherboardCell,
	direction: Direction.Value
) -> MotherboardCell:

	var offset := Vector2i.ZERO

	match direction:
		Direction.Value.UP:
			offset = Vector2i.UP
		Direction.Value.RIGHT:
			offset = Vector2i.RIGHT
		Direction.Value.DOWN:
			offset = Vector2i.DOWN
		Direction.Value.LEFT:
			offset = Vector2i.LEFT

	var target = cell.grid_position + offset

	if !is_in_bounds(target):
		return null

	return get_cell(target)
	
func process_packets(packets: Array[Packet]) -> ExecutionResult:
	var result = ExecutionResult.new()
	
	result.packets = packets
	
	var output := 0
	for packet in packets:
		output += packet.output
	
	result.total_output = output
	return result

func can_install_plugin(plugin: Plugin, origin: Vector2i) -> bool:
	for local_pos in plugin.occupied_cells:
		var world_pos = origin + local_pos
		
		if !is_in_bounds(world_pos):
			return false
		
		if get_cell(world_pos).has_plugin():
			return false
	return true

func install_plugin(plugin: Plugin, origin: Vector2i):
	if !can_install_plugin(plugin, origin):
		return
	
	for local_pos in plugin.occupied_cells:
		var world_pos = origin + local_pos
		var cell = get_cell(world_pos)
		
		cell.plugin = plugin
		cell.local_position = local_pos
	plugin.origin = origin
