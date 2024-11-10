extends Node
class_name inventory_manager

@export var slot_list: Array[Button]

func collect(p_item: item):
	slot_list[p_item.index].add(1)

func get_selected_items():
	return null
