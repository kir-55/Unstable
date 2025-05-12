extends Control




@export var death_info: RichTextLabel
@export var new_amulet_count_label: RichTextLabel






func _on_start_exit_pressed():
	Client.reset_multiplayer_connection()
	get_tree().quit()

func _on_exit_pressed():
	Client.reset_multiplayer_connection()
	GlobalFunctions.load_menu("main", true, true)

func _on_progress_pressed():
	GlobalFunctions.load_menu("progress", true)


func _on_gameover_progress_pressed():
	GlobalFunctions.load_menu("progress", true, false)






func _ready():
	if !death_info:
		return
	
	GlobalFunctions.save_player_data()
	
	
	
	
	
func _on_new_amulet_count_ready():
	pass




func _on_multiplayer_pressed():
	GlobalFunctions.load_menu("multiplayer_join")


func _on_settings_pressed():
	GlobalFunctions.load_menu("settings", true)


# GAME MODES

func _on_again_pressed():
	GlobalFunctions.reload()


func _on_story_play_pressed():
	GlobalFunctions.reload(GlobalEnums.GAME_MODES.STORY)


func _on_endless_play_pressed():
	GlobalFunctions.reload(GlobalEnums.GAME_MODES.ENDLESS)


func _on_tutorial_pressed():
	GlobalVariables.game_mode = GlobalEnums.GAME_MODES.TUTORIAL
	get_tree().change_scene_to_file("res://Scenes/Locations/tutorial.tscn")
