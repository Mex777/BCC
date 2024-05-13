extends CanvasLayer

func _process(delta):
	if Player.is_dead() == true:
		self.show()
	else:
		self.hide()

func _on_respawn_pressed():
	Player.reset()
	get_tree().change_scene_to_file("res://Scenes/World/World.tscn")


func _on_main_screen_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainMenu/MainMenu.tscn")
