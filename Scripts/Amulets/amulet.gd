@tool
class_name Amulet
extends Resource

@export var id: int = 0
@export var name: String = "Amulet"
@export var description: String = ""
@export var texture: Texture2D
@export var incompatible_amulets : Array[int]


@export var consumable: bool = false

@export var has_timer: bool = false:
	set(value):
		has_timer = value
		notify_property_list_changed()

@export var timer_reload: float = 1


#Regulacja widoczności w edytorze
@export var stack_limit: bool = false:
	set(value):
		stack_limit = value
		notify_property_list_changed()

@export var limit: int = 1

@export var chance_multiplier : int = 1



func _validate_property(property: Dictionary) -> void:
	if property.name in ["limit"] and !stack_limit:
		property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name in ["timer_reload"] and !has_timer:
		property.usage = PROPERTY_USAGE_NO_EDITOR
