class_name Weapon
extends Node2D



var can_shoot: bool = true

# this id is incremented!!!!!!! by 1
@export var current_weapon_type_id: int:
	set(value):
		if value > 0:
			self.texture = GlobalVariables.active_weapon_types[value-1].texture
		current_weapon_type_id = value

var shooting_weapon_timer: Timer

@export var shoot_point: Node2D


func _ready():
	if !shoot_point:
		shoot_point = self
	

func _unhandled_input(event):
	if GlobalVariables.game_is_on and Input.is_action_just_pressed("fire") and can_shoot and get_parent().is_multiplayer_authority():
		fire_weapon()


func fire_weapon() -> void:
	if current_weapon_type_id != 0  and GlobalVariables.active_weapon_types[current_weapon_type_id-1].bullet_prefab and GlobalVariables.active_weapon_types[current_weapon_type_id-1].active and get_parent().is_multiplayer_authority():

		if Client.active and GlobalVariables.active_weapon_types[current_weapon_type_id - 1].spawn_on_peers:
			Client.spawn.rpc(GlobalVariables.active_weapon_types[current_weapon_type_id - 1].bullet_prefab, shoot_point.global_position, get_parent().original_speed, GlobalVariables.active_weapon_types[current_weapon_type_id - 1].bullet_speed, GlobalVariables.active_weapon_types[current_weapon_type_id - 1].initial_rotation)
		else:
			Client.spawn(GlobalVariables.active_weapon_types[current_weapon_type_id - 1].bullet_prefab, shoot_point.global_position, get_parent().original_speed, GlobalVariables.active_weapon_types[current_weapon_type_id - 1].bullet_speed, GlobalVariables.active_weapon_types[current_weapon_type_id - 1].initial_rotation)


		get_parent().velocity.x -= GlobalVariables.active_weapon_types[current_weapon_type_id - 1].knockback_force
		# Start cooldown
		can_shoot = false
		shooting_weapon_timer.start()


func on_passive_weapon(weapon_type: WeaponType):
	if weapon_type and weapon_type.bullet_prefab and !weapon_type.active and get_parent().is_multiplayer_authority():
		if Client.active and weapon_type.spawn_on_peers:
			Client.spawn.rpc(weapon_type.bullet_prefab, shoot_point.global_position, 0, weapon_type.bullet_speed, weapon_type.initial_rotation)
		else:
			Client.spawn(weapon_type.bullet_prefab, shoot_point.global_position, 0, weapon_type.bullet_speed, weapon_type.initial_rotation)



func on_active_weapon():
	can_shoot = true
