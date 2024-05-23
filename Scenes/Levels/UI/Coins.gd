extends Label


func _physics_process(delta):
	# Update UI gems count   
	text = str(Game.get_coins())
