extends AbstractEnemy
class_name Mob

# Mobs don't take damage
func take_damage(damage: int) -> void:
	pass


# Mobs do not move by default on the X-axis
func _physics_process(delta: float) -> void:
	# Applying gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		
	move_and_slide()

