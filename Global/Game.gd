extends Node

var curr_coins: int = 0
var god_mode: bool = false
var in_cutscene: bool = false
var combat_counter: int = 0
var level_name: String = "Level1"
var audio_player: AudioStreamPlayer = AudioStreamPlayer.new()
var boss_killed: bool = false

var chapter_names = {
	"Level1": "Chapter one",
	"Level2": "Chapter two",
	"Level3": "Chapter three"
}


func add_coins(coins) -> void:
	curr_coins += int(coins)


func set_coins(coins: int) -> void:
	curr_coins = coins


func get_coins() -> int:
	return curr_coins
	
	
func reset() -> void:
	curr_coins = 0
	god_mode = false
	in_cutscene = false
	combat_counter = 0

	
func advance_to_level(level_name: String) -> void:
	if level_name not in chapter_names:
		chapter_names[level_name] = ""
	# Creates a transition with the corresponding chapter name
	self.level_name = level_name
	TransitionScene.transition(chapter_names[level_name])
	await TransitionScene.on_transition_finished
	
	# Changes the scene to the new level
	var location: String = "res://Scenes/Levels/" + level_name + ".tscn"
	get_tree().change_scene_to_file(location)
	
	
func toggle_god_mode() -> void:
	god_mode = !god_mode
	
	
func set_god_mode(val: bool) -> void:
	god_mode = val


func toggle_cutscene() -> void:
	in_cutscene = !in_cutscene
	
	
func enter_combat() -> void:
	combat_counter += 1


func exit_combat() -> void:
	combat_counter -= 1
	
	
func in_combat() -> bool:
	return combat_counter > 0
	
	
func in_god_mode() -> bool:
	return god_mode
	
	
func is_in_cutscene() -> bool:
	return in_cutscene
	
	
func get_god_mode() -> bool:
	return god_mode
	
	
func get_level_name() -> String:
	return level_name
	
func enemy_dying_sound() -> void:
	audio_player.stream = load("res://Assets/Audio/SFX/Enemy death.mp3")
	if not audio_player.is_inside_tree():
		add_child(audio_player)
	audio_player.play()

	
