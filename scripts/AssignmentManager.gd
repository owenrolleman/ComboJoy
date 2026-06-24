class_name AssignmentManager
extends Node2D

signal gained_output

@export var current_assignment: AssignmentData

var current_progress: int = 0

func _ready():
	
	print("Assignment:")
	print(current_assignment.name)
	
	print("Quota:")
	print(current_assignment.quota)
	
	print("Modifiers:")
	for modifier in current_assignment.modifiers:
		print("- ", modifier.name)

func add_output(value: int):
	current_progress += value
	gained_output.emit(current_progress, current_assignment.quota)

func get_quota() -> int:
	return current_assignment.quota

func end_assignment():
	print("Assignment over")
