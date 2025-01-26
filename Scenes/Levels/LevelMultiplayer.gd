extends Node2D

var playerScene = preload("res://Scenes/Aurora/Aurora.tscn")


func _ready():
	for player in MultiplayerManager.Players:
		var curr_player = playerScene.instantiate()
		curr_player.name = str(MultiplayerManager.Players[player].id)
		add_child(curr_player)
		curr_player.global_position = get_tree().get_nodes_in_group("spawn").pick_random().global_position
		curr_player.camera.limit_left = 0
		curr_player.camera.limit_right = 99999
		curr_player.camera.limit_top = 0
		curr_player.camera.limit_bottom = 99999
	
		
		
	
