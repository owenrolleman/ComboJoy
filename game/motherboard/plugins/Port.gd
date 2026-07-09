class_name Port
extends Resource

enum PortType {
	INPUT,
	OUTPUT
}

var direction: Direction.Value = Direction.Value.UP
var local_position := Vector2i.ZERO
var accept_conditions: Array[PacketCondition]

@export var type: PortType

func accepts(packet):
	for condition in accept_conditions:
		if !condition.matches(packet):
			return false
	return true

func _init(dir: Direction.Value, pos: Vector2i, conds: Array[PacketCondition]):
	self.direction = dir
	self.local_position = pos
	self.accept_conditions = conds
