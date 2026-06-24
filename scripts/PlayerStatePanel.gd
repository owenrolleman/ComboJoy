class_name PlayerStatePanel
extends Control

@onready var stress_label = $VBoxContainer/StressLabel
@onready var bandwidth_label = $VBoxContainer/StressLabel

var player_state_manager: PlayerStateManager

func update_display():
	bandwidth_label.text = "Bandwidth: " + str(player_state_manager.bandwidth)

