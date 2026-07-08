class_name Port
extends Resource

enum PortType {
	INPUT,
	OUTPUT
}

var direction: Direction.Value = Direction.Value.UP
var accept_conditions: Array[PacketCondition]
var priority: int

@export var type: PortType

func accepts(packet):
	for condition in accept_conditions:
		if !condition.matches(packet):
			return false
	return true

