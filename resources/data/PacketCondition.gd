# Extendable class used to assign conditions on input/output/processing
class_name PacketCondition
extends Resource

var specificity_level : int = 0

func matches(packet: Packet) -> bool:
	return true

func specificity() -> int:
	return specificity_level
