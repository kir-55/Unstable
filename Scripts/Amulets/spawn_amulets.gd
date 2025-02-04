extends HBoxContainer



@export var label: Label

var amulets_chosen: Array[int]

var amount_of_items_to_take: int = GlobalVariables.player_amulets.count(1) + 1



@export var amulet_prefab: PackedScene
@export var amulets_list: Array[Amulet]


@export var amulets_displayed: Array[int]

func _ready():
	label.text = "You have a few seconds to grab " + str(amount_of_items_to_take) + " item" + ("s." if amount_of_items_to_take > 1  else ".")
	var multiplied_amulets_list : Array[Amulet]
	for i in amulets_list:
		for j in range(i.chance_multiplier):
			multiplied_amulets_list.append(i)
	print(str(multiplied_amulets_list.map(func(amulet): return amulet.id)))
	for i in range(GlobalVariables.items_in_home):
		var random_amulet = multiplied_amulets_list.pick_random()
		
		while !can_be_generated(random_amulet.id):
			while multiplied_amulets_list.has(random_amulet):
				multiplied_amulets_list.erase(random_amulet)
			print(str(multiplied_amulets_list.map(func(amulet): return amulet.id)) + " po usunieciu")
			random_amulet = multiplied_amulets_list.pick_random()
		
		amulets_displayed.append(random_amulet.id)
		spawn_amulet(random_amulet)


		
func can_be_generated(amulet_id: int):
	if !amulets_list[amulet_id].stack_limit:
		return true
	elif amulets_list[amulet_id].limit > GlobalVariables.player_amulets.count(amulet_id) + amulets_displayed.count(amulet_id):
		return true
	else:
		return false

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
			GlobalVariables.player_global_speed += 100
			GlobalVariables.items_in_home += 1
		if amulet[0] == 4:
			GlobalVariables.player_global_speed -= 100
			GlobalVariables.initial_chance_for_lag -= 10
		amulets_chosen.append(amulet[0])
		label.text = "You have a few seconds to grab " + str(amount_of_items_to_take-amulets_chosen.size()) + " item" + ("s." if amount_of_items_to_take-amulets_chosen.size() > 1  else ".")
		
		amulet[1].queue_free()
		
		if !GlobalVariables.player_amulets.has(1) or  amulets_chosen.size() >= amount_of_items_to_take:
			grab_and_leave()
			
func grab_and_leave():
	GlobalVariables.player_amulets.append_array(amulets_chosen)
	get_tree().change_scene_to_file("res://Scenes/age_travel_machine.tscn")
