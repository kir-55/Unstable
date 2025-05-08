extends Area2D

@export var animation_player: AnimationPlayer
#@export var brown_color: Color

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		if animation_player and not animation_player.is_playing():
			animation_player.play("explosion")
			#body.get_node("Sprite2D").self_modulate = brown_color
