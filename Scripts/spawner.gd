extends StaticBody2D
@onready var main = self.get_parent()
var spawn_time = 5.0
var rng = RandomNumberGenerator.new()
var spawner_list = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawner_list["Zombie"] = preload("res://Objects/Enemy/zombie.tscn")
	spawner_list["BucketZombie"] = preload("res://Objects/Enemy/zombie2.tscn")
	


func _process(delta: float) -> void:
	spawn_time -= delta
	if spawn_time <= 0:
		spawn()
		
		
func spawn():
	print(type_string(typeof(spawner_list)))
	var randindividual = spawner_list[spawner_list.keys().pick_random()]
	var zombie = randindividual.instantiate()
	var range = 50
	zombie.position = position + (Vector2(rng.randf_range(-1.0, 1),rng.randf_range(-1.0, 1)).normalized()) * range
	main.add_child.call_deferred(zombie)
	print("Created")
	spawn_time = rng.randf_range(5.0, 10.0)
	
	
