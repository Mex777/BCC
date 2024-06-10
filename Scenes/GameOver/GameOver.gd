extends CanvasLayer
class_name GameOver

# Variable for tracking if the player has chosen to respawn.
var respawn: bool = false

var audio_player: AudioStreamPlayer = AudioStreamPlayer.new()

func _process(_delta: float) -> void:
	if not audio_player.is_inside_tree():
		add_child(audio_player)
	
	if Player.is_dead() == true and not respawn:
		audio_player.stream = load("res://Assets/Audio/Music/Lady of Shadows.mp3")
		audio_player.play()
		self.show()
	else:
		self.hide()


func _on_respawn_pressed() -> void:
	respawn = true

	# Transition to the first level.
	TransitionScene.transition("Chapter one")
	await TransitionScene.on_transition_finished

	# Reset the player and game.
	audio_player.stop()
	Player.reset()
	Game.reset()
	get_tree().change_scene_to_file("res://Scenes/Levels/Level1.tscn")


func _on_main_screen_pressed() -> void:
	audio_player.stop()
	get_tree().change_scene_to_file("res://Scenes/MainMenu/MainMenu.tscn")
