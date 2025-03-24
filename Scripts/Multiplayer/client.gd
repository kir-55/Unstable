extends Node


var game_scene: String = "res://Scenes/Locations/city.tscn"

#@export var player_prefab: PackedScene
const DEFAULT_PORT = 12345
const MAX_CLIENTS = 32
const ADDRESS = "129.159.255.167"  #"firegame.pl" #"127.0.0.1"
const LOCAL_ADDRESS = "127.0.0.1"
const LOBBY_ID_LENGHT = 3
const LOBBY_ID_SYMBOLS = "abcdefghijklmnopqrstuvwxyz1234567890"
const DELETE_LOBBY_AFTER = 3  #measured in hours

var players = {}
var dead_players = {}

var active = false

# Votes for events
var start_game_vote = 0
var voted_to_start_game = false

var leave_home_vote = 0
var voted_to_leave_home = false

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




var is_active := false

var has_to_rejoin := false
var queue_to_play_again := false

var peer = WebSocketMultiplayerPeer.new()
var rtc_peer = WebRTCMultiplayerPeer.new()

var id: int = 0
var host_id: int = 0
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
	


func rtc_peer_disconnected(id):
	print("RTC peer disonnected " + str(id))


var candidate_queues = {}  # Add this at the top of your client script

func _process(delta):
	peer.poll()
	rtc_peer.poll()
	if peer.get_available_packet_count() > 0:
		var packet = peer.get_packet()
		if packet:
			var data_string = packet.get_string_from_utf8()
			var data = JSON.parse_string(data_string)
			print(data)
			if data.message_type == MessageTypes.ID:
				id = data.id
				connected(id)
				print("CLIENT: Recieved id: " + str(id))
			elif data.message_type == MessageTypes.USER_CONNECTED:
				create_peer(data.id)
			elif data.message_type == MessageTypes.LEAVE_LOBBY:
				players = data.players
				lobby_id = data.lobby_id
				host_id = data.host
			elif data.message_type == MessageTypes.LOBBY:
				players = data.players
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
					print("CLIENT(" + str(id) + ") Got candidate: " + str(data.org_peer))
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
	if id_to_rejoin != "":
		join_lobby(id_to_rejoin)
		id_to_rejoin = ""



func create_peer(id):
	if id != self.id:
		print("CLIENT(" + str(self.id) + "): Creating peer for id " + str(id))

		var peer := WebRTCPeerConnection.new()
		peer.initialize({
			"iceServers": [
				{ "urls": ["stun:stun.l.google.com:19302"] },
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

			print("Peer %d signaling state: %s" % [id, signaling_states[peer.get_signaling_state()]])
			print("Peer %d connection state: %s" % [id, connection_states[peer.get_connection_state()]])

		)

		rtc_peer.add_peer(peer, id)
		if id < rtc_peer.get_unique_id():
			peer.create_offer()



func send_to_server(message):
	var message_bytes = JSON.stringify(message).to_utf8_buffer()
	# replace with direct to server
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
	print("result: " + str(_result))
	print("response code: " + str(_response_code))
	print("hearders: " + str(_headers))
	print("body: " + str(body))
	public_ip = body.get_string_from_utf8()
	print("Public IPv4 Address: ", public_ip)



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
	print("ICE Candidate for %d: %s" % [id, sdp_name])
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
	players.clear()
	dead_players.clear()
	
	# Removes all mp sync from scene
	for node in get_tree().get_nodes_in_group("multiplayer_sync"):
		node.queue_free()
		
	multiplayer.multiplayer_peer = null  # This forces Godot to reinitialize networking
	connect_to_server()

@rpc("any_peer")
func rejoin(lobby_id: String):
	print("trying to rejoin")
	players.clear()
	dead_players.clear()
	id_to_rejoin = lobby_id
	reset_multiplayer_connection()
	
	


func leave_lobby():
	var message = {
		"message_type": MessageTypes.LEAVE_LOBBY,
		"id": id,
		"lobby_id": lobby_id
	}
	send_to_server(message)
	GlobalFunctions.load_menu("main")
	#reset_multiplayer_connection()
	
	

@rpc("any_peer")
func join_lobby(lobby_id: String, nickname: String = ""):
	
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
func start_game(id):
	if id != self.id or !voted_to_start_game:
		if id == self.id:
			voted_to_start_game = true
		start_game_vote += 1

	if start_game_vote >= players.size():
		start_game_vote = 0
		voted_to_start_game = false

		var message = {
			"message_type": MessageTypes.REMOVE_LOBBY,
			"lobby_id": lobby_id
		}
		
		GlobalVariables.game_is_on = true
		GlobalVariables.terrain_code = hash(lobby_id)
		GlobalVariables.player_global_speed = GlobalVariables.initial_player_speed
		GlobalFunctions.start_timer()
		send_to_server(message)
		get_tree().change_scene_to_file(game_scene)


@rpc("any_peer", "call_local")
func leave_home(id):
	if id != self.id or !voted_to_leave_home:
		if id == self.id:
			voted_to_leave_home = true
		leave_home_vote += 1
		
	if leave_home_vote >= players.size() - dead_players.size():
		leave_home_vote = 0
		voted_to_leave_home = false
		get_tree().change_scene_to_file("res://Scenes/age_travel_machine.tscn")



@rpc("any_peer", "call_local")
func player_died(id: int, name, score, time):
	var player = {
		"id": id,
		"name": name,
		"score": score,
		"time": time
	}
	dead_players[id] = player
	
	if dead_players.size() == players.size() - 1:
		if GlobalVariables.game_is_on:
			GlobalVariables.game_is_on = false
			GlobalFunctions.load_menu("multiplayer_victory", false)
		else:
			GlobalFunctions.load_menu("multiplayer_loss", false)
