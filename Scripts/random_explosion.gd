extends Node

@export var explosion_prefabs: Array[PackedScene]



func _ready():
	var instance = explosion_prefabs.pick_random().instantiate()
	instance.global_position = get_parent().global_position
	get_tree().current_scene.add_child(instance)
	
	instance.emitting = true

