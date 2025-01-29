extends Node2D
class_name MainMenu

@onready var options_menu = preload("res://Scenes/MainMenu/OptionsMenu/OptionsMenu.tscn").instantiate()
@onready var keymap_menu = preload("res://Scenes/MainMenu/KeymapMenu/KeymapMenu.tscn").instantiate()
@onready var volume_menu = preload("res://Scenes/MainMenu/VolumeMenu/VolumeMenu.tscn").instantiate()
@onready var skins_menu = preload("res://Scenes/MainMenu/SkinMenu/SkinMenu.tscn").instantiate()

func _ready() -> void:
	get_tree().root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_IGNORE
	MusicPlayer.play_music()  # Pornește muzica

	# 📌 Dacă nu există fișier de salvare, dezactivăm butonul Continue
	if load("res://Saves/Save.tres") == null:
		$ContinueBtn.disabled = true
	else:
		$ContinueBtn.disabled = false

	# 📌 Adăugăm meniurile ca copii, dar ascunse
	add_child(options_menu)
	add_child(keymap_menu)
	add_child(volume_menu)
	add_child(skins_menu)

	options_menu.hide()
	keymap_menu.hide()
	volume_menu.hide()
	skins_menu.hide()

# 📌 Închide jocul
func _on_quit_btn_pressed() -> void:
	get_tree().quit()

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

# 📌 Navigare spre `OptionsMenu`
func _on_options_btn_pressed() -> void:
	_hide_all_menus()
	options_menu.show()

# 📌 Ascunde toate meniurile înainte de a arăta unul nou
func _hide_all_menus() -> void:
	options_menu.hide()
	keymap_menu.hide()
	volume_menu.hide()
	skins_menu.hide()
