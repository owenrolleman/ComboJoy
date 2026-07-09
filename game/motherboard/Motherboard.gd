class_name Motherboard
extends Node2D

const MAX_SIZE := Vector2i(10, 10)
const CELL_SIZE := 64

var board_size := Vector2i(3, 3)

var grid := []

# TODO: Turn into a scene later
var input_cell: MotherboardCell
var input_direction: Direction.Value

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
			
			$CellContainer.add_child(cell)
			grid[x].append(cell)
	init_input_cell(get_cell(Vector2i(0, 0)), Direction.Value.RIGHT)
# TODO: Abstract into Grid2D class (both this and game board inherit) - several duped funcs

func init_input_cell(cell: MotherboardCell, direction: Direction.Value):
	input_cell = cell
	input_direction = direction

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
	
	assert(cell != null, "get_neighbor() called with null cell")
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
	
	var queue: Array[PacketTraversal] = []
	var result = ExecutionResult.new()
	# Build traversal array
	for packet in packets:
		var traversal := PacketTraversal.new()
		
		traversal.packet = packet
		traversal.cell = input_cell
		traversal.direction = input_direction
		
		queue.append(traversal)
	
	# Execution loop
	while !queue.is_empty():
		var traversal = queue.pop_front()
		var result_traversals: Array[PacketTraversal] = process_traversal(traversal, result)
		queue.append_array(result_traversals)
		
	return result

func process_traversal(traversal: PacketTraversal, result: ExecutionResult) -> Array[PacketTraversal]:
	# Move one cell
	if !move_traversal(traversal):
		handle_exit(traversal, result)
		return []
	
	# Empty cell -> Continue moving
	if !traversal.cell.has_plugin():
		return [traversal]
	
	# Plugin found
	var plugin = traversal.cell.plugin
	var traversals = plugin.process_collision(traversal)
	var surviving: Array[PacketTraversal] = []
	
	for t in traversals:
		
		eject_from_plugin(t, plugin)
		
		if t.cell == null:
			handle_exit(t, result)
		else:
			surviving.append(t)
	return surviving

func handle_exit(traversal: PacketTraversal, result: ExecutionResult):
	# TODO:
	# Determine which motherboard edge the packet exited from
	# Validate against edge port conditions
	
	result.packets.append(traversal.packet)
	result.total_output += traversal.packet.output

func move_traversal(traversal: PacketTraversal) -> bool:
	traversal.cell = get_neighbor(traversal.cell, traversal.direction)
	return traversal.cell != null

func eject_from_plugin(traversal: PacketTraversal, plugin: Plugin):
	var world_pos = plugin.origin + traversal.output_port.local_position
	
	world_pos += Direction.to_vector(traversal.direction)
	if !is_in_bounds(world_pos):
		traversal.cell = null
	else:
		traversal.cell = get_cell(world_pos)

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
		plugin.position = grid_to_world(origin)
		cell.local_position = local_pos
	plugin.origin = origin
	plugin.position = grid_to_world(origin)
	
	%CellContainer.add_child(plugin)

func _draw():
	var board_width = board_size.x * CELL_SIZE
	var board_height = board_size.y * CELL_SIZE
	
	var color = Color.LIGHT_GRAY
	# var offset = Vector2(-CELL_SIZE / 2.0, -CELL_SIZE / 2.0)
	var offset = Vector2.ZERO
	# Vertical lines
	for x in range(board_size.x + 1):
		draw_line(
			offset + Vector2(x * CELL_SIZE, 0),
			offset + Vector2(x * CELL_SIZE, board_height),
			color,
			1.0
		)
	
	# Horizontal lines
	for y in range(board_size.y + 1):
		draw_line(
			offset + Vector2(0, y * CELL_SIZE),
			offset + Vector2(board_width, y * CELL_SIZE),
			color,
			1.0
		)
