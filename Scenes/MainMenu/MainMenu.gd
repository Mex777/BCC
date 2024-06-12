extends Node2D
class_name MainMenu


func _ready() -> void:
	get_tree().root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_IGNORE
	
	# If there is no save file, disable the continue button.
	if load("res://Saves/Save.tres") == null:
		$ContinueBtn.disabled = true
	else:
		$ContinueBtn.disabled = false


# Closes game when the exit button is pressed.
func _on_quit_btn_pressed() -> void:
	get_tree().quit()


# Function for handling when the new game button is pressed.
func _on_play_btn_pressed() -> void:
	# Reset the player and the game.
	Player.reset()
	Game.reset()
	
	# Saves the game state.
	SaveManager.save_game()
	
	# Changes the scene to level 1.
	TransitionScene.transition("Chapter one")
	await TransitionScene.on_transition_finished
	get_tree().change_scene_to_file("res://Scenes/Levels/Level1.tscn")


func _on_continue_btn_pressed() -> void:
	# Load the game state from the save file.
	SaveManager.load_game()
