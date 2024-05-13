extends TextureProgressBar

func _process(_delta):
	value = min(Player.get_hp() / Player.get_max_hp() + 0.2, 1);
