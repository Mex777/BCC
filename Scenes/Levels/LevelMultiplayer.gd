extends Node2D

var playerScene = preload("res://Scenes/Aurora/Aurora.tscn")
var finals = false

var camera_limits = [
	[130, 0, 940, 570],
	[112, 1410, 2350, 557],
	[790, 740, 1680, 1230]
]

func _ready():
	$TopUI/ColorRect/Spectators.text = " Spectators:\n"
	if multiplayer.is_server() == false:
		return
		
	var index = 0
	for player in MultiplayerManager.Players:
		add_player_to_arena.rpc(player, index)
		index += 1
	
	start_round.rpc()
		

@rpc("any_peer", "call_local")
func add_player_to_arena(player, index):
	var curr_player = playerScene.instantiate()
	curr_player.name = str(player)
	#add_child(curr_player)
	var curr_arena = int(index / 2)
	get_node("Arena" + str(curr_arena) + "/Players").add_child(curr_player)
	curr_player.global_position = get_tree().get_nodes_in_group("spawn")[index].global_position
	curr_player.camera.limit_left = camera_limits[curr_arena][1]
	curr_player.camera.limit_right = camera_limits[curr_arena][2]
	curr_player.camera.limit_top = camera_limits[curr_arena][0]
	curr_player.camera.limit_bottom = camera_limits[curr_arena][3]
	


@rpc("call_local", "any_peer")
func move_in_finals(player_id, index):
	var spawn = get_node("/root/LevelMultiplayer/Arena2/SpawnLocations/" + str(index))
	var player = null
	for curr in get_tree().get_nodes_in_group("Player"):
		if curr.name == str(player_id):
			player = curr
			break
	player.global_position = spawn.global_position
	player.camera.limit_left = camera_limits[2][1]
	player.camera.limit_right = camera_limits[2][2]
	player.camera.limit_top = camera_limits[2][0]
	player.camera.limit_bottom = camera_limits[2][3]


@rpc("call_local", "any_peer")
func move_spectator(id, arena = 2):
	if str(multiplayer.get_unique_id()) == str(id):
		$TopUI.hide()
		var camera = get_node("/root/LevelMultiplayer/Arena" + str(arena) + "/Camera" + str(arena))
		camera.enabled = true
		camera.make_current()


@rpc("call_local", "any_peer")
func winner_label(player_name, arena):
	var label = get_node("/root/LevelMultiplayer/Arena" + str(arena) + "/Camera" + str(arena) + "/Label")
	if arena < 2:
		label.text = "ARENA " + str(arena + 1) + "\nWINNER " + player_name
	else:
		label.text = "FINALS\nWINNER " + player_name
	

func _process(float):
	var minutes = int($GameTime.time_left) / 60
	var seconds = int($GameTime.time_left) % 60
	if seconds < 10:
		seconds = "0" + str(seconds)
	else:
		seconds = str(seconds)
		
	$TopUI/TimeLeft.text = "0" + str(minutes) + ":" + seconds
	
	if multiplayer.is_server() == false:
		return
		
	var val = " Spectators:\n"
	for player_id in MultiplayerManager.losers:
		val += "  • " + MultiplayerManager.Players[player_id.to_int()].name + "\n"
	update_spectators.rpc(val)	
	
	if finals == true:
		var players_arena = get_tree().get_nodes_in_group("Player")
		if len(players_arena) == 1:
			var player_name = MultiplayerManager.Players[players_arena[0].name.to_int()].name
			winner_label.rpc(player_name, 2)
			show_game_end.rpc(player_name)
		
		for i in range(len(MultiplayerManager.losers)):
			move_spectator.rpc(MultiplayerManager.losers[i])
		return
		
	var arenas = get_tree().get_nodes_in_group("arena")
	if MultiplayerManager.ended[0] == false:
		var players_arena0 = arenas[0].find_child("Players").get_children()
		if len(players_arena0) == 1:
			MultiplayerManager.ended[0] = true
			MultiplayerManager.winners.append(players_arena0[0].name)
			var player_name = MultiplayerManager.Players[players_arena0[0].name.to_int()].name
			winner_label.rpc(player_name, 0)
		if len(players_arena0) == 0:
			MultiplayerManager.ended[0] = true
		for i in range(len(MultiplayerManager.losers)):
			move_spectator.rpc(MultiplayerManager.losers[i], 0)
	
	if MultiplayerManager.ended[1] == false:
		var players_arena1 = arenas[1].find_child("Players").get_children()
		if len(players_arena1) == 1:
			MultiplayerManager.ended[1] = true
			MultiplayerManager.winners.append(players_arena1[0].name)
			var player_name = MultiplayerManager.Players[players_arena1[0].name.to_int()].name
			winner_label.rpc(player_name, 1)
		if len(players_arena1) == 0:
			MultiplayerManager.ended[1] = true
		for i in range(len(MultiplayerManager.losers)):
			move_spectator.rpc(MultiplayerManager.losers[i], 1)
	
	if MultiplayerManager.ended[0] and MultiplayerManager.ended[1]:
		move_players_to_finals()

		

