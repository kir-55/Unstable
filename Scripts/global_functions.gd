extends Node

func reload():
	Engine.time_scale = 1
	GlobalVariables.last_score = 0
	GlobalVariables.player_global_speed = GlobalVariables.initial_player_speed
	GlobalVariables.game_is_on = true
	GlobalVariables.player_amulets = []
	GlobalVariables.times_treveled = 0
	GlobalVariables.items_in_home = GlobalVariables.initial_items_in_home
	get_tree().change_scene_to_file("res://Scenes/Locations/city.tscn")

func _ready():
	load_player_data()


func save_player_data():
	var file = FileAccess.open(GlobalVariables.player_data_path, FileAccess.WRITE)
	if file:
		var data = {
			"best_score": GlobalVariables.best_score
		}
		file.store_string(JSON.stringify(data))
		file.close()

func load_player_data():
	var file = FileAccess.open(GlobalVariables.player_data_path, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		var data = JSON.parse_string(content)
		if data and "best_score" in data:
			GlobalVariables.best_score = data["best_score"]
		file.close()
