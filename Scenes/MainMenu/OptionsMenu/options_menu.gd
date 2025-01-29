extends Node2D

@onready var keymap_menu = preload("res://Scenes/MainMenu/KeymapMenu/KeymapMenu.tscn").instantiate()
@onready var volume_menu = preload("res://Scenes/MainMenu/VolumeMenu/VolumeMenu.tscn").instantiate()
@onready var skins_menu = preload("res://Scenes/MainMenu/SkinMenu/SkinMenu.tscn").instantiate()

func _ready() -> void:
	MusicPlayer.play_music()  # Continuă muzica în opțiuni
	
	# 📌 Adăugăm meniurile ca copii și le ascundem
	add_child(keymap_menu)
	add_child(volume_menu)
	add_child(skins_menu)

	keymap_menu.hide()
	volume_menu.hide()
	skins_menu.hide()

# 📌 Navigare spre meniul de Keymap
func _on_keymap_btn_pressed() -> void:
	keymap_menu.show()

# 📌 Navigare spre meniul de Volume
func _on_volume_btn_pressed() -> void:
	volume_menu.show()

# 📌 Navigare spre meniul de Skins
func _on_skins_btn_pressed() -> void:
	skins_menu.show()

# 📌 Butonul "Back" - Revine la `MainMenu`
func _on_back_btn_pressed() -> void:
	self.hide()
	var main_menu = get_tree().get_first_node_in_group("main_menu")
	if main_menu:
		main_menu.show()
