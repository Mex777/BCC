extends TextureProgressBar
class_name StunIcon

func _process(_delta: float) -> void:
	# When the player's HP is 0, hide the stun icon.
	if (Player.get_hp() == 0):
		self.visible = false
		return
	
	# Update the UI stun icon based on the cooldown of the Aurora's basic attack.
	if len(MultiplayerManager.Players) == 0:
		value = 1 - $"../../Aurora".get_child(7).time_left / 5 
	else:
		var players = get_tree().get_nodes_in_group("Player")
		var val = null
		for player in players:
			if player.name == str(multiplayer.get_unique_id()):
				val = player
				break
		#value = 1 - val.get_child(7).time_left / 5
