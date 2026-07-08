extends Node2D

@onready var board = $Board
@onready var motherboard = $Motherboard
@onready var selection_manager = $Systems/SelectionManager
@onready var execution_manager = $Systems/ExecutionManager
@onready var resource_manager = $Systems/ResourceManager
@onready var resource_panel = $UI/ResourcePanel
@onready var assignment_panel = $UI/AssignmentPanel
@onready var assignment_manager = $Systems/AssignmentManager
@onready var player_state_panel = $UI/PlayerStatePanel
@onready var player_state_manager = $Systems/PlayerStateManager

func _ready():
	board.cell_created.connect(_on_board_cell_created)
	
		# Init Board
	board.create_board()
	queue_redraw()
	
	# Setup selection manager connections
	selection_manager.board = board
	selection_manager.player_state_manager = player_state_manager
	selection_manager.bandwidth_change_requested.connect(player_state_manager.update_bandwidth)
	selection_manager.execution_requested.connect(execution_manager.execute)
	
	execution_manager.board = board
	execution_manager.motherboard = motherboard
	execution_manager.assignment_manager = assignment_manager
	execution_manager.resource_manager = resource_manager
	execution_manager.selection_manager = selection_manager
	
	# Setup player state manager and panel
	player_state_panel.player_state_manager = player_state_manager
	player_state_manager.bandwidth_updated.connect(player_state_panel.update_display)
	player_state_panel.update_display()
	
	# Assignment Manager + Panel link
	assignment_panel.assignment_manager = assignment_manager
	assignment_manager.gained_output.connect(assignment_panel.update_progress)
	assignment_panel.update_display_info()
	
	# Link resource panel to manager
	resource_panel.resource_manager = resource_manager
	resource_manager.resources_changed.connect(
		resource_panel.update_display
	)
	resource_panel.update_display()

func _on_board_cell_created(cell):
	cell.cell_hovered.connect(selection_manager.on_cell_hovered)
	cell.cell_clicked.connect(selection_manager.on_cell_clicked)
	cell.cell_unhovered.connect(selection_manager.on_cell_unhovered)
