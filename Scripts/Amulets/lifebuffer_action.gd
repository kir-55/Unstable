extends Node2D

@onready var amulet_system = GlobalVariables.player.find_child("Amulets")

func _ready():
	if not GlobalVariables.player_amulets.has(11):
		if amulet_system:
			amulet_system.attach_amulet(11)
			amulet_system.display_amulets()
	queue_free()

func set_velocity(speed : Vector2):
	pass
