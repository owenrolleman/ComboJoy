class_name SelectionManager
extends Node2D

signal bandwidth_change_requested
signal resources_collected
signal output_updated

var board: Board
var player_state_manager: PlayerStateManager

var current_path: Array[CellNode] = []

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

func backtrack_to_cell(cell):
	var index = current_path.find(cell)
	var count: int = 0
	while current_path.size() > index:
		var removed_cell = current_path.pop_back()
		removed_cell.set_selected(false)
		bandwidth_change_requested.emit(removed_cell.tile.cost)
	
	update_valid_targets()

func is_adjacent(cell_a, cell_b) -> bool:

	var dx = abs(cell_a.grid_position.x - cell_b.grid_position.x)
	var dy = abs(cell_a.grid_position.y - cell_b.grid_position.y)

	return dx + dy == 1

func add_cell(cell):
	# Checks if the player can afford to select a tile that costs 1 BW to select
	# TODO: Implement different BW costs on tiles (heavy modifier)
	if !can_afford(1):
		print("No more bandwidth")
		return
		
	current_path.append(cell)
	cell.set_selected(true)
	bandwidth_change_requested.emit(cell.tile.cost * -1) # Invert so cost is subtracted from current BW
	
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
		if neighbor not in current_path and can_afford(neighbor.get_cost()):
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
	resources_collected.emit(counts)
	var output = calculate_output(counts)
	output_updated.emit(output)
	board.clear_tiles(current_path)
	board.apply_gravity_down()
	clear_path()
	board.refill_board()
	print(counts)

func is_out_of_bandwidth():
	return player_state_manager.can_afford_tile(1)

func can_afford(cost: int):
	return player_state_manager.can_afford_tile(cost)

func calculate_output(counts: Dictionary) -> int:
	var output: int = 0
	for color in counts:
		output += counts[color]
	
	return output
