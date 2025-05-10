extends Node





var game_scene: String = "res://Scenes/Locations/epoch.tscn"

#@export var player_prefab: PackedScene
const DEFAULT_PORT = 12345
const MAX_CLIENTS = 32
const ADDRESS = "129.159.255.167"  #"firegame.pl" #"127.0.0.1"
const LOCAL_ADDRESS = "127.0.0.1"
const LOBBY_ID_LENGHT = 3
const LOBBY_ID_SYMBOLS = "abcdefghijklmnopqrstuvwxyz1234567890"
const DELETE_LOBBY_AFTER = 3  #measured in hours

# dictionary with nicknames, id's
var players = {}

# arrays of id's
var players_dead = {}
var players_alive = []
var players_rtc = []
var players_voted_start = []
var players_voted_leave_home = []

var active = false
var is_in_lobby = false

var still_playing = true

var need_to_rejoin: bool = false
var id_to_rejoin: String = ""

enum MessageTypes {
	ID,
	JOIN,
	USER_CONNECTED,
	USER_DISCONNECTED,
	LOBBY,
	REMOVE_LOBBY,
	CANDIDATE,
	OFFER,
	ANSWER,
	CHECK_IN,
	LEAVE_LOBBY,
}

enum EndStates {
	Victory,
	Fail,
	Draw
}


var is_active := false

var has_to_rejoin := false
var queue_to_play_again := false

var peer = WebSocketMultiplayerPeer.new()
var rtc_peer = WebRTCMultiplayerPeer.new()

var id: int = 0
var host_id: int = 0
# if host dies he will be host and he will find reserve host
var reserve_host_id: int = 0

var lobby_id: String
var public_ip: String


var player_name: String = ""


func connect_to_server():
	peer.create_client("ws://" + ADDRESS + ":" + str(DEFAULT_PORT))
	print("CLIENT: STARTED")


func _ready():
	multiplayer.connected_to_server.connect(rtc_server_connected)
	multiplayer.peer_connected.connect(rtc_peer_connected)
	multiplayer.peer_disconnected.connect(rtc_peer_disconnected)



	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed)

	var url = "http://checkip.amazonaws.com"
	var error = http_request.request(url)

	if error != OK:
		print("Failed to make request: ", error)



func rtc_server_connected():
	print("RTC server connected ")


func rtc_peer_connected(id):
	print("RTC peer connected " + str(id))
	players_rtc.append(id)
	if host_id == self.id:
		print("Giveing newly connected peer updated votes")
		update_players.rpc_id(id, players, players_voted_start)
	
	update_players(players)



func rtc_peer_disconnected(disconnected_id):
	print("RTC peer disonnected ", disconnected_id)
	players.erase(str(disconnected_id))
	players_rtc.erase(disconnected_id)
	if players_voted_start.has(disconnected_id):
		players_voted_start.erase(disconnected_id)
	if players_voted_leave_home.has(disconnected_id):
		players_voted_leave_home.erase(disconnected_id)
	update_players(players)
	


var candidate_queues = {}  # Add this at the top of your client script

@rpc("any_peer", "call_local")
func update_players(new_players, players_voted_start = []):
	print()
	print("___ UPDATING PLAYERS (", self.id, ")","[HOST]" if self.id == host_id else ("[RESERVE HOST]" if self.id == reserve_host_id else "") ," ___")
	

			
	if players_voted_start != []:
		print("___ Getting up to date with votes: ", players_voted_start)
		self.players_voted_start = players_voted_start
		
	players = new_players
	var valid_ids = players.keys()

	if players.size() == 0:
		self.players_rtc.clear()
		self.players_dead.clear()
		self.players_alive.clear()
		self.players_voted_start.clear()
		self.players_voted_leave_home.clear()
		return

	players_alive.clear()
	for id in valid_ids:
		players_alive.append(int(id))

	players_dead.clear()
	
	# NOT WORKING
	var arrays_to_clean = [players_rtc, self.players_voted_start]
	for array in arrays_to_clean:
		array = array.filter(func(e): return valid_ids.has(str(e)))
	
	
	if players.size() == 1 and !is_in_lobby:
		reset_multiplayer_connection()
		has_to_rejoin = true
		id_to_rejoin = ""
		return
	
	print("___ players: ", players.keys())
	print("___ players rtc: ", players_rtc)
		

	# HOST REPLACEMENT
	if !players.has(str(host_id)):
		print("___ NO HOST FOUND")
		if self.id == reserve_host_id:
			print("___ TRYING TO REPLACE HOST")
			# reserved host becomes host
			# and finds new reserved host
			if players.size() > 1:
				set_new_host.rpc(self.id, players_rtc.pick_random())

	
	
	if reserve_host_id == 0 or !players.has(str(reserve_host_id)):
		print("___ NO RESERVE FOUND")
		if self.id == host_id:
			print("___ TRYING TO SET RESERVE")
			if players.size() < 2:
				print("___ NOT ENOUGH PLAYERS")
			elif players.size() != players_rtc.size() + 1:
				print("___ NOT ENOUGH RTC PLAYERS")
			else:
				set_new_host.rpc(self.id, players_rtc.pick_random())
		
	if players_alive.size() > 1 and self.players_voted_start.size() == players_alive.size(): 
		#if someone who hasnt voted disconnects 
		start_game.rpc(0) #trying to start game



