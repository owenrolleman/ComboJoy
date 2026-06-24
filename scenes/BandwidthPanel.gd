class_name BandwidthPanel
extends Control

@onready var bandwidth_label = $BandwidthLabel
var selection_manager: SelectionManager

func update_display():
	bandwidth_label.text = "Bandwidth: " + str(selection_manager.bandwidth)
