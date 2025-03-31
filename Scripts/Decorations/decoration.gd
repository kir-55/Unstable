class_name Decoration
extends Resource

@export var prefab: PackedScene
@export_category("Chances")
@export var name : String
@export var spawn_on_center := false
@export var chance_to_spawn: float
@export var width := 0
@export var pattern_type : String
@export var type: GlobalEnums.DECORATION_LAYERS = GlobalEnums.DECORATION_LAYERS.ON_GROUND
@export var incompatible_with_types: Array[GlobalEnums.DECORATION_LAYERS]

@export_category("Scale range")
@export var min_scale: float
@export var max_scale: float
