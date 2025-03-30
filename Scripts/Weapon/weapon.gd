class_name Weapon
extends Node2D



var can_shoot: bool = true


var current_weapon_type: WeaponType

var shooting_weapon_timer : Timer



func _unhandled_input(event):
	if GlobalVariables.game_is_on and Input.is_action_just_pressed("fire") and can_shoot:
		fire_weapon()

func fire_weapon() -> void:
	if current_weapon_type and current_weapon_type.bullet_prefab and current_weapon_type.active:
		var bullet = current_weapon_type.bullet_prefab.instantiate()
		bullet.global_position = global_position
		get_tree().current_scene.add_child(bullet)
		 
		# Determine shooting direction based on player's input
		var input_direction = get_parent().direction

		# Default to shooting right if no inputd
		if input_direction == Vector2.ZERO:
			input_direction = Vector2.RIGHT
		bullet.set_velocity(Vector2(get_parent().velocity.x, 0) + input_direction * current_weapon_type.bullet_speed)
		get_parent().velocity.x -= current_weapon_type.knockback_force
		# Start cooldown
		can_shoot = false
		shooting_weapon_timer.start()


func on_passive_weapon(weapon_type: WeaponType):
	if weapon_type and weapon_type.bullet_prefab and !weapon_type.active:
		var instance = weapon_type.bullet_prefab.instantiate()
		instance.global_position = global_position
		get_parent().get_parent().add_child(instance)

func on_active_weapon():
	can_shoot = true
