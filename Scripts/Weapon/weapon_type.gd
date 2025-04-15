@tool

class_name WeaponType
extends Resource

@export var bullet_prefab: String

# if triggered with user input - active
# if staticly called over time - !active
@export var active: bool = false:
	set(value):
		active = value
		notify_property_list_changed()
@export var texture: Texture2D


@export var bullet_speed: float = 600.0      # Speed of the spawned bullets
@export var knockback_force: float = 200.0   # Knockback magnitude applied to the parent

@export var spawn_on_peers: bool = false


@export var initial_rotation: float = 0 

func _validate_property(property: Dictionary) -> void:
	if property.name in ["texture"] and !active:
		property.usage = PROPERTY_USAGE_NO_EDITOR
		
