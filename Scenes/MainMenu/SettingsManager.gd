extends Node

const SETTINGS_FILE := "res://settings.cfg"  # Folosim un singur fișier global
var settings := {}

func _ready() -> void:
	load_settings()

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
		for category in ["keybinds", "volume", "aurora"]:
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
		}
	}
	save_settings()
