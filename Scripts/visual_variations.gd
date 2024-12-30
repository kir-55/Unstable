extends Sprite2D


@export var visual_variations: Array[Texture2D]

# Called when the node enters the scene tree for the first time.
func _ready():
	if visual_variations:
		texture = visual_variations.pick_random()
