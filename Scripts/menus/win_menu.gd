extends Control

@export var score : Label
@export var win_label : RichTextLabel
@export var amulet_prefab : PackedScene
@export var new_amulet_count_label : RichTextLabel

var win_type = GlobalEnums.WIN_TYPES.NONE

func _ready():
	score.text += str(float(GlobalVariables.last_score)) + " score"
	score.text += "\n" + str((Time.get_ticks_msec() - GlobalVariables.time_started)/1000) + " seconds"
	var escape_amulets : Array
	if win_type == GlobalEnums.WIN_TYPES.REPAIR:
		escape_amulets = GlobalVariables.amulets.filter(func(x): return x.required_for_repair)
		win_label.text = "[center]You [color=#e1a845][wave]repaired[/wave][/color] the time machine!!![/center]"
	elif win_type == GlobalEnums.WIN_TYPES.DESTRUCTION:
		escape_amulets = GlobalVariables.amulets.filter(func(x): return x.required_for_destruction)
		win_label.text = "[center]You [color=#c33c40][wave]destroyed[/wave][/color] the time machine!!![/center]"
	for amulet in escape_amulets:
		spawn_amulet(amulet)

func spawn_amulet(amulet):
	var amulet_representation = amulet_prefab.instantiate()
	amulet_representation.texture = amulet.texture
	amulet_representation.custom_minimum_size = Vector2(32, 32)
	amulet_representation.tooltip_text = amulet.name.to_upper() + "\n" + amulet.description


func _on_progress_button_pressed():
	GlobalFunctions.load_menu("progress", false)


func _on_main_menu_button_pressed():
	Client.active = false
	GlobalFunctions.load_menu("main", true, true)


func _on_rich_text_label_ready():
	if GlobalVariables.player_new_amulets.size() > 0:
		new_amulet_count_label.append_text('[center]Progress [/center][color="#c57835"][font_size=16][shake rate=5 level=10](' + str(GlobalVariables.player_new_amulets.size()) + ' New!)[/shake][/font_size][/color]')
	else:
		new_amulet_count_label.append_text("[center]Progress[/center]")
