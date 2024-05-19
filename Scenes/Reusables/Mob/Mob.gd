extends "res://Scenes/Reusables/AbstractEnemy/AbstractEnemy.gd"

func take_damage(damage):
	pass

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
	move_and_slide()
