@tool
class_name Amulet
extends Resource

@export var id: int = 0
@export var name: String = "Amulet"
@export var description: String = ""
@export var texture: Texture2D

#Regulacja widoczności w edytorze
@export var stack_limit: bool = false:
	set(value):
		stack_limit = value
		notify_property_list_changed()

@export var limit: int = 1



func _validate_property(property: Dictionary) -> void:
	if property.name in ["limit"] and !stack_limit:
		property.usage = PROPERTY_USAGE_NO_EDITOR
