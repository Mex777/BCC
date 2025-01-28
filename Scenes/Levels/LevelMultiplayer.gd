extends Node2D

var playerScene = preload("res://Scenes/Aurora/Aurora.tscn")
var finals = false

func _ready():
	var index = 0
	for player in MultiplayerManager.Players:
		var curr_player = playerScene.instantiate()
		curr_player.name = str(player)
		#add_child(curr_player)
		get_node("Arena" + str(int(index / 2)) + "/Players").add_child(curr_player)
		curr_player.global_position = get_tree().get_nodes_in_group("spawn")[index].global_position
		index += 1
		curr_player.camera.limit_left = 0
		curr_player.camera.limit_right = 99999
		curr_player.camera.limit_top = 0
		curr_player.camera.limit_bottom = 99999
	
		
func _process(float):
	if finals == true:
		return
		
	var arenas = get_tree().get_nodes_in_group("arena")

	var players_arena0 = arenas[0].find_child("Players").get_children()
	var players_arena1 = arenas[1].find_child("Players").get_children()
	
	if len(players_arena0) <= 1 and len(players_arena1) <= 1:
		move_winners.rpc()
		
	

@rpc("any_peer", "call_local")
func move_winners():
	if finals:
		return
	finals = true
	var arenas = get_tree().get_nodes_in_group("arena")
	var players_arena0 = arenas[0].find_child("Players").get_children()
	var players_arena1 = arenas[1].find_child("Players").get_children()
	#$Arena1.queue_free()
	#$Arena0.queue_free()
	var players = get_node("/root/LevelMultiplayer/Arena2/Players")
	if len(players_arena0) > 0:
		var spawn = get_node("/root/LevelMultiplayer/Arena2/SpawnLocations/4")
		players_arena0[0].global_position = spawn.global_position
		#players_arena0[0].reparent(players)
	if len(players_arena1) > 0:
		var spawn = get_node("/root/LevelMultiplayer/Arena2/SpawnLocations/5")
		players_arena1[0].global_position = spawn.global_position
		#players_arena1[0].reparent(players)
