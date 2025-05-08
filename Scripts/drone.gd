extends Sprite2D

@export var min_height: float = 40
@export var speed: float = 1


@onready var acceptable_difference: float = randf_range(10, 30)
var go_up:bool = true


func _process(delta):
	if GlobalVariables.game_is_on or (Client.active and Client.players_alive.size() > 1):
		if abs(get_parent().global_position.y - min_height) > acceptable_difference:
			acceptable_difference = randf_range(10, 30)
			go_up = true
			
			
		if go_up:
			get_parent().global_position.y = lerp(get_parent().global_position.y, get_parent().global_position.y - 20, 0.1)
			if abs(get_parent().global_position.y - min_height) < 10:
				go_up = false
				
		else:
			get_parent().global_position.y = lerp(get_parent().global_position.y, get_parent().global_position.y + 20, 0.01)
		
	
