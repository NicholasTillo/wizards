extends CharacterBody2D

class_name player_body_2d

#Export Variables
@export var speed = 400

@export var temp:spell

#Onready Variables
@onready var main = self.get_parent()
@onready var bullet = preload("res://Objects/spellProjectiles/bullet.tscn")
#Other Variables
var current_cantrip: spell = null
var dead = false
var health = 20  
var i_frames = 0
var rng = RandomNumberGenerator.new()
var conditionList: Array = []

#Verbal Components 
var held_fire_time = 0
var charging = false

#Somatic Components 
var draw_section_visible = false
var inv_section_visible = false

#Material Components 
@export var playerinv:inventory

func get_i_frames():
	return i_frames

##Spell Handlers
func get_current_cantrip():
	return current_cantrip

func set_current_cantrip(p_spell):
	print(p_spell)
	current_cantrip = p_spell
	bullet = load(current_cantrip.get_scene())


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
	$OtherDisplays/HealthBar.max_value = health
	$OtherDisplays/HealthBar.value = health
	
	set_current_cantrip(temp)
	
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
	$OtherDisplays/  HealthBar.value = health


func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed


func _physics_process(delta):
	get_input()
	if not dead:
		move_and_slide()
	i_frames -= delta
	if charging:
		held_fire_time -= delta



func _input(event):
	if dead:
		return 

	if event.is_action_pressed("fire"):
		$OtherDisplays/ChargeBar.visible = true
		charging = true
		
	if event.is_action_released("fire"):
		if held_fire_time < 1:
			charging = false
			activate_cantrip()
		else:
			######
			activate_spell(int(held_fire_time), "shape", "inventory.get_chosen")
			
		$OtherDisplays/ChargeBar.visible = false
		

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
		

func activate_cantrip():
	var b = bullet.instantiate()
	b.position = position + ((get_global_mouse_position() - position).normalized() * 50)
	main.add_child.call_deferred(b)
	print("Created")
	
	
####THIS ONE NEXT
func activate_spell(verbal, somatic, material):
	pass
