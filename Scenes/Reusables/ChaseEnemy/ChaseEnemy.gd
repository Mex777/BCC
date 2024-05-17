extends "res://Scenes/Reusables/AbstractEnemy/AbstractEnemy.gd"

var player
var chasing = false

func _physics_process(delta):
	if chasing:
		speed = max_speed
		var player_in_right: bool = player.position.x > position.x
		if player_in_right != facing_right:
			flip()
	else:
		speed = 0
		
	super(delta)
	
	if not cooldown_base_attack and attacking and not stunned:
		attack()
		
	move_and_slide()
	
func flip():
	super()
	$AttackRange.scale *= -1

func attack():
	super()
	player.take_damage(damage)

func _on_chase_range_body_entered(body):
	if body.name == "Aurora":
		player = body
		chasing = true

func _on_chase_range_body_exited(body):
	if body.name == "Aurora":
		chasing = false
		player = null

func _on_attack_range_body_entered(body):
	if body.name == "Aurora":
		attacking = true

func _on_attack_range_body_exited(body):
	if body.name == "Aurora":
		attacking = false
