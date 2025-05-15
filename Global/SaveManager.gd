extends Node

var save_path: String = "res://Saves/"
var save_name: String = "Save.dat"
var save_data: Dictionary
var key_file = "res://key.ini"
var key = "masfjklsdaljfksdfklsdjf"

func _ready() -> void:
	save_data = {
		"data": SaveData.new().data
	}
	
	if FileAccess.file_exists(key_file) == false:
		var file = FileAccess.open_encrypted_with_pass(key_file, FileAccess.WRITE, key)
		var password = str(Crypto.new().generate_random_bytes(32))
		file.store_string(password)
		file.close()
		save_game()
		
	var file = FileAccess.open_encrypted_with_pass(key_file, FileAccess.READ, key)
	var content = file.get_as_text()
	Game.key = content

func load_game() -> void:
	# Loads the save file
	var config = ConfigFile.new()
	
	if config.load_encrypted_pass(save_path + save_name, Game.key) == OK:
		for category in ["data"]:
			for key in config.get_section_keys(category):
				save_data[category][key] = config.get_value(category, key)
		print(save_data)
	else:
		save_game()
		load_game()
		return
	
	
	# Loads the save file into runtime
	Game.set_coins(save_data["data"]["Gems"])
	Game.set_god_mode(save_data["data"]["GodMode"])
	Player.set_hp(save_data["data"]["HP"])
	Player.set_skin(save_data["data"]["Skin"])
	Game.advance_to_level(save_data["data"]["LevelName"])
	
	
# Creates a save file based on the current state of the game
func save_game() -> void:
	save_data["data"]["Gems"] = Game.get_coins()
	save_data["data"]["GodMode"] = Game.get_god_mode()
	save_data["data"]["HP"] = Player.get_hp()
	save_data["data"]["LevelName"] = Game.get_level_name()
	save_data["data"]["Skin"] = Player.get_skin_no_format()
	
	var config = ConfigFile.new()
	
	for category in save_data.keys():
		for key in save_data[category].keys():
			config.set_value(category, key, save_data[category][key])
	
	var error = config.save_encrypted_pass(save_path + save_name, Game.key)
	
	
