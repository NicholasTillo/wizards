extends ColorRect



var flag:bool = false 
var total: float = 0.05

var curLine = null

@onready var line = preload("res://Objects/Line.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if flag:
		total -= delta
		if Input.is_action_pressed("left_click") and total < 0:
			print(curLine.points)
			curLine.add_point(get_local_mouse_position())
			total = 0.05
		

	

func start_drawing():
	flag = true 
	curLine = line.instantiate()
	add_child.call_deferred(curLine)

func finish_drawing():
	flag = false 
