extends TextureProgressBar
class_name BasicAttackIcon

func _process(_delta: float) -> void:
	# When the player's HP is 0, hide the sword icon.
	if (Player.get_hp() == 0):
		self.visible = false
		return
	
	# Update the UI sword icon based on the cooldown of the Aurora's basic attack.
	value = 1 - $"../../Aurora".get_child(6).time_left / 0.6
