extends PointLight2D


@export var take_from: Sprite2D

func _process(delta):
	if take_from.texture != texture:
		texture = take_from.texture
		position = Vector2.ZERO
		offset = take_from.offset


