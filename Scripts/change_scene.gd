extends Timer





var destination_level_info: LevelInfo


@export var baner: TextureRect
@export var title: Label
@export var description: Label

func _ready():
	var destination = GlobalVariables.next_epoch
	
	for level_info in GlobalVariables.epochs:
		if level_info.level == destination:
			destination_level_info = level_info
	
	if !destination_level_info:
		print("error")
		
	baner.texture = destination_level_info.baner
	title.text = destination_level_info.title
	description.text = destination_level_info.description
		
func _on_timeout():
	get_tree().change_scene_to_file(destination_level_info.scene)
 
