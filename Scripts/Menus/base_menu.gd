extends Control




@export var death_info: RichTextLabel
@export var new_amulet_count_label: RichTextLabel
@export var play_button: Button
@export var story_play_button: Button


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

func _input(event):
	if event is InputEventMouseButton and event.pressed and GlobalVariables.is_gamepad_controlling:
		GlobalVariables.is_gamepad_controlling = false
		play_button.release_focus()
		story_play_button.release_focus()
	if play_button.visible:
		GlobalFunctions.gamepad_input_focus_button(event, play_button)
	else:
		GlobalFunctions.gamepad_input_focus_button(event, story_play_button)

# GAME MODES

func _on_again_pressed():
	GlobalFunctions.reload()


func _on_story_play_pressed():
	GlobalFunctions.reload(GlobalEnums.GAME_MODES.STORY)


func _on_endless_play_pressed():
	GlobalFunctions.reload(GlobalEnums.GAME_MODES.ENDLESS)



func _on_tutorial_pressed():
	GlobalFunctions.reload(GlobalEnums.GAME_MODES.TUTORIAL)

