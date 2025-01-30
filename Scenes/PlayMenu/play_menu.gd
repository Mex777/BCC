extends Node2D
class_name PlayMenu

func _ready() -> void:
	get_tree().root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_IGNORE
	MusicPlayer.play_music()  # Pornește muzica

	# 📌 Dacă nu există fișier de salvare, dezactivăm butonul Continue
	if FileAccess.file_exists("res://Saves/Save.dat") == false:
		$ContinueBtn.disabled = true
	else:
		$ContinueBtn.disabled = false

# 📌 Start New Game
func _on_play_btn_pressed() -> void:
	Player.reset()
	Game.reset()
	SaveManager.save_game()
	TransitionScene.transition("Chapter one")
	await TransitionScene.on_transition_finished
	get_tree().change_scene_to_file("res://Scenes/Levels/Level1.tscn")

# 📌 Continue Game
func _on_continue_btn_pressed() -> void:
	SaveManager.load_game()

func _on_multiplayer_btn_pressed():
	get_tree().change_scene_to_file("res://Scenes/MultiplayerMenu/MultiplayerScene.tscn")

func _on_back_btn_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainMenu/MainMenu.tscn")
