extends Node

const max_hp: float = 100
var hp: float = max_hp;
var skin = "Prisoner"


func is_dead():
	return hp <= 0


func take_damage(damage):
	hp = max(hp - damage, 0)

	
func set_hp(val: float):
	hp = val


func get_hp():
	return hp


func reset():
	hp = max_hp
	
	
func get_max_hp():
	return max_hp
	
	
func get_skin():
	return " (" + skin + ")"
	

# Extra function for saving purposes
func get_skin_no_format():
	return skin
	
	
func set_skin(skin_name):
	skin = skin_name
