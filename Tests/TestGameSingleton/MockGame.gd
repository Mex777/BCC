extends "res://Global/Game.gd"
class_name MockGame

func advance_to_level(level_name: String) -> void:
	# Creates a transition with the corresponding chapter name
	self.level_name = level_name