@rpc("any_peer", "call_local")
func send_hp():
	receive_hp.rpc_id(1, multiplayer.get_unique_id(), Player.get_hp())
	

@rpc("any_peer", "call_local")
func receive_hp(id, hp):
	if multiplayer.is_server() == false:
		return
	MultiplayerManager.Players[id].hp = hp

func _on_game_time_timeout():
	if multiplayer.is_server() == false:
		return
		
	send_hp.rpc()
	var arenas = get_tree().get_nodes_in_group("arena")
	
	if finals:
		var players_arena2 = get_tree().get_nodes_in_group("Player")
		if len(players_arena2) == 2:
			players_arena2.sort_custom(func(a, b): 
				return MultiplayerManager.Players[a.name.to_int()].hp > MultiplayerManager.Players[b.name.to_int()].hp
			)
			players_arena2[1].queue_free_rpc.rpc(players_arena2[1].name)
			MultiplayerManager.winners.append(players_arena2[0].name)
		
		var player_name = MultiplayerManager.Players[players_arena2[0].name.to_int()].name
		winner_label.rpc(player_name, 2)
		show_game_end.rpc(player_name)
		
		for i in range(len(MultiplayerManager.losers)):
			move_spectator.rpc(MultiplayerManager.losers[i])
		return
	
	var players_arena0 = arenas[0].find_child("Players").get_children()
	if len(players_arena0) == 2:
		players_arena0.sort_custom(func(a, b): 
			return MultiplayerManager.Players[a.name.to_int()].hp > MultiplayerManager.Players[b.name.to_int()].hp
		)
		players_arena0[1].queue_free_rpc.rpc(players_arena0[1].name)
		MultiplayerManager.winners.append(players_arena0[0].name)
	
	var players_arena1 = arenas[1].find_child("Players").get_children()
	if len(players_arena1) == 2:
		players_arena1.sort_custom(func(a, b): 
			return MultiplayerManager.Players[a.name.to_int()].hp > MultiplayerManager.Players[b.name.to_int()].hp
		)
		players_arena1[1].queue_free_rpc.rpc(players_arena1[1].name)
		MultiplayerManager.winners.append(players_arena1[0].name)
	
	move_players_to_finals()
	
func move_players_to_finals():
	if multiplayer.is_server() == false:
		return
	for i in range(len(MultiplayerManager.winners)):
		move_in_finals.rpc(MultiplayerManager.winners[i], i + 4)
	
	for i in range(len(MultiplayerManager.losers)):
		move_spectator.rpc(MultiplayerManager.losers[i])
		
	finals = true
	start_round.rpc()


func _on_start_timer_timeout():
	$OnScreenTimer.hide()
	$GameTime.start()
	MultiplayerManager.freeze = false


@rpc("call_local", "any_peer")	
func start_round():
	MultiplayerManager.freeze = true
	$StartTimer.start()
	$OnScreenTimer.show()


@rpc("call_local", "any_peer")
func update_spectators(val):
	$TopUI/ColorRect/Spectators.text = val


@rpc("call_local", 'any_peer')
func show_game_end(player_name):
	$GameFinished.show()
	$GameFinished/Winner.text = "GAME ENDED\n" + player_name + " WON!"


func _on_back_btn_pressed():
	get_tree().quit()
	return
	var scene = load("res://Scenes/MainMenu/MainMenu.tscn").instantiate()
	get_tree().root.add_child(scene)
	get_node("/root/MultiplayerScene").queue_free()
	queue_free()
	if multiplayer.is_server():
		for peer_id in multiplayer.get_peers():
			multiplayer.multiplayer_peer.disconnect_peer(peer_id)
		multiplayer.multiplayer_peer = null
		MultiplayerManager.Players = {}
		MultiplayerManager.winners = []
		MultiplayerManager.losers = []
		
		print("Server closed")
	else:
		multiplayer.multiplayer_peer.disconnect_peer(multiplayer.get_unique_id())
