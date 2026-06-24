class_name AssignmentData
extends Resource

@export var name: String
@export var quota: int

@export var modifiers: Array[RuleModifier]

func has_modifier(name: String) -> bool:

	for modifier in modifiers:
		if modifier.modifier_name == name:
			return true

	return false
