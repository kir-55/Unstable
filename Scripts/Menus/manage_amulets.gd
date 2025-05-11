extends Control

@export var amulet_icon_scene : PackedScene
@export var label_and_new_amulet_container : HBoxContainer
@export var current_player_amulets_container : HBoxContainer
@export var border_container : Panel

enum ManageTypes {
	REMOVE,
	REPLACE
}

@export var manage_type: ManageTypes

var new_amulet_id = 0
var chosen_amulet_representation = null

func _ready():
	if label_and_new_amulet_container and manage_type == ManageTypes.REPLACE:
		var new_amulet_instance  = amulet_icon_scene.instantiate()
		var new_amulet = GlobalVariables.amulets[new_amulet_id]
		new_amulet_instance.texture = new_amulet.texture
		new_amulet_instance.tooltip_text = new_amulet.name.to_upper() + "\n" + new_amulet.description
		label_and_new_amulet_container.add_child(new_amulet_instance)
		
	if current_player_amulets_container:
		var displayed_amulets : Dictionary
		for amulet_id in GlobalVariables.player_amulets:
			if displayed_amulets.keys().count(amulet_id) > 0:
				displayed_amulets[amulet_id].get_child(0).text = str(str(GlobalVariables.player_amulets.count(amulet_id)) + "X")
			else:
				var amulet_instance = spawn_amulet_with_bind(current_player_amulets_container, amulet_id)
				displayed_amulets[amulet_id] = amulet_instance
		
		border_container.custom_minimum_size = current_player_amulets_container.custom_minimum_size
		border_container.custom_minimum_size.x -= current_player_amulets_container.get_theme_constant("separation")
		current_player_amulets_container.position.x += current_player_amulets_container.get_theme_constant("separation") / 2

func spawn_amulet_with_bind(container: HBoxContainer, amulet_id: int):
	var amulet = GlobalVariables.amulets[amulet_id]
	var amulet_instance = amulet_icon_scene.instantiate()
	amulet_instance.texture = amulet.texture
	amulet_instance.tooltip_text = amulet.name.to_upper() + "\n" + amulet.description
	
	if manage_type == ManageTypes.REPLACE:
		amulet_instance.gui_input.connect(on_amulet_click_swap.bind(amulet_id))
	elif manage_type == ManageTypes.REMOVE:
		amulet_instance.gui_input.connect(on_amulet_click_remove.bind(amulet_id))
	
	var min_size = 120
	var panel = Panel.new()
	var style = StyleBoxFlat.new()
	style.set_border_width_all(2)
	style.border_color = Color(1, 1, 1)
	style.bg_color = Color(0, 0, 0, 0)
	panel.custom_minimum_size = Vector2(min_size, min_size)
	panel.add_theme_stylebox_override("panel", style)

	var center = CenterContainer.new()
	center.custom_minimum_size = Vector2(min_size, min_size)
	current_player_amulets_container.custom_minimum_size.y = min_size
	current_player_amulets_container.custom_minimum_size.x += min_size + current_player_amulets_container.get_theme_constant("separation")
	
	center.add_child(amulet_instance)
	panel.add_child(center)
	container.add_child(panel)
	
	return amulet_instance


func on_amulet_click_swap(event: InputEvent, amulet_id):
	if event is InputEventMouseButton and event.pressed:
		#print(GlobalVariables.player_amulets)
		for i in range(GlobalVariables.player_amulets.size()):
			if GlobalVariables.player_amulets[i] == amulet_id:
				GlobalVariables.player_amulets[i] = new_amulet_id
		var copy_player_amulets = GlobalVariables.player_amulets.duplicate()
		for id in copy_player_amulets:
			if id == new_amulet_id:
				if GlobalVariables.player_amulets.filter(func(id): return id == new_amulet_id).size() > 1:
					GlobalVariables.player_amulets.erase(new_amulet_id)
		#print(GlobalVariables.player_amulets)
		if chosen_amulet_representation:
			chosen_amulet_representation.queue_free()
		get_tree().current_scene.complete_amulet_choice()
		queue_free()
		
		
func on_amulet_click_remove(event: InputEvent, amulet_id):
	if event is InputEventMouseButton and event.pressed:
		GlobalVariables.player_amulets.erase(amulet_id)
		get_tree().current_scene.check_if_can_stay()
		queue_free()




func _on_cancel_pressed():
	var home = get_tree().current_scene
	if chosen_amulet_representation:
		home.amulets_chosen.pop_back()
	queue_free()
