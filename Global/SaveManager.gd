extends Node

var save_path: String = "res://Saves/"
var save_name: String = "Save.tres"
var save_data: SaveData


func _ready() -> void:
	save_data = SaveData.new()


func load_game() -> void:
	# Loads the save file
	save_data = ResourceLoader.load(save_path + save_name).duplicate(true)
	
	# Loads the save file into runtime
	Game.set_coins(save_data.data["Gems"])
	Game.set_god_mode(save_data.data["GodMode"])
	Player.set_hp(save_data.data["HP"])
	Player.set_skin(save_data.data["Skin"])
	Game.advance_to_level(save_data.data["LevelName"])
	
	
# Creates a save file based on the current state of the game
func save_game() -> void:
	save_data.data["Gems"] = Game.get_coins()
	save_data.data["GodMode"] = Game.get_god_mode()
	save_data.data["HP"] = Player.get_hp()
	save_data.data["LevelName"] = Game.get_level_name()
	save_data.data["Skin"] = Player.get_skin_no_format()
	ResourceSaver.save(save_data, save_path + save_name)
	
	
