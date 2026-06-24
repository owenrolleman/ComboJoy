class_name PlayerStateManager
extends Node

signal bandwidth_updated

@export var max_bandwidth: int = 8
var bandwidth: int = max_bandwidth

func update_bandwidth(amt: int):
	bandwidth += amt
	bandwidth_updated.emit()
	

func can_afford_tile(cost: int):
	return bandwidth >= cost
