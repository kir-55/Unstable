class_name EpochInfo
extends Resource


@export_category("-- description --")
@export var title: String
@export var description: String
@export var baner: Texture2D


@export_category("-- ground --")
@export var ground_color : Color
@export var grass_color : Color


@export_category("-- decorations --")
@export var decorations : Array[Decoration]
@export var decoration_spawn_pattern : String


@export_category("-- ambiance --")
@export var environment : Resource
@export var directional_light : PackedScene
@export var background_color : Color


@export_category("-- ambiance --")
@export var parallax_background_close : Texture2D
@export var parallax_background_far : Texture2D
@export var parallax_foreground : Texture2D


@export_category("-- audio --")
@export var music : AudioStreamMP3


