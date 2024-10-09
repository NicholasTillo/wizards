extends StaticBody2D

#If player is in the area2d
var if_in_range = true
var time_till_heal = 10.0
#Amount Healed
var amount = 2
var player = null

func _ready() -> void:
	pass # Replace with function body.



func _process(delta: float) -> void:
	#If the player is within range, tick down time
	if if_in_range:
		time_till_heal -= delta
	if time_till_heal <= 0:
		$AudioPlayer.play()
		
		player.heal(amount)
		#Reset time to heal
		time_till_heal = 10.0
		
		
func _on_player_enter(body: Node2D) -> void:
	#Once player enters the area 2d, linked to signal
	if body.is_in_group("player"):
		player = body
		if_in_range = true
		print("entered")
		
func _on_player_leave(body: Node2D) -> void:
	#Once player leaves the area 2d, linked to signal
	if body.is_in_group("player"):
		player = null
		if_in_range = false
		print("left")

	
