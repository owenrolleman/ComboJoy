class_name AssignmentManager
extends Node2D

@export var current_assignment: AssignmentData

func _ready():
	
	print("Assignment:")
	print(current_assignment.name)
	
	print("Quota:")
	print(current_assignment.quota)
	
	print("Modifiers:")
	for modifier in current_assignment.modifiers:
		print("- ", modifier.name)
	
