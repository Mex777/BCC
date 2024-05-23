extends "res://Scenes/Reusables/AbstractEnemy/AbstractEnemy.gd"

# Mobs don't take damage
func take_damage(damage):
	pass


# Mobs do not move by default on the X-axis
func _physics_process(delta):
	# Applying gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		
	move_and_slide()

