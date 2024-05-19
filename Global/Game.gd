extends Node

var curr_coins = 0

var chapter_names = {
	"Level1": "Chapter one",
	"Level2": "Chapter two",
	"Level3": "Chapter three"
}

func add_coins(coins):
	curr_coins += coins
	
func get_coins():
	return curr_coins
	
func reset():
	curr_coins = 0
	
func advance_to_level(level_name):
	TransitionScene.transition(chapter_names[level_name])
	await TransitionScene.on_transition_finished
	var location = "res://Scenes/Levels/" + level_name + ".tscn"
	get_tree().change_scene_to_file(location)
