class_name Motherboard
extends Node2D

func process_packets(packets: Array[Packet]) -> ExecutionResult:
	var result = ExecutionResult.new()
	
	result.packets = packets
	
	var output := 0
	for packet in packets:
		output += packet.output
	
	result.total_output = output
	return result
