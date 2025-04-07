class_name Weapon
extends Node2D



var can_shoot: bool = true


var current_weapon_type: WeaponType

var shooting_weapon_timer : Timer

@rpc("any_peer", "call_local")
func spawn(prefab: PackedScene, position: Vector2, player_velocity_x: float, speed: float):
	var instance = prefab.instantiate()
	instance.global_position = position
	get_tree().current_scene.add_child(instance)
		
	instance.set_velocity(Vector2(player_velocity_x, 0) + Vector2.RIGHT * speed)


func _unhandled_input(event):
	if GlobalVariables.game_is_on and Input.is_action_just_pressed("fire") and can_shoot:
		fire_weapon()


func fire_weapon() -> void:
	if current_weapon_type and current_weapon_type.bullet_prefab and current_weapon_type.active:
		if Client.active and current_weapon_type.spawn_on_peers:
			spawn.rpc(current_weapon_type.bullet_prefab, global_position, get_parent().velocity.x, current_weapon_type.bullet_speed)
		else:
			spawn(current_weapon_type.bullet_prefab, global_position, get_parent().velocity.x, current_weapon_type.bullet_speed)
			
		
		get_parent().velocity.x -= current_weapon_type.knockback_force
		# Start cooldown
		can_shoot = false
		shooting_weapon_timer.start()


func on_passive_weapon(weapon_type: WeaponType):
	if weapon_type and weapon_type.bullet_prefab and !weapon_type.active:
		if Client.active and weapon_type.spawn_on_peers:
			spawn.rpc(weapon_type.bullet_prefab, global_position, get_parent().velocity.x, weapon_type.bullet_speed)
		else:
			spawn(weapon_type.bullet_prefab, global_position, get_parent().velocity.x, weapon_type.bullet_speed)


func on_active_weapon():
	can_shoot = true
