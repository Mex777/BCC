extends Node

const SETTINGS_FILE := "res://settings.cfg"  # Folosim un singur fișier global
var settings := {}


func _ready() -> void:
	load_settings()
	load_video_settings()


# Salvează setările în settings.cfg
func save_settings() -> void:
	var config = ConfigFile.new()
	
	# Salvăm toate setările din dicționar
	for category in settings.keys():
		for key in settings[category].keys():
			config.set_value(category, key, settings[category][key])

	var error = config.save_encrypted_pass(SETTINGS_FILE, Game.key)


# Încarcă setările la pornirea jocului
func load_settings() -> void:
	var config = ConfigFile.new()
	
	if config.load_encrypted_pass(SETTINGS_FILE, Game.key) == OK:
		# Inițializăm dicționarul settings din fișierul salvat
		for category in ["keybinds", "volume", "aurora", "video_settings"]:
			if not settings.has(category):
				settings[category] = {}

			for key in config.get_section_keys(category):
				settings[category][key] = config.get_value(category, key)
	else:
		_set_default_settings()


# Setează valori implicite dacă nu există fișierul de setări
func _set_default_settings() -> void:
	settings = {
		"keybinds": {
			"move_left": "A",
			"move_right": "D",
			"jump": "Space",
			"stun": "R",
			"base_attack": "Mouse 1"
		},
		"volume": {
			"music": 50,
			"master": 50,
			"player_sfx": 50,
			"enemies_sfx": 50
		},
		"aurora": {
			"skin": "Prisoner"
		},
		"video_settings": {
			"fullscreen": false,
			"resolution": Vector2i(1280, 720),
			"vsync": 0,
			"borderless": false
		}
	}
	save_settings()


func load_video_settings():
	var index = SettingsManager.settings["video_settings"]["resolution"]
	if index == Vector2i(1280, 720):
		DisplayServer.window_set_size(Vector2i(1280, 720))
		SettingsManager.settings["video_settings"]["resolution"] = Vector2i(1280, 720)
		SettingsManager.save_settings()
	elif index == Vector2i(1600, 900):
		DisplayServer.window_set_size(Vector2i(1600, 900))
		SettingsManager.settings["video_settings"]["resolution"] = Vector2i(1600, 900)
		SettingsManager.save_settings()
	else:
		DisplayServer.window_set_size(Vector2i(1920, 1080))
		SettingsManager.settings["video_settings"]["resolution"] = Vector2i(1920, 1080)
		SettingsManager.save_settings()

	index = SettingsManager.settings["video_settings"]["fullscreen"]
	if index == false:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		SettingsManager.settings["video_settings"]["fullscreen"] = false
		SettingsManager.save_settings()
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		SettingsManager.settings["video_settings"]["fullscreen"] = true
		SettingsManager.save_settings()

	index = SettingsManager.settings["video_settings"]["borderless"]
	if index == false:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		SettingsManager.settings["video_settings"]["borderless"] = false
		SettingsManager.save_settings()
	else:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		SettingsManager.settings["video_settings"]["borderless"] = true
		SettingsManager.save_settings()

	index = SettingsManager.settings["video_settings"]["vsync"]
	if index == 0:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		SettingsManager.settings["video_settings"]["vsync"] = 0
		SettingsManager.save_settings()
	elif index == 1:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		SettingsManager.settings["video_settings"]["vsync"] = 1
		SettingsManager.save_settings()
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ADAPTIVE)
		SettingsManager.settings["video_settings"]["vsync"] = 2
		SettingsManager.save_settings()
