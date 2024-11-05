extends enemyInterface


class_name zombie




func _ready():
	$HealthBar.max_value = health
	$HealthBar.value = health
	
func damage(num):
	health -= num
	update_damage()
	if health <= 0:
		die()
	
	
func die():
	dead = true
	$AudioPlayer.play()
	death_animation()
	await get_tree().create_timer(1.0).timeout
	var randnum = rng.randf_range(0,1)
	if randnum <= 0.5:
		var inst = collectable.instantiate()
		inst.set_item(drop)
		inst.position = position
		main.add_child.call_deferred(inst)
	queue_free()

	
func update_damage():
	$HealthBar.value = health
	
func death_animation():
	$Sprite.texture = load("res://Assets/meteorite-or-fire-ball-illustration-png.webp")
	
func movement():
	if player_chase: 
		velocity = (player.position - position).normalized() * speed
	
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	
	if not dead:
		movement()
		var collision = move_and_collide(velocity * speed * delta)
		if collision:
			#print("I collided with ", collision.get_collider().name)
			collision(collision.get_collider())
	
##Condition Handlers
func apply_condition(condition):
	conditionList.append(condition)

func handle_condition(p_condition):
	pass
	
	
func handle_conditions():
	for i in conditionList:
		handle_condition(i)




##Collision Handlers
func collision(collider):
	if collider.is_in_group("player"):
		if collider.get_i_frames() <= 0:
			collider.damage(damage_num)

func on_enter(body):
	if body.is_in_group("player"):
		player = body
		player_chase = true
	
func on_exit(body): 
	if body.is_in_group("player"):
		player = null
		player_chase = false
