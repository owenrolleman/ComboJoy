class_name ResourcePanel
extends Control

@onready var red_label = $RedLabel
@onready var blue_label = $BlueLabel
@onready var green_label = $GreenLabel
@onready var yellow_label = $YellowLabel
@onready var purple_label = $PurpleLabel
@onready var output_label = $OutputLabel

var resource_manager: ResourceManager

func update_display():
	red_label.text = "Red: " + str(resource_manager.red_res)
	blue_label.text = "Blue: " + str(resource_manager.blue_res)
	green_label.text = "Green: " + str(resource_manager.green_res)
	yellow_label.text = "Yellow: " + str(resource_manager.yellow_res)
	purple_label.text = "Purple: " + str(resource_manager.purple_res)
	output_label.text = "Current Output: " + str(resource_manager.generated_output)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
