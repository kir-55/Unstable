extends Node2D

func _ready():
	if not GlobalVariables.player_amulets.has(11):
		GlobalFunctions.add_amulet(11)
	queue_free()

func set_velocity(speed : Vector2):
	pass
