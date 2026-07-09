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

# Main API for traversals entering a plugin. Handles checking of ports
func process_collision(traversal: PacketTraversal) -> Array[PacketTraversal]:
	var input_port = find_input_port(traversal)
	
	if input_port == null:
		return []
	
	return process(traversal)

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

# Takes an array of packettraversal objects and routes them to the correct output ports
# If no valid output port can be found, packet is lost
func route_packets(traversals: Array[PacketTraversal]) -> Array[PacketTraversal]:

	var surviving: Array[PacketTraversal] = []

	for traversal in traversals:

		var port = find_output_port(traversal.packet)

		if port == null:
			continue

		traversal.direction = port.direction
		traversal.output_port = port
		surviving.append(traversal)

	return surviving

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



func process_internal(traversal: PacketTraversal) -> Array[PacketTraversal]:
	return [traversal]

func packet_can_use_port(traversal: PacketTraversal, port: Port) -> bool:
	return port.accepts(traversal.packet)

func find_input_port(traversal: PacketTraversal) -> Port:
	var incoming_side = Direction.opposite(traversal.direction)
	for port in input_ports:
		if port.direction != incoming_side:
			continue
		
		if port.local_position != traversal.cell.local_position:
			continue
		
		if !port.accepts(traversal.packet):
			return null
		
		return port
	return null

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

func local_to_world(local_pos: Vector2i) -> Vector2i:
	return origin + local_pos

func _draw():
	for port in input_ports:
		draw_circle(local_to_world(port.local_position), 6, Color.GREEN)
	
	for port in output_ports:
		draw_circle(local_to_world(port.local_position), 6, Color.RED)
	
	for cell in occupied_cells:

		draw_rect(
			Rect2(
				cell * Motherboard.CELL_SIZE,
				Vector2.ONE * Motherboard.CELL_SIZE
			),
			Color(0.2,0.3,0.5,0.3)
		)
