extends Node2D

@onready var Wizard = preload("res://Objects/Character.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var wizzy = Wizard.instantiate()
	wizzy.add_to_group("player")
	self.add_child(wizzy)
 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
