extends Camera2D

@export var speed: float
@export var vertical_speed: float
@export var initial_target: Node
@export var epoch: Epoch
var target = initial_target
var target_id: int

var new_target


@export var max_distance: Vector2
var distance_to_target: Vector2
@export var offsett:= Vector2(400, -130)

func _ready():
	target_id = Client.id

func _enter_tree():
	if !target and get_tree().root.get_child(4).has_signal("player_spawned"):
		get_tree().root.get_child(4).player_spawned.connect(_set_target)

func _set_target(target):
	initial_target = target
	self.target = target 

func _process(delta):
	if target and !target.is_queued_for_deletion():
		if GlobalVariables.game_is_on or epoch.death_animation or !epoch.can_accept_input:
				distance_to_target.x = abs(position.x - target.global_position.x + offsett.x) 
				distance_to_target.y = abs(position.y - target.global_position.y + offsett.y)
				
				if distance_to_target.x > max_distance.x:
					position.x = lerp(position.x, target.global_position.x + offsett.x, delta*speed)
				
				if distance_to_target.y > max_distance.y:
					position.y = lerp(position.y, target.global_position.y + offsett.y, delta*vertical_speed)
		else:
			if Client.active:
				if Client.players_alive.size() <= 1:
					target = initial_target
				elif !target_id or !Client.players_alive.has(target_id):
					target_id = Client.players_alive.pick_random()
					target = get_tree().current_scene.find_child("Player" + str(target_id), true, false)
					
			
			if !target:
				target = initial_target
			else:
				var mouse_offset = (get_viewport().get_mouse_position() - Vector2( get_viewport().size / 2))
				var pos = target.global_position + offsett + lerp(Vector2(), mouse_offset.normalized() * 200, mouse_offset.length() / 1000)
				pos.y = min(pos.y, target.global_position.y + offsett.y - 1)
				global_position = pos
	elif Client.active and Client.players_alive:
			target_id = Client.players_alive.pick_random()
			target = get_tree().current_scene.find_child("Player" + str(target_id), true, false)
		
