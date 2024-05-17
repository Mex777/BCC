extends Node2D

func _ready():
	get_tree().root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_IGNORE

func _on_quit_btn_pressed():
	get_tree().quit()

func _on_play_btn_pressed():
	Player.reset()
	TransitionScene.transition("Chapter one")
	await TransitionScene.on_transition_finished
	get_tree().change_scene_to_file("res://Scenes/Levels/Level1.tscn")
