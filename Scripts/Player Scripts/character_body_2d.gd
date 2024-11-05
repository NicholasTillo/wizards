extends CharacterBody2D

class_name player_body_2d

#Export Variables
@export var speed = 400
@export var playerinv:inventory
@export var temp:spell

#Onready Variables
@onready var main = self.get_parent()
@onready var bullet = preload("res://Objects/spellProjectiles/bullet.tscn")
#Other Variables
var current_spell: spell = null
var dead = false
var health = 20  
var i_frames = 0
var rng = RandomNumberGenerator.new()
var conditionList: Array = []

var draw_section_visible = false
var inv_section_visible = false


func get_i_frames():
	return i_frames

##Spell Handlers
func get_current_spell():
	return current_spell

func set_current_spell(p_spell):
	print(p_spell)
	current_spell = p_spell
	bullet = load(current_spell.get_scene())


##Condition Handlers
func apply_condition(condition):
	conditionList.append(condition)

func handle_condition(p_condition):
	pass


func handle_conditions():
	for i in conditionList:
		handle_condition(i)




func _ready():
	#Set Init Values 
	$HealthBar.max_value = health
	$HealthBar.value = health
	
	set_current_spell(temp)
	
func damage(num):
	health -= num
	update_damage()
	i_frames = 1
	if health <= 0:
		die()
		

func heal(p_amount):
	health += p_amount 
	update_damage()

	
func die():
	$AudioPlayer.play()
	death_animation()
	await get_tree().create_timer(3.0).timeout
	get_tree().reload_current_scene()
	
	
	
	
func death_animation():
	$CollisionShape2D/Sprite.texture = load("res://Assets/meteorite-or-fire-ball-illustration-png.webp")
	
	
func update_damage():
	$HealthBar.value = health


func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed


func _physics_process(delta):
	get_input()
	if not dead:
		move_and_slide()
	i_frames -= delta



func _input(event):
	if dead:
		return 

	if event.is_action_pressed("fire"):
		activate_spell()
		

		#Handlers for menu
	if event.is_action_pressed("left_click") and inv_section_visible == true:
		pass


	if event.is_action_pressed("inv_menu"):
		inv_section_visible = true
		$MainCam/InventoryManager/Display/itempanel.visible = true
	if event.is_action_released("inv_menu"):
		inv_section_visible = false
		$MainCam/InventoryManager/Display/itempanel.visible = false


		#Handlers for drawing
	if event.is_action_pressed("left_click") and draw_section_visible == true:
		$MainCam/InventoryManager/Display/drawsection.start_drawing()
	if event.is_action_released("left_click") and draw_section_visible == true:
		var finishedShape = $MainCam/InventoryManager/Display/drawsection.finish_drawing()
		
	if event.is_action_pressed("draw_menu"):
		draw_section_visible = true
		$MainCam/InventoryManager/Display/drawsection.visible = true
	if event.is_action_released("draw_menu"):
		draw_section_visible = false
		$MainCam/InventoryManager/Display/drawsection.visible = false
		

func activate_spell():
	var b = bullet.instantiate()
	b.position = position + ((get_global_mouse_position() - position).normalized() * 50)
	main.add_child.call_deferred(b)
	print("Created")
