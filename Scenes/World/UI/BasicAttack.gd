extends TextureProgressBar

func _process(_delta):
	if (Player.get_hp() == 0):
		self.visible = false
		return
		
	value = 1 - $"../../Aurora".get_child(6).time_left / 0.6
