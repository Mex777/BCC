extends "res://Scenes/Reusables/AbstractEnemy/AbstractEnemy.gd"

@export var JUMP_VELOCITY = -200
var jump_cooldown = false
var flip_cooldown = false
var player
var chasing = false

func _physics_process(delta):
	if chasing:
		speed = max_speed
		var player_in_right: bool = player.position.x > position.x
		var player_above: bool = player.position.y + 30 < position.y
		if player_in_right != facing_right and not flip_cooldown and not stunned:
			flip()
		if player_above and is_on_floor() and not jump_cooldown and not stunned:
			jump()
	else:
		speed = 0
		
	super(delta)
	
	if not cooldown_base_attack and attacking and not stunned:
		attack()
		
	move_and_slide()
	
func flip():
	flip_cooldown = true
	super()
	$AttackRange.scale *= -1
	await get_tree().create_timer(0.5).timeout
	flip_cooldown = false
	
func jump():
	jump_cooldown = true
	velocity.y = JUMP_VELOCITY
	await get_tree().create_timer(2).timeout
	jump_cooldown = false

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
