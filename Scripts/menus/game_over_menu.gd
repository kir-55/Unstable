extends Control




@export var death_info: RichTextLabel
@export var new_amulet_count_label: RichTextLabel


func _on_start_exit_pressed():
	Client.reset_multiplayer_connection()
	get_tree().quit()

func _on_exit_pressed():
	Client.reset_multiplayer_connection()
	GlobalFunctions.load_menu("main", true, true)


# has to be fixed, two identical functions
func _on_progress_pressed():
	GlobalFunctions.load_menu("progress", true)


func _on_gameover_progress_pressed():
	GlobalFunctions.load_menu("progress", true)


func _on_again_pressed():
	GlobalFunctions.reload()


func _ready():
	if !death_info:
		return
	
	GlobalFunctions.save_player_data()
	
	if GlobalVariables.last_score == GlobalVariables.best_score:
		death_info.append_text("[center][font_size=25][color='#3d80a3']Score: " + str(GlobalVariables.last_score) + "[/color][/font_size][color='#c57835'][font_size=16][shake rate=5 level=10][sup] (New Best!)[/sup][/shake][/font_size][/color][/center]")
	else:
		death_info.append_text("[center][font_size=25][color='#3d80a3']Score: " + str(GlobalVariables.last_score) + "[/color][/font_size][font_size=16] (Best: " + str(GlobalVariables.best_score) + ")[/font_size][/center]")

func _on_new_amulet_count_ready():
	if GlobalVariables.player_new_amulets.size() > 0:
		new_amulet_count_label.append_text('[center]Progress [/center][color="#c57835"][font_size=16][shake rate=5 level=10][sup](' + str(GlobalVariables.player_new_amulets.size()) + ' New!)[/sup][/shake][/font_size][/color]')
	else:
		new_amulet_count_label.append_text("[center]Progress[/center]")



func _on_multiplayer_pressed():
	GlobalFunctions.load_menu("multiplayer_join")


func _on_settings_pressed():
	GlobalFunctions.load_menu("settings", true)


