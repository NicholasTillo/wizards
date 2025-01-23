extends SpellProjectileInterface

var closest_enemy = null


func init_unique_variables():
	chosenSpell = load("res://Objects/Resoruces/Spells/Cantrips/spell2.tres")

	 #Get the vector that goes towards the mouse
	velocity = (get_global_mouse_position() - player_pos).normalized()
		
	var temp = player_pos.angle_to_point(get_global_mouse_position())                                                                                                                                                 
	#Set the rotation to the angle, facing the mouse. 
	rotation_degrees = rad_to_deg(temp)
	if rotation_degrees > 180:  
		rotation_degrees -= 360
		

func movement():
	if closest_enemy == null:
		return velocity * chosenSpell.speed
	else:
		var temp = position.angle_to_point(closest_enemy.position)                                                                                                                                                 
		#Set the rotation to the angle, facing the mouse. 
		rotation_degrees = rad_to_deg(temp)
		if rotation_degrees > 180:  
			rotation_degrees -= 360
			
			
		velocity += (closest_enemy.position - position).normalized() * 1.5 
		#return (closest_enemy.position - position).normalized() * speed
		return velocity * chosenSpell.speed


func collision(body):
	var willFree = effect(body)
	if willFree:
		queue_free()
		
		
func effect(p_body):
	var will_free_flag
	
	if p_body.is_in_group("border"):
		will_free_flag = true
		return will_free_flag
		
	if p_body.is_in_group("enemy"):
		p_body.damage(chosenSpell.damage)
		will_free_flag = true
		
	return will_free_flag
	
func on_enter(body):
	if body.is_in_group("enemy"):
		print("Chosen Enemy")
		closest_enemy = body
		
	
func on_exit(body): 
	if body.is_in_group("enemy"):
		closest_enemy = null
		