func _process(delta):
	peer.poll()
	rtc_peer.poll()
	if peer.get_available_packet_count() > 0:
		var packet = peer.get_packet()
		if packet:
			var data_string = packet.get_string_from_utf8()
			var data = JSON.parse_string(data_string)
			#print(data)
			if data.message_type == MessageTypes.ID:
				id = data.id
				connected(id)
				#print("CLIENT: Recieved id: " + str(id))
			elif data.message_type == MessageTypes.USER_CONNECTED:
				create_peer(data.id)
			elif data.message_type == MessageTypes.LEAVE_LOBBY:
				update_players(data.players)
				lobby_id = data.lobby_id
				host_id = data.host
			elif data.message_type == MessageTypes.LOBBY:
				update_players(data.players)
				lobby_id = data.lobby_id
				host_id = data.host

				if queue_to_play_again == true:
					rejoin.rpc(data.lobby_id)
					queue_to_play_again = false
					has_to_rejoin = true
				elif has_to_rejoin:
					has_to_rejoin = false
					rejoin(data.lobby_id)
				GlobalFunctions.load_menu("multiplayer_lobby")

			elif data.message_type == MessageTypes.CANDIDATE:
				if rtc_peer.has_peer(data.org_peer):
					#print("CLIENT(" + str(id) + ") Got candidate: " + str(data.org_peer))
					rtc_peer.get_peer(data.org_peer).connection.add_ice_candidate(data.mid, int(data.index), data.sdp)
			elif data.message_type == MessageTypes.OFFER:
				if rtc_peer.has_peer(data.org_peer):
					rtc_peer.get_peer(data.org_peer).connection.set_remote_description("offer", data.data)
			elif data.message_type == MessageTypes.ANSWER:
				if rtc_peer.has_peer(data.org_peer):
					rtc_peer.get_peer(data.org_peer).connection.set_remote_description("answer", data.data)


func connected(id):
	rtc_peer.create_mesh(id)
	multiplayer.multiplayer_peer = rtc_peer
	if has_to_rejoin:
		join_lobby(id_to_rejoin)
		id_to_rejoin = ""
		has_to_rejoin = false



func create_peer(id):
	if id != self.id:
		var peer := WebRTCPeerConnection.new()
		peer.initialize({
			"iceServers": [
				{"urls": ["stun:stun.l.google.com:19302"]},
				{
					"urls": [
						"turn:global.relay.metered.ca:80?transport=udp"
					],
					"username": "63f31ac8c1461346174ed164",
					"credential": "fr5Bdg0NsoOPxhOz"
				}
			],
			"iceTransportPolicy": "relay"
		})

		# Connect ICE candidate and session events
		peer.ice_candidate_created.connect(_on_ice_candidate_created.bind(id))
		peer.session_description_created.connect(_on_offer_created.bind(id))

		# Periodically check the connection state (since no direct signal exists)
		get_tree().create_timer(1.0).timeout.connect(func():
			var signaling_states = ["stable", "have-local-offer", "have-remote-offer", "have-local-pranswer", "have-remote-pranswer", "closed"]
			var connection_states = ["new", "checking", "connected", "completed", "failed", "disconnected", "closed"]
		)

		rtc_peer.add_peer(peer, id)
		if id < rtc_peer.get_unique_id():
			peer.create_offer()



func send_to_server(message):
	var message_bytes = JSON.stringify(message).to_utf8_buffer()
	peer.put_packet(message_bytes)


