extends Label

func _physics_process(delta):
	text = str("Coins: ") + str(Game.get_coins())