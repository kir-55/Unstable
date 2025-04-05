extends Control

@export var score : RichTextLabel
@export var win_type_label : RichTextLabel
@export var win_type_amulets_label : RichTextLabel
@export var amulet_prefab : PackedScene
@export var new_amulet_count_label : RichTextLabel
@export var amulets_container : GridContainer

var win_type = GlobalEnums.WIN_TYPES.REPAIR

func _ready():
	score.text += str(GlobalVariables.last_score)
	var escape_amulets : Array
	if win_type == GlobalEnums.WIN_TYPES.REPAIR:
		escape_amulets = GlobalVariables.amulets.filter(func(x): return x.required_for_repair)
		win_type_label.text += "REPAIR" + "[/shake][/color][/center]!"
		win_type_amulets_label.text = "[center]Repair amulets:"
	elif win_type == GlobalEnums.WIN_TYPES.DESTRUCTION:
		escape_amulets = GlobalVariables.amulets.filter(func(x): return x.required_for_destruction)
		win_type_label.text += "DESTRUCTION" + "[/shake][/color][/center]!"
		win_type_amulets_label.text = "[center]Destruction amulets:"
	else:
		print("Invalid/NONE Win Type!")
	for amulet in escape_amulets:
		spawn_amulet(amulet)

func spawn_amulet(amulet):
	var amulet_representation = amulet_prefab.instantiate()
	amulet_representation.texture = amulet.texture
	amulet_representation.stretch_mode = 4
	amulet_representation.tooltip_text = amulet.name.to_upper() + "\n" + amulet.description
	amulets_container.add_child(amulet_representation)


func _on_progress_button_pressed():
	GlobalFunctions.load_menu("progress", false)


func _on_main_menu_button_pressed():
	GlobalFunctions.load_menu("main", true, true)


func _on_rich_text_label_ready():
	if GlobalVariables.player_new_amulets.size() > 0:
		new_amulet_count_label.append_text('[center]Progress [/center][color="#c57835"][font_size=16][shake rate=5 level=10](' + str(GlobalVariables.player_new_amulets.size()) + ' New!)[/shake][/font_size][/color]')
	else:
		new_amulet_count_label.append_text("[center]Progress[/center]")
