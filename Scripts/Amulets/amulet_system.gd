extends Node

@export var amulet_icon_template: PackedScene
var amulets_panel: Container

var amulets_displayed = false

@export var amulets_list: Array[Amulet] = []
 
@export var amulets_available: Array[int] = []

@export_group("amulets variables")

@export_category("some plant")
@export var dash_duration_increase: float = 0.05
@export var dash_speed_increase: float = 50
@export var dash_cooldown_increase: float = 0.05
@export var drop_throgh_speed_increase: float = 100

@export var trail_color = Color("#eff37c")

func _ready():
	if amulets_panel:
		display_amulets()

func display_amulets():
	var unique_amulets = {}
	
	# Add array elements as keys to the dictionary
	for item in amulets_available:
		if item in unique_amulets:
			unique_amulets[item] += 1
		else:
			unique_amulets[item] = 1
		
	for amulet_in_panel in amulets_panel.get_children():
		amulet_in_panel.queue_free()
		
	for amulet_id in unique_amulets.keys():
		var amulet_representation = amulet_icon_template.instantiate()
		amulet_representation.texture = amulets_list[amulet_id].texture
		amulet_representation.tooltip_text = amulets_list[amulet_id].name.to_upper() + "\n" +  amulets_list[amulet_id].description
		if unique_amulets[amulet_id] > 1:
			amulet_representation.get_child(0).text = str(unique_amulets[amulet_id]) + "X"
		amulets_panel.add_child(amulet_representation)
	amulets_displayed = true

func _process(delta):
	if !amulets_displayed and amulets_panel:
		display_amulets()
			
func atach_amulet(id):
	amulets_available.append(id)
	var amulet_representation = amulet_icon_template.instantiate()
	amulet_representation.texture = amulets_list[id].texture
	amulet_representation.tooltip_text = amulets_list[id].name.to_upper() + "\n" +  amulets_list[id].description 
	amulets_panel.add_child(amulet_representation)
	
func remove_amulet(id):
	if amulets_available.size() > 0:
		var index = amulets_available.find(id)	
		# Check if the id was found
		if index >= 0 and index < amulets_available.size() and amulets_available[index] == id:
			amulets_available.remove_at(index)
			#GlobalVariables.player_amulets.remove_at(index)
		else:
			print("ID not found in the array.")
		amulets_displayed = false
