extends Area2D

@export var front_side: Sprite2D  # Drag your sprite into this in the editor

func _ready():
	# Connect signals
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		# Set alpha to 50%
		var modulate = front_side.modulate
		modulate.a = 0.5
		front_side.modulate = modulate

func _on_body_exited(body):
	if body.is_in_group("Player"):
		# Restore full opacity
		var modulate = front_side.modulate
		modulate.a = 1.0
		front_side.modulate = modulate
