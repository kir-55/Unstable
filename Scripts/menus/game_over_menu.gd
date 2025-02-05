extends Control




@export var last_score_label : Label
@export var best_score_label : Label
@export var new_amulet_count_label : RichTextLabel



func _on_exit_pressed():
	get_tree().quit()
	
func _on_progress_pressed():
	GlobalFunctions.load_menu(GlobalEnums.MENU_LEVEL.PROGRESS, true)

func _on_gameover_progress_pressed():
	GlobalFunctions.load_menu(GlobalEnums.MENU_LEVEL.PROGRESS, true)

func _on_again_pressed():
	GlobalFunctions.reload()

func _ready():
	while(!last_score_label or !best_score_label):
		return
	last_score_label.set_text(last_score_label.get_text() + str(GlobalVariables.last_score))
	best_score_label.set_text(best_score_label.get_text() + str(GlobalVariables.best_score))


func _on_new_amulet_count_ready():
	if GlobalVariables.player_new_amulets.size() > 0:
		new_amulet_count_label.append_text('[center]Progress ([color="red"]' + str(GlobalVariables.player_new_amulets.size()) + ' new![/color])[/center]')
	else:
		new_amulet_count_label.append_text("[center]Progress[/center]")
