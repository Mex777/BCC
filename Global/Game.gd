extends Node

var curr_coins: int = 0
var god_mode: bool = false
var in_cutscene: bool = false
var combat_counter: int = 0
var level_name = "Level1"

var chapter_names = {
	"Level1": "Chapter one",
	"Level2": "Chapter two",
	"Level3": "Chapter three"
}

func add_coins(coins):
	curr_coins += coins

func set_coins(coins):
	curr_coins = coins

func get_coins():
	return curr_coins
	
func reset():
	curr_coins = 0
	god_mode = false
	in_cutscene = false
	combat_counter = 0

	
func advance_to_level(level_name):
	self.level_name = level_name
	TransitionScene.transition(chapter_names[level_name])
	await TransitionScene.on_transition_finished
	var location = "res://Scenes/Levels/" + level_name + ".tscn"
	get_tree().change_scene_to_file(location)
	
func toggle_god_mode():
	god_mode = !god_mode
	
func set_god_mode(val: bool):
	god_mode = val

func toggle_cutscene():
	in_cutscene = !in_cutscene
	
func enter_combat():
	combat_counter += 1

func exit_combat():
	combat_counter -= 1
	
func in_combat():
	return combat_counter > 0
	
func in_god_mode():
	return god_mode
	
func is_in_cutscene():
	return in_cutscene
	
func get_god_mode():
	return god_mode
	
func get_level_name():
	return level_name
