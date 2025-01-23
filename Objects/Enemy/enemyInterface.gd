extends CharacterBody2D

class_name enemyInterface

enum {
	IDLE,
	ROAMING,
	FOLLOWING,
	DEAD
}
@export var drop: item
@export var enemyStat: enemyStats
@onready var collectable = preload("res://Objects/collectable.tscn")
@onready var main = self.get_parent()


var health:int
var speed:int
var damage_num:int
var movement_timer = 0
var player = null
var rng = RandomNumberGenerator.new()

var currentState = IDLE

var conditionList: Array = []

#MUST OVERRIDE FUNCTIONS

func _ready():
	pass
	

func death_animation():
	pass

func movement(pDelta):
	pass
	
func idle(pDelta):
	pass
		 

func roaming(pDelta):
	pass

#CAN OVERRIDE IF KNOW WHAT DOING
func damage(num):
	health -= num
	update_damage()
	if health <= 0:
		die()

func update_damage():
	$HealthBar.value = health
	
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	match currentState: 
		IDLE:
			idle(delta)
		ROAMING:
			roaming(delta)
		FOLLOWING:
			movement(delta)
		DEAD:
			return
	var collision = move_and_collide(velocity * speed * delta)
	if collision:
		collision(collision.get_collider())

func handle_condition(p_condition):
	pass
	
func handle_conditions():
	for i in conditionList:
		handle_condition(i)
	
func apply_condition(condition):
	conditionList.append(condition)
	
	
func die():
	currentState = DEAD
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
	
	
	##Collision Handlers
func collision(collider):
	if collider.is_in_group("player"):
		if collider.get_i_frames() <= 0:
			collider.damage(damage_num)

func on_enter(body):
	if body.is_in_group("player"):
		player = body
		currentState = FOLLOWING
	
func on_exit(body): 
	if body.is_in_group("player"):
		player = null
		currentState = ROAMING