func send_offer(id, data):
	var message = {
		"message_type": MessageTypes.OFFER,
		"id": id,
		"org_peer": self.id,
		"data": data,
		"lobby": lobby_id
	}
	send_to_server(message)


func send_answer(id, data):
	var message = {
		"message_type": MessageTypes.ANSWER,
		"id": id,
		"org_peer": self.id,
		"data": data,
		"lobby": lobby_id
	}
	send_to_server(message)


func _on_request_completed(_result, _response_code, _headers, body):
	public_ip = body.get_string_from_utf8()




func _on_offer_created(type, data, id):
	var modified_sdp = data.replace("IN IP4 127.0.0.1", "IN IP4 " + public_ip)
	modified_sdp = modified_sdp.replace("c=IN IP4 0.0.0.0", "c=IN IP4 " + public_ip)
	modified_sdp = modified_sdp.replace("m=application 9 UDP/DTLS/SCTP", "m=application 5000 UDP/DTLS/SCTP")

	if !rtc_peer.has_peer(id):
		return

	rtc_peer.get_peer(id).connection.set_local_description(type, modified_sdp)

	if type == "offer":
		send_offer(id, modified_sdp)
	else:
		send_answer(id, modified_sdp)




func _on_ice_candidate_created(mid_name, index_name, sdp_name, id):
	#print("ICE Candidate for %d: %s" % [id, sdp_name])
	var message = {
		"message_type": MessageTypes.CANDIDATE,
		"id": id,
		"org_peer": self.id,
		"mid": mid_name,
		"index": index_name,
		"sdp": sdp_name,
		"lobby": lobby_id
	}
	send_to_server(message)



func reset_multiplayer_connection():
	if multiplayer.multiplayer_peer:
		multiplayer.multiplayer_peer.close()
		multiplayer.multiplayer_peer = null
		print("Multiplayer connection closed. Resetting connection...")

	peer = WebSocketMultiplayerPeer.new()
	rtc_peer = WebRTCMultiplayerPeer.new()

	# Ensure all peers are removed
	update_players({})

	# Removes all mp sync from scene
	for node in get_tree().get_nodes_in_group("multiplayer_sync"):
		node.queue_free()

	multiplayer.multiplayer_peer = null  # This forces Godot to reinitialize networking
	connect_to_server()

@rpc("any_peer")
func rejoin(lobby_id: String):
	print()
	print("TRYING TO REJOIN")
	print()
	
	has_to_rejoin = true
	id_to_rejoin = lobby_id
	reset_multiplayer_connection()
	update_players({})




func leave_lobby():
	var message = {
		"message_type": MessageTypes.LEAVE_LOBBY,
		"id": id,
		"lobby_id": lobby_id
	}
	send_to_server(message)
	update_players({})
	GlobalFunctions.load_menu("main")
	is_in_lobby = false
	reset_multiplayer_connection()
	Client.active = false



@rpc("any_peer")
func join_lobby(lobby_id: String, nickname: String = ""):
	is_in_lobby = true
	
	update_players({})
	if nickname == "" and player_name != "":
		nickname = player_name
	else:
		player_name = nickname

	var message = {
		"message_type": MessageTypes.LOBBY,
		"id": id,
		"name": nickname,
		"lobby_id": lobby_id
	}
	send_to_server(message)



@rpc("any_peer", "call_local")
func start_game(id: int):
	# id == 0 means this is is just recheck if can start game 
	if id != 0 and !players_voted_start.has(id):
		print("New player voted")
		players_voted_start.append(id)
		print("players_voted_start", players_voted_start)
	
	players_voted_start.sort()
	players_alive.sort()
	
	if players_voted_start == players_alive:
		players_voted_start.clear()
		var message = {
			"message_type": MessageTypes.REMOVE_LOBBY,
			"lobby_id": lobby_id
		}

		still_playing = true
		is_in_lobby = false
		GlobalVariables.last_score = 0
		GlobalVariables.player_global_speed = GlobalVariables.initial_player_speed
		GlobalVariables.game_is_on = true
		GlobalVariables.player_amulets.assign(GlobalVariables.initial_player_amulets.duplicate())
		GlobalVariables.player_new_amulets.clear()
		
		# start epoch is decided by id of last player that hit start
		GlobalVariables.current_epoch_id = id%GlobalVariables.epochs.size()
		# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
		
		GlobalVariables.times_treveled = 0
		GlobalVariables.items_in_home = GlobalVariables.initial_items_in_home
		GlobalVariables.terrain_code = hash(lobby_id)
		GlobalVariables.player_global_speed = GlobalVariables.initial_player_speed
		GlobalVariables.is_in_epoch = true
		
		GlobalFunctions.start_timer()
		send_to_server(message)
		get_tree().change_scene_to_file(game_scene)
	else:
		print("Not enough players to start!")
		print("players alive: ", players_alive)
		print("players voted: ", players_voted_start)

