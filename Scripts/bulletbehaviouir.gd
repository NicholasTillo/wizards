extends CharacterBody2D

#Speed of the projectile


var chosenSpell = null
var speed = 200
#How mcuh damage itll deal


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Find the players position
	var characterScript = get_tree().get_nodes_in_group("player")[0] as character_body_2d
	var player_pos = get_tree().get_nodes_in_group("player")[0].position
	#Get the vector that goes towards the mouse
	velocity = (get_global_mouse_position() - player_pos).normalized()
	#And the angle
	var temp = player_pos.angle_to_point(get_global_mouse_position())                                                                                                                                                 
	#Set the rotation to the angle, facing the mouse. 
	rotation_degrees = rad_to_deg(temp) + 180
	if rotation_degrees > 180:  
		rotation_degrees -= 360
		
	print(chosenSpell)
	
	chosenSpell = characterScript.get_current_spell()
	print(chosenSpell)
	
	
	

func _physics_process(delta: float) -> void:
	chosenSpell.movement()
	#move, and if itll hit a collider, itll do its effect. 
	var collision = move_and_collide(velocity * speed * delta)
	if collision:
		if collision.get_collider().is_in_group("border"):
			print("inborder")
			queue_free()
		print("I collided with ", collision.get_collider().name)
		collision(collision.get_collider())

func collision(body):
	chosenSpell.effect(body)
	queue_free()
