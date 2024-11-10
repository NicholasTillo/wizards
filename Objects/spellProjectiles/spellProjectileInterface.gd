extends CharacterBody2D

class_name SpellProjectileInterface

var chosenSpell = null
var speed = 0
var characterScript: player_body_2d = null
var player_pos: Vector2 = Vector2(0,0)


#MUST OVERRIDE FUNCTIONS
func init_unique_variables():
	pass
	
func movement():
	pass
	
func collision(p_body):
	pass
	
	
#SHOULD NOT OVERRIDE UNLESS KNOWING WHAT DOING. 
func _ready() -> void:
	#Find the players position
	characterScript = get_tree().get_nodes_in_group("player")[0] as player_body_2d
	player_pos = get_tree().get_nodes_in_group("player")[0].position
	
	chosenSpell = characterScript.get_current_cantrip()
	
	init_unique_variables()
	
func _physics_process(delta: float) -> void:
	var moveVector = movement()
	
	#move, and if itll hit a collider, itll do its effect. 
	var collision = move_and_collide(moveVector * delta)
	if collision:	
		print("I collided with ", collision.get_collider().name)
		collision(collision.get_collider())
	
