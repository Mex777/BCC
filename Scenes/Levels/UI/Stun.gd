extends TextureProgressBar
class_name StunIcon

func _process(_delta: float) -> void:
	# When the player's HP is 0, hide the stun icon.
	if (Player.get_hp() == 0):
		self.visible = false
		return
	
	# Update the UI stun icon based on the cooldown of the Aurora's basic attack.
	value = 1 - $"../../Aurora".get_child(7).time_left / 5
