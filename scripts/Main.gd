extends Node2D

@onready var board = $Board
@onready var selection_manager = $Systems/SelectionManager
@onready var resource_manager = $Systems/ResourceManager
@onready var resource_panel = $UI/ResourcePanel
@onready var assignment_panel = $UI/AssignmentPanel
@onready var assignment_manager = $Systems/AssignmentManager
@onready var player_state_panel = $UI/PlayerStatePanel

func _ready():
	player_state_panel.update_display(selection_manager.max_bandwidth)
	board.cell_created.connect(_on_board_cell_created)
	
		# Init Board
	board.create_board()
	
	# Setup selection manager connections
	selection_manager.board = board
	selection_manager.bandwidth_changed.connect(player_state_panel.update_display)
	selection_manager.resources_collected.connect(resource_manager.add_resources)
	selection_manager.output_updated.connect(assignment_manager.add_output)
	
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
