extends CharacterBody2D

class_name player_body_2d

#Export Variables
@export var speed = 400

@export var temp:spell

#Onready Variables
@onready var main = self.get_parent()
@onready var bullet = preload("res://Objects/spellProjectiles/bullet.tscn")
#Other Variables

var dead = false
var health = 20
var i_frames = 0
var rng = RandomNumberGenerator.new()
var conditionList: Array = []

#UI Elements
@onready var health_bar_ui = $OtherDisplays/HealthBar
@onready var charge_bar_ui = $OtherDisplays/ChargeBar

#SpellStuff
var spell_book: Array = []
var current_cantrip: spell = null
var recent_cast: spell = null
var wand_cooldown: float = 0
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

func get_recent_cast():
	return recent_cast

func set_recent_cast(p_spell):
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
	health_bar_ui.max_value = health
	health_bar_ui.value = health
	
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
	$DeathAudioPlayer.play()
	death_animation()
	await get_tree().create_timer(3.0).timeout
	get_tree().reload_current_scene()
	
	
	
	
func death_animation():
	$CollisionShape2D/Sprite.texture = load("res://Assets/meteorite-or-fire-ball-illustration-png.webp")
	
	
	

	
	
func update_damage():
	health_bar_ui.value = health


func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed


func _physics_process(delta):
	get_input()
	if not dead:
		move_and_slide()
	i_frames -= delta
	
	if charging:
		print(held_fire_time)
		held_fire_time += delta
		update_chargebar(held_fire_time)
	if wand_cooldown > 0:
		wand_cooldown -= delta


func update_chargebar(p_held_fire_time):
	charge_bar_ui.value = int(p_held_fire_time)
	
	
func _input(event):
	if dead:
		return 

	if event.is_action_pressed("fire"):
		if wand_cooldown > 0:
			return
			
			
		$OtherDisplays/ChargeBar.visible = true
		charging = true
		held_fire_time = 0
		
	if event.is_action_released("fire"):			
		if wand_cooldown > 0:
			return
		print(held_fire_time)
		charging = false
		if held_fire_time < 1:
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
func activate_spell(verbal, somatic, materials):
	for single_spell in spell_book:
		if(single_spell.lower_verbal_bound >= verbal and 
			single_spell.upper_verbal_bound <= verbal and 
				single_spell.somatic_requirement == materials and  
					single_spell.material_requirement == materials ):
			var spell_instance = single_spell;
			var b = spell_instance.instantiate()
			b.position = position + ((get_global_mouse_position() - position).normalized() * 50)
			main.add_child.call_deferred(b)
			return
			
	fizzle()
	
		
func fizzle():
	$MiscAudioPlayer.play()
	wand_cooldown = 2
	 
	
