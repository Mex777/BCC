extends Label
class_name CoinsLabel

func _physics_process(delta: float) -> void:
	# Update UI gems count   
	text = str(Game.get_coins())
