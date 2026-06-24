class_name AssignmentPanel
extends Control

@onready var assignment_name_label = $VBoxContainer/AssignmentName
@onready var quota_label = $VBoxContainer/QuotaLabel
@onready var modifier_label = $VBoxContainer/ModifierLabel

var assignment_manager: AssignmentManager

func update_display():
	if assignment_manager == null:
		return
	
	var assignment = assignment_manager.current_assignment
	
	if assignment == null:
		return
	
	# Build Labels
	assignment_name_label.text = assignment.name
	quota_label.text = "Quota: " + str(assignment.quota)
	var modifier_text: String = ""
	
	for modifier in assignment.modifiers:
		modifier_text += "- " + modifier.name + "\n"
	
	modifier_label.text = modifier_text

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
