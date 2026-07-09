class_name PacketTraversal
extends RefCounted

var packet: Packet
var cell: MotherboardCell
var direction: Direction.Value
var output_port: Port

func update_transversal(cell: MotherboardCell, direction: Direction.Value):
	self.cell = cell
	self.direction = direction
