extends Sprite2D

@export var min_height: float = 40
@export var speed: float = 1

func _process(delta):
	if get_parent().global_position.y > min_height:
		get_parent().global_position.y = lerp(get_parent().global_position.y, get_parent().global_position.y - 20, 1)
