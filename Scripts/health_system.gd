extends Node

@export var max_health := 80.0
@export var audio:PackedScene
@onready var health = max_health

var player: Node2D

func take_damage(value):
	health -= value
	if health <= 0:
		get_parent().get_parent().get_parent().add_child(audio.instantiate())
		print("damage")
		get_parent().queue_free()
