extends CanvasLayer
class_name GameOver

# Variable for tracking if the player has chosen to respawn.
var respawn: bool = false
var music_playing = false
var audio_player: AudioStreamPlayer


func _ready():
	audio_player = AudioStreamPlayer.new()
	audio_player.stream = load("res://Assets/Audio/Music/Lady of Shadows.mp3")
	if not audio_player.is_inside_tree():
		add_child(audio_player)


func _process(_delta: float) -> void:
	if Player.is_dead() == true and not respawn:
		if not music_playing:
			music_playing = true
			audio_player.play()
		self.show()
	else:
		self.hide()


func _on_respawn_pressed() -> void:
	respawn = true
	
	music_playing = false
	audio_player.stop()

	# Transition to the first level.
	TransitionScene.transition("Chapter one")
	await TransitionScene.on_transition_finished

	# Reset the player and game.
	Player.reset()
	Game.reset()
	get_tree().change_scene_to_file("res://Scenes/Levels/Level1.tscn")


func _on_main_screen_pressed() -> void:
	music_playing = false
	audio_player.stop()
	get_tree().change_scene_to_file("res://Scenes/MainMenu/MainMenu.tscn")
