extends Area2D

@export var animation_player: AnimationPlayer
#@export var brown_color: Color

func _on_body_entered(body):
	if body.is_in_group("Player") or body.is_in_group("Projectile"):
		if animation_player and not animation_player.is_playing():
			animation_player.play("explosion")
			#body.get_node("Sprite2D").self_modulate = brown_color
	
	


func _on_area_entered(area):
	if area.is_in_group("Projectile"):
		if animation_player and not animation_player.is_playing():
			animation_player.play("explosion")
