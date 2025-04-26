class_name LevelInfo
extends Resource

@export var level: GlobalEnums.LEVELS
@export var title: String
@export var description: String
@export var baner: Texture2D
@export var decorations : Array[Decoration]
@export var decoration_spawn_pattern : String
@export var environment : Resource
@export var parallax_background : PackedScene
@export var directional_light : PackedScene
@export var ground_color : Color
@export var grass_color : Color
@export var music : AudioStreamMP3
