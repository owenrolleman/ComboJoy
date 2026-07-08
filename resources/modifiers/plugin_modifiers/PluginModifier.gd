# Base class for plugin modifiers, any new plugin modifier should extend this
# class and alter these functions as necessary
class_name PluginModifier
extends Resource

func before_process(plugin: Plugin, traversal: PacketTraversal):
	pass

func after_process(plugin: Plugin, traversals: Array[PacketTraversal]):
	pass
