extends "res://Scenes/Reusables/PatrolEnemy/PatrolEnemy.gd"

var player

func _physics_process(delta):
	super(delta)
	if attacking and cooldown_base_attack == false and not stunned:
		attack()
		player.take_damage(damage)

func _on_area_2d_body_entered(body):
	if body.name == "Aurora":
		attacking = true
		self.player = body

func _on_area_2d_body_exited(body):
	if body.name == "Aurora":
		attacking = false
		player = null

