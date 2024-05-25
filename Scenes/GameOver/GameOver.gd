extends CanvasLayer
class_name GameOver

# Variable for tracking if the player has chosen to respawn.
var respawn: bool = false


func _process(_delta: float) -> void:
	if Player.is_dead() == true and not respawn:
		self.show()
	else:
		self.hide()


func _on_respawn_pressed() -> void:
	respawn = true

	# Transition to the first level.
	TransitionScene.transition("Chapter one")
	await TransitionScene.on_transition_finished

	# Reset the player and game.
	Player.reset()
	Game.reset()
	get_tree().change_scene_to_file("res://Scenes/Levels/Level1.tscn")


func _on_main_screen_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu/MainMenu.tscn")
