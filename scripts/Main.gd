extends Node2D

@onready var board = $Board
@onready var selection_manager = $Systems/SelectionManager
@onready var resource_manager = $Systems/ResourceManager
@onready var resource_panel = $UI/ResourcePanel
@onready var assignment_panel = $UI/AssignmentPanel
@onready var assignment_manager = $Systems/AssignmentManager
@onready var bandwidth_panel = $UI/BandwidthPanel

func _ready():
	bandwidth_panel.selection_manager = selection_manager
	bandwidth_panel.update_display()
	
	# Setup selection manager connections
	selection_manager.board = board
	selection_manager.resource_manager = resource_manager
	selection_manager.bandwidth_changed.connect(bandwidth_panel.update_display)
	
	# Assignment Manager + Panel link
	assignment_panel.assignment_manager = assignment_manager
	assignment_panel.update_display()
	
	# Link resource panel to manager
	resource_panel.resource_manager = resource_manager
	resource_manager.resources_changed.connect(
		resource_panel.update_display
	)
	resource_panel.update_display()
	
	#
