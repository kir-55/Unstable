class_name HealthSystem
extends Node

@export var max_health := 80.0
@export var explosion_prefab:PackedScene
@export var explosion_point: Node2D
@export var breaking_shader : Shader = preload("res://Styles/breaking.gdshader")
@onready var health = max_health

func set_breaking_shader_parameters(material):
	material.set_shader_parameter("sensitivity", health / max_health)
	material.set_shader_parameter("cracks_color", GlobalVariables.decoration_breaking_effect_color)

func apply_breaking_shader():
	for child in get_parent().get_children():
		if child is Sprite2D:
			child.material = ShaderMaterial.new()
			child.material.shader = breaking_shader
			set_breaking_shader_parameters(child.material)

func take_damage(value):
	health -= value
	apply_breaking_shader()
	if health <= 0:
		var explosion = explosion_prefab.instantiate()
		# sale bug fixed
		if explosion is RigidBody2D:
			# necessary funcion 
			# assumption is that every throwable rigidbody has script 
			# scale_workaround.gd
			explosion.get_child(0).scale = get_parent().scale / 2
			#for child in explosion.get_children():
				#if child is Node2D and not child is CollisionShape2D:
					#child.scale = get_parent().scale
		else:
			explosion.scale = get_parent().scale
			
			
		if explosion_point:
			explosion.global_position = explosion_point.global_position
		else:
			explosion.global_position = get_parent().global_position
		
		if "emitting" in explosion:
			explosion.emitting = true
		elif "emitting" in explosion.get_child(0):
			explosion.get_child(0).emitting = true
			
		get_tree().current_scene.add_child(explosion)
		
		get_parent().queue_free()
