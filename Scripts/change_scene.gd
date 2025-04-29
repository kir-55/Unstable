extends Timer

var destination_epoch: EpochInfo


@export var baner: TextureRect
@export var title: Label
@export var description: Label

func _ready():
	destination_epoch = GlobalVariables.epochs[GlobalVariables.next_epoch_id]
	
	baner.texture = destination_epoch.baner
	title.text = destination_epoch.title
	description.text = destination_epoch.description
		
func _on_timeout():
	GlobalVariables.current_epoch_id = GlobalVariables.next_epoch_id
	get_tree().change_scene_to_file("res://Scenes/Locations/epoch.tscn")
 
