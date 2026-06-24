class_name SelectionManager
extends Node2D

signal bandwidth_changed

var board: Board
var resource_manager: ResourceManager

var current_path: Array[CellNode] = []
@export var bandwidth: int = 8

func has_active_path():
	return current_path.size() > 0

func on_cell_clicked(cell):
	handle_selection(cell)

func on_cell_hovered(cell):
	cell.set_hovered(true)
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		handle_selection(cell)

func on_cell_unhovered(cell):
	cell.set_hovered(false)

# Adds 'value' to bandwidth, emits to UI
func update_bandwidth(value: int):
	bandwidth += value
	bandwidth_changed.emit()

func backtrack_to_cell(cell):
	var index = current_path.find(cell)
	var count: int = 0
	while current_path.size() > index:
		var removed_cell = current_path.pop_back()
		removed_cell.set_selected(false)
		count += 1
		
	update_bandwidth(count)
	
	update_valid_targets()

func is_adjacent(cell_a, cell_b) -> bool:

	var dx = abs(cell_a.grid_position.x - cell_b.grid_position.x)
	var dy = abs(cell_a.grid_position.y - cell_b.grid_position.y)

	return dx + dy == 1

func add_cell(cell):
	if bandwidth <= 0:
		print("No more bandwidth")
		return
		
	update_bandwidth(-1)
	current_path.append(cell)
	cell.set_selected(true)
	print("Added cell: ", cell.grid_position)
	update_valid_targets()

func clear_path():
	for cell in current_path:
		cell.set_selected(false)

	current_path.clear()
	update_valid_targets()

func update_valid_targets():
	# Remove existing highlighting
	for column in board.grid:
		for cell in column:
			cell.set_valid_target(false)
	
	if current_path.is_empty():
		return
	
	var last_cell = current_path.back()
	var neighbors = board.get_neighbors(last_cell)
	
	for neighbor in neighbors:
		if neighbor not in current_path:
			neighbor.set_valid_target(true)

func _input(event):
	if event.is_action_pressed("execute"):
		execute_path()
		

# Attempts to add cell to selected path
# Returns true on success, false on failure
# Failure includes selecting non-adjacent cell and selecting cell
# already within the path
func handle_selection(cell) -> bool:
	print("Cell " + str(cell.grid_position) + " selected")
	if cell in current_path:
		backtrack_to_cell(cell)
		return false
	
	if current_path.size() > 0:
		
		var last_cell = current_path.back()
		if !is_adjacent(last_cell, cell):
			return false

	add_cell(cell)
	return true

func score_path() -> Dictionary:
	var counts = {
		Tile.TileType.RED: 0,
		Tile.TileType.BLUE: 0,
		Tile.TileType.YELLOW: 0,
		Tile.TileType.GREEN: 0,
		Tile.TileType.PURPLE: 0
	}
	for cell in current_path:
		
		if !cell.has_tile():
			continue
		
		counts[cell.tile.tile_type] += 1
	return counts

func execute_path():

	# Count colors
	# Apply effects
	# Destroy tiles
	if current_path.is_empty():
		return
	
	print("Executing path...")
	var counts = score_path()

	resource_manager.add_resources(counts)
	board.clear_tiles(current_path)
	board.apply_gravity_down()
	clear_path()
	board.refill_board()
	print(counts)
