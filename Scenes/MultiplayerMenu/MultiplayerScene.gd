extends Control

@export var Address = "0.0.0.0"
@export var port = 8910
var peer
const MAX_PLAYERS = 4
var player_name

# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	if "--server" in OS.get_cmdline_args():
		hostGame()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Lobby/PlayerCnt.text = str(len(MultiplayerManager.Players)) + " / " + str(MAX_PLAYERS)


# this get called on the server and clients
func peer_connected(id):
	print("Player Connected " + str(id))
	
	
# this get called on the server and clients
func peer_disconnected(id):
	print("Player Disconnected " + str(id))
	MultiplayerManager.Players.erase(id)
	var players = get_tree().get_nodes_in_group("Player")
	for i in players:
		if i.name == str(id):
			i.queue_free()


 #called only from clients
func connected_to_server():
	print("connected To Sever!")
	$Lobby.show()
	SendPlayerInformation.rpc_id(1, name, multiplayer.get_unique_id())

# called only from clients
func connection_failed():
	print("Couldnt Connect")

@rpc("any_peer")
func SendPlayerInformation(name, id):
	if !MultiplayerManager.Players.has(id):
		MultiplayerManager.Players[id] ={
			"name" : name,
			"id" : id,
			"index": len(MultiplayerManager.Players)
		}
	
	if multiplayer.is_server():
		for i in MultiplayerManager.Players:
			SendPlayerInformation.rpc(MultiplayerManager.Players[i].name, i)

@rpc("any_peer","call_local")
func StartGame():
	var scene = load("res://Scenes/Levels/LevelMultiplayer.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()
	
func hostGame():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, MAX_PLAYERS)
	if error != OK:
		print("cannot host: " + error)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting For Players!")
	$Lobby.show()
	
	
func _on_host_button_down():
	hostGame()
	

func _on_start_game_button_down():
	StartGame.rpc()


func _on_create_btn_pressed():
	$CreateLayout.show()


func _on_join_btn_pressed():
	$JoinLayout.show()


func _on_join_lobby_btn_pressed():
	player_name = $JoinLayout/Name.text
	Address = $JoinLayout/IP.text
	peer = ENetMultiplayerPeer.new()
	peer.create_client(Address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)


func _on_create_lobby_btn_pressed():
	player_name = $CreateLayout/Name.text
	hostGame()
	SendPlayerInformation(name, multiplayer.get_unique_id())


func _on_start_game_btn_pressed():
	StartGame.rpc()
