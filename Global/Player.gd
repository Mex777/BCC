extends Node

const max_hp: float = 100
var hp: float = max_hp;


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
