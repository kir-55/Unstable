extends Node

@export var amulet_icon_template: PackedScene
var amulets_panel: Container

var amulets_displayerd = false

@export var amulets_list: Array[Amulet] = []
 
@export var amulets_avaliable: Array[int] = []


func _ready():
	if amulets_panel:
		for amulet_id in amulets_avaliable:
			var amulet_representation = amulet_icon_template.instantiate()
			amulet_representation.texture = amulets_list[amulet_id].texture
			amulet_representation.tooltip_text = amulets_list[amulet_id].name.to_upper() + "\n" +  amulets_list[amulet_id].description 
			amulets_panel.add_child(amulet_representation)
			amulets_displayerd = true

func _process(delta):
	if !amulets_displayerd and amulets_panel:
		for amulet_id in amulets_avaliable:
			var amulet_representation = amulet_icon_template.instantiate()
			amulet_representation.texture = amulets_list[amulet_id].texture
			amulet_representation.tooltip_text = amulets_list[amulet_id].name.to_upper() + "\n" +  amulets_list[amulet_id].description 
			amulets_panel.add_child(amulet_representation)
			amulets_displayerd = true
			
func atach_amulet(id):
	amulets_avaliable.append(id)
	var amulet_representation = amulet_icon_template.instantiate()
	amulet_representation.texture = amulets_list[id].texture
	amulet_representation.tooltip_text = amulets_list[id].name.to_upper() + "\n" +  amulets_list[id].description 
	amulets_panel.add_child(amulet_representation)
