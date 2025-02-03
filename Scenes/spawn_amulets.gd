extends HBoxContainer



@export var label: Label

var amulets_chosen: Array[int]

var amount_of_items_to_take: int = GlobalVariables.player_amulets.count(1) + 1



@export var amulet_prefab: PackedScene
@export var amulets_list: Array[Amulet]



func _ready():
	label.text = "You have a few seconds to grab " + str(amount_of_items_to_take) + " item" + ("s." if amount_of_items_to_take > 1  else ".")
	var one_per_player_amulets : Array[Amulet]
	for i in amulets_list:
		if i.one_per_player == true:
			one_per_player_amulets.append(i)
	var spawned_amulets_ids : Array[int]
	
	for i in range(GlobalVariables.items_in_home):
		if(one_per_player_amulets.size() == amulets_list.size()):
			spawn_amulet(amulets_list.pick_random())
			continue
			
		var random_amulet = amulets_list.pick_random()
		#var does_player_have_all_one_amulets = one_per_player_amulets.all(func(amulet): return amulet.id in GlobalVariables.player_amulets)
		#var all_one_per_player_amulets_spawned = one_per_player_amulets.all(func(amulet): return spawned_amulets_ids.has(amulet.id))
		if random_amulet.one_per_player and is_generating_one_per_player_amulet_possible(spawned_amulets_ids, one_per_player_amulets):
				while random_amulet.id in spawned_amulets_ids or random_amulet.id in GlobalVariables.player_amulets:
					random_amulet = one_per_player_amulets.pick_random()
		else:
			while random_amulet.one_per_player == true:
				random_amulet = amulets_list.pick_random()
		spawned_amulets_ids.append(random_amulet.id)
		spawn_amulet(random_amulet)

func is_generating_one_per_player_amulet_possible(spawned_amulets_ids, one_per_player_amulets):
	if one_per_player_amulets.all(func(amulet): return amulet.id in GlobalVariables.player_amulets) or one_per_player_amulets.all(func(amulet): return spawned_amulets_ids.has(amulet.id)):
		return false
	
	var combined = spawned_amulets_ids
	for item in GlobalVariables.player_amulets:
		if not combined.has(item):
			combined.append(item)
	if combined.all(func(element): return element in one_per_player_amulets):
		return false
	else:
		return true

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
			GlobalVariables.player_global_speed += 50
			GlobalVariables.items_in_home += 1
		if amulet[0] == 4:
			GlobalVariables.player_global_speed -= 70
			GlobalVariables.initial_chance_for_lag -= 10
		amulets_chosen.append(amulet[0])
		label.text = "You have a few seconds to grab " + str(amount_of_items_to_take-amulets_chosen.size()) + " item" + ("s." if amount_of_items_to_take-amulets_chosen.size() > 1  else ".")
		
		amulet[1].queue_free()
		
		if !GlobalVariables.player_amulets.has(1) or  amulets_chosen.size() >= amount_of_items_to_take:
			grab_and_leave()
			
func grab_and_leave():
	GlobalVariables.player_amulets.append_array(amulets_chosen)
	get_tree().change_scene_to_file("res://Scenes/age_travel_machine.tscn")
