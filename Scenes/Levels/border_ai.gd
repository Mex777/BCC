extends Area2D 

func _on_body_entered(body):
	if body.name == "Aurora":
		#print("chitz")
		var obj = $"../Aurora"
		#obj.ai_controller.reward -= 0.3
		#Player.reset()
		#Game.reset()
		#get_tree().change_scene_to_file("res://Scenes/Levels/LevelDemo.tscn")
		#obj.global_position = Vector2(169, 428)
		#obj.ai_controller.reset()
