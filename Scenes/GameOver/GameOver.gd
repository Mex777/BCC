extends CanvasLayer

var respawn = false

func _process(_delta):
	if Player.is_dead() == true and not respawn:
		self.show()
	else:
		self.hide()

func _on_respawn_pressed():
	respawn = true
	TransitionScene.transition("Chapter one")
	await TransitionScene.on_transition_finished
	Player.reset()
	get_tree().change_scene_to_file("res://Scenes/Levels/Level1.tscn")


func _on_main_screen_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainMenu/MainMenu.tscn")
