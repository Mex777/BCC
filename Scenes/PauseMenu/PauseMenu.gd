extends CanvasLayer
class_name PauseMenu

func _input(event) -> void:
	if Input.is_action_just_pressed("pause") and !Game.is_in_cutscene():
		if get_tree().paused:
			_on_resume_button_pressed()
		else:
			_on_pause_button_pressed()


func _on_resume_button_pressed() -> void:
	self.hide()
	get_tree().paused = false


func _on_pause_button_pressed() -> void:
	self.show()
	get_tree().paused = true


func _on_restart_level_pressed() -> void:
	self.hide()
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_main_menu_pressed():
	self.hide()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/MainMenu/MainMenu.tscn")