@rpc("any_peer", "call_local")
func spawn(prefab: String, position: Vector2, player_velocity_x: float, speed: float, initial_rotation: float):
	var instance = load(prefab).instantiate()
	instance.global_position = position
	get_tree().current_scene.add_child(instance)

	if instance.has_method("set_velocity"):
		instance.set_velocity(Vector2(player_velocity_x, 0) + Vector2.RIGHT.rotated(initial_rotation) * speed)

	if "rotation" in instance:
		instance.rotation = initial_rotation
	if "speed" in instance:
		instance.speed += speed + player_velocity_x


	return instance

@rpc("any_peer")
func apply_screen_effect(effect_prefab: String, delete_other_effects := false):  #effect_prefab must be a path to TextureRect scene
	var canvas_layer = get_tree().current_scene.canvas_layer
	if !canvas_layer:
		return

	if delete_other_effects:
		for child in canvas_layer.get_children():
			if child is TextureRect:
				child.queue_free()
	var effect_instance = load(effect_prefab).instantiate()
	canvas_layer.add_child(effect_instance)


@rpc("any_peer", "call_local")
func leave_home(id):
	#if new_host_id = :
		#host_id = new_host_id
		#new_host_id = 0

	if !players_voted_leave_home.has(id) and players_alive.has(id):
		players_voted_leave_home.append(id)
		print("NEW PLAYER VOTED: ", players_voted_leave_home)
		
	
	players_voted_leave_home.sort()
	players_alive.sort()
	if players_voted_leave_home == players_alive:
		print("LEAVING HOME, RESETING VOTES")
		print()
		players_voted_leave_home.clear()
		get_tree().change_scene_to_file("res://Scenes/Locations/age_travel_machine.tscn")

@rpc("any_peer", "call_local")
func end_game(result: EndStates):
	GlobalVariables.game_is_on = false

	match result:
		EndStates.Victory:
			GlobalFunctions.load_menu("multiplayer_victory", false)
		EndStates.Fail:
			GlobalFunctions.load_menu("multiplayer_loss", false)
		EndStates.Draw:
			GlobalFunctions.load_menu("multiplayer_draw", false)


@rpc("any_peer", "call_local")
func set_new_host(new_host_id: int, new_reserve_host_id: int):
	print()
	if host_id != new_host_id:
		print("SETTING NEW HOST AND RESERVE IN /// ", Client.id, "  ", Client.player_name ," ///")
		host_id = new_host_id
	else:
		print("SETTING NEW RESERVE IN /// ", Client.id, "  ", Client.player_name ," ///")
		
	reserve_host_id = new_reserve_host_id
	
	print("/// players", Client.players.keys())
	print("/// players rtc:", Client.players_rtc)
	print("/// host_id:", Client.host_id)
	print("/// reserve host:", Client.reserve_host_id)



@rpc("any_peer", "call_local")
func player_died(id: int, name, score, time):
	var player = {
		"id": id,
		"name": name,
		"score": score,
		"time": time
	}

	players_dead[id] = {
		"id": id,
		"name": name,
		"time": time,
		"score": score
	}
	players_alive.erase(id)

	if self.id == host_id and still_playing:  # Only host runs this block
		print("player " + str(id) + " died new players alive:" + str(players_alive))
		if players_alive.size() <= 1:
			# One player left — victory for them
			for player_id in players.keys():
				if players_alive.has(player_id.to_int()):
					# Send victory to the last alive player
					end_game.rpc_id(player_id.to_int(), EndStates.Victory)
				else:
					# Others get a loss screen
					end_game.rpc_id(player_id.to_int(), EndStates.Fail)
			still_playing = false
			print("Victory for one player, loss for others.")
		else:
			# Only one player died (more still alive), just update state
			#end_game.rpc(EndStates.Fail)
			print("One player died, game still on.")

