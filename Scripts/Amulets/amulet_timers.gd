class_name AmuletTimers
extends Node

@export var amulet_timer_prefab: PackedScene
@export var weapon: Weapon

var shooting_weapon_timer : Timer

var timers := {}

func _ready():
	GlobalVariables.game_state_changed.connect(_state_changed)
	
	for amulet_id in GlobalVariables.player_amulets:
		if GlobalVariables.amulets[amulet_id].has_timer:
			var amulet_timer_representation = amulet_timer_prefab.instantiate()
			amulet_timer_representation.name = str(amulet_id) + "timer"
			amulet_timer_representation.wait_time = GlobalVariables.amulets[amulet_id].timer_reload
			
			
			if GlobalVariables.amulets[amulet_id].is_weapon and GlobalVariables.amulets[amulet_id].weapon:
				if GlobalVariables.amulets[amulet_id].weapon.active:
					weapon.current_weapon_type_id = GlobalVariables.amulets[amulet_id].weapon.id + 1
					weapon.shooting_weapon_timer = amulet_timer_representation
					amulet_timer_representation.timeout.connect(weapon.on_active_weapon)
					
				else:
					amulet_timer_representation.autostart = true
					amulet_timer_representation.set_one_shot(false)
					amulet_timer_representation.timeout.connect(weapon.on_passive_weapon.bind(GlobalVariables.amulets[amulet_id].weapon))
					
			timers[amulet_id] = amulet_timer_representation
			add_child(amulet_timer_representation)
			amulet_timer_representation.paused = true
			
func _state_changed(is_on):
	if !is_on:
		for t in timers:
			timers[t].paused = true
	else:
		for t in timers:
			timers[t].paused = false
