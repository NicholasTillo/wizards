extends Button


@onready var item_visual: Sprite2D = $item_display
@onready var count_visual: Label = $count_display
@onready var dimmer: ColorRect = $ColorRect
@onready var item_count: int = 0

@export var index: int
@export var corresponding_item: item

func _ready():
	item_visual.texture = corresponding_item.overworld_texture
	
func add(num: int):
	if item_count == 0:
		undim()
	item_count += num
	write(item_count)
	
func select():
	pass
	
func dim():
	dimmer.visible = true
	
func undim():
	dimmer.visible = false
	
func remove(num: int):
	item_count -= num
	if item_count < 0:
		item_count = 0
	if item_count == 0:
		dim()
	write(item_count)
	
	
func write(p_num: int):
	count_visual.text = str(item_count)
	
	
	
