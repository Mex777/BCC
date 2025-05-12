extends Node

var max_hp: int = 10
var hp: int = max_hp;
var skin: String = "Prisoner"


func is_dead() -> bool:
	return hp <= 0


func take_damage(damage: int) -> void:
	hp = max(hp - damage, 0)


func set_hp(val: int) -> void:
	hp = max(min(val, max_hp), 0)


func add_hp(val: int) -> void:
	hp = max(min(hp + val, max_hp), 0)


func get_hp() -> int:
	return hp


func reset() -> void:
	hp = max_hp
	skin = SettingsManager.settings["aurora"]["skin"]


func get_max_hp() -> int:
	return max_hp


func get_skin() -> String:
	return " (" + skin + ")"


# Extra function for saving purposes
func get_skin_no_format() -> String:
	return skin


func set_skin(skin_name: String) -> void:
	skin = skin_name


func load_skin_from_config() -> void:
	var config = ConfigFile.new()
	if config.load("res://settings.cfg") == OK:
		skin = config.get_value("aurora", "skin", "Prisoner")  # Implicit "Prisoner"
	else:
		print("Failed to load skin from settings.cfg. Using default: Prisoner")
