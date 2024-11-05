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
func effect(p_enemyBody): 
	var will_free_flag
	
	if p_enemyBody.is_in_group("border"):
		will_free_flag = true
		return will_free_flag

	if id == 111:
		if p_enemyBody.is_in_group("enemy"):
			p_enemyBody.damage(damage)
			will_free_flag = true
		elif p_enemyBody.is_in_group("obsticle"):
			will_free_flag = true

	if id == 112:
		if p_enemyBody.is_in_group("enemy"):
			p_enemyBody.damage(damage)
			p_enemyBody.apply_condition(condition_array[0])

			
	return will_free_flag



func get_scene():
	return scene_path

func getID():
	return id
