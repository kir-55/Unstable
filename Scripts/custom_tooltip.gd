extends TextureRect

@export var tooltip_prefab: PackedScene
func _make_custom_tooltip(for_text):
	var tooltip = tooltip_prefab.instantiate()
	tooltip.get_child(0).text = for_text
	return tooltip
 
	
