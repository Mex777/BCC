extends "res://Scenes/Reusables/AbstractEnemy/AbstractEnemy.gd"

@onready var projectile = load("res://Scenes/Reusables/Projectile/Projectile.tscn")

var player = null


# Ranged enemies don't move on the X-axis
func _physics_process(delta):
	# Applying gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if not cooldown_base_attack and attacking and not stunned:
		attack()
		
	move_and_slide()


# When the player exits shooting range it stops attacking him
func _on_area_2d_body_exited(body):
	if body.name == "Aurora":
		attacking = false
		Game.exit_combat()
		player = null


# When the player enters range it starts attacking him
func _on_area_2d_body_entered(body):
	if body.name == "Aurora":
		attacking = true
		Game.enter_combat()
		player = body
		if not cooldown_base_attack and not stunned:
			attack()


func attack():
	# Uses cooldown logic from parent
	super()
	
	# Checks direction of the player to know in which direction to shoot
	var player_in_right: bool = player.position.x > position.x
	
	# Flips enemy based on player position
	if player_in_right != facing_right:
		flip()
	
	# Shoots a projectile towards the player
	var instance = projectile.instantiate()
	instance.right = player_in_right
	add_child(instance)
	
