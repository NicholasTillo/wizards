extends StaticBody2D
@onready var main = self.get_parent()
@onready var spawner = preload("res://Objects/Enemy/zombie.tscn")
var spawn_time = 5.0
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _process(delta: float) -> void:
	spawn_time -= delta
	if spawn_time <= 0:
		spawn()
		
		
func spawn():
	var zombie = spawner.instantiate()
	var range = 50
	zombie.position = position + (Vector2(rng.randf_range(-1.0, 1),rng.randf_range(-1.0, 1)).normalized()) * range
	main.add_child.call_deferred(zombie)
	print("Created")
	spawn_time = rng.randf_range(5.0, 10.0)
	
	
