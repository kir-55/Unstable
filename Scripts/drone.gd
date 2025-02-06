extends Sprite2D

@export var min_height: float = 40
@export var speed: float = 1

func _process(delta):
	if global_position.y > min_height:
		global_position.y = lerp(global_position.y, global_position.y - 20, 1)
