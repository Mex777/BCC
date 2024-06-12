extends AbstractEnemy

@onready var projectile = load("res://Scenes/Reusables/Projectile/Projectile.tscn")

var player: Aurora = null


# Ranged enemies don't move on the X-axis
func _physics_process(delta: float) -> void:
	# Applying gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if not cooldown_base_attack and attacking and not stunned:
		attack()
		
	move_and_slide()


# When the player exits shooting range it stops attacking him
func _on_area_2d_body_exited(body: CharacterBody2D) -> void:
	if body.name == "Aurora":
		attacking = false
		Game.exit_combat()
		player = null


# When the player enters range it starts attacking him
func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if body.name == "Aurora":
		attacking = true
		Game.enter_combat()
		player = body
		if not cooldown_base_attack and not stunned:
			attack()


func attack() -> void:
	# Uses cooldown logic from parent
	super()
	
	# Checks direction of the player to know in which direction to shoot
	var player_in_right: bool = player.position.x > position.x
	
	# Flips enemy based on player position
	if player_in_right != facing_right:
		flip()
	
	$AnimatedSprite.play("Attacking")
	
	# Shoots a projectile towards the player
	var instance: Projectile = projectile.instantiate()
	instance.right = player_in_right
	instance.damage = damage
	add_child(instance)
	
