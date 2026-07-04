class_name ExecutionManager
extends Node

var board: Board
var motherboard: Motherboard

var assignment_manager: AssignmentManager
var resource_manager: ResourceManager
var selection_manager: SelectionManager

func execute(cells: Array[CellNode]):
	var packets: Array[Packet] = board.create_packets(cells)
	var result: ExecutionResult = motherboard.process_packets(packets)
	resource_manager.add_resources(result.packets)
	assignment_manager.add_output(result.total_output)
	board.clear_tiles(cells)
	board.apply_gravity_down()
	board.refill_board()
	selection_manager.clear_path()
