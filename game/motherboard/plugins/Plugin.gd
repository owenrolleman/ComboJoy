class_name Plugin
extends Node2D

@export var plugin_name: String
@export_multiline var description: String

@export var input_ports: Array[Port]
@export var output_ports: Array[Port]
@export var occupied_cells: Array[Vector2i] = [Vector2i.ZERO]

var origin: Vector2i
var modifiers: Array[PluginModifier] = []
var processing_conditions: Array[PacketCondition]

# Core procedure for a packet getting processed by a plugin
# Packet already accepted by plugin at this point
# Check if process condition is valid for accepted packet
# If so, process the packet. Then check for modifiers and do their logic
# Finally, select output port for packet. Set traversal direction to port direction

func process(traversal: PacketTraversal) -> Array[PacketTraversal]:

	var traversals: Array[PacketTraversal]

	if should_process(traversal.packet):
		apply_before_modifiers(traversal)
		traversals = process_internal(traversal)
		apply_after_modifiers(traversals)
	else:
		traversals = [traversal]

	route_packets(traversals)

	return traversals

func should_process(packet: Packet) -> bool:

	for condition in processing_conditions:
		if !condition.matches(packet):
			return false

	return true

func apply_before_modifiers(traversal: PacketTraversal):

	for modifier in modifiers:
		modifier.before_process(self, traversal)

func apply_after_modifiers(traversals: Array[PacketTraversal]):

	for modifier in modifiers:
		modifier.after_process(self, traversals)

# Takes an array of packettraversal objects and routes them to the correct output ports
func route_packets(traversals: Array[PacketTraversal]) -> Array[PacketTraversal]:

	var surviving: Array[PacketTraversal] = []

	for traversal in traversals:

		var port = find_output_port(traversal.packet)

		if port == null:
			continue

		traversal.outgoing_direction = port.direction
		surviving.append(traversal)

	return surviving

func process_internal(traversal: PacketTraversal) -> Array[PacketTraversal]:
	return [traversal]

func packet_can_use_port(traversal: PacketTraversal, port: Port) -> bool:
	return port.accepts(traversal.packet)

func find_output_port(packet: Packet) -> Port:
	var best: Port = null
	
	for port in output_ports:
		if !port.accepts(packet):
			continue
		
		if best == null:
			best = port
			continue
		
		if port.conditions.size() > best.conditions.size():
			best = port
	return best
