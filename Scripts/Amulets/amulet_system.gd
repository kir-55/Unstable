extends Node

@export var amulet_icon_template: PackedScene

@onready var amulets_panel: Container = get_tree().root.get_child(4).amulets_panel

@export var amulet_timers: AmuletTimers
@export var amulet_timer_bar: PackedScene

@export var effects_animator: AnimationPlayer

var amulets_displayed = false

@export var amulets_available = GlobalVariables.player_amulets

@export_group("amulets variables")

@export_category("some plant")
@export var dash_duration_increase: float = 0.05
@export var dash_speed_increase: float = 50
@export var dash_cooldown_increase: float = 0.05
@export var drop_throgh_speed_increase: float = 100

@export var trail_color = Color("#eff37c")

func use_amulet(event: InputEvent, amulet_id: int):
	if event is InputEventMouseButton and event.pressed:
		if amulet_id == 8:
			Engine.time_scale = 0.5

		if amulet_id == 4:
			effects_animator.play("immunity")

		if GlobalVariables.amulets[amulet_id].sound:
			var instance = GlobalVariables.amulets[amulet_id].sound.instantiate()
			get_tree().current_scene.add_child(instance)
		
		if amulet_id == 6:
			for tm in amulet_timers.timers:
				amulet_timers.timers[tm].start(amulet_timers.timers[tm].wait_time / 2)
		
		if amulet_id == 16:
			pass

		remove_amulet(amulet_id)

func display_amulets():
	if !Client.active or get_parent().is_multiplayer_authority():
		print("displaying: " + str(amulets_available))
		var unique_amulets = {}

		for item in amulets_available:
			if item in unique_amulets:
				unique_amulets[item] += 1
			else:
				unique_amulets[item] = 1

		for amulet_in_panel in amulets_panel.get_children():
			amulet_in_panel.queue_free()

		for amulet_id in unique_amulets.keys():
			var amulet_representation = amulet_icon_template.instantiate()
			amulet_representation.texture = GlobalVariables.amulets[amulet_id].texture
			amulet_representation.tooltip_text = GlobalVariables.amulets[amulet_id].name.to_upper() + "\n" + GlobalVariables.amulets[amulet_id].description
			if unique_amulets[amulet_id] > 1:
				amulet_representation.get_child(0).text = str(unique_amulets[amulet_id]) + "X"
			if GlobalVariables.amulets[amulet_id].consumable == true:
				amulet_representation.gui_input.connect(use_amulet.bind(amulet_id))
			if GlobalVariables.amulets[amulet_id].has_timer:
				var amulet_timer_bar_representation = amulet_timer_bar.instantiate()
				amulet_timer_bar_representation.amulet_timer = amulet_timers.timers[amulet_id]
				amulet_representation.add_child(amulet_timer_bar_representation)
			amulets_panel.add_child(amulet_representation)
		amulets_displayed = true

func _ready():
	display_amulets()

func _process(delta):
	if !amulets_displayed and amulets_panel:
		display_amulets()

func attach_amulet(id):
	amulets_available.append(id)
	var amulet_representation = amulet_icon_template.instantiate()
	amulet_representation.texture = GlobalVariables.amulets[id].texture
	amulet_representation.tooltip_text = GlobalVariables.amulets[id].name.to_upper() + "\n" + GlobalVariables.amulets[id].description
	amulets_panel.add_child(amulet_representation)

func remove_amulet(id):
	if amulets_available.size() > 0:
		var index = amulets_available.find(id)
		if index >= 0 and index < amulets_available.size() and amulets_available[index] == id:
			amulets_available.remove_at(index)
		else:
			print("ID not found in the array.")
		amulets_displayed = false
