extends CanvasItem

# ---- Player color properties ----
@export var skin_color: Color
@export var skin_shadow: Color
@export var ear_color: Color

@export var hair_color: Color
@export var hair_shadow: Color

@export var coat_color: Color
@export var coat_shadow: Color
@export var coat_shadow2: Color

@export var tshirt_color: Color
@export var tshirt_shadow: Color

@export var pocket_color: Color
@export var pocket_color2: Color

@export var pants_light: Color
@export var pants_shadow: Color

@export var shoes_light: Color
@export var shoes_color: Color
@export var shoes_shadow: Color

@export var glasses_color: Color
@export var glasses_frame: Color
@export var glasses_light: Color

@export var mouth_color: Color
@export var hand_color: Color
@export var hand_color_shadow: Color

@export var glasses: bool = false:
	set(value):
		glasses = value
		update_colors()

func _ready():
	update_colors()
	GlobalVariables.on_player_colors_changed.connect(update_colors)

func update_colors():
	if !Client.active or get_parent().is_multiplayer_authority():
		for key in GlobalVariables.player_colors:
			self.set(key, GlobalVariables.player_colors[key])
	
	var original_material := material
	if original_material == null:
		push_error("Target has no material assigned.")
		return

	if original_material is ShaderMaterial:
		var duplicated_material := original_material.duplicate()
		material = duplicated_material

		# Check all uniforms in shader
		var uniform_list = duplicated_material.shader.get_shader_uniform_list()
		var uniform_names = uniform_list.map(func(u): return u.name)

		# Set glasses flag
		if "has_glasses" in uniform_names:
			duplicated_material.set_shader_parameter("has_glasses", glasses)

		# List of all color fields
		var color_keys = [
			"skin_color", "skin_shadow", "ear_color",
			"hair_color", "hair_shadow",
			"coat_color", "coat_shadow", "coat_shadow2",
			"tshirt_color", "tshirt_shadow",
			"pocket_color", "pocket_color2",
			"pants_light", "pants_shadow",
			"shoes_light", "shoes_color", "shoes_shadow",
			"glasses_color", "glasses_frame", "glasses_light", 
			"mouth_color", "hand_color", "hand_color_shadow"
		]

		# Apply each parameter if defined in shader
		for key in color_keys:
			if key in uniform_names:
				duplicated_material.set_shader_parameter(key, get(key))
			else:
				print_debug("Shader does not have parameter: ", key)
	else:
		push_error("Material is not a ShaderMaterial.")
