extends CanvasLayer
class_name PauseMenu

@onready var resume_button = $Resume
@onready var options_button = $Options
@onready var main_menu_button = $MainMenu

@onready var options_menu = preload("res://Scenes/MainMenu/OptionsMenu/OptionsMenu.tscn").instantiate()
@onready var keymap_menu = preload("res://Scenes/MainMenu/KeymapMenu/KeymapMenu.tscn").instantiate()
@onready var volume_menu = preload("res://Scenes/MainMenu/VolumeMenu/VolumeMenu.tscn").instantiate()
@onready var skins_menu = preload("res://Scenes/MainMenu/SkinMenu/SkinMenu.tscn").instantiate()

# 📌 Inițializare meniuri la pornire
func _ready() -> void:
	add_to_group("pause")  # Adăugăm meniul de pauză în grup
	self.hide()  # Ascundem meniul de pauză la început

	_connect_buttons()
	_load_menus()

# 📌 Conectează butoanele principale
func _connect_buttons() -> void:
	resume_button.connect("pressed", Callable(self, "_on_resume_button_pressed"))
	options_button.connect("pressed", Callable(self, "_on_options_button_pressed"))
	main_menu_button.connect("pressed", Callable(self, "_on_main_menu_pressed"))

# 📌 Încarcă meniurile și le ascunde
func _load_menus() -> void:
	add_child(options_menu)
	add_child(keymap_menu)
	add_child(volume_menu)
	add_child(skins_menu)

	options_menu.hide()
	keymap_menu.hide()
	volume_menu.hide()
	skins_menu.hide()

	# 📌 Asigură-te că meniurile știu că sunt în `PauseMenu`
	options_menu.add_to_group("options_menu")
	keymap_menu.add_to_group("keymap_menu")
	volume_menu.add_to_group("volume_menu")
	skins_menu.add_to_group("skins_menu")

# 📌 Controlează ESC pentru a ieși corect din meniuri
func _input(event) -> void:
	if event.is_action_pressed("pause") and !Game.is_in_cutscene():
		if options_menu.visible or keymap_menu.visible or volume_menu.visible or skins_menu.visible:
			_close_all_menus()
			return
			
		if visible:
			_resume_game()
		else:
			_pause_game()


#  Resume Game
func _on_resume_button_pressed() -> void:
	_resume_game()

func _resume_game() -> void:
	if not visible:
		return
	
	# Ascunde acest meniu
	self.hide()
	_close_all_menus()
	
	# Verifică dacă există alte instanțe de PauseMenu și le ascunde
	for menu in get_tree().get_nodes_in_group("pause"):
		if menu != self:
			menu.hide()
	
	get_tree().paused = false


func _pause_game() -> void:
	#  Dacă există deja un meniu activ, nu mai deschide altul
	for menu in get_tree().get_nodes_in_group("pause"):
		if menu.visible:
			return

	self.show()
	get_tree().paused = true


# Deschide meniul de setări
func _on_options_button_pressed() -> void:
	_close_all_menus()
	options_menu.show()

# Funcții pentru navigare între meniuri
func _on_keymap_button_pressed() -> void:
	_close_all_menus()
	keymap_menu.show()

func _on_volume_button_pressed() -> void:
	_close_all_menus()
	volume_menu.show()

func _on_skins_button_pressed() -> void:
	_close_all_menus()
	skins_menu.show()

# 📌 Închide toate meniurile și revine la PauseMenu
func _close_all_menus() -> void:
	options_menu.hide()
	keymap_menu.hide()
	volume_menu.hide()
	skins_menu.hide()

# 📌 Revenire la Main Menu (pierde progresul)
func _on_main_menu_pressed() -> void:
	self.hide()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/MainMenu/MainMenu.tscn")
