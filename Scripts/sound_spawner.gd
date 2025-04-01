extends Node


@export var spawn_on_start_prefab: PackedScene


func _ready():
	var instance = spawn_on_start_prefab.instantiate()
	get_tree().current_scene.add_child(instance)


