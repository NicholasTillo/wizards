extends Resource


class_name enemyStats

@export var id: int = 0
@export var name: String = ""

@export var health: int = 0
@export var speed:int = 0
@export var damage:int = 0

@export var sprite: Texture2D = null


@export var condition_array: Array = []

func getSpeed():
	return speed
	
func getHealth():
	return health
	
func getDamage():
	return damage
