extends Node2D

var playerScene = preload("res://Scenes/Aurora/Aurora.tscn")
var finals = false


func _ready():
	if multiplayer.is_server() == false:
		return
		
	var index = 0
	for player in MultiplayerManager.Players:
		add_player_to_arena.rpc(player, index)
		index += 1
		

@rpc("any_peer", "call_local")
func add_player_to_arena(player, index):
	var curr_player = playerScene.instantiate()
	curr_player.name = str(player)
	#add_child(curr_player)
	get_node("Arena" + str(int(index / 2)) + "/Players").add_child(curr_player)
	curr_player.global_position = get_tree().get_nodes_in_group("spawn")[index].global_position
	curr_player.camera.limit_left = 0
	curr_player.camera.limit_right = 99999
	curr_player.camera.limit_top = 0
	curr_player.camera.limit_bottom = 99999


@rpc("call_local", "any_peer")
func move_in_finals(player_id, index):
	var spawn = get_node("/root/LevelMultiplayer/Arena2/SpawnLocations/" + str(index))
	var player = null
	for curr in get_tree().get_nodes_in_group("Player"):
		if curr.name == str(player_id):
			player = curr
			break
	player.global_position = spawn.global_position


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
	if finals == true:
		var players_arena = get_tree().get_nodes_in_group("Player")
		if len(players_arena) == 1:
			var player_name = MultiplayerManager.Players[players_arena[0].name.to_int()].name
			winner_label.rpc(player_name, 2)
		
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
	for i in range(len(MultiplayerManager.winners)):
		move_in_finals.rpc(MultiplayerManager.winners[i], i + 4)
	
	for i in range(len(MultiplayerManager.losers)):
		move_spectator.rpc(MultiplayerManager.losers[i])
			
	finals = true
	$GameTime.start()
