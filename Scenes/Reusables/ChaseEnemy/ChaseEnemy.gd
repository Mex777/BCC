extends AbstractEnemy
class_name ChaseEnemy

@export var JUMP_VELOCITY: float = -200
var jump_cooldown: bool = false
var flip_cooldown: bool = false
var player: Aurora
var chasing: bool = false


func _physics_process(delta: float) -> void:
	if chasing:
		# Start chasing the player on the X-axis
		speed = max_speed
		var player_in_right: bool = player.position.x > position.x
		var player_above: bool = player.position.y + 30 < position.y
		if player_in_right != facing_right and not flip_cooldown and not stunned:
			flip()

		# Jump after the player
		if player_above and is_on_floor() and not jump_cooldown and not stunned:
			jump()
	else:
		# Enter idle mode if not chasing
		speed = 0
	
	# Add physics
	super(delta)
	
	if not cooldown_base_attack and attacking and not stunned:
		attack()
		
	move_and_slide()
	

# Adding flip cooldown so that enemy doesn't change directions constantly
func flip() -> void:
	flip_cooldown = true
	super()
	$AttackRange.scale *= -1
	await get_tree().create_timer(0.5).timeout
	flip_cooldown = false
	
	
func jump() -> void:
	jump_cooldown = true
	velocity.y = JUMP_VELOCITY
	await get_tree().create_timer(2).timeout
	jump_cooldown = false


func attack() -> void:
	super()
	player.take_damage(damage)


# Start chasing the player when it enters chaser's range
func _on_chase_range_body_entered(body: CharacterBody2D) -> void:
	if body.name == "Aurora":
		player = body
		Game.enter_combat()
		chasing = true


# Stop chasing the player when it leaves chaser's range
func _on_chase_range_body_exited(body: CharacterBody2D) -> void:
	if body.name == "Aurora":
		chasing = false
		Game.exit_combat()
		player = null


# Start attacking the player when it enters attack range
func _on_attack_range_body_entered(body: CharacterBody2D) -> void:
	if body.name == "Aurora":
		attacking = true


# Stop attacking the player when it leaves attack range
func _on_attack_range_body_exited(body: CharacterBody2D) -> void:
	if body.name == "Aurora":
		attacking = false
