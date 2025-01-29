extends Node2D

@onready var music_slider = $VBoxContainer/MusicVolumeContainer/Slider
@onready var master_slider = $VBoxContainer/MasterVolumeContainer/Slider
@onready var player_sfx_slider = $VBoxContainer/PlayerSFXContainer/Slider
@onready var enemies_sfx_slider = $VBoxContainer/EnemiesSFXContainer/Slider

@onready var options_menu = get_tree().get_first_node_in_group("options_menu")  # Găsește meniul de opțiuni

func _ready() -> void:
	SettingsManager.load_settings()  # Încărcăm setările globale
	_load_settings()  # Aplicăm valorile
	_connect_signals()  # Conectăm slider-ele
	MusicPlayer.play_music()  # Continuăm muzica în meniul volumului

# Conectăm slider-ele
func _connect_signals() -> void:
	music_slider.connect("value_changed", Callable(self, "_on_music_volume_changed"))
	master_slider.connect("value_changed", Callable(self, "_on_master_volume_changed"))
	player_sfx_slider.connect("value_changed", Callable(self, "_on_player_sfx_changed"))
	enemies_sfx_slider.connect("value_changed", Callable(self, "_on_enemies_sfx_changed"))

# Funcții pentru schimbarea volumului
func _on_music_volume_changed(value: float) -> void:
	_update_volume("Music", "music", value)

func _on_master_volume_changed(value: float) -> void:
	_update_volume("Master", "master", value)

func _on_player_sfx_changed(value: float) -> void:
	_update_volume("PlayerSFX", "player_sfx", value)

func _on_enemies_sfx_changed(value: float) -> void:
	_update_volume("EnemiesSFX", "enemies_sfx", value)

# Funcție comună pentru actualizarea volumului
func _update_volume(bus_name: String, setting_key: String, value: float) -> void:
	SettingsManager.settings["volume"][setting_key] = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), linear_to_db(value / 100.0))
	SettingsManager.save_settings()

# Încărcăm valorile volumului din `settings.cfg`
func _load_settings() -> void:
	if "volume" in SettingsManager.settings:
		var volumes = SettingsManager.settings["volume"]

		music_slider.value = volumes.get("music", 50)
		master_slider.value = volumes.get("master", 50)
		player_sfx_slider.value = volumes.get("player_sfx", 50)
		enemies_sfx_slider.value = volumes.get("enemies_sfx", 50)

		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(volumes["music"] / 100.0))
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(volumes["master"] / 100.0))
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("PlayerSFX"), linear_to_db(volumes["player_sfx"] / 100.0))
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("EnemiesSFX"), linear_to_db(volumes["enemies_sfx"] / 100.0))

# Butonul Back
func _on_back_btn_pressed() -> void:
	self.hide()
	if options_menu:
		options_menu.show()
