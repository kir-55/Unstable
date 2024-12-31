extends Timer


var destination: GlobalVariables.LEVELS


@export var levels_info: Array[LevelInfo]

var destination_level_info: LevelInfo


@export var baner: TextureRect
@export var title: Label
@export var description: Label

func _ready():
	destination = GlobalVariables.LEVELS[GlobalVariables.LEVELS.keys()[randi() % GlobalVariables.LEVELS.size()]]
	while GlobalVariables.last_world == destination:
		destination = GlobalVariables.LEVELS[GlobalVariables.LEVELS.keys()[randi() % GlobalVariables.LEVELS.size()]]
	
	for level_info in levels_info:
		if level_info.level == destination:
			destination_level_info = level_info
	
	if !destination_level_info:
		print("error")
		
	baner.texture = destination_level_info.baner
	title.text = destination_level_info.title
	description.text = destination_level_info.description
		
func _on_timeout():
	get_tree().change_scene_to_packed(destination_level_info.scene)
 
