extends Node

var save_path = "res://Saves/"
var save_name = "Save.tres"
var save_data


func _ready():
	save_data = SaveData.new()


func load_game():
	# Loads the save file
	save_data = ResourceLoader.load(save_path + save_name).duplicate(true)
	
	# Loads the save file into runtime
	Game.set_coins(save_data.data["Gems"])
	Game.set_god_mode(save_data.data["GodMode"])
	Player.set_hp(save_data.data["HP"])
	Game.advance_to_level(save_data.data["LevelName"])
	
	
# Creates a save file based on the current state of the game
func save_game():
	save_data.data["Gems"] = Game.get_coins()
	save_data.data["GodMode"] = Game.get_god_mode()
	save_data.data["HP"] = Player.get_hp()
	save_data.data["LevelName"] = Game.get_level_name()
	ResourceSaver.save(save_data, save_path + save_name)
	
	
