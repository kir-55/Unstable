extends Node2D


@export var label: Label
@export var displayed_amulets_container: HBoxContainer
@export var canvas_layer: CanvasLayer
@export var texture_rect: TextureRect
@export var win_menu_scene: PackedScene

@export var to_delete_when_won: Array[Node]



var amulets_chosen: Array[int]

var amount_of_items_to_take: int = GlobalVariables.player_amulets.count(2) + 1
var win_type := GlobalEnums.WIN_TYPES.NONE



@export var amulet_prefab: PackedScene


@export var amulets_displayed: Array[int]

var label_with: int = 0

func _ready():
	label_with = label.size.x
	label.size.x = 0
	
	if !Client.active:
		check_for_win()
		
	if !Client.active or Client.players_alive.has(Client.id):
		if GlobalVariables.player_amulets.has(7):
			texture_rect.texture = GlobalVariables.epochs[GlobalVariables.next_epoch_id].baner

		label.text = "You have a few seconds to grab " + str(amount_of_items_to_take) + " item" + ("s." if amount_of_items_to_take > 1 else ".")
		var multiplied_amulets_list: Array[Amulet]
		for amulet in GlobalVariables.amulets:
			if (!Client.active and amulet.available_in_singleplayer) or (Client.active and amulet.available_in_multiplayer):
				for i in range(amulet.chance_multiplier):
					multiplied_amulets_list.append(amulet)
			
		
		
		for i in range(GlobalVariables.items_in_home):

			var random_amulet = multiplied_amulets_list.pick_random()

			while !can_be_generated(random_amulet.id):
				while multiplied_amulets_list.has(random_amulet):
					multiplied_amulets_list.erase(random_amulet)
				random_amulet = multiplied_amulets_list.pick_random()

			amulets_displayed.append(random_amulet.id)
			spawn_amulet(random_amulet)
	else:
		label.text = "(You are dead) other players choose amulets!"


func _process(delta):
	if is_instance_valid(label) and label.size.x < label_with:
		label.size.x += 10


func check_for_win():
	
	if !Client.active:
		var amulets_required_for_repair = GlobalVariables.amulets.filter(func(x): return x.required_for_repair).map(func(x): return x.id)
		var amulets_required_for_destruction = GlobalVariables.amulets.filter(func(x): return x.required_for_destruction).map(func(x): return x.id)
		if amulets_required_for_repair.all(func(x): return x in GlobalVariables.player_amulets):
			print("you won by repair")
			GlobalFunctions.load_menu("win", false, false, Callable(self, "menu_instance_repair_callable"))
			# repair - call the repair menu, run the repair animation

		elif amulets_required_for_destruction.size() > 0 and amulets_required_for_destruction.all(func(x): return x in GlobalVariables.player_amulets):
			# destruction - call the destruction menu, run the destruction animation
			GlobalFunctions.load_menu("win", false, false, Callable(self, "menu_instance_destruction_callable"))
			print("you won by destruction")
		else:
			return

		for n in to_delete_when_won:
			n.queue_free()

func menu_instance_repair_callable(menu):
	menu.win_type = GlobalEnums.WIN_TYPES.REPAIR

func menu_instance_destruction_callable(menu):
	menu.win_type = GlobalEnums.WIN_TYPES.DESTRUCTION


func are_amulets_compatible(amulet1_id: int, amulet2_id: int):
	if GlobalVariables.amulets[amulet1_id].incompatible_amulets.has(amulet2_id) or GlobalVariables.amulets[amulet2_id].incompatible_amulets.has(amulet1_id):
		return false
	else:
		return true

func can_be_generated(amulet_id: int):
	if amount_of_items_to_take > 1:
		# used combined array to avoid checking the same id twice in function: are_amulets_compatible(id ,amulet_id)
		var combined_id_arrays := GlobalVariables.player_amulets + amulets_displayed

		for i in combined_id_arrays:
			while combined_id_arrays.has(i):
				combined_id_arrays.erase(i)
			combined_id_arrays.append(i)

		for id in combined_id_arrays:
			if !are_amulets_compatible(id, amulet_id):
				return false
	else:
		for id in GlobalVariables.player_amulets:
			if !are_amulets_compatible(id, amulet_id):
				return false

	if !GlobalVariables.amulets[amulet_id].stack_limit:
		return true
	elif GlobalVariables.amulets[amulet_id].limit > GlobalVariables.player_amulets.count(amulet_id) + amulets_displayed.count(amulet_id):
		return true
	else:
		return false

func spawn_amulet(amulet):
	var amulet_representation = amulet_prefab.instantiate()
	amulet_representation.texture = amulet.texture
	amulet_representation.tooltip_text = amulet.name.to_upper() + "\n" + amulet.description
	amulet_representation.gui_input.connect(chosed_amulet.bind([amulet.id, amulet_representation]))
	displayed_amulets_container.add_child(amulet_representation)

func chosed_amulet(event: InputEvent, amulet):
	if !Client.active or Client.players_alive.has(Client.id):
		if event is InputEventMouseButton and event.pressed and amulets_chosen.size() < amount_of_items_to_take:
			if amulet[0] == 2:
				GlobalVariables.player_global_speed += 100
				GlobalVariables.items_in_home += 1
			#if amulet[0] == 4:
				#GlobalVariables.player_global_speed -= 100
				#GlobalVariables.initial_chance_for_lag -= 10
			amulets_chosen.append(amulet[0])

			if amount_of_items_to_take -amulets_chosen.size() <= 0 and Client.active:
				label.text = "Wait for other players!"
			else:
				label.text = "You have a few seconds to grab " + str(amount_of_items_to_take -amulets_chosen.size()) + " item" + ("s." if amount_of_items_to_take -amulets_chosen.size() > 1 else ".")


			amulet[1].queue_free()

			if !GlobalVariables.player_amulets.has(2) or amulets_chosen.size() >= amount_of_items_to_take:
				grab_and_leave()
			elif !Client.active:
				check_for_win()

func grab_and_leave():
	if !Client.active or Client.players_alive.has(Client.id):
		GlobalVariables.player_amulets.append_array(amulets_chosen)
		for i in GlobalVariables.player_amulets:
			if ! (i in GlobalVariables.player_amulet_collection):
				GlobalVariables.player_new_amulets.append(i)
				GlobalVariables.player_amulet_collection.append(i)
		Client.leave_home.rpc(Client.id)

