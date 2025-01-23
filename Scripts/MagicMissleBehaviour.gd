extends SpellProjectileInterface


# Called when the node enters the scene tree for the first time.
func init_unique_variables():
	chosenSpell = load("res://Objects/Resoruces/Spells/Cantrips/MagicMissles.tres")
	 #Get the vector that goes towards the mouse
	velocity = (get_global_mouse_position() - player_pos).normalized()
		
	var temp = player_pos.angle_to_point(get_global_mouse_position())                                                                                                                                                 
	#Set the rotation to the angle, facing the mouse. 
	rotation_degrees = rad_to_deg(temp) + 180
	if rotation_degrees > 180:  
		rotation_degrees -= 360
	
	
func movement():
	return velocity * speed

func collision(body):
	var willFree = chosenSpell.effect(body)
	if willFree:
		queue_free()
