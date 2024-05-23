extends "res://Scenes/Reusables/PatrolEnemy/PatrolEnemy.gd"

var player


# Inherits patrolling logic and attacks the player.
func _physics_process(delta):
	super(delta)
	if attacking and cooldown_base_attack == false and not stunned:
		attack()
		player.take_damage(damage)


# When player enters range it stops attacking it
func _on_area_2d_body_entered(body):
	if body.name == "Aurora":
		attacking = true
		Game.enter_combat()
		self.player = body

# When player exits attack range it stops attacking it
func _on_area_2d_body_exited(body):
	if body.name == "Aurora":
		attacking = false
		Game.exit_combat()
		player = null

