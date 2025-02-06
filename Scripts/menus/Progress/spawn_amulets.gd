extends GridContainer

@export var amulet_prefab: PackedScene
@export var not_found_amulet_texture : Texture
@export var new_amulet_outline : PackedScene

func _ready():
	GlobalVariables.player_amulet_collection.sort()
	
	for amulet_id in GlobalVariables.amulets.size():
		if GlobalVariables.player_amulet_collection.has(amulet_id):
			spawn_amulet(GlobalVariables.amulets[amulet_id])
		else:
			var amulet_representation = amulet_prefab.instantiate()
			amulet_representation.texture = not_found_amulet_texture
			amulet_representation.tooltip_text = "???\n" +  "This amulet has not been found yet..."
			add_child(amulet_representation)

func spawn_amulet(amulet):
	var amulet_representation = amulet_prefab.instantiate()
	amulet_representation.texture = amulet.texture
	amulet_representation.tooltip_text = amulet.name.to_upper() + "\n" +  amulet.description
	if amulet.id in GlobalVariables.player_new_amulets:
		amulet_representation.add_child(new_amulet_outline.instantiate()) 
	add_child(amulet_representation)
