extends TextureProgressBar
class_name HPBar

func _process(_delta: float) -> void:
	# Updates Player's HP bar, works on percentages.
	# Has an offset of 20% because of the HP bar design
	value = min(float(Player.get_hp()) / Player.get_max_hp() + 0.2, 1);
