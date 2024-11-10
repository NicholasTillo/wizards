extends Resource

class_name spell

@export var isCantrip: bool = false
@export var id: int = 0
@export var name: String = ""
@export var recepie: Array = []
@export var speed:int = 0
@export var damage:int = 0

@export var shape: shapeSpell = null
@export var sprite: Texture2D = null
@export var scene_path: String = ""

@export var condition_array: Array = []


#If the spell should have a different effect when hitting an enemy

func get_scene():
	return scene_path

func getID():
	return id
