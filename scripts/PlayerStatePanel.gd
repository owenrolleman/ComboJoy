class_name PlayerStatePanel
extends Control

@onready var stress_label = $VBoxContainer/StressLabel
@onready var bandwidth_label = $VBoxContainer/StressLabel

func update_display(bandwidth: int):
	bandwidth_label.text = "Bandwidth: " + str(bandwidth)
	
