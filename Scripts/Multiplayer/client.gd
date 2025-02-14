extends Node



var game_scene: String = "res://Scenes/Locations/city.tscn"

#@export var player_prefab: PackedScene
const DEFAULT_PORT = 12345
const MAX_CLIENTS = 32
const ADDRESS = "129.159.255.167"#"firegame.pl" #"127.0.0.1"
const LOCAL_ADDRESS = "127.0.0.1"
const LOBBY_ID_LENGHT = 3
const LOBBY_ID_SYMBOLS = "abcdefghijklmnopqrstuvwxyz1234567890"
const DELETE_LOBBY_AFTER = 3 #measured in hours

var players = {}

var active = false

# Votes for events
var start_game_vote = 0
var voted_to_start_game = false

var leave_home_vote = 0
var voted_to_leave_home = false

enum MessageTypes{
	ID,
	JOIN,
	USER_CONNECTED,
	USER_DISCONNECTED,
	LOBBY,
	REMOVE_LOBBY,
	CANDIDATE,
	OFFER,
	ANSWER,
	CHECK_IN
}


var is_active = false

var peer = WebSocketMultiplayerPeer.new()
var rtc_peer = WebRTCMultiplayerPeer.new()

var id: int = 0
var host_id: int = 0
var lobby_id: String

var player_name: String


func connect_to_server():
	peer.create_client("ws://" + ADDRESS +":" + str(DEFAULT_PORT))
	print("CLIENT: STARTED")


func _ready():
	multiplayer.connected_to_server.connect(rtc_server_connected) 
	multiplayer.peer_connected.connect(rtc_peer_connected) 
	multiplayer.peer_disconnected.connect(rtc_peer_disconnected) 
	
	


	
func rtc_server_connected():
	print("RTC server connected ")


func rtc_peer_connected(id):
	print("RTC peer connected " + str(id))


func rtc_peer_disconnected(id):
	print("RTC peer disonnected " + str(id))


func _process(delta):
	peer.poll()
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
			elif data.message_type == MessageTypes.LOBBY:
				players = data.players
				lobby_id = data.lobby_id
				host_id = data.host
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


func create_peer(id):
	if id != self.id:
		var peer := WebRTCPeerConnection.new()
		peer.initialize({
			"iceServers" : [{"urls":["stun:stun.l.google.com:19302"]}]
		})
		print("CLIENT(" + str(self.id) + "): binding id " + str(id))
		
		peer.session_description_created.connect(_on_offer_created.bind(id))
		peer.ice_candidate_created.connect(_on_ice_candidate_created.bind(id))
		rtc_peer.add_peer(peer, id)
		if id < rtc_peer.get_unique_id():
			peer.create_offer()


func send_to_server(message):
	var message_bytes = JSON.stringify(message).to_utf8_buffer()
	# replace with direct to server
	peer.put_packet(message_bytes)


func send_offer(id, data):
	var message = {
		"message_type" : MessageTypes.OFFER,
		"id" : id,
		"org_peer" : self.id,
		"data": data,
		"lobby": lobby_id
	}
	send_to_server(message)


func send_answer(id, data):
	var message = {
		"message_type" : MessageTypes.ANSWER,
		"id" : id,
		"org_peer" : self.id,
		"data": data,
		"lobby": lobby_id
	}
	send_to_server(message)


func _on_offer_created(type, data, id):
	if !rtc_peer.has_peer(id):
		return
	
	rtc_peer.get_peer(id).connection.set_local_description(type, data)
	
	if type == "offer":
		send_offer(id, data)
	else:
		send_answer(id, data)


func _on_ice_candidate_created(mid_name, index_name, sdp_name, id):
	var message = {
		"message_type" : MessageTypes.CANDIDATE,
		"id" : id,
		"org_peer" : self.id,
		"mid" : mid_name,
		"index" : index_name,
		"sdp" : sdp_name,
		"lobby" : lobby_id
	}
	send_to_server(message)




func join_lobby(nickname: String, lobby_id: String):
	player_name = nickname
	
	var message = {
		"message_type" : MessageTypes.LOBBY,
		"id" : id,
		"name" : nickname,
		"lobby_id" : lobby_id
	}
	send_to_server(message)


@rpc("any_peer", "call_local")
func start_game(id):
	if id != self.id or !voted_to_start_game:
		if id == self.id:
			voted_to_start_game = true
		start_game_vote += 1
		
	if start_game_vote >= players.size():
		start_game_vote=0
		voted_to_start_game = false
		
		var message = {
			"message_type" : MessageTypes.REMOVE_LOBBY,
			"lobby_id" : lobby_id
		}
		send_to_server(message)
		get_tree().change_scene_to_file(game_scene)


@rpc("any_peer", "call_local")
func leave_home(id):
	if id != self.id or !voted_to_leave_home:
		if id == self.id:
			voted_to_leave_home = true
		leave_home_vote += 1
		
	if leave_home_vote >= players.size():
		leave_home_vote=0
		voted_to_leave_home = false
		get_tree().change_scene_to_file("res://Scenes/age_travel_machine.tscn")
