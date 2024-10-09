extends Node

@export var slot_list: Array[Button]

func collect(p_item: item):
	slot_list[p_item.index].add(1)
