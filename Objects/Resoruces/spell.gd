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

@export var condition_array: Array = []


#If the spell should have a different effect when hitting an enemy
func effect(p_enemyBody): 
	if id == 111:
		if p_enemyBody.is_in_group("enemy"):
			p_enemyBody.damage(damage)
	if id == 112:
		if p_enemyBody.is_in_group("enemy"):
			p_enemyBody.damage(damage)
			p_enemyBody.apply_condition(condition_array[0])
			
	
	
#If the spell should have a different movement patter. 
func movement():
	pass
