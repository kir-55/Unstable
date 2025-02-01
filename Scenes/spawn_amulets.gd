extends HBoxContainer



@export var label: Label

var amulets_chosen: Array[int]

var amount_of_items_to_take: int = GlobalVariables.player_amulets.count(1) + 1



@export var amulet_prefab: PackedScene
@export var amulets_list: Array[Amulet]

func _ready():
	label.text = "You have a few seconds to grab " + str(amount_of_items_to_take) + " item" + ("s." if amount_of_items_to_take > 1  else ".")
	for i in range(GlobalVariables.items_in_home):
		spawn_amulet(amulets_list.pick_random())

func spawn_amulet(amulet):
	var amulet_representation = amulet_prefab.instantiate()
	amulet_representation.texture = amulet.texture
	amulet_representation.tooltip_text = amulet.name.to_upper() + "\n" +  amulet.description 
	amulet_representation.gui_input.connect(chosed_amulet.bind([amulet.id, amulet_representation]))
	add_child(amulet_representation)

func chosed_amulet(event: InputEvent, amulet):
	if event is InputEventMouseButton and event.pressed:
		print("amulet clicked " + str(amulet[0]))
		if amulet[0] == 1:
			GlobalVariables.player_global_speed += 20
			if amount_of_items_to_take+1 >= GlobalVariables.items_in_home:
				GlobalVariables.items_in_home += 1
		
		amulets_chosen.append(amulet[0])
		label.text = "You have a few seconds to grab " + str(amount_of_items_to_take-amulets_chosen.size()) + " item" + ("s." if amount_of_items_to_take-amulets_chosen.size() > 1  else ".")
		
		amulet[1].queue_free()
		
		if !GlobalVariables.player_amulets.has(1) or  amulets_chosen.size() >= amount_of_items_to_take:
			grab_and_leave()
			
func grab_and_leave():
	GlobalVariables.player_amulets.append_array(amulets_chosen)
	get_tree().change_scene_to_file("res://Scenes/age_travel_machine.tscn")
