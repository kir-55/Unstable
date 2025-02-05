extends Control




@export var last_score_label : Label
@export var best_score_label : Label



func _on_exit_pressed():
	get_tree().quit()
	
func _on_progress_pressed():
	GlobalFunctions.load_menu(GlobalEnums.MENU_LEVEL.PROGRESS, true)

func _on_gameover_progress_pressed():
	GlobalFunctions.load_menu(GlobalEnums.MENU_LEVEL.PROGRESS, true, true)


func _on_again_pressed():
	GlobalFunctions.reload()

func _ready():
	while(!last_score_label or !best_score_label):
		return
	last_score_label.set_text(last_score_label.get_text() + str(GlobalVariables.last_score))
	best_score_label.set_text(best_score_label.get_text() + str(GlobalVariables.best_score))
	
