extends Node

@export var max_health := 80.0
@export var explosion_prefab:PackedScene
@export var explosion_point: Node2D
@onready var health = max_health


func take_damage(value):
	health -= value
	if health <= 0:
		var explosion = explosion_prefab.instantiate()
		if explosion_point:
			explosion.global_position = explosion_point.global_position
		else:
			explosion.global_position = get_parent().global_position
		
		if "emitting" in explosion:
			explosion.emitting = true
		elif "emitting" in explosion.get_child(0):
			explosion.get_child(0).emitting = true
			
		get_tree().current_scene.add_child(explosion)
		
		#print("damage")
		get_parent().queue_free()
