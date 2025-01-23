extends enemyInterface


class_name zombie


func _ready():
	health = enemyStat.getHealth()
	speed = enemyStat.getSpeed()
	damage_num = enemyStat.getDamage()
	$HealthBar.max_value = health
	$HealthBar.value = health
	
	
func damage(num):
	health -= num
	update_damage()
	if health <= 0:
		die()
	



	
func death_animation():
	$Sprite.texture = load("res://Assets/meteorite-or-fire-ball-illustration-png.webp")
	
func movement(pDelta):
	velocity = (player.position - position).normalized() * speed
	
func roaming(pDelta):
	if movement_timer < 0:
		velocity = Vector2(rng.randf_range(-1,1),rng.randf_range(-1,1)).normalized() * speed * rng.randf_range(0.2,0.4)
		if rng.randf() < 0.5:
			currentState = IDLE
		movement_timer = rng.randf_range(2,5)
	
	movement_timer -= pDelta
	
func idle(pDelta):
	velocity = Vector2()
	if movement_timer < 0:
		if rng.randf() < 0.5:
			currentState = ROAMING
	movement_timer -= pDelta
	
