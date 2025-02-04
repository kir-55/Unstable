extends Sprite2D

@export_category("arrow")
@export var arrow_min_speed: float = 200
@export var arrow_max_speed: float = 400

var arrow_speed: float

func _ready():
	arrow_speed = randf_range(arrow_min_speed, arrow_max_speed)

func _process(delta):
	if GlobalVariables.game_is_on:
		global_position.y += arrow_speed * delta

