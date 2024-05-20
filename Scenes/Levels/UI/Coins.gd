extends Label

func _physics_process(delta):
	text = str(Game.get_coins())
