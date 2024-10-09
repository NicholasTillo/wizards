extends Area2D


# Called when the node enters the scene tree for the first time.
var contained_item = null
func set_item(p_item: item):
	$displaysprite.texture = p_item.overworld_texture
	contained_item = p_item


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.find_child("InventoryManager").collect(contained_item)
		queue_free()
